//
//  NetworkManager.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 15/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

import Foundation
import Alamofire

typealias complection = (MovieApiResponse?)->()
typealias complectionDtails = (DetailsResponse?)->()

typealias ImageHandler = (_ image: UIImage?,_ urlString: String?,_ error: String?) ->()

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request."
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case imageFail = "fail to get image."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

struct NetworkManager {
    static let shared = NetworkManager()
    

    func listRequest(endPoint: Router, handler: @escaping complection){
        request(endPoint).responseJSON{ resp in
            guard resp.result.isSuccess, let data = resp.data else {
                print(NetworkResponse.noData)
                return
            }
            
            do{
                let apiResponse = try JSONDecoder().decode(MovieApiResponse.self, from: data)
                handler(apiResponse)
            }catch{
                print(NetworkResponse.unableToDecode)
            }
        }
        
        
    }
    
    func detailsRequest(endPoint: Router, handler: @escaping complectionDtails){
        request(endPoint).responseJSON{ resp in
            guard resp.result.isSuccess, let data = resp.data else {
                print(NetworkResponse.noData)
                return
            }
            
            do{
                let apiResponse = try JSONDecoder().decode(DetailsResponse.self, from: data)
                handler(apiResponse)
            }catch{
                print(NetworkResponse.unableToDecode)
            }
        }
        
        
    }
    
    
    func getUrl(endPoint: Router) -> URL?{
        return endPoint.getImageUrl()
    }
    
    
    func getImage(endPoint: Router, handler: @escaping ImageHandler){
        guard let url = endPoint.getImageUrl() else {
            handler(nil, nil, NetworkResponse.imageFail.rawValue)
            return
        }
        ImageDownloadManager.shared.downloadImage(url) { (image, url, error) in
            if let _ = error{
                handler(nil, nil, NetworkResponse.imageFail.rawValue)
                return
            }
            handler(image, url, nil)
        }
    }
}


class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
