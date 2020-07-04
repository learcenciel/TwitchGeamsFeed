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
    
    static let commonParameters: [String: Any] = [:]
    
    static var headers: HTTPHeaders = [
        "Authorization": "Bearer l7sadz3bg5ir8lepdetca7h5tq7apv",
        "Client-ID": "m61dz6t4k3mkbn7tllby7j7hhob7uz"
    ]
    
    func get<T: Decodable>(url: String,
                           parameters: [String: Any]?, completionHandler: @escaping(Result<T, HTTPErrors>) -> Void) {
        var queryParameters = HTTPClient.commonParameters

        if let parameters = parameters {
            for key in parameters.keys {
                queryParameters[key] = parameters[key]
            }
        }
        
        AF.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPClient.headers).validate().responseData { data in
            switch data.result {
            case .success(let responseData):
                do {
                    let jsonDecoder = JSONDecoder()
                    let decodedResponseData = try jsonDecoder.decode(T.self, from: responseData)
                    completionHandler(.success(decodedResponseData))
                } catch {
                    completionHandler(.failure(.parsingError))
                }
            case .failure:
                completionHandler(.failure(.parsingError))
            }
        }
    }
}
