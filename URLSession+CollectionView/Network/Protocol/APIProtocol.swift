//
//  APIProtocol.swift
//  KakaoBankAppStoreSearch
//
//  Created by 양호준 on 2023/09/17.
//

import Foundation

protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

enum HttpMethod {
    case get

    var description: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}
