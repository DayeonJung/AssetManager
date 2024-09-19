//
//  AuthTarget.swift
//  AssetManager
//
//  Created by 정다연 on 8/29/24.
//

import Foundation
import Moya

enum AuthTarget {
    case token(AuthRequestParameter)
}

extension AuthTarget: TargetType {
    var baseURL: URL {
        URL(string: APISetting.shared.auth)!
    }
    
    var path: String {
        "/tokenP"
    }
    
    var method: Moya.Method {
        switch self {
        case .token: return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .token(let parameter):
            return .requestJSONEncodable(parameter)
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    
}
