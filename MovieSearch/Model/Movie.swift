//
//  Movie.swift
//  MovieSearch
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import UIKit

struct MovieListResponse : Codable,DataResponseParser  {
    var moviesList:[Movie]?
    
    enum CodingKeys: String, CodingKey {
        case moviesList = "Search"
    }
    
    func parseResponse() -> [FileRecord] {
        let fileRecordList = moviesList?.map { (movieRecord) -> FileRecord in
            return FileRecord(movieRecord: movieRecord)
        }
        
        guard let strongFileLList = fileRecordList else {
            (UIApplication.shared.delegate as! AppDelegate).searchingEnd = true
            return []
        }
        
        return strongFileLList
    }
}

struct Movie : Codable {
    var title:String
    var year:String
    var imdbID:String
    var type:String
    var poster:String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
