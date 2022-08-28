//
//  HTTP.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-28.
//

import Foundation

enum HTTP {
    enum Method: String {
        case get = "GET"
    }
    
    enum Header {
        enum Field: String {
            case contentType = "Content-Type"
        }
        
        enum Value: String {
            case applicationJson = "application/json"
        }
    }
}

extension URLRequest {
    
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {
        case .getMinimumAppVersion:
            setValue(HTTP.Header.Value.applicationJson.rawValue, forHTTPHeaderField: HTTP.Header.Field.contentType.rawValue)
        }
    }
}

extension JSONSerialization {
    
    static func getDictonaryResponse(data: Data, key: String) -> String? {
        
        if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let responseString = dict[key] as? String {
            return responseString
        } else {
            return nil
        }
    }
}
