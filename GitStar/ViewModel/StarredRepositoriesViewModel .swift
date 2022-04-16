//
//  StarredRepoViewModel.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 12/04/2022.
//

import Foundation

protocol StarredRepositoriesViewModelDelegate : AnyObject {
    func didRecieveData()
    func didFailRecievingData(error : Error)
}

class StarredRepositoriesViewModel {

    private var starredReposCellViewModels: [StarredRepositoryCellViewModel] = [StarredRepositoryCellViewModel]()
    
    private var starredRepoModels = [StarredRepoModel]()
    
    weak var delegate : StarredRepositoriesViewModelDelegate?
    
    var pageCount = 1
    
    var isPaginating = false
    
    var requestDate : String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "YYYY-MM-d"
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -31, to: currentDate) else {
            return ""
        }
        return dateFormatter.string(from: fromDate)
    }
    
    // Fetching the most starred repos in the last 30 days for the current date
    func getStarredRepoData() {
        NetworkManager.networkManager.fetchData(with: "https://api.github.com/search/repositories?q=created:%3E\(requestDate)&sort=stars&order=desc&per_page=100&page=\(pageCount)") { [weak self] result in
            switch result {
            case .success(let starredRepoData):
                self?.starredRepoModels = starredRepoData
                self?.processFetchedRepoData(repos: self?.starredRepoModels)
            case .failure(let error):
                self?.delegate?.didFailRecievingData(error: error)
            }
        }
    }
    
    //MARK: - Pagination
    
    // Fetching the next page for the most starred repos
    func loadMoreData() {
       
        guard isPaginating == false , !starredRepoModels.isEmpty else {
            return
        }
        pageCount += 1
        isPaginating = true
        NetworkManager.networkManager.fetchData(with: "https://api.github.com/search/repositories?q=created:%3E\(requestDate)&sort=stars&order=desc&per_page=100&page=\(pageCount)") { [weak self] result in
            switch result {
            case .success(let starredRepoData):
                self?.starredRepoModels.append(contentsOf: starredRepoData)
                self?.processFetchedRepoData(repos: self?.starredRepoModels)
                self?.isPaginating = false
            case .failure(let error):
                self?.delegate?.didFailRecievingData(error: error)
            }
        }
    }
    
    // Formatting the fetched date for each starred repository
    func parseDateFormat(dateAsString : String) -> String? {
        
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
    func calculateTime(repoCreatedTime : Double , currentTime : TimeInterval) -> String {
        
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
    
    // Creating CellViewModels from the fetched Starred repositories
    func processFetchedRepoData(repos : [StarredRepoModel]?) {
        var viewModels = [StarredRepositoryCellViewModel]()
        
        for repo in starredRepoModels {
            let cellVM = StarredRepositoryCellViewModel(starredRepoName: repo.name ?? "", starredRepoDescription: repo.description ?? "No description Available", starredRepoStarsCount: repo.stargazers_count ?? 0 , starredRepoIssuesCount: repo.open_issues_count ?? 0, starredRepoDateOfCreation: parseDateFormat(dateAsString: repo.created_at ?? "") ?? "", imageURL: repo.owner.avatar_url ?? "")
            viewModels.append(cellVM)
        }
        starredReposCellViewModels = viewModels
        delegate?.didRecieveData()
    }
    
    // Returning numberOfCells for the TableView
    func numberOfCells()-> Int {
        return starredReposCellViewModels.count
    }
    
    // Returning cellModel for each cell in the TableView
    func getCellViewModel( at indexPath: IndexPath ) -> StarredRepositoryCellViewModel {
        return starredReposCellViewModels[indexPath.row]
    }

}
