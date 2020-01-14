//
//  BaseViewCell.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 16/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

import UIKit

class BaseViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    var stringUrl: URL?
    var finalPath: String?
    var movie: Movie?{
        didSet{
            guard let path = movie?.posterPath, let baseUrlString = NetworkManager.shared.getUrl(endPoint: .getPoster(size: .poster, path: path)) else {
                return
            }
            finalPath = path
            stringUrl = baseUrlString
        }
        
    }
    var cast: Cast?{
        didSet{
            nameLabel.text = cast?.name
            guard let path = cast?.posterPath, let baseUrlString = NetworkManager.shared.getUrl(endPoint: .getPoster(size: .cast, path: path)) else {
                return
            }
            finalPath = path
            stringUrl = baseUrlString
        }
        
    }
    
    var baseUrlString: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        
    }
    
}
