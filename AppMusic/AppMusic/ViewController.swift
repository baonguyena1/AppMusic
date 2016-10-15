//
//  ViewController.swift
//  AppMusic
//
//  Created by Nguyen Bao on 10/15/16.
//  Copyright © 2016 Bao Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    var avAudioPlayer: AVAudioPlayer!
    var avPlayer: AVPlayer!
    let musicArray = ["Anywhere I Go", "Atinge"]
    var timer: Timer?
    
    @IBOutlet weak var durationSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle play music in background mode
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
        } catch {
            
        }
    
        playMusicAt(0)
        playMusicOnline()
    }
    
    func playMusicAt(_ index:Int) {
        guard let path = Bundle.main.path(forResource: musicArray[index], ofType: "mp3") else {
            return
        }
        let url: URL = URL(fileURLWithPath: path)
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: "mp3")
            durationSlider.minimumValue = 0.0
            durationSlider.maximumValue = Float(avAudioPlayer.duration)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeDurationFollowPlayer), userInfo: nil, repeats: true)
            avAudioPlayer.delegate = self
            avAudioPlayer.play()
            
            // Handle show infor in lock screen
            let artWork = MPMediaItemArtwork(image: #imageLiteral(resourceName: "anywhere_i_go"))
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle: "Anywhere I Go",
                MPMediaItemPropertyArtist: "Vicetone",
                MPMediaItemPropertyPlaybackDuration: avAudioPlayer.duration,
                MPMediaItemPropertyArtwork: artWork
            ]
            UIApplication.shared.beginReceivingRemoteControlEvents()
            becomeFirstResponder()
        } catch let error {
            print(error)
        }
    }
    
    func playMusicOnline() {
        let urlString = ""
        if let url = URL(string: urlString) {
            avPlayer = AVPlayer(url: url);
            avPlayer.play()
        }
    }
    
    // handle remote control of iphone (play/pause/next)
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {
            return
        }
        
        if event.type == .remoteControl {
            switch event.subtype {
            case .remoteControlPlay:
                avAudioPlayer.play()
            case .remoteControlPause:
                avAudioPlayer.pause()
            case .remoteControlNextTrack:
                print("bai tiep theo")
            case .remoteControlPreviousTrack:
                print("bai truoc do")
            default:
                print("chua dang ky")
            }
        }
    }
    
    @IBAction func changeDurationTime(_ sender: AnyObject) {
        avAudioPlayer.pause()
        avAudioPlayer.currentTime = TimeInterval(durationSlider.value)
        avAudioPlayer.play()
    }
    
    func changeDurationFollowPlayer() {
        durationSlider.value = Float(avAudioPlayer.currentTime)
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            playMusicAt(1)
        }
    }
}

