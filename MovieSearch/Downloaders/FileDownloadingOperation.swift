//
//  FileDownloadingOperation.swift
//  MovieSearch
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import Foundation

protocol DownloadableProtocol {
    func downloadingCompletedSuccessfully(dataRecord:FileRecord)
}

class FileDownloadingOperation: Operation {
    var dataRecord:FileRecord!
    var cache:NSCache<FileRecord,NSData>!
    override func main() {
        if isCancelled || dataRecord.state == .cancelled{
            dataRecord.state = .cancelled
            return
        }
        
        dataRecord.state = .executing
        let data = NSData(contentsOf: URL(string: dataRecord.movie.poster)!)
        if data != nil {
            cache.setObject(data!, forKey: dataRecord)
            dataRecord.state = .finished
        } else {
            dataRecord.state = .failed
        }
    }
}
