//
//  NetworkManager.swift
//  HarshDemoPractical
//
//  Created by My Mac Mini on 09/02/24.
//


import UIKit

enum HttpMehtod : String{
    case get = "GET"
    case post = "POST"
}

class NetworkManager {
    
    static let shared = NetworkManager()
   
    private init() {}
    
    func requestApi<T: Codable>(
        modelType: T.Type,
        urlString: String,
        httpMethod: HttpMehtod,
        param: Encodable? = nil,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        
        guard let url = URL(string: Constant.MAIN_URL + urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if let parameters = param {
            request.httpBody = try? JSONEncoder().encode(parameters)
        }
        
        if let headers = Utility.shared.getHeader() {
            request.allHTTPHeaderFields = headers
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                if let httpResponse = response as? HTTPURLResponse {
                    print("Error: Invalid response. Status code: \(httpResponse.statusCode)")
                } else {
                    print("Error: Invalid response. Unknown status code")
                }
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedModel = try JSONDecoder().decode(modelType.self, from: data)
                completion(.success(decodedModel))
            } catch {
                print("Error decoding data:", error)
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    
    
}

