//
//  ViewController.swift
//  ScratchMe
//
//  Created by Tobias Marciszko on 15/11/15.
//  Copyright © 2015 Tobias Marciszko. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MyImageView : UIImageView {
    
    var drawPath : UIBezierPath = UIBezierPath.init();
    
    override var canBecomeFirstResponder : Bool {
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawFromTouches(touches);
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawFromTouches(touches);
    }
    
    func drawFromTouches(_ touches: Set<UITouch>) {
        for touch: AnyObject in touches {
            let touchLocation = touch.location(in: self);
            
            maskWithCircle(touchLocation.x, y: touchLocation.y);
        }
    }
    
    func maskWithCircle(_ x: CGFloat, y: CGFloat) {
        
        let aCircle : CAShapeLayer = CAShapeLayer.init();
        let newPath = UIBezierPath.init(roundedRect: CGRect(x: x - 35, y: y - 35, width: 70, height: 70), cornerRadius: 35);
        
        drawPath.append(newPath);
        
        aCircle.path = drawPath.cgPath;
        aCircle.fillColor = UIColor.black.cgColor;
        
        self.layer.mask = aCircle;
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mainImage: MyImageView!
    
    var drawPath : UIBezierPath = UIBezierPath.init()
    let imageCount = 13
    
    var indices : [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    var currIndex = 0
    
    // player stuff
    var player = AVPlayer.init()
    var playerLayer = AVPlayerLayer.init()
    
    override func viewDidLoad() {
        mainImage.isUserInteractionEnabled = true
        mainImage.isMultipleTouchEnabled = true
        super.viewDidLoad()
        // randomizeIndices()
        showNextPicture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNextPicture() {
        
        mainImage.layer.mask = CAShapeLayer.init()
        mainImage.drawPath = UIBezierPath.init()

        let index = indices[currIndex]
        
        print(index)
        
        if (index > imageCount) {
            mainImage.isUserInteractionEnabled = false
            mainImage.image = nil
            mainImage.layer.mask = nil
            playVideo()
        } else {
            mainImage.isUserInteractionEnabled = true
            let name = String.init(format: "%d.jpg", index)
            mainImage.layer.mask = CAShapeLayer.init()
            mainImage.image = UIImage(named: name)
        }
        
        currIndex += 1
        
        if (currIndex > imageCount) {
            currIndex = 0
            randomizeIndices()
        }
    }
    
    func randomizeIndices() {
        
        print("old: ", indices)
        
        let nrOfSwaps : Int = ((Int)(arc4random()) % 100) + 50
        var i : Int = 0
        
        print("nrOfSwaps",nrOfSwaps)
        
        while (i < nrOfSwaps) {
            let firstIndex  = (Int)(arc4random()) % (imageCount + 1)
            let secondIndex = (Int)(arc4random()) % (imageCount + 1)
            
            if (firstIndex != secondIndex) {
                swap(&indices[firstIndex], &indices[secondIndex])
                i += 1
            }
        }
        
        print("new: ", indices)
    }
    
    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        stopVideo()
        showNextPicture()
    }
    
    func playVideo() {
        let path = Bundle.main.url(forResource: "lambs", withExtension: "mp4")
        player = AVPlayer(url: path!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.mainImage.bounds
        self.mainImage.layer.addSublayer(playerLayer)
        player.play()
    }
    
    func stopVideo() {
        player.pause()
        player = AVPlayer.init()
        playerLayer.removeFromSuperlayer()
    }
}
