//
//  MovieSearchProtocol.swift
//  MovieSearch
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import UIKit

protocol MovieSearchProtocol {
    func movieListDownloadingCompletes(error: Bool, moviesArray: [FileRecord])
        
    func nextPageMovieListDownloadingCompletes(error: Bool, moviesArray: [FileRecord])
        
    func imageDownloadingCompleted(for indexPath: IndexPath)
}

