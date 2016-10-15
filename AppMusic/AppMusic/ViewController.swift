//
//  ViewController.swift
//  AppMusic
//
//  Created by Nguyen Bao on 10/15/16.
//  Copyright © 2016 Bao Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var avAudioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let path = Bundle.main.path(forResource: "Anywhere I Go", ofType: "mp3") else {
            return
        }
        let url: URL = URL(fileURLWithPath: path)
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: "mp3")
            avAudioPlayer.play()
        } catch let error {
            print(error)
        }
    }
    
    
}

