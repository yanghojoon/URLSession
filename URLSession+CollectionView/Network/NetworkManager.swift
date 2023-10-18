//
//  NetworkManager.swift
//  URLSession+CollectionView
//
//  Created by 양호준 on 2023/10/18.
//

import Foundation

import RxSwift

struct NetworkManager {
    private let session: URLSessionProtocol
    private let disposeBag = DisposeBag()

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Basic URLSession
    func fetchData<T: Decodable>(page: Int, decodingType: T.Type) {
        
    }

    // MARK: - RxSwift
    func fetchData<T: Decodable>(api: APIProtocol, decodingType: T.Type) -> Observable<T> {
        return Observable.create { emitter in
            guard let task = dataTask(api: api, emitter: emitter) else {
                return Disposables.create()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func dataTask<T: Decodable>(api: APIProtocol, emitter: AnyObserver<T>) -> URLSessionDataTask? {
        guard let urlRequest = URLRequest(api: api) else {
            emitter.onError(NetworkError.urlIsNil)
            return nil
        }

        let task = session.dataTask(with: urlRequest) { data, response, _ in
            let successStatusCode = 200..<300
            guard let httpResponse = response as? HTTPURLResponse,
                  successStatusCode.contains(httpResponse.statusCode) else {
                emitter.onError(NetworkError.statusCodeError)
                return
            }

            if let data = data {
                guard let decodedData = JSONParser<T>().decode(from: data) else {
                    emitter.onError(JSONParserError.decodingFail)
                    return
                }

                emitter.onNext(decodedData)
            }
        }

        return task
    }
}

// MARK: - Error
extension NetworkManager {
    private enum NetworkError: Error, LocalizedError {
        case statusCodeError
        case unknownError
        case urlIsNil
        
        var errorDescription: String? {
            switch self {
            case .statusCodeError:
                return "정상적인 StatusCode가 아닙니다."
            case .unknownError:
                return "알수 없는 에러가 발생했습니다."
            case .urlIsNil:
                return "정상적인 URL이 아닙니다."
            }
        }
    }
}
