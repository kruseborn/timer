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
    let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    var timer = Timer()
    @IBOutlet weak var startAndPauseButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        let filePath = Bundle.main.path(forResource: "alarmSound", ofType: "mp3")
        
        let fileURL = URL(fileURLWithPath: filePath!)
        var error : NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }

        audioPlayer.prepareToPlay()
        
        //timerPicker.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        timerPicker.delegate = timerPicker;
        timerPicker.dataSource = timerPicker;
        timerPicker.initialize(timerText, initValues : timerValues, valuesPerComponent : [60,60,60], addPrefix : true)
        
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(TimerViewController.doneButton(_:)))
        let toolbarButtons = [barButton];
        doneToolbar.setItems(toolbarButtons, animated: true)
        //doneToolbar.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func TimerAction(_ sender: AnyObject) {
        timerText.inputView = timerPicker
        timerText.inputAccessoryView = doneToolbar
    }
    
    func doneButton(_ sender:UIBarButtonItem) {
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
    @IBAction func ResetAction(_ sender: AnyObject) {
        timerValues = timerPicker.getTimerValues()
        startAndPauseButton.title = "Start"
        timer.invalidate()
        setTimerTextValues()
        UIApplication.shared.isIdleTimerDisabled = false
    }
 
    @IBAction func StartAndPauseAction(_ sender: UIBarButtonItem) {
        if(startAndPauseButton.title == "Start") {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.updateTimer), userInfo: nil, repeats: true)
            startAndPauseButton.title = "Stop"
            UIApplication.shared.isIdleTimerDisabled = true
        }
        else {
            startAndPauseButton.title = "Start"
            UIApplication.shared.isIdleTimerDisabled = false
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
        let title = "Timer"
        let message = "Time is up"
        let alert:UIAlertView = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: "ok")
        alert.show()
        
    }
    
    func updateTimer() {
        timerValues[2] -= 1
        if(timerValues[2] < 0 && timerValues[1] > 0) {
            timerValues[2] = 59
            timerValues[1] -= 1
            if(timerValues[1] < 0 && timerValues[0] > 0) {
                timerValues[1] = 59
                timerValues[0] -= 1
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

