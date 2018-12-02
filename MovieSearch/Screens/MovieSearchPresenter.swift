//
//  MovieSearchPresenter.swift
//  MovieSearch
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import UIKit

class MovieSearchPresenter:DownloadableProtocol {
    
    private var searchView: MovieSearchProtocol!
    var imageListDownloader = FileListDownloader.sharedInstance
    var imageDownloadingQueue:FileDownloaderOperationQueue?
    
    init(with view:MovieSearchProtocol) {
        searchView = view
        imageDownloadingQueue = FileDownloaderOperationQueue(withDelegate: self)
    }
    
    func downloadFreshURLListRequest(searchString:String) {
        imageDownloadingQueue?.cancelAllOperations()
        imageDownloadingQueue?.delegate = self
        guard searchString.trimmingCharacters(in: CharacterSet.whitespaces) != Constants.emptyString else {
            imageListDownloader.cancelDataFetchingFromServer()
            return
        }
        
        imageListDownloader.downloadFreshMetaDataForText(searchText: searchString, modelClass: MovieListResponse(), successHandler: { (newPhoneRecordList) in
            self.searchView.movieListDownloadingCompletes(error:false, moviesArray: newPhoneRecordList)
        }) {
            self.searchView.movieListDownloadingCompletes(error: true, moviesArray: [])
        }
    }
    
    func downloadNextPageImagesURLList(searchString:String) {
        imageListDownloader.downloadNextPageMetaData(searchText: searchString, modelClass: MovieListResponse(), successHandler: { (newPhoneRecordList) in
            self.searchView.nextPageMovieListDownloadingCompletes(error: false, moviesArray: newPhoneRecordList)
        }, failureHandler: {
            self.searchView.nextPageMovieListDownloadingCompletes(error: false, moviesArray: [])
        })
    }
    
    func startDownloadingImage(record: FileRecord, imageCache:NSCache<FileRecord,NSData>) {
        imageDownloadingQueue?.addDataRecordInDownloadingQueue(dataRecord: record, cache: imageCache)
    }
    
    func downloadingCompletedSuccessfully(dataRecord:FileRecord) {
        self.searchView.imageDownloadingCompleted(for: dataRecord.associatedIndexPath!)
    }
    
    func cancelOperationAtIndexPath(indexPath:IndexPath){
        imageDownloadingQueue?.cancelOperationAtIndexPath(indexPath: indexPath)
    }
}
