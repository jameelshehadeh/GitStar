//
//  StringDateFormatter.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 19/04/2022.
//

import Foundation

class StringDateFormatter {
        
    // Formatting the fetched date for each starred repository
    static func parseDateFormat(dateAsString : String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "YYYY-M-d-H:m:sZ"
        let dateSubstrings = dateAsString.split(separator: "T")
        
        let dateFirstPart = dateSubstrings[0] + "-" + dateSubstrings[1]
        
        guard let formattedDate = dateFormatter.date(from: String(dateFirstPart)) else {
            return nil
        }
    
        let date = formattedDate.timeIntervalSince1970
        let timePostedSecondsSince1970 = Double(date)
        let currentTime = Date().timeIntervalSince1970
        return calculateTime(repoCreatedTime: timePostedSecondsSince1970, currentTime: currentTime)
    }
    
    // Calculating the repository's time since it was created
    private static func calculateTime(repoCreatedTime : Double , currentTime : TimeInterval) -> String {
        
        let postedSinceTimeInSeconds = currentTime - repoCreatedTime
        
        switch postedSinceTimeInSeconds {
        case 0...59 :
            return "now"
        case 60...3600 :
            let time = Int(postedSinceTimeInSeconds / 60)
            if time == 1 {
                return "\(time) min ago"
            }
            return "\(time) mins ago"
        case 3600...86400 :
            let time = Int(postedSinceTimeInSeconds / 3600)
            if time == 1 {
                return "\(time) hour ago"
            }
            return"\(time) hours ago"
        case 86400...604800 :
            let time = Int(postedSinceTimeInSeconds / 86400)
            if time == 1 {
                return "\(time) day ago"
            }
            return"\(time) days ago"
        case 604800...2419200 :
            let time = Int(postedSinceTimeInSeconds / 604800)
            if time == 1 {
                return " \(time) week ago"
            }
            return "\(time) weeks ago"
        case 2419200...29030400 :
            let time = Int(postedSinceTimeInSeconds / 2419200)
            if time == 1 {
                return "\(time) month ago"
            }
            return "\(time) months ago"
        case 29030400... :
            let time = Int(postedSinceTimeInSeconds / 29030400)
            if time == 1 {
                return "\(time) year ago"
            }
            return"\(time) years ago"
        default:
            return "no time"
        }
    }
    
}
