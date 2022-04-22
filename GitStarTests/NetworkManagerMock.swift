//
//  NetworkManagerMock.swift
//  GitStarTests
//
//  Created by Jameel Shehadeh on 21/04/2022.
//

import Foundation

@testable import GitStar
import XCTest

class NetworkManagerMock : NetworkManagerProtocol {
    
    var fetchDataisCalled = false
        
    var fetchError : NetworkManagerErrors!
    
    func fetchData(with url: String, completion: @escaping (Result<[StarredRepoModel], Error>) -> Void) {
        fetchDataisCalled = true
    }
    
    func fetchFailure(error : NetworkManagerErrors) {
        fetchError = NetworkManagerErrors.failedFetchData
    }

}
