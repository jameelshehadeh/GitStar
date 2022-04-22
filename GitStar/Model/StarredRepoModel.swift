//
//  StarredRepoModel.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 11/04/2022.
//

import Foundation

struct StarredRepoModel : Decodable {
    
    let name : String?
    let description : String?
    let stargazers_count : Int?
    let open_issues_count : Int?
    let created_at : String?
    let owner : OwnerModel
    
}
