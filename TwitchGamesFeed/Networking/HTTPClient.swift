//
//  HTTPClient.swift
//  SimpleWeather
//
//  Created by Alexander on 25.05.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Alamofire
import Foundation

enum HTTPErrors: Error {
    case parsingError
}

class HTTPClient {
    func get<T: Decodable>(url: String,
                           headers: HTTPHeaders?,
                           parameters: [String: Any]?, completionHandler: @escaping(Result<T, HTTPErrors>) -> Void) {
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseData { data in
                switch data.result {
                case .failure(let err):
                    print(err)
                case .success(let responseData):
                    do {
                        let jsonDecoder = JSONDecoder()
                        let decodedResponseData = try jsonDecoder.decode(T.self, from: responseData)
                        completionHandler(.success(decodedResponseData))
                    } catch {
                        completionHandler(.failure(.parsingError))
                    }
                }
        }
    }
}
