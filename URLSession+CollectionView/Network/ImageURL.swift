//
//  ImageURL.swift
//  URLSession+CollectionView
//
//  Created by 양호준 on 2023/10/18.
//

import Foundation

struct ImageListAPI: APIProtocol {
    let url: URL?
    let method: HttpMethod = .get
    
    init(page: Int) {
        var urlComponents = URLComponents(string: "\(ConfigManager.shared.baseURL)photos")
        let queryItems = [
            URLQueryItem(name: "client_id", value: "\(ConfigManager.shared.accessKey)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        urlComponents?.queryItems = queryItems
        
        self.url = urlComponents?.url
    }
}
