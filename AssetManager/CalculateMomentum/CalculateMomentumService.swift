//
//  CalculateMomentumService.swift
//  AssetManager
//
//  Created by 정다연 on 8/29/24.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class CalculateMomentumService {
    static let momentumServiceProvider = MoyaProvider<AuthTarget>(requestClosure: TimeoutClosure)
    static let globalServiceProvider = MoyaProvider<AuthTarget>(requestClosure: TimeoutClosure)
    
    private static let TimeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) -> Void in
        if var urlRequest = try? endpoint.urlRequest() {
            urlRequest.timeoutInterval = 30
            closure(.success(urlRequest))
        } else {
            closure(.failure(MoyaError.requestMapping(endpoint.url)))
        }
    }
    
    private static func JSONResponseDataFormatter(_ data: Data) -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
        } catch {
            return String(data: data, encoding: .utf8) ?? ""
        }
    }
    
    func getToken(parameter: AuthRequestParameter) -> Observable<Result<GetTokenResponse, Error>> {
        return Observable.create { observer in
//            let request = CalculateMomentumService.momentumServiceProvider.rx
//                .request(.token(parameter))
//                .mapObject(GetTokenResponse.self)
//                .asObservable()
//                .subscribe { response in
//                    observer.onNext(.success(response))
//                    observer.onCompleted()
//                } onError: { error in
//                    observer.onError(error)
//                    observer.onCompleted()
//                }
            
            return Disposables.create {
//                request.dispose()
            }
        }
    }
}
