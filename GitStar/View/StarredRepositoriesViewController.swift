//
//  ViewController.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 11/04/2022.
//

import UIKit

class StarredRepositoriesViewController: UIViewController {
    
    var viewModel : StarredRepositoriesViewModel = {
        return StarredRepositoriesViewModel()
    }()
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(StarredRepoTableViewCell.nibName(), forCellReuseIdentifier: "StarredRepoCell")
        tableView.rowHeight = 140
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        viewModel.delegate = self
        viewModel.getStarredRepoData()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
}

//MARK: - TableView DataSource/Delegate methods

extension StarredRepositoriesViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarredRepoCell", for: indexPath) as! StarredRepoTableViewCell
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.starredRepoCellViewModel = cellViewModel
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

//MARK: -  StarredRepositoriesHomeViewDelegate

extension StarredRepositoriesViewController : StarredRepositoriesViewModelDelegate {
    func didRecieveData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
        }
    }
}

//MARK: - UIScrollViewDelegate
extension StarredRepositoriesViewController : UIScrollViewDelegate {
    
    //Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        if position + tableView.frame.height == tableView.contentSize.height || position + tableView.frame.height > tableView.contentSize.height  {
            viewModel.loadMoreData()
        }
    }
}
