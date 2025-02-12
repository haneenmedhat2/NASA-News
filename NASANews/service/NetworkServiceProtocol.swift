//
//  NetworkServiceProtocol.swift
//  NASANews
//
//  Created by Haneen Medhat on 12/01/2025.
//

import Foundation

protocol NetworkServiceProtocol {
    
    func fetchData(completion : @escaping (Result<[NewsInfo], Error>) -> ())
}
