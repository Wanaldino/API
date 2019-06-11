//
//  API.swift
//  SocialNetwork
//
//  Created by Wanaldino on 10/3/19.
//  Copyright © 2019 Wanaldino. All rights reserved.
//

import Foundation

typealias URLParameters = [String: String]
typealias BodyParameters = [String: AnyObject]
typealias HTTPHeaders = [String: String]

class API {
    
    static var isDebugActivate = true
    
    static func startCall<T: Decodable>(_ APIURLRequest: APIURLRequest<T>, success: @escaping (T) -> (), failure: @escaping () -> ()) {
        guard let urlRequest = APIURLRequest.getURLResquest() else { return }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return failedCall(APIURLRequest, response: response, error: error, failure: failure) }
            guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else { return failedCall(APIURLRequest, response: response, error: error, failure: failure) }
            
            successCall(APIURLRequest, response: response, data: decodedData, success: success)
        }
        
        task.resume()
    }
    
    fileprivate static func successCall<T: Decodable>(_ APIURLRequest: APIURLRequest<T>, response: URLResponse?, data: T, success: @escaping (T) -> ()) {
        isDebugActivate ? printSuccessCallDetail(APIURLRequest, response: response as? HTTPURLResponse, data: data) : Void()
        
        DispatchQueue.main.sync { success(data) }
    }
    
    fileprivate static func failedCall<T: Decodable>(_ APIURLRequest: APIURLRequest<T>, response: URLResponse?, error: Error?, failure: @escaping () -> ()) {
        isDebugActivate ? printFailedCallDetail(APIURLRequest, response: response as? HTTPURLResponse, error: error) : Void()
        
        DispatchQueue.main.sync { failure() }
    }
    
    fileprivate static func printSuccessCallDetail<T: Decodable>(_ APIURLRequest: APIURLRequest<T>, response: HTTPURLResponse?, data: T) {
        print("------------------SUCCESS------------------")
        print("URL: ", APIURLRequest.urlString)
        print("HEADERS: ", APIURLRequest.httpHeaders)
        print("RESPONSE CODE: ", response?.statusCode ?? 0)
        print("RESULT: ", data)
    }
    
    fileprivate static func printFailedCallDetail<T: Decodable>(_ APIURLRequest: APIURLRequest<T>, response: HTTPURLResponse?, error: Error?) {
        print("------------------FAILED------------------")
        print("URL: ", APIURLRequest.urlString)
        print("HEADERS: ", APIURLRequest.httpHeaders)
        print("RESPONSE CODE: ", response?.statusCode ?? 0)
        print("ERROR: ", error ?? nil)
    }
}
