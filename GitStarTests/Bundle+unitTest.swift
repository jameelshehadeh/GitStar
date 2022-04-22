//
//  Bundle+unitTest.swift
//  GitStarTests
//
//  Created by Jameel Shehadeh on 16/04/2022.
//

import Foundation

extension Bundle {
    public class var unitTest: Bundle {
        return Bundle(for: NetworkManagerTests.self)
    }
}
