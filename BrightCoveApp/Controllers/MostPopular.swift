//
//  FirstViewController.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 15/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

import UIKit

class MostPopular: BaseClass {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Most Popular"
        // Do any additional setup after loading the view.
        
    }
    
    override func getAssets(page: Int = 1) {
        collectionView.activityIndicator(show: true)
        if Connectivity.isConnectedToInternet {
            NetworkManager.shared.listRequest(endPoint: .mostPopular(page: page)) { [weak self](resp) in
                print(resp ?? "")
                guard let result = resp else {
                    return
                }
                if let list = self?.list {
                    self?.list = list + result.movies
                }else{
                    self?.list = result.movies
                }
                DispatchQueue.main.async {
                    
                    self?.collectionView.activityIndicator(show: false)
                    self?.collectionView?.reloadData()
                    
                }
            }
            
            
        }else {
            noInternetALert()
            collectionView.activityIndicator(show: false)
            
            
        }
        
    }
    
}

