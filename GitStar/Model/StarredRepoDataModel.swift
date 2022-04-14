//
//  StarredRepoData.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 14/04/2022.
//

import Foundation

struct StarredRepoDataModel : Decodable {

    let total_count : Int
    let incomplete_results : Bool
    let items : [StarredRepoModel]
    
}
