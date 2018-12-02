//
//  URLBuilder.swift
//  MovieSearchAssignment
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import Foundation

struct URLParameters {
    var searchString:String
    var pageNumber:Int
    var relativeURL:String
    var apiKey:String
}

class URLBuilder: NSObject {
    var url:URL!
    init(urlParams:URLParameters) {
        
        let filteredSearchString = urlParams.searchString.trimmingCharacters(in: CharacterSet.whitespaces).replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        url = URL(string: "\(urlParams.relativeURL)?s=\(filteredSearchString)&page=\(urlParams.pageNumber)&apikey=\(urlParams.apiKey)")
    }
}

