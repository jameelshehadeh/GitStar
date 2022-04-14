//
//  StarredRepoTableViewCell.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 11/04/2022.
//

import UIKit
import SwiftUI

class StarredRepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoStarsLabel: UILabel!
    @IBOutlet weak var repoIssuesLabel: UILabel!
    @IBOutlet weak var repoDateOfCreationLabel: UILabel!
    @IBOutlet weak var repoOwnerImageView: UIImageView!
    
    var starredRepoCellViewModel : StarredRepositoryCellViewModel? {
        didSet {
            guard let repoName = starredRepoCellViewModel?.starredRepoName , let dateOfCreation = starredRepoCellViewModel?.starredRepoDateOfCreation , let starsCount = starredRepoCellViewModel?.starredRepoStarsCount , let issuesCount = starredRepoCellViewModel?.starredRepoIssuesCount , let imageURL = starredRepoCellViewModel?.imageURL else {
                return
            }
            repoNameLabel.text = starredRepoCellViewModel?.starredRepoName
            repoDescriptionLabel.text = starredRepoCellViewModel?.starredRepoDescription
            repoStarsLabel.text = "Stars: \(starsCount)"
            repoIssuesLabel.text = "Issues: \(issuesCount)"
            repoDateOfCreationLabel.text = "Submitted \(dateOfCreation) by \(repoName)"
            
            downloadImage(from: imageURL) { [weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.repoOwnerImageView.image = image
                    }
                case .failure(_):
                    break
                }
            }
        }
    }

    func downloadImage(from URLString : String , completion : @escaping (Result<UIImage,Error>)->Void) {
        
        guard let imageURL = URL(string: URLString) else {
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data , _ , error in
            guard error == nil , let data = data else {
                return
            }
            // got data
            guard let image = UIImage(data: data) else {
                return
            }
            completion(.success(image))
        }.resume()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        repoDateOfCreationLabel.adjustsFontSizeToFitWidth = true
        repoStarsLabel.adjustsFontSizeToFitWidth = true
        repoIssuesLabel.adjustsFontSizeToFitWidth = true
        repoOwnerImageView.layer.cornerRadius = repoOwnerImageView.frame.width/2
    }
    
    func configureCellUI(){
        
        repoStarsLabel.backgroundColor = .systemGreen
        repoStarsLabel.layer.cornerRadius = 8
        repoStarsLabel.textColor = .white
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    static func nibName()-> UINib {
        return UINib(nibName: "StarredRepoTableViewCell", bundle: nil)
    }
    
}
 
 
