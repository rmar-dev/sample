//
//  VideoLauncher.swift
//  TVAppTeste
//
//  Created by Ricardo Rabeto on 03/03/2018.
//  Copyright © 2018 Ricardo Rabeto. All rights reserved.
//

import UIKit
import YouTubePlayer
import AVFoundation

class VideoPlayerView: UIView, YouTubePlayerDelegate {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    var videoControl = 0
    var launch: Bool?{
        didSet{
            youtubePlayer.loadVideoID((videoDetailKeys![videoControl]))
        }
    }
    var videoDetailKeys: [String]?
    var urlString: String?
    var controlPlay = 0
    /*let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0)
        return view
    }()*/
    @IBOutlet weak var controlContainerView: UIView!{
        didSet{
            controlContainerView.backgroundColor = UIColor(white: 1, alpha: 0)
        }
    }
    var controller: DetailsController?
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var PauseButton: UIButton!
    @IBAction func playPlayer(_ sender: UIButton) {
        switch sender.currentImage {
        case playButton.currentImage, PauseButton.currentImage:
            playMovie()
        case backward.currentImage:
            lastMovie()
        case foward.currentImage:
            nextMovie()
        case closeButton.currentImage:
            closePlayerView()
        default:
            return
        }
    }
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backward: UIButton!
    @IBOutlet weak var foward: UIButton!
    @IBOutlet weak var videoLenghtLabel: UILabel!
    @IBOutlet weak var videoCurrentLenghtLabel: UILabel!
    @IBOutlet weak var videoSlider: UISlider!{
        didSet{
            videoSlider.setThumbImage(#imageLiteral(resourceName: "thumb"), for: .normal)
            videoSlider.minimumTrackTintColor = UIColor(hexa: ApplicationColors.primary_colour)
            videoSlider.maximumTrackTintColor = .white
        }
    }
    let youtubePlayer = YouTubePlayerView()
    
    var mainView: UIView?
 
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        playButton.isHidden = false
        backward.isHidden = false
        foward.isHidden = false
        activityIndicatorView.isHidden = true
        
        

        
    }
    
    @objc func dismissButtons()
    {
        
        closeButton.isHidden = true
        playButton.isHidden = true
        PauseButton.isHidden = true
        backward.isHidden = true
        foward.isHidden = true
//        videoSlider.isHidden = true
//        videoLenghtLabel.isHidden = true
//        videoCurrentLenghtLabel.isHidden = true
        
    }
    func showButtons()
    {
        if(controlPlay == 0){
            playButton.isHidden = false
        }else{
            PauseButton.isHidden = false
        }
        closeButton.isHidden = false
        backward.isHidden = false
        foward.isHidden = false
//        videoSlider.isHidden = false
//        videoLenghtLabel.isHidden = false
//        videoCurrentLenghtLabel.isHidden = false
        
        Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(dismissButtons), userInfo: nil, repeats: false)
        //playMovie()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = (touches.first)!
        
        if (touch.view == controlContainerView && closeButton.isHidden == true){
            self.showButtons()
        }else if(closeButton.isHidden == false){
            self.dismissButtons()
        }else{
            print("touchesBegan | This is not an ImageView")
        }
    }
    override init(frame: CGRect ) {
        super.init(frame: frame)
         Bundle.main.loadNibNamed("VideoPlayerView", owner: self, options: nil)
       // contentView.frame = self.bounds
        youtubePlayer.frame = frame
        youtubePlayer.delegate = self
       // controlContainerView.frame = frame
       
        youtubePlayer.playerVars = ["controls": 0 as AnyObject,
                                    "showinfo": 0 as AnyObject,
                                    "playsinline": 1 as AnyObject,
                                    "autoplay": 1 as AnyObject,
                                    "rel": 0 as AnyObject,
                                    "modestbranding": 0 as AnyObject]
        
        
        addSubview(youtubePlayer)
        addSubview(controlContainerView)
        
        NSLayoutConstraint.activate([
            controlContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            controlContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            controlContainerView.topAnchor.constraint(equalTo: topAnchor),
            controlContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
//        addConstraintsWithFormat(format: "V:|[v0]|", view: controlContainerView)
//        addConstraintsWithFormat(format: "H:|[v0]|", view: controlContainerView)
        controlContainerView.isUserInteractionEnabled = true
        
        controlContainerView.addSubview(activityIndicatorView)
        
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: controlContainerView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: controlContainerView.centerYAnchor).isActive = true
        
        playButton.tintColor = UIColor(hexa: ApplicationColors.primary_colour)
        PauseButton.tintColor = UIColor(hexa: ApplicationColors.primary_colour)
        foward.tintColor = UIColor(hexa: ApplicationColors.primary_colour)
        closeButton.tintColor = UIColor(hexa: ApplicationColors.primary_colour)
        backward.tintColor = UIColor(hexa: ApplicationColors.primary_colour)
        
    }
   
   
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("its ready")
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func closePlayerView() {
        print("hidding player....")
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.myOrientation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
        controlPlay = 0
        youtubePlayer.pause()
        
        if let keyWindow = UIApplication.shared.keyWindow{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.mainView?.frame = CGRect(x: keyWindow.frame.width - 15, y: keyWindow.frame.height + 15, width: 10, height: 10)
            }, completion: { (completedAnimation) in
                UIApplication.shared.setStatusBarHidden(false, with: .fade)
                
            })
        }
        
        
    }
    
    @objc private func playMovie(){
        
        if controlPlay == 0{
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissButtons), userInfo: nil, repeats: false)
            controlPlay = 1
            switchStates()
            youtubePlayer.play()
        }else{
            
            controlPlay = 0
           switchStates()
            youtubePlayer.pause()
        }
    }
    func switchStates(){
           playButton.isHidden = !playButton.isHidden
           PauseButton.isHidden = !PauseButton.isHidden
       }
    @objc private func lastMovie(){
        
        if videoControl > 0 {
           
            videoControl -= 1
            youtubePlayer.loadVideoID((videoDetailKeys![videoControl]))
            playButton.isHidden = true
            backward.isHidden = true
            foward.isHidden = true
            activityIndicatorView.isHidden = false
        }
    }
    @objc private func nextMovie(){
        
        if let count = videoDetailKeys?.count,   videoControl < count - 1 {
            
            videoControl += 1
            youtubePlayer.loadVideoID((videoDetailKeys![videoControl]))
            playButton.isHidden = true
            backward.isHidden = true
            foward.isHidden = true
            activityIndicatorView.isHidden = false
        }
    }
    
   
}

class VideoLauncher: NSObject {
    
    var videoDetailKeys: [String]?
    var view: UIView?
    
    func showVideoPlayer(){
        print("showing video player...")

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.myOrientation = .landscape
        let value =  UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
        
        if let keyWindow = UIApplication.shared.keyWindow{
           
            view = UIView(frame: keyWindow.frame)

            view?.backgroundColor = .black
            
            let videoPlayerView = VideoPlayerView(frame: keyWindow.frame)
            videoPlayerView.videoDetailKeys = videoDetailKeys
            videoPlayerView.mainView = view
            
            view?.addSubview(videoPlayerView)
            view?.frame = CGRect(x: keyWindow.frame.width-10, y: keyWindow.frame.height-10, width: 10, height: 10)
            //make a small animation to popup the video player
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view?.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
                
            })
            
            keyWindow.addSubview(view!)
            videoPlayerView.launch = true

        }
        
    }
}
