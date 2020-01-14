//
//  BaseController.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 15/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

/*
 
 Main controller, all the controllers from the tab bar will inherit from this one
 
 */

import Foundation
import UIKit
class BaseClass: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    var refreshRate = 3
    let cellId = "cellid"
    var list: [Movie]?
    var cellsDictionary = [String: IndexPath]()
    var cellWidth: CGFloat = 0
    var globalPage = 1
    
    lazy var size = (width: cellWidth, height: cellWidth * 1.6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellsDictionary = [:]
        
        //remove space in layout and place nav and tab colors
        initialSetup()
        
        self.collectionView.register(UINib(nibName: "BaseViewCell", bundle: nil), forCellWithReuseIdentifier: cellId)
    
        getAssets()
        
        title="Title"
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = rc
        
    }
    
    
    @objc func handleRefresh() {
        list = []
        collectionView.reloadData()
        globalPage = 1
        getAssets()
        collectionView.refreshControl?.endRefreshing()
    }
    
    @objc func handleAction(){
        guard let vc = storyboard?.instantiateViewController(identifier: "SearchViewController", creator: { coder in
            return SearchViewController(coder: coder)
        }) else {
            fatalError("Failed to load EditUserViewController from storyboard.")
        }
        
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.backBarButtonItem?.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func initialSetup(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
        tabBarController?.tabBar.tintColor = UIColor(hexa:ApplicationColors.primary_colour)
        navigationController?.navigationBar.barTintColor = UIColor(hexa:ApplicationColors.primary_colour)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backItem?.title = ""
        
        //setup the search button to implement in navigation items
        let searchBarButton = UIBarButtonItem(image: UIImage(named: "ic_action_search"), style: .plain, target: self, action: #selector(handleAction))
        navigationItem.rightBarButtonItem = searchBarButton
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: cellWidth * 1.6)
    }
    
    override func viewWillLayoutSubviews() {
        cellWidth = UIDevice.current.orientation.isLandscape ?
            UIScreen.main.bounds.width / 6 :
            UIScreen.main.bounds.width / 3
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseViewCell
        cell.image.image = UIImage(named: "poster_placeholder")
        cell.movie = list?[indexPath.item]
        
        if let url = cell.stringUrl?.absoluteString{
            cellsDictionary[url] = indexPath
        }
        
        cell.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        cell.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let displayCell = cell as? BaseViewCell, let finalPath = displayCell.finalPath{
            NetworkManager.shared.getImage(endPoint: .getPoster(size: .poster, path: finalPath)) { [weak self](img, url, error) in
                if let err = error {
                    print(err)
                }
                DispatchQueue.main.async {
                    if let url = url, let updateIndex = self?.cellsDictionary[url]{
                        if let updateCell = collectionView.cellForItem(at: updateIndex) as? BaseViewCell{
                            updateCell.image.image = img
                            
                        }
                    }
                }
            }
            
            print("visible cell is now on screen \(cell) " )
            if let data = list{
                if indexPath.row >= data.count - refreshRate {
                    globalPage += 1
                    getAssets(page: globalPage)
                }
                
            }
        }else{
            let hasValue = cellsDictionary.first {$1 == indexPath}
            if (hasValue != nil){
                collectionView.reloadData()
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "DetailsController", creator: { [weak self] coder in
            return DetailsController(coder: coder, model: self?.list?[indexPath.item])
        }) else {
            fatalError("Failed to load EditUserViewController from storyboard.")
        }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getAssets(page: Int = 1){
        
    }
    
    func noInternetALert(){
        let alert = UIAlertController(title: "No internet connection!!", message: "Try again?", preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { [weak self]
            UIAlertAction in
            self?.handleRefresh()
        }
        
        alert.addAction(okAction)

        self.present(alert, animated: true)
    }
}
