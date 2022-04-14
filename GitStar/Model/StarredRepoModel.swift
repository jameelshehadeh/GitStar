//
//  StarredRepoModel.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 11/04/2022.
//

import Foundation

struct StarredRepoData : Decodable {

    let total_count : Int
    let incomplete_results : Bool
    let items : [StarredRepoModel]
    
}

struct OwnerModel : Decodable {
    let avatar_url : String?
}

struct StarredRepoModel : Decodable {
    
    let name : String?
    let description : String?
    let stargazers_count : Int?
    let open_issues_count : Int?
    let created_at : String?
    let owner : OwnerModel
}


