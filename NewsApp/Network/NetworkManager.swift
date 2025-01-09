//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Burak Özdemir on 9.01.2025.
//

import Foundation

//MARK: - Enums

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum NetworkError: Error {
    case invalidURL
    case invalidRequest
    case decodeError
    case cannotFindHost
}

enum Endpoint {
    case everything
}

//MARK: - Protocols

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    func request(apiKey: String, subject: String) -> Result<URLRequest, NetworkError>
}

//MARK: - Extensions

extension Endpoint: EndpointProtocol {
    var baseURL: String {
        return "https://newsapi.org/v2"
    }
    
    var path: String {
        switch self {
        case .everything: return "/everything"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .everything: return .GET
        }
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    func request(apiKey: String, subject: String) -> Result<URLRequest, NetworkError> {
        guard let url = URL(string: baseURL + path + "?q=\(subject)&apiKey=\(apiKey)") else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return .success(request)
    }
}

//MARK: - NetworkManager

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let apiKey = "31df781063414c8081ba6142b73be248"
    
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let request = endpoint.request(apiKey: apiKey, subject: "apple")
        
        switch request {
        case .success(let request):
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodeError))
                }
            }
            .resume()
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func getData(completion: @escaping (Result<NewsModel, NetworkError>) -> Void) {
        let endpoint = Endpoint.everything
        request(endpoint: endpoint, completion: completion)
    }
}
