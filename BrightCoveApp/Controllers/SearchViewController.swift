//
//  SearchViewController.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 18/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

import Foundation
import UIKit
class SearchViewController: BaseClass{
    
    var queryString: String?
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search movie, minimum 3 characters"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.init(hexa: ApplicationColors.white)
        sb.delegate = self
        sb.autocapitalizationType = .none
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.searchTextField.textColor = UIColor(hexa: ApplicationColors.primary_colour)
        //Magnifying glass
        let textFieldInsideSearchBar = sb.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = UIColor(hexa: ApplicationColors.primary_colour)
        return sb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        buildContraints()
        collectionView?.keyboardDismissMode = .onDrag
        
        // Do any additional setup after loading the view.
    }
    
    private func buildContraints(){
        if let nb = navigationController?.navigationBar{
            navigationController?.navigationBar.addSubview(searchBar)
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: nb.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: nb.leadingAnchor, constant: 28),
                searchBar.trailingAnchor.constraint(equalTo: nb.trailingAnchor, constant: -8),
                searchBar.bottomAnchor.constraint(equalTo: nb.bottomAnchor)
            ])
        }
        
    }
    
    
    /*Look for assts to populate the apllication
     first try to validate the connection if not send a alert
     */
    override func getAssets(page: Int = 1) {
        
        collectionView.activityIndicator(show: true)
        if Connectivity.isConnectedToInternet {
            if let query = queryString{
                NetworkManager.shared.listRequest(endPoint: .search(query: query, page: page)) { [weak self](resp) in
                    print(resp ?? "")
                    guard let result = resp else {
                        return
                    }
                    if(self?.list?.last?.id == result.movies.last?.id){
                        self?.refreshRate = -1000
                    }else{
                        self?.refreshRate = 3
                        self?.list = result.movies
                        
                    }
                    
                    DispatchQueue.main.async {
                        self?.collectionView.activityIndicator(show: false)
                        self?.collectionView?.reloadData()
                        
                    }
                }
            }
        }else {
            noInternetALert()
            collectionView.activityIndicator(show: false)
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count > 2){
            let search = searchText.trim()
            queryString = search.replace(string:" ", replacement: " ")
            globalPage = 1
            getAssets()
        }else if searchText.count < 2{
            self.list = []
        }
        collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
        
    }
    fileprivate func fetchSearch() {
        //        APIService.sharedInstance.fetchMovies(filter: "&query=\(queryString)", page: 1, "/search/movie?") { (videos: [Video]) in
        //
        //            self.videos = videos
        //
        //            DispatchQueue.main.async {
        //                self.collectionView?.reloadData()
        //            }
        //        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        searchBar.endEditing(true)
        searchBar.isHidden = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if searchBar.isHidden {
            view.endEditing(false)
            
            searchBar.isHidden = false
        }
    }
}
