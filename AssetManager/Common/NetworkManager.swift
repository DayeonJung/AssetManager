import Foundation
import Moya

enum KoreaInvestmentAPI {
    case getAccessToken
    case getOverseasStockPrice(exchangeCode: String, stockCode: String)
}

extension KoreaInvestmentAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://openapi.koreainvestment.com:9443")!
    }
    
    var path: String {
        switch self {
        case .getAccessToken:
            return "/oauth2/tokenP"
        case .getOverseasStockPrice:
            return "/uapi/overseas-price/v1/quotations/dailyprice"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAccessToken:
            return .post
        case .getOverseasStockPrice:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAccessToken:
            return .requestParameters(
                parameters: [
                    "grant_type": "client_credentials",
                    "appkey": Token.appKey,
                    "appsecret": Token.appSecret
                ],
                encoding: JSONEncoding.default
            )
        case let .getOverseasStockPrice(exchangeCode, stockCode):
            return .requestParameters(
                parameters: [
                    "AUTH": "",
                    "EXCD": exchangeCode,
                    "SYMB": stockCode,
                    "GUBN": "0",  // 0:일 1:주 2:월
                    "BYMD": "",   // 시작일자 (YYYYMMDD)
                    "MODP": "0"   // 0:일반 1:수정주가
                ],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getAccessToken:
            return [
                "Content-Type": "application/json"
            ]
        case .getOverseasStockPrice:
            return [
                "Content-Type": "application/json",
                "authorization": "Bearer \(Token.accessToken)",
                "appkey": Token.appKey,
                "appsecret": Token.appSecret,
                "tr_id": "HHDFS76240000"  // 해외주식 기간별시세 거래ID
            ]
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private let provider = MoyaProvider<KoreaInvestmentAPI>()
    private let tokenManager = TokenManager.shared
    
    private init() {}
    
    /// 토큰 유효성 확인 후 필요시 갱신
    private func ensureValidToken() async throws {
        // 이미 유효한 토큰이 있다면 그대로 사용
        if tokenManager.isTokenValid {
            print("🔑 기존 토큰 사용 (유효함)")
            return
        }
        
        print("🔄 토큰이 없거나 만료됨. 새 토큰 발급 중...")
        let _ = try await requestNewAccessToken()
        print("✅ 새 토큰 발급 완료")
    }
    
    /// 새로운 접근토큰 요청 (내부용)
    private func requestNewAccessToken() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getAccessToken) { result in
                switch result {
                case let .success(response):
                    do {
                        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: response.data)
                        
                        // TokenManager에 토큰 저장
                        self.tokenManager.saveToken(tokenResponse)
                        
                        continuation.resume(returning: tokenResponse.access_token)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// 해외주식 시세 조회 (자동 토큰 관리 포함)
    func getOverseasStockPrice(exchangeCode: String, stockCode: String) async throws -> [StockPriceOutput2]? {
        // API 호출 전 토큰 유효성 확인 및 갱신
        try await ensureValidToken()
        
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getOverseasStockPrice(exchangeCode: exchangeCode, stockCode: stockCode)) { result in
                switch result {
                case let .success(response):
                    do {
                        let priceResponse = try JSONDecoder().decode(StockPrice.self, from: response.data)
                        continuation.resume(returning: priceResponse.output2)
                    } catch {
                        print("Decoding error: \(error)")
                        continuation.resume(throwing: error)
                    }
                case let .failure(error):
                    print("Network error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// 앱 시작 시 호출 - 저장된 토큰 로드
    func initialize() {
        tokenManager.loadSavedToken()
        tokenManager.printTokenStatus()
    }
    
    /// 토큰 상태 확인 (디버깅용)
    func checkTokenStatus() {
        tokenManager.printTokenStatus()
    }
    
    /// 토큰 강제 갱신
    func forceRefreshToken() async throws {
        tokenManager.clearToken()
        try await ensureValidToken()
    }
}

struct TokenResponse: Codable {
    let access_token: String
    let access_token_token_expired: String
    let token_type: String
    let expires_in: Int
}

struct StockPrice: Codable {
    let output1: StockPriceOutput1?
    let output2: [StockPriceOutput2]?
    let rtCD, msgCD, msg1: String?

    enum CodingKeys: String, CodingKey {
        case output1, output2
        case rtCD = "rt_cd"
        case msgCD = "msg_cd"
        case msg1
    }
}

// MARK: - Output1
struct StockPriceOutput1: Codable {
    let rsym, zdiv, nrec: String?
}

// MARK: - Output2
struct StockPriceOutput2: Codable {
    let xymd, clos, sign, diff: String?
    let rate, output2Open, high, low: String?
    let tvol, tamt, pbid, vbid: String?
    let pask, vask: String?

    enum CodingKeys: String, CodingKey {
        case xymd, clos, sign, diff, rate
        case output2Open = "open"
        case high, low, tvol, tamt, pbid, vbid, pask, vask
    }
}
