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
        tableView.rowHeight = 157
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
    
    // Showing ActivityIndicator for pagination
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = .gray
        footerView.addSubview(spinner)
        DispatchQueue.main.async {
            spinner.startAnimating()
        }
        return footerView
    }
    
}

//MARK: - TableView DataSource/Delegate methods

extension StarredRepositoriesViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StarredRepoCell", for: indexPath) as! StarredRepoTableViewCell
        cell.selectionStyle = .none
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
    
    func didFailRecievingData(error: Error) {
        DispatchQueue.main.async {
            self.present(Alerts.showeErrorFetchingMoreReposAlert(), animated: true)
        }
    }
    
    func didRecieveData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.tableFooterView = nil
        }
    }
}

//MARK: - UIScrollViewDelegate

extension StarredRepositoriesViewController : UIScrollViewDelegate {
    //Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.tableFooterView = self?.createSpinnerFooter()
        }
        let position = scrollView.contentOffset.y
        if position + tableView.frame.height == tableView.contentSize.height || position + tableView.frame.height > tableView.contentSize.height  {
            viewModel.loadMoreData()
        }
    }
}
