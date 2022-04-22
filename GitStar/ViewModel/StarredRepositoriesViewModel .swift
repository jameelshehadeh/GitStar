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

    let networkManagerProtocol : NetworkManagerProtocol
    
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
    
    init(networkManagerProtocol: NetworkManagerProtocol = NetworkManager()){
        self.networkManagerProtocol = networkManagerProtocol
    }
    
    // Fetching the most starred repos in the last 30 days for the current date
    func fetchStarredRepoData() {
        
        let requestURL = "\(NetworkConstants.baseURL)/search/repositories?q=created:%3E\(requestDate)&sort=stars&order=desc&per_page=100&page=\(pageCount)"
        
        networkManagerProtocol.fetchData(with: requestURL ) { [weak self] result in
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
        
        let requestURL = "\(NetworkConstants.baseURL)/search/repositories?q=created:%3E\(requestDate)&sort=stars&order=desc&per_page=100&page=\(pageCount)"
        
        networkManagerProtocol.fetchData(with: requestURL) { [weak self] result in
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
    
    // Creating CellViewModels from the fetched Starred repositories
    func processFetchedRepoData(repos : [StarredRepoModel]?) {
        var viewModels = [StarredRepositoryCellViewModel]()
        
        for repo in starredRepoModels {
            let cellVM = StarredRepositoryCellViewModel(starredRepoName: repo.name ?? "", starredRepoDescription: repo.description ?? "No description Available", starredRepoStarsCount: repo.stargazers_count ?? 0 , starredRepoIssuesCount: repo.open_issues_count ?? 0, starredRepoDateOfCreation: StringDateFormatter.parseDateFormat(dateAsString: repo.created_at ?? "") ?? "", imageURL: repo.owner.avatar_url ?? "")
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
