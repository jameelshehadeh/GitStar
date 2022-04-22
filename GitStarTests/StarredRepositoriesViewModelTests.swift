//
//  StarredRepositoriesViewModelTests.swift
//  GitStarTests
//
//  Created by Jameel Shehadeh on 16/04/2022.
//

import XCTest

@testable import GitStar

class StarredRepositoriesViewModelTests: XCTestCase {

    var sut: StarredRepositoriesViewModel!
    
    var networkManagerMock = NetworkManagerMock()
    
    override func setUp() {
        super.setUp()
        sut = StarredRepositoriesViewModel(networkManagerProtocol: networkManagerMock)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testfetchData(){
        
        sut.networkManagerProtocol.fetchData(with: "") { _ in
            
        }
        
        XCTAssert(networkManagerMock.fetchDataisCalled)
    }
    
    func testfetchFailure(){
    
        let error = NetworkManagerErrors.failedFetchData
        
        networkManagerMock.fetchFailure(error: error)
    
        let apiError = networkManagerMock.fetchError
        
        XCTAssertEqual(error, apiError)
    }
    
}
 
