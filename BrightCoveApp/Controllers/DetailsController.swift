//
//  DetailsController.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 17/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {
    @IBOutlet weak var buttonPlay: UIButton!
    var cellsDictionary = [String: IndexPath]()
    var posterDropDictionary = [String?: String]()
    let size = CGSize(width: 90, height: 90 * 1.6)
    @IBOutlet weak var subTitle: UILabel!
    var details = DetailsViewController()
    var moreDetails: DetailsResponse?
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    var cellCount = 0
    var controller = 0
    
    init?(coder: NSCoder, model: Movie?) {
        guard let movie = model else {
            super.init(coder: coder)
            return
        }
        self.details.model = movie
        super.init(coder: coder)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLayoutSubviews(){
        
        buttonPlay.tintColor = UIColor.init(hexa: ApplicationColors.primary_colour)
        buttonPlay.backgroundColor = .white
        buttonPlay.layer.cornerRadius = buttonPlay.bounds.width / 2
        titleLabel.numberOfLines = 2
        overview.numberOfLines = 8
        
        overview.text = details.detailsOverview
        titleLabel.text = details.title
        rateLabel.text = details.rate
        dateLabel.text = details.date
        
    }
    
    @IBAction func openPlayer(_ sender: UIButton) {
        
        print("open player")
        let videoLauncher = VideoLauncher()
        if let clips = moreDetails?.videos?.results{
            var list = [String]()
            clips.forEach {
                if let key = $0.key{
                    list.append(key)
                }
                
            }
            videoLauncher.videoDetailKeys = list
            videoLauncher.showVideoPlayer()
            videoLauncher.view?.backgroundColor = .black
        }
        
    }
}

extension DetailsController: UICollectionViewDelegate, UICollectionViewDataSource{
    var cellid: String{
        return "cellid"
    }
    
    override func viewDidLoad() {
        cellsDictionary = [:]
        details.getDetaisl(complection: {[weak self] (response) in
            self?.moreDetails = response
            DispatchQueue.main.async {
                if let lbl = self?.moreDetails?.tagline{
                    self?.subTitle.text = lbl
                }
            }
            
            self?.castCollectionView.reloadData()
        })
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.register(UINib(nibName: "BaseViewCell", bundle: nil), forCellWithReuseIdentifier: cellid)
        castCollectionView.heightAnchor.constraint(equalToConstant: size.height * 2).isActive = true
        
        posterDropDictionary[details.posterPath] = "poster"
        posterDropDictionary[details.backPath] = "backdrop"
        
        details.getBackdrop { [weak self] (img, url) in
            if let url = url,  let place = self?.details.imagesDict[url]{
                self?.updateImages(to: img, from: place)

            }
        }
        details.getPoster { [weak self] (img, url) in
            if let url = url,  let place = self?.details.imagesDict[url]{
                self?.updateImages(to: img, from: place)

            }
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! BaseViewCell
        cell.image.image = UIImage(named: "poster_placeholder")
        cell.cast = moreDetails?.credits?.cast?[indexPath.item]
        if let url = cell.stringUrl?.absoluteString{
            cellsDictionary[url] = indexPath
        }
        cell.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        cell.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return controller > 1 ? (moreDetails?.credits?.cast?.count ?? 0) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let displayCell = cell as? BaseViewCell, let url = displayCell.finalPath{
            NetworkManager.shared.getImage(endPoint: .getPoster(size: .cast, path: url)) { [weak self](img, url, error) in
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
        }
    }

    
    func updateImages(to img: UIImage,from place: String){
        DispatchQueue.main.async {[weak self] in
            self?.controller += 1
            if let control = self?.controller, control > 1 {
                self?.castCollectionView.reloadData()
                
            }

            switch place {
            case "poster":
                self?.posterImage.image = img
            case "backdrop":
                self?.backdrop.image = img
            default:
                return
            }
        }
        
    }
}
