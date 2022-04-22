//
//  NetworkManagerTests.swift
//  GitStarTests
//
//  Created by Jameel Shehadeh on 16/04/2022.
//

import XCTest
@testable import GitStar

class NetworkManagerTests: XCTestCase {
    
    var sut : NetworkManager!
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager()
    }
    
    override func tearDown() {
     
        sut = nil
        super.tearDown()
    }
    
    func testFetchData() {
        
        let sut = self.sut
        let promise = XCTestExpectation(description: "Data fetched successfully")
        var responseError : Error?
        var resposeData : [StarredRepoModel]?
        
        guard let bundle = Bundle.unitTest.url(forResource: "stub", withExtension: "json") else {
            XCTFail("Could not fetch Data")
            return
        }
        
        let URLAsString = "\(bundle)"
        
        sut!.fetchData(with: URLAsString) { results in
            switch results {
            case .success(let data):
                resposeData = data
                responseError = nil
                promise.fulfill()
            case .failure(let error):
                responseError = error
            }
        }
        
        wait(for: [promise], timeout: 1)
        XCTAssertNil(responseError)
        XCTAssertNotNil(resposeData)
    }
    

}
