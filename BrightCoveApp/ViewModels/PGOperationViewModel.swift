//
//  PGOperationViewModel.swift
//  BrightCoveApp
//
//  Created by Ricardo Rabeto on 17/10/2019.
//  Copyright © 2019 Ricardo Rabeto. All rights reserved.
//

import UIKit

class PGOperation: Operation {
    var downloadHandler: ImageDownloadHandler?
    var imageUrl: URL!
    
    override var isAsynchronous: Bool{
        get{
            return true
        }
    }
    private var _executing = false {
        willSet{
            willChangeValue(forKey: "isExecuting")
        }
        didSet{
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool{
        return _executing
    }
    
    private var _finished = false {
        willSet{
            willChangeValue(forKey: "isFinished")
        }
        didSet{
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool{
        return _finished
    }
    
    func executing(_ executing: Bool){
        _executing = executing
    }
    
    func finish(_ finished: Bool){
        _finished = finished
    }
    
    required init(url: URL) {
        self.imageUrl = url
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        self.executing(true)
        
        //Async download call
        self.downloadImageFromUrl()
        
        
    }
    func downloadImageFromUrl(){
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: self.imageUrl) { (location, response, error) in
            if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
                let image = UIImage(data: data)
                self.downloadHandler?(image, self.imageUrl.absoluteString, error)
            }
        }
        downloadTask.resume()
    }
}
