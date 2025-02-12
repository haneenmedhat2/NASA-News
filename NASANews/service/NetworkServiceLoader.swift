//
//  NetworkServiceLoader.swift
//  NASANews
//
//  Created by Haneen Medhat on 12/01/2025.
//

import Foundation
import UIKit

class NetworkServiceLoader : NetworkServiceProtocol {
    let networkService : NetworkService
    
    init(networkService:NetworkService = .shared){
        self.networkService = networkService
    }
    
    func fetchData(completion: @escaping (Result<[NewsInfo], Error>) -> ()) {
        networkService.networkService(url: Constant.url1, completion: completion)
    }
}
