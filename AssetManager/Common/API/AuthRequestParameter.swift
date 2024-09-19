//
//  AuthRequestParameter.swift
//  AssetManager
//
//  Created by 정다연 on 8/29/24.
//

import Foundation

// MARK: - AuthRequestParameter
struct AuthRequestParameter: Codable {
    let grantType, appkey, appsecret: String?

    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case appkey, appsecret
    }
}
