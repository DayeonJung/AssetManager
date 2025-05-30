//
//  TokenManager.swift
//  AssetManager
//
//  Created by Dayeon Jung on 5/30/25.
//

import Foundation

struct Token {
    static let appKey = "PSZELJjmw57G7q7SrnBfLbg0NJXF20YQv8mh"
    static let appSecret = "m3KPRB6FiR5qWra8M7/ycCPks7rUn2sEkDqZLxfKqJHwvXBetr4tlPdX/WIZVrizWrQvEENqrqWB/5bsGnquRQ6zCd1N7dgJbVlI9gHCRu+Sohnn9ooXUwnku2bafauhwpPqg1QBN50IR3qtwBfZ92KxW8iUKB4bIXihXYCvF9DTIZEjBzg="
    static var accessToken = ""
    
    static func setAccessToken(to value: String) {
        accessToken = value
    }
}

// MARK: - TokenManager
class TokenManager {
    static let shared = TokenManager()
    
    private let userDefaults = UserDefaults.standard
    private let accessTokenKey = "korea_investment_access_token"
    private let tokenExpiryKey = "korea_investment_token_expiry"
    private let tokenIssuedKey = "korea_investment_token_issued"
    
    private init() {}
    
    /// 저장된 토큰이 유효한지 확인 (6시간 갱신 주기 고려)
    var isTokenValid: Bool {
        guard let expiryDateString = userDefaults.string(forKey: tokenExpiryKey),
              let issuedDate = userDefaults.object(forKey: tokenIssuedKey) as? Date else {
            return false
        }
        
        // 토큰 발급 후 6시간이 지났는지 확인 (갱신 주기)
        let sixHoursAfterIssued = issuedDate.addingTimeInterval(6 * 60 * 60) // 6시간
        let now = Date()
        
        // 6시간이 지나지 않았다면 기존 토큰 사용
        if now < sixHoursAfterIssued {
            return true
        }
        
        // 6시간이 지났다면 실제 만료시간 확인
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let expiryDate = dateFormatter.date(from: expiryDateString) else {
            return false
        }
        
        return now < expiryDate
    }
    
    /// 현재 저장된 접근토큰 반환
    var currentAccessToken: String? {
        guard isTokenValid else { return nil }
        return userDefaults.string(forKey: accessTokenKey)
    }
    
    /// 토큰 정보 저장
    func saveToken(_ tokenResponse: TokenResponse) {
        userDefaults.set(tokenResponse.access_token, forKey: accessTokenKey)
        userDefaults.set(tokenResponse.access_token_token_expired, forKey: tokenExpiryKey)
        userDefaults.set(Date(), forKey: tokenIssuedKey)
        
        // Token 구조체의 accessToken도 업데이트
        Token.setAccessToken(to: tokenResponse.access_token)
        
        print("✅ 토큰 저장 완료")
        print("- 토큰: \(tokenResponse.access_token.prefix(20))...")
        print("- 만료시간: \(tokenResponse.access_token_token_expired)")
    }
    
    /// 저장된 토큰 정보 삭제
    func clearToken() {
        userDefaults.removeObject(forKey: accessTokenKey)
        userDefaults.removeObject(forKey: tokenExpiryKey)
        userDefaults.removeObject(forKey: tokenIssuedKey)
        Token.setAccessToken(to: "")
        print("🗑️ 토큰 정보 삭제 완료")
    }
    
    /// 앱 시작 시 저장된 토큰 로드
    func loadSavedToken() {
        if let savedToken = currentAccessToken {
            Token.setAccessToken(to: savedToken)
            print("📱 저장된 토큰 로드 완료: \(savedToken.prefix(20))...")
        } else {
            print("❌ 유효한 저장된 토큰이 없습니다.")
        }
    }
    
    /// 토큰 상태 정보 출력 (디버깅용)
    func printTokenStatus() {
        print("=== 토큰 상태 ===")
        print("유효한 토큰 존재: \(isTokenValid)")
        
        if let issuedDate = userDefaults.object(forKey: tokenIssuedKey) as? Date {
            let sixHoursLater = issuedDate.addingTimeInterval(6 * 60 * 60)
            let timeUntilRefresh = sixHoursLater.timeIntervalSinceNow
            
            if timeUntilRefresh > 0 {
                let hours = Int(timeUntilRefresh) / 3600
                let minutes = Int(timeUntilRefresh) % 3600 / 60
                print("갱신까지 남은 시간: \(hours)시간 \(minutes)분")
            } else {
                print("갱신 가능한 시점입니다.")
            }
        }
        
        if let expiryString = userDefaults.string(forKey: tokenExpiryKey) {
            print("토큰 만료시간: \(expiryString)")
        }
        print("===============")
    }
}
