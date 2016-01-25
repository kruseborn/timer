//
//  FirstViewController.swift
//  Interval Tabata Timer
//
//  Created by Tobias Kruseborn on 28/02/15.
//  Copyright (c) 2015 mesa mingi. All rights reserved.
//

import UIKit


class StopwatchViewController: UIViewController {
    
    @IBOutlet weak var timerText: UITextField!
    
    @IBOutlet weak var startAndPuseButton: UIBarButtonItem!
    
    var ms = 0
    var seconds = 0
    var minutes = 0
    var timer = NSTimer()
    
    override func viewDidLoad() {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ResetTimer(sender: AnyObject) {
        ms = 0
        seconds = 0
        minutes = 0
        timer.invalidate()
        timerText.text = "00:00:00"
        startAndPuseButton.title = "Start"
        UIApplication.sharedApplication().idleTimerDisabled = false
    }
    
    @IBAction func startTimer(sender: UIBarButtonItem) {
        if(startAndPuseButton.title == "Start") {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
            startAndPuseButton.title = "Stop"
            UIApplication.sharedApplication().idleTimerDisabled = true
        }
        else {
            startAndPuseButton.title = "Start"
            UIApplication.sharedApplication().idleTimerDisabled = false
            timer.invalidate()
        }
    }
    func updateTimer() {
        ms++
        if(ms == 100) {
            ms = 0
            seconds++;
        }
        if(seconds == 60) {
            seconds = 0
            minutes++
        }
        let secStr = (ms < 10 ? "0" + String(ms) : String(ms))
        let minutesStr = (seconds < 10 ?  "0" + String(seconds) : String(seconds))
        let hoursStr = (minutes < 10 ? "0" + String(minutes) :  String(minutes))
        timerText.text = hoursStr + ":" + minutesStr + ":" + secStr
    }
    
}

