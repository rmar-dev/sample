//
//  MovieCell.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 17/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

import Foundation

class MovieCell: BaseViewCell {
    override var movie: Movie?{
        didSet{
            if let path = movie?.posterPath {
                baseUrlString = path
                NetworkManager.shared.getImage(endPoint: .getPoster(size: .poster, path: path)) { [weak self](img, url, error) in
                    if let err = error {
                        print(err)
                    }
                    print(img)
                   // self?.image.image = img
                }
            }
            
        }
    }
}
