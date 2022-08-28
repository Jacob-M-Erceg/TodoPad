//
//  Endpoints.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-28.
//

import Foundation

enum Endpoint {
    case getMinimumAppVersion(path: String = "/api/app-conf")
    
    var request: URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValues(for: self)
        
        return request
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.baseURL
        components.port = Constants.port
        components.path = path
        return components.url
    }
    
    private var path: String {
        switch self {
        case .getMinimumAppVersion(let path):
            return path
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .getMinimumAppVersion:
            return HTTP.Method.get.rawValue
        }
    }
}
