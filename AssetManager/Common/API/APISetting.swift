//
//  APISetting.swift
//  AssetManager
//
//  Created by 정다연 on 8/29/24.
//

import Foundation

class APISetting {
    static let shared = APISetting()

    var domain: String {
        return "https://openapi.koreainvestment.com:9443"
    }
    
    var auth: String {
        "\(domain)/oauth2"
    }
    
    var overseasPrice: String {
        "\(auth)/uapi/overseas-price/v1/quotations"
    }
}
