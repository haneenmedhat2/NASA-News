//
//  NetworkService.swift
//  NASANews
//
//  Created by Haneen Medhat on 21/12/2024.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private init(){}
    
    func networkService <T:Decodable>(url:URL,completion: @escaping  (Result<T,Error>) -> Void){
      
        let request = URLRequest(url: url)
         URLSession.shared.dataTask(with: request){ data,response,error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                print("No data was found")
                return
            }
                do{
                    let result = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            
        }.resume()
    }
    
}
