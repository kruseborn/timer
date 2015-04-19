//
//  FirstViewController.swift
//  Interval Tabata Timer
//
//  Created by Tobias Kruseborn on 28/02/15.
//  Copyright (c) 2015 mesa mingi. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {

    var audioPlayer : AVAudioPlayer! = nil
    
    let timerPicker  : TimerPicker = TimerPicker()
    @IBOutlet weak var timerText: UITextField!
    var timerValues = [0,0,0]
    let doneToolbar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
    var timer = NSTimer()
    @IBOutlet weak var startAndPauseButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        let filePath = NSBundle.mainBundle().pathForResource("alarmSound", ofType: "mp3")
        
        let fileURL = NSURL(fileURLWithPath: filePath!)
        var error : NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: fileURL, error: &error)

        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1
        audioPlayer.play()

        
        //timerPicker.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        timerPicker.delegate = timerPicker;
        timerPicker.dataSource = timerPicker;
        timerPicker.initialize(timerText, initValues : timerValues, valuesPerComponent : [60,60,60], addPrefix : true)
        
        var barButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneButton:")
        var toolbarButtons = [barButton];
        doneToolbar.setItems(toolbarButtons, animated: true)
        //doneToolbar.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func TimerAction(sender: AnyObject) {
        timerText.inputView = timerPicker
        timerText.inputAccessoryView = doneToolbar
    }
    
    func doneButton(sender:UIBarButtonItem) {
        timerValues = timerPicker.getTimerValues()
        timerText.resignFirstResponder() // To resign the inputView on clicking done.
        startAndPauseButton.title = "Start"
        timer.invalidate()
        setTimerTextValues()
    }
    func setTimerTextValues() {
        var strArray = ["", "", ""]
        for i in 0..<timerValues.count {
            strArray[i] = (timerValues[i] < 10 ? "0" + String(timerValues[i]) : String(timerValues[i]))
        }
        timerText.text = strArray[0] + ":" + strArray[1] + ":" + strArray[2]
    }
    @IBAction func ResetAction(sender: AnyObject) {
        timerValues = timerPicker.getTimerValues()
        startAndPauseButton.title = "Start"
        timer.invalidate()
        setTimerTextValues()
    }
 
    @IBAction func StartAndPauseAction(sender: UIBarButtonItem) {
        if(startAndPauseButton.title == "Start") {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
            startAndPauseButton.title = "Stop"
        }
        else {
            startAndPauseButton.title = "Start"
            timer.invalidate()
        }
    }
    func showAlert() {
        if(_soundIsOn) {
            audioPlayer.play()
        }
        if(_vibratorOn) {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        var title = "Timer"
        var message = "Time is up"
        var alert:UIAlertView = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("ok")
        alert.show()
        
    }
    
    func updateTimer() {
        timerValues[2]--
        if(timerValues[2] < 0 && timerValues[1] > 0) {
            timerValues[2] = 59
            timerValues[1]--
            if(timerValues[1] < 0 && timerValues[0] > 0) {
                timerValues[1] = 59
                timerValues[0]--
            }
        }
        
        if(timerValues[0] <= 0 && timerValues[1] <= 0 && timerValues[2] < 0) {
            showAlert()
            timerValues[0] = 0; timerValues[1] = 0; timerValues[2] = 0
            
            timer.invalidate()
            return
        }
        setTimerTextValues()
    }
    
}

