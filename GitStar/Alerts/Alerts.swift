//
//  Alerts.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 15/04/2022.
//

import Foundation
import UIKit

class Alerts {
    
    static func showeErrorFetchingMoreReposAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: "Error loading more repositories.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        return alert
    }

}
