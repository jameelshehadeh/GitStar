//
//  NetworkManager.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 11/04/2022.
//

import Foundation

// Network Errors
enum NetworkManagerErrors : Error {
    case failedFetchData
    case failedToParseJSON
}

class NetworkManager {
    
    static let networkManager = NetworkManager()
    
    // Fetching StarredRepos data
    func fetchData(with url : String , completion : @escaping (Result<[StarredRepoModel],Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            print("error creating URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data , _ , error in
            guard error == nil , let data = data else {
                completion(.failure(NetworkManagerErrors.failedFetchData))
                return
            }
            guard let decodedData = self?.parseJSON(with: data) else {
                completion(.failure(NetworkManagerErrors.failedToParseJSON))
                return
            }
            completion(.success(decodedData.items))
        }.resume()
        
    }
    
    // Parsing JSON
    func parseJSON(with data : Data) -> StarredRepoDataModel? {
        
        do {
            let decodedData = try JSONDecoder().decode(StarredRepoDataModel.self, from: data)
            return decodedData
        }
        
        catch {
            return nil
        }
    }
    
}


