//
//  APIURLRequest.swift
//  SocialNetwork
//
//  Created by Wanaldino on 11/3/19.
//  Copyright © 2019 Wanaldino. All rights reserved.
//

import Foundation

class APIURLRequest<T: Decodable> {
    
    var urlString: String
    var httpMethod: HTTPMethod
    var urlParameters: URLParameters
    var bodyParameters: BodyParameters
    var httpHeaders: HTTPHeaders
    var resultType: T.Type
    var cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
    var timeoutInterval = 10.0 //One minute
    
    init(urlString: String, httpMethod: HTTPMethod = .get, urlParameters: URLParameters = [:], bodyParameters: BodyParameters = [:], headers: HTTPHeaders = [:], resultType: T.Type) {
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.urlParameters = urlParameters
        self.bodyParameters = bodyParameters
        self.httpHeaders = headers
        self.resultType = resultType
    }
    
    private func setHTTPMethod(to urlRequest: inout URLRequest) {
        urlRequest.httpMethod = self.httpMethod.rawValue
    }
    
    private func addHeaders(to urlRequest: inout URLRequest) {
        if let token = UserDefaults.standard.string(forKey: "access_token") {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.httpHeaders.forEach { (key, value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func addUrlParameters(to urlRequest: inout URLRequest) {
        if self.urlParameters.count == 0 { return }
        
        let urlParametersString = self.urlParameters.compactMap({ $0.key + "=" + $0.value}).joined(separator: "&")
        guard let urlString = urlRequest.url?.absoluteString else { return }
        guard let url = URL(string: urlString + "?" + urlParametersString) else { return }
        
        urlRequest.url = url
    }
    
    private func addBodyParameters(to urlRequest: inout URLRequest) {
        if self.bodyParameters.count == 0 { return }
        
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: self.bodyParameters, options: .prettyPrinted)
    }
    
    func getURLResquest() -> URLRequest? {
        guard let url = URL(string: self.urlString) else { return nil }
        var urlRequest = URLRequest(url: url, cachePolicy: self.cachePolicy, timeoutInterval: self.timeoutInterval)
        
        self.setHTTPMethod(to: &urlRequest)
        self.addHeaders(to: &urlRequest)
        self.addUrlParameters(to: &urlRequest)
        self.addBodyParameters(to: &urlRequest)
        
        return urlRequest
    }
}
