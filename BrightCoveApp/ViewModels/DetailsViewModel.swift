//
//  DetailsViewModel.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 17/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

import Foundation
import UIKit

struct DetailsViewController {
    
    var imagesDict = [String: String]()
    var posterPath: String?
    var backPath: String?
    
    var model: Movie?{
        didSet{
            if let path = model?.posterPath, let baseUrlString = NetworkManager.shared.getUrl(endPoint: .getPoster(size: .poster, path: path)) {
                imagesDict[baseUrlString.absoluteString] = "poster"
                posterPath = path
            }
            if let path = model?.backdrop, let baseUrlString = NetworkManager.shared.getUrl(endPoint: .getPoster(size: .backdrop, path: path)) {
                imagesDict[baseUrlString.absoluteString] = "backdrop"
                backPath = path
            }
            
            
        }
        
    }
    
    
    var detailsOverview: String {
        return model?.overview ?? "No overview"
    }
    
    var title: String{
        return model?.title ?? "No Title"
    }
    
    var rate: String{
        let rating = "\(model?.rating ??  0)"
        return rating != "0" ? rating : "N/A"
    }
    
    var date: String{
        if let date = model?.releaseDate{
            let split = date.split(separator: "-")
            return String(.SubSequence(split[0]))
            // return formater.string(from: date)
        }else{
            return "N/A"
        }
    }
    
    var getImagePlaceholder: UIImage{
        return UIImage(named: "poster_placeholder") ?? UIImage()
    }
    
    func getPoster( posterHandler: @escaping (UIImage, String?) -> ()){
        NetworkManager.shared.getImage(endPoint: .getPoster(size: .poster, path: posterPath ?? "")){(img, url, error) in
            guard let image = img else {
                return
            }
            posterHandler(image, url)
            
        }
    }
    
    func getDetaisl(complection: @escaping (DetailsResponse)->()) {
        if let id = model?.id{
            NetworkManager.shared.detailsRequest(endPoint: .getDetails(id: id)){ (resp) in
                if let result = resp {
                    complection(result)
                }
            }
        }
    }
    func getBackdrop( backHandler: @escaping (UIImage, String?) -> ()){
        NetworkManager.shared.getImage(endPoint: .getPoster(size: .backdrop, path: backPath ?? "")){(img, url, error) in
            guard let image = img else {
                return
            }
            
            backHandler(image, url)
        
        }
    }
}
