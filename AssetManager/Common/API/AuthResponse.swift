//
//  AuthResponse.swift
//  AssetManager
//
//  Created by 정다연 on 8/29/24.
//

import Foundation

// MARK: - GetTokenResponse
struct GetTokenResponse: Codable {
    let accessToken, accessTokenTokenExpired, tokenType: String?
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessTokenTokenExpired = "access_token_token_expired"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
