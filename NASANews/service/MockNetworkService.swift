//
//  MockNetworkService.swift
//  NASANews
//
//  Created by Haneen Medhat on 04/02/2025.
//

import Foundation

class MockNetworkService : NetworkServiceProtocol {
    
    func fetchData(completion : @escaping (Result<[NewsInfo], Error>) -> ()) {
        completion(.success([]))
    }
}
