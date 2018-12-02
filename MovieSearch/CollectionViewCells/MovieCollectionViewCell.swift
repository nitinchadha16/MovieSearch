//
//  MovieCollectionViewCell.swift
//  MovieSearch
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var failedLabel: UILabel!
    @IBOutlet weak var movieView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showActivityIndicator()
    }
    
    override func prepareForReuse() {
        hideActivityIndicator()
        hideDownloadFailedError()
        movieView.image = UIImage()
    }
    
    func showDownloadFailedError() {
        failedLabel.isHidden = false
    }
    
    func hideDownloadFailedError() {
        failedLabel.isHidden = true
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }

}
