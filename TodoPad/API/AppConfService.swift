//
//  AppConfService.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-28.
//

import Foundation

enum AppConfServiceError: Error {
    case serverError(String)
    case unknown(String = "An unknown error occurred.")
    case decodingError(String = "Error parsing server response.")
}

class AppConfService {
    
    static func getMinimumAppVersion(completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = Endpoint.getMinimumAppVersion().request else { return }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(AppConfServiceError.unknown(error.localizedDescription)))
                return
            }
            
            if let data = data {
                if let minimumAppVersion = JSONSerialization.getDictonaryResponse(data: data, key: "min-app-version") {
                    completion(.success(minimumAppVersion))
                } else {
                    completion(.failure(AppConfServiceError.decodingError("Error decoding min-app-version")))
                }
            } else {
                completion(.failure(AppConfServiceError.serverError("Nil data response.")))
            }
        }.resume()
    }
}
