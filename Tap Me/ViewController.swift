//
//  ViewController.swift
//  Tap Me
//
//  Created by Joseph Leiferman on 3/3/16.
//  Copyright © 2016 electricBrain. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    var buttonBeep : AVAudioPlayer?
    var secondBeep : AVAudioPlayer?
    var backgroundMusic : AVAudioPlayer?
    var taps = 0
    var seconds = 0
    var timer = NSTimer()
    
    @IBAction func buttonPressed() {
        taps++
        scoreLabel.text = "Score: \(taps)"
        buttonBeep?.play()
    }
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer? {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var audioPlayer: AVAudioPlayer?
        
        //3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not avaiable")
        }
        return audioPlayer
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let buttonBeep = self.setupAudioPlayerWithFile("ButtonTap", type: "wav") {
            self.buttonBeep = buttonBeep
        }
        if let secondBeep = self.setupAudioPlayerWithFile("SecondBeep", type: "wav") {
            self.secondBeep = secondBeep
        }
        if let backgroundMusic = self.setupAudioPlayerWithFile("HallOfTheMountainKing", type: "mp3") {
            self.backgroundMusic = backgroundMusic
        }
        // sets backgroundColor to bg_tile.png
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_tile.png")!)
        // sets score label to field_score.png
        scoreLabel.backgroundColor = UIColor(patternImage: UIImage(named: "field_score.png")!)
        // sets score label to field_time.png
        timerLabel.backgroundColor = UIColor(patternImage: UIImage(named: "field_time.png")!)
        setupGame()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGame() {
        seconds = 30
        taps = 0
        backgroundMusic?.volume = 0.3
        backgroundMusic?.play()
        
        timerLabel.text = "Time: \(seconds)"
        scoreLabel.text = "Score: \(taps)"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"),
            userInfo: nil, repeats: true)
        
    }
    
    func subtractTime() {
        seconds--
        timerLabel.text = "Time: \(seconds)"
        secondBeep?.play()
        
        
        if( seconds == 0) {
            timer.invalidate()
            let alert = UIAlertController(title: "Time is up!", message: "You scored \(taps) points", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Play Again", style: UIAlertActionStyle.Default, handler: {
                action in self.setupGame()
            }))
            presentViewController(alert, animated: true, completion: nil)
            
        }
    }
}

