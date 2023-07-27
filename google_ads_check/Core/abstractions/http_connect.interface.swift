//
//  http_connect.interface.swift
//  google_ads_check
//
//  Created by Shahanul on 16/7/23.
//

import Foundation

enum HTTPError: Error {
    case requestFailed
    case invalidResponse
    case dataConversionFailed
    case invalidURL
}

protocol IHttpConnect {
    
    func get<T: Codable>(
        _ url: String,
        headers: [String: String]?,
        query: [String: String]?
    ) async throws ->  AppResponse<T>
    
    func post<T: Codable>(
        _ url: String,
        body: Data?,
        headers: [String: String]?,
        query: [String: String]?
    ) async throws ->  AppResponse<T>
    
    func put<T: Codable>(
        _ url: String,
        body: Data?,
        headers: [String: String]?
    ) async throws ->  AppResponse<T>
    
    func patch<T: Codable>(
        _ url: String,
        body: Data?,
        headers: [String: String]?
    ) async throws ->  AppResponse<T>
    
    func delete<T: Codable>(
        _ url: String,
        headers: [String: String]?,
        query: [String: String]?
    ) async throws ->  AppResponse<T>
}


class DefaultHttpConnect : IHttpConnect {
    func get< T: Codable>(_ url: String, headers: [String : String]?, query: [String : String]?) async throws -> AppResponse<T> where T : Decodable, T : Encodable {
        var request = try buildUrl(url, query: query, body: nil, headers: headers)
        request.httpMethod = "GET"
        return try await sendRequest(url: request)
    }
    
    func post< T: Codable>(_ url: String, body: Data?, headers: [String : String]?, query: [String : String]?) async throws -> AppResponse<T> where T : Decodable, T : Encodable {
        
        var request = try buildUrl(url, query: query, body: body, headers: headers)
        request.httpMethod = "POST"
        return try await sendRequest(url: request)
    }
    
    func put< T: Codable>(_ url: String, body: Data?, headers: [String : String]?) async throws -> AppResponse<T> where T : Decodable, T : Encodable {
        var request = try buildUrl(url, query: nil, body: body, headers: headers)
        request.httpMethod = "PUT"
        return try await sendRequest(url: request)
    }
    
    func patch< T: Codable>(_ url: String, body: Data?, headers: [String : String]?) async throws -> AppResponse<T> where T : Decodable, T : Encodable {
        var request = try buildUrl(url, query: nil, body: body, headers: headers)
        request.httpMethod = "PATCH"
        return try await sendRequest(url: request)
    }
    
    func delete< T: Codable>(_ url: String, headers: [String : String]?, query: [String : String]?) async throws -> AppResponse<T> where T : Decodable, T : Encodable {
        var request = try buildUrl(url, query: query, body: nil, headers: headers)
        request.httpMethod = "DELETE"
        return try await sendRequest(url: request)
    }
    
    
    
    
    let baseURL: URL
    let session: URLSession
    
    init(baseURL: URL) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: .default)
    }
    
    func buildUrl( _ path: String,
                   query: [String : String]?,
                   body: Data?,
                   headers: [String: String]?
                   
    )throws -> URLRequest{
        
        throw HTTPError.invalidURL
        let url = URL(string: path, relativeTo: baseURL)
        
        guard let url = url else{
            throw HTTPError.invalidURL
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        var queryItems:[URLQueryItem] = []
        
        // query params
        if let query = query , !query.isEmpty{
           
            for item in query {
               // print("\(item.key) => \(String(describing: item.value))")
                let v =  URLQueryItem(name: item.key, value: item.value)
                queryItems.append(v)
            }
            
        }
        
        
        
        urlComponents?.queryItems = queryItems
        
        
        guard let apiUrl = urlComponents?.url else {
            throw HTTPError.invalidURL
        }
        print( "url => \(apiUrl.absoluteString)")
        
        var request = URLRequest(url: apiUrl)
        
        
        
        // headers
        if let headers = headers, !headers.isEmpty {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        //body
        request.httpBody = body
        
        return request;
        
    }
    
    
    
    private func sendRequest<R: Codable>(url: URLRequest  )async throws -> AppResponse<R> {
        
        do{
            let (data, res) = try await session.data(for: url)
            
            let response = res as? HTTPURLResponse
            
            let responseData = try JSONDecoder().decode(R.self, from: data)
            
            return AppResponse(statusCode:  response?.statusCode ?? 299 , payload: responseData);
        }
        
        catch  {
            throw error
        }
        
    }
}
