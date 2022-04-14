//
//  NetworkManager.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 11/04/2022.
//

import Foundation

class NetworkManager {
    
    static let networkManager = NetworkManager()
    
    func fetchData(with url : String , completion : @escaping (Result<[StarredRepoModel],Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            print("error")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data , _ , error in
            guard error == nil , let data = data else {
                print("error2")
                return
            }
            guard let decodedData = self?.parseJSON(with: data) else {
                print("error parsing JSON")
                return
            }
            completion(.success(decodedData.items))
            
        }.resume()
        
    }
    
    func parseJSON(with data : Data) -> StarredRepoData? {
        
        do {
            let decodedData = try JSONDecoder().decode(StarredRepoData.self, from: data)
            return decodedData
        }
        
        catch {
            return nil
        }
        
    }

}
