//
//  URLRequest+Extension.swift
//  KakaoBankAppStoreSearch
//
//  Created by 양호준 on 2023/09/17.
//

import Foundation

extension URLRequest {
    init?(api: APIProtocol) {
        guard let url = api.url else {
            return nil
        }

        self.init(url: url)
        self.httpMethod = "\(api.method)"
    }
}
