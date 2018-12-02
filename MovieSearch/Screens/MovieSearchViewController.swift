//
//  MovieSearchViewController.swift
//  MovieSearch
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import UIKit

let COLLECTION_VIEW_CELL_PADDING = 10

class MovieSearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var noMoviesLabel: UILabel!
    
    let transition = Animator()
    var selectedImage:MovieCollectionViewCell!
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    var isDownloadingFailed = false
    
    var numberOfColumns:Int = 2
    
    var dataRecordArray = [FileRecord]()
    var imagesCache:NSCache<FileRecord,NSData> = NSCache()
    
    var presenter:MovieSearchPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterface()
        intializeDepdendencies()
    }
    
    func intializeDepdendencies() {
        presenter = MovieSearchPresenter(with: self)
    }
    
    func showActivityIndicator() {
        activityIndicatorView.isHidden = false
        noMoviesLabel.isHidden = true
    }
    
    func hideActivityIndicator() {
        activityIndicatorView.isHidden = true
    }
    
    func downloadFreshURLListRequest(searchString: String) {
        dataRecordArray.removeAll()
        reloadUserInterface()
        showActivityIndicator()
        presenter.downloadFreshURLListRequest(searchString: searchString)
    }
    
    func downloadNextPageImagesURLList(searchString:String) {
        showActivityIndicator()
        presenter.downloadNextPageImagesURLList(searchString: searchString)
    }
    
    
    func configureUserInterface() {
        collectionView.register(UINib(nibName: String(describing: MovieCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.movieCollectionCellIdentifier)
        
        activityIndicatorView.layer.cornerRadius = 25
        searchBar.delegate = self
        searchBar.placeholder = Constants.searchString
        navigationItem.titleView = searchBar
    }
    
    func reloadUserInterface() {
        hideActivityIndicator()
        self.collectionView.reloadData()
        noMoviesLabel.isHidden = !dataRecordArray.isEmpty
        noMoviesLabel.text = ((dataRecordArray.isEmpty && isDownloadingFailed) ? Constants.unableToDownloadString : Constants.noMoviesString )
    }
}

extension MovieSearchViewController: MovieSearchProtocol {
    func movieListDownloadingCompletes(error: Bool, moviesArray: [FileRecord]) {
        self.dataRecordArray = moviesArray
        self.isDownloadingFailed = error
        self.reloadUserInterface()
    }
    
    func nextPageMovieListDownloadingCompletes(error: Bool, moviesArray: [FileRecord]) {
        if error == false {
            dataRecordArray += moviesArray
            reloadUserInterface()
            collectionView.flashScrollIndicators()
        } else {
            hideActivityIndicator()
        }
    }
    
    func imageDownloadingCompleted(for indexPath: IndexPath) {
        self.collectionView.reloadItems(at: [indexPath])
    }
}


extension MovieSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataRecordArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CellIdentifiers.movieCollectionCellIdentifier , for: indexPath) as! MovieCollectionViewCell
        
        let movieRecord = dataRecordArray[indexPath.row]
        
        //Data may be cleared due to Memory issue. We have to download it again.
        if movieRecord.state == .finished && imagesCache.object(forKey: movieRecord) == nil {
            movieRecord.state = .new
        }
        
        switch(movieRecord.state) {
            
        case .cancelled:
            movieRecord.state = .new
            fallthrough
            
        case .new:
            movieRecord.associatedIndexPath = indexPath
            presenter.startDownloadingImage(record: movieRecord, imageCache: imagesCache)
            fallthrough
            
        case .executing:
            cell.showActivityIndicator()
            
        case .failed:
            cell.showDownloadFailedError()
            
        case .finished:
            cell.movieView.image = UIImage(data: imagesCache.object(forKey: movieRecord)! as Data)
        }
        
        cell.movieTitleLabel.text = movieRecord.movie.title
        cell.typeLabel.text = movieRecord.movie.type
        cell.yearLabel.text = "\(DateHelper.calculatePastYears(year: movieRecord.movie.year)) years ago"
        
        if indexPath.row == dataRecordArray.count - 1 {
            downloadNextPageImagesURLList(searchString: searchBar.text!)
        }
        
        return cell
    }
}

extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSide = (Int(collectionView.frame.width) - ((numberOfColumns - 1) * COLLECTION_VIEW_CELL_PADDING))/numberOfColumns
        return CGSize(width: cellSide,height:cellSide)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let imageData = imagesCache.object(forKey: dataRecordArray[indexPath.row]) as Data?, let image = UIImage(data: imageData) {
            
            selectedImage = collectionView.cellForItem(at: indexPath) as? MovieCollectionViewCell
            
            let imageDetailViewController = storyboard!.instantiateViewController(withIdentifier: String(describing: DetailedViewController.self)) as! DetailedViewController
            imageDetailViewController.image = image
            imageDetailViewController.movie = dataRecordArray[indexPath.row].movie
            imageDetailViewController.transitioningDelegate = self
            present(imageDetailViewController, animated: true, completion: nil)
        }
    }
}

extension MovieSearchViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard !dataRecordArray.isEmpty else {
            return
        }
        
        if dataRecordArray[indexPath.row].state != .executing && dataRecordArray[indexPath.row].state != .finished {
            presenter.cancelOperationAtIndexPath(indexPath: indexPath)
        }
    }
}

extension MovieSearchViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)
        
        transition.presenting = true
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedString = searchBar.text, searchedString.trimmingCharacters(in: CharacterSet.whitespaces) != Constants.emptyString {
            downloadFreshURLListRequest(searchString: searchedString)
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        (UIApplication.shared.delegate as! AppDelegate).searchingEnd = false
    }
}
