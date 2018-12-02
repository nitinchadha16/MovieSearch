//
//  FileRecord.swift
//  MovieSearchAssignment
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import Foundation

protocol DataResponseParser {
    func parseResponse() -> [FileRecord]
}

enum OperationState:String {
    case new, executing, finished, cancelled, failed
}

class FileRecord {
    var state:OperationState
    var associatedIndexPath:IndexPath?
    var movie:Movie
    
    init(movieRecord:Movie) {
        state = .new
        self.movie = movieRecord
    }
}

