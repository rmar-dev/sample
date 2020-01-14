//
//  Movie.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 15/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

import Foundation


struct DetailsResponse: Decodable {
    let credits: People?
    let videos: Videos?
    let tagline: String

}


struct People: Decodable {
    let cast: [Cast]?
    let crew: [Cast]?
}


struct Cast {
    let name: String?
    let posterPath: String?
}

extension Cast: Decodable {
    
    enum MovieCodingKeys: String, CodingKey {
        case name
        case posterPath = "profile_path"
    }
    
    init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
        
        name = try movieContainer.decode(String?.self, forKey: .name)
        posterPath = try movieContainer.decode(String?.self, forKey: .posterPath)
        
    }
    
    
}

struct Videos: Decodable {
    let results: [Video]?
}

struct Video: Decodable {
    let id: String
    let key: String?
    let name: String?
    let site: String?
}

