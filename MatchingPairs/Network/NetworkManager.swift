//
//  NetworkManager.swift
//  MatchingPairs
//
//  Created by Elena Diana Morosanu on 28.06.2024.
//

import Foundation
import Combine

protocol NetworkManager {
    func fetchData<T: Decodable>(from urlString: String) -> AnyPublisher<T, Error>
}

class URLNetworkManager: NetworkManager {
    
    static var shared = URLNetworkManager()
    private init() { }
    
    func fetchData<T>(from urlString: String) -> AnyPublisher<T, any Error> where T : Decodable {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    enum NetworkError: Error {
           case invalidURL
       }
}
