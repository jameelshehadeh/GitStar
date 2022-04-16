//
//  StarredRepoTableViewCell.swift
//  GitStar
//
//  Created by Jameel Shehadeh on 11/04/2022.
//

import UIKit
import SDWebImage

class StarredRepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoStarsLabel: UILabel!
    @IBOutlet weak var repoIssuesLabel: UILabel!
    @IBOutlet weak var repoDateOfCreationLabel: UILabel!
    @IBOutlet weak var repoOwnerImageView: UIImageView!
    
    var starredRepoCellViewModel : StarredRepositoryCellViewModel? {
        didSet {
            guard let repoName = starredRepoCellViewModel?.starredRepoName , let dateOfCreation = starredRepoCellViewModel?.starredRepoDateOfCreation , let starsCount = starredRepoCellViewModel?.starredRepoStarsCount , let issuesCount = starredRepoCellViewModel?.starredRepoIssuesCount , let imageURLString = starredRepoCellViewModel?.imageURL else {
                return
            }
            repoNameLabel.text = starredRepoCellViewModel?.starredRepoName
            repoDescriptionLabel.text = starredRepoCellViewModel?.starredRepoDescription
            repoStarsLabel.text = "Stars: \(starsCount)"
            repoIssuesLabel.text = "Issues: \(issuesCount)"
            repoDateOfCreationLabel.text = "Submitted \(dateOfCreation) by \(repoName)"
            
            guard let imageURL = URL(string: imageURLString) else {
                return
            }
            repoOwnerImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "person.circle.fill"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        repoDateOfCreationLabel.adjustsFontSizeToFitWidth = true
        repoStarsLabel.adjustsFontSizeToFitWidth = true
        repoIssuesLabel.adjustsFontSizeToFitWidth = true
        repoOwnerImageView.layer.cornerRadius = repoOwnerImageView.frame.width/2
        configureCellUI()
    }
    
    // Configuring UITableViewCell appearance
    func configureCellUI(){
        repoStarsLabel.backgroundColor = .systemGreen
        repoIssuesLabel.backgroundColor = .systemGreen
        repoStarsLabel.layer.cornerRadius = 6
        repoIssuesLabel.layer.cornerRadius = 6
        repoStarsLabel.layer.masksToBounds = true
        repoIssuesLabel.layer.masksToBounds = true
        repoStarsLabel.textColor = .white
        repoIssuesLabel.textColor = .white
    }
        
    static func nibName()-> UINib {
        return UINib(nibName: "StarredRepoTableViewCell", bundle: nil)
    }
    
}
 
 
