//
//  DetailedViewController.swift
//  MovieSearch
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    var movie:Movie!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    var image:UIImage!
    
    override func viewDidLoad() {
        imageView.image = image
        movieTitleLabel.text = "Title : \(movie.title)"
        yearLabel.text = "Year : \(movie.year)"
        typeLabel.text = "Type : \(movie.type)"
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionClose(_:))))
    }
    
    @objc func actionClose(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
