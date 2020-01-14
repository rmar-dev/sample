//
//  NetworkManager.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 15/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

/*
 
 Public router --
 
 this is were all the internet connections are configured
 to be acessed we use the share property
 
 */

import Foundation
import Alamofire

public enum ImageSize {
    case poster
    case cast
    case backdrop
    
    var size: String{
        switch self{
        case .poster:
            return "200"
        case .cast:
            return "185"
        case .backdrop:
            return "780"
        }
    }
    
    
}


public enum Router: URLRequestConvertible {
    case mostPopular(page: Int)
    case mostRecent(page: Int)
    case bestRated(page: Int)
    case video(id: Int)
    case search(query: String, page: Int)
    case getDetails(id: Int)
    case getPoster(size: ImageSize, path: String)
    
    
    
    enum Constants {
        static let baseURL = "https://api.themoviedb.org/3/"
        static let MovieAPIKey = "0021a23bfb885072bce112e519e7381c"
        static let posterBaseUrl = "https://image.tmdb.org/t/p/"
        static let youtubeApiKey = "AIzaSyC6CFbCHI1na2WFg96tGtqbOP7vs4q4R2g"
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var timeOut: Double{
        return TimeInterval(10 * 1000)
    }
    
    
    var path: String {
        switch self {
        case .mostPopular:
            return "popularity.desc"
        case .mostRecent:
            return "release_date.desc"
        case .bestRated:
            return "vote_average.desc"
        case .video(let id):
            return "\(id)/videos"
        case .getDetails(let id):
            return "\(id)"
        case .getPoster(let size, let final):
            return "\(Constants.posterBaseUrl)w\(size.size)\(final)"
        case .search:
            return ""
        }
    }
    
    var page: Int {
        switch self {
        case .mostRecent(let page):
            return page
        case .mostPopular(let page):
            return page
        case .bestRated(let page):
            return page
        default:
            return 1
        }
    }
    
    var endPoint: String {
        switch self {
        case .getDetails(let id):
            return "movie/\(id)"
        case .search:
            return "search/movie"
        default:
            return "discover/movie"
        }
    }
    
    var language: String {
        return "en-US"
    }
    
    var primaryReleaseDate: String {
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.string(from: date)
    }
    
    var parameters: [String: Any] {
        switch self {
        case .search(let query, _):
            return[
                "api_key": Constants.MovieAPIKey,
                "query": query,
                "language": language,
                "page": page
            ]
        case .getDetails:
            return [
                "api_key": Constants.MovieAPIKey,
                "append_to_response": "credits,videos",
                "language": language
            ]
        default:
            return [
                "api_key": Constants.MovieAPIKey,
                "page": page,
                "sort_by": path,
                "primary_release_date.lte": primaryReleaseDate,
                "language": language
            ]
        }
        
    }
    
    
    public func getImageUrl() -> URL?{
        return URL(string:path)
    }
    
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = try (Constants.baseURL + endPoint).asURL()
        var request = URLRequest(url: url)
        request.timeoutInterval = timeOut
        request.httpMethod = method.rawValue
        NetworkLogger.log(request: request, params: parameters)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}




