//
//  FirstViewController.swift
//  Interval Tabata Timer
//
//  Created by Tobias Kruseborn on 28/02/15.
//  Copyright (c) 2015 mesa mingi. All rights reserved.
//

import UIKit
import AVFoundation

var _soundEffect = true
var _soundEffectKey = "soundEffect"
var _soundIsOn = true
var _vibratorOn = true
var _delayTime = 3
var _delayKey = "delay"
var _vibrateKey = "vibrate"
var _soundKey = "sound"

var _roundKey = "round"
var _workTimeKey = "worktime"
var _restTimeKey = "resttime"

class IntervalViewController: UIViewController {
    var alarmSound = URL(fileURLWithPath: (Bundle.main.path(forResource: "alarmSound", ofType: "mp3"))!)
    var roundSounds = URL(fileURLWithPath: (Bundle.main.path(forResource: "round_sound", ofType: "mp3"))!)
    var delaySound = URL(fileURLWithPath: (Bundle.main.path(forResource: "warning_beep", ofType: "mp3"))!)
    
    var finalRoundSound = URL(fileURLWithPath: (Bundle.main.path(forResource: "final_round", ofType: "mp3"))!)
    var gogoSound = URL(fileURLWithPath: (Bundle.main.path(forResource: "gogo", ofType: "wav"))!)
    var finishSound = URL(fileURLWithPath: (Bundle.main.path(forResource: "outstanding", ofType: "mp3"))!)
    
    
    var audioPlayer = AVAudioPlayer()
    var audioPlayerRound = AVAudioPlayer()
    
    //var audioPlayerstartSound = AVAudioPlayer()
    var audioPlayerDelay = AVAudioPlayer()
    var audiPlayerFinalRound = AVAudioPlayer()
    var audioPlayerGoGo = AVAudioPlayer()
    var audioPlayerFinish = AVAudioPlayer()
    
    
    
    @IBOutlet weak var currentRoundText: UITextField!
    @IBOutlet weak var timerText: UITextField!
    var timer = Timer()
    @IBOutlet weak var startAndPauseButton: UIBarButtonItem!
    var isInWorkoutMode = true
    
    @IBOutlet weak var roundText: UITextField!
    let roundPicker  : TimerPicker = TimerPicker()
    var roundValue = [8]
    var currentRoundValue = 1
    
    var totalRoundValues = [100]
    let roundToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    
    @IBOutlet weak var workTimeText: UITextField!
    let workTimePicker  : TimerPicker = TimerPicker()
    var workTimeValues = [0,0,20]
    var workTimeTotals = [60,60,60]
    let workTimeToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    
    @IBOutlet weak var delayText: UITextField!
    
    @IBOutlet weak var restTimeText: UITextField!
    let restTimePicker  : TimerPicker = TimerPicker()
    var restTimeValues = [0,0,10]
    var restTimeTotals = [60,60,60]
    let restTimeToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    var hasStarted = false
    var delayTime = _delayTime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delayTime = _delayTime
        let defaults = UserDefaults.standard
        if(defaults.value(forKey: _delayKey) != nil) {
            _delayTime = defaults.value(forKey: _delayKey) as! NSInteger!
        }
        if(defaults.value(forKey: _soundKey) != nil) {
            _soundIsOn = defaults.value(forKey: _soundKey) as! Bool!
        }
        if(defaults.value(forKey: _vibrateKey) != nil) {
            _vibratorOn = defaults.value(forKey: _vibrateKey) as! Bool!
        }
        if(defaults.value(forKey: _soundEffectKey) != nil) {
            _soundEffect = defaults.value(forKey: _soundEffectKey) as! Bool!
        }
        if(defaults.value(forKey: _workTimeKey) != nil) {
            workTimeValues = defaults.value(forKey: _workTimeKey) as! [Int]
        }
        if(defaults.value(forKey: _restTimeKey) != nil) {
            restTimeValues = defaults.value(forKey: _restTimeKey) as! [Int]
        }
        if(defaults.value(forKey: _roundKey) != nil) {
            roundValue = defaults.value(forKey: _roundKey) as! [Int]
        }
        audioPlayer = try! AVAudioPlayer(contentsOf: alarmSound);
        audioPlayer.prepareToPlay()
        
        audioPlayerRound = try! AVAudioPlayer(contentsOf: roundSounds)
        audioPlayerRound.prepareToPlay()
        
        //audioPlayerstartSound = AVAudioPlayer(contentsOfURL: startSound, error: nil)
        //audioPlayerstartSound.prepareToPlay()
        audioPlayerDelay = try! AVAudioPlayer(contentsOf: delaySound)
        audioPlayerDelay.prepareToPlay()
        audiPlayerFinalRound = try! AVAudioPlayer(contentsOf: finalRoundSound)
        audiPlayerFinalRound.prepareToPlay()
        audioPlayerGoGo = try! AVAudioPlayer(contentsOf: gogoSound)
        audioPlayerGoGo.prepareToPlay()
        audioPlayerFinish = try! AVAudioPlayer(contentsOf: finishSound)
        audioPlayerFinish.prepareToPlay()
      
        

        delayText.alpha = 0.0
        //round picker
        roundPicker.delegate = roundPicker
        roundPicker.dataSource = roundPicker
        roundPicker.initialize(roundText, initValues: roundValue, valuesPerComponent: totalRoundValues, addPrefix: false, zeroIndex: false)
        var barButton = UIBarButtonItem(title: "Done", style: .plain, target:self, action: #selector(IntervalViewController.roundPickerDone))
        var toolbarButtons = [barButton];
        roundToolBar.setItems(toolbarButtons, animated: true)
       
        //worktime picker
        workTimePicker.delegate = workTimePicker
        workTimePicker.dataSource = workTimePicker
        workTimePicker.initialize(workTimeText, initValues: workTimeValues, valuesPerComponent: workTimeTotals, addPrefix: true)
        var workTimeBarButton = UIBarButtonItem(title: "Done", style: .plain, target:self, action: #selector(IntervalViewController.workTimePickerDone))
        var workTimeToolbarButtons = [workTimeBarButton];
        workTimeToolBar.setItems(workTimeToolbarButtons, animated: true)
        
        //resttime picker
        restTimePicker.delegate = restTimePicker
        restTimePicker.dataSource = restTimePicker
        restTimePicker.initialize(restTimeText, initValues: restTimeValues, valuesPerComponent: restTimeTotals, addPrefix: true)
        var restTimeBarButton = UIBarButtonItem(title: "Done", style: .plain, target:self, action: #selector(IntervalViewController.restTimePickerDone))
        var restTimeToolbarButtons = [restTimeBarButton];
        restTimeToolBar.setItems(restTimeToolbarButtons, animated: true)
        resetValuesFromPicker();

        
        //set colors
        //self.view.backgroundColor = UIColor(red: 255, green: 0, blue: 255, alpha: 255);
    
        
    }
    
    func setTimerTextValue(_ values : [Int]) {
        var strArray = ["", "", ""]
        for i in 0..<values.count {
            strArray[i] = (values[i] < 10 ? "0" + String(values[i]) : String(values[i]))
        }
        timerText.text = strArray[0] + ":" + strArray[1] + ":" + strArray[2]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func resetValuesFromPicker() {
        UIApplication.shared.isIdleTimerDisabled = false
        currentRoundValue = 1
        roundValue[0] = roundPicker.getTimerValues()[0]
        workTimeValues = workTimePicker.getTimerValues()
        restTimeValues = restTimePicker.getTimerValues()
        setTimerTextValue(workTimeValues)
        currentRoundText.text = "Round: " + String(currentRoundValue) + "/" + String(roundValue[0])
        startAndPauseButton.title = "Start"
        isInWorkoutMode = true
        hasStarted =  false
        delayTime = _delayTime
        timerText.alpha = 1.0
        currentRoundText.alpha = 1.0
        delayText.alpha = 0.0
        delayText.text = String(delayTime)
        
        //store value to phone
        let defaults = UserDefaults.standard
        defaults.setValue(workTimeValues, forKey: _workTimeKey)
        defaults.synchronize()
        defaults.setValue(restTimeValues, forKey: _restTimeKey)
        defaults.synchronize()
        defaults.setValue(roundValue, forKey: _roundKey)
        defaults.synchronize()
        
        timer.invalidate()
    }
  
    @IBAction func roundAction(_ sender: UITextField) {
        roundText.inputView = roundPicker
        roundText.inputAccessoryView = roundToolBar
    }
    @IBAction func workTimeAction(_ sender: UITextField) {
        workTimeText.inputView = workTimePicker
        workTimeText.inputAccessoryView = workTimeToolBar
    }
    @IBAction func restTimeAction(_ sender: UITextField) {
        restTimeText.inputView = restTimePicker
        restTimeText.inputAccessoryView = restTimeToolBar
    }
    func workTimePickerDone() {
        resetValuesFromPicker()
        workTimeText.resignFirstResponder()
    }
    func roundPickerDone() {
        resetValuesFromPicker()
        roundText.resignFirstResponder()
    }
    func restTimePickerDone() {
        resetValuesFromPicker()
        restTimeText.resignFirstResponder()
    }
    
    @IBAction func StartAndPauseAction(_ sender: UIBarButtonItem) {
        if(startAndPauseButton.title == "Start") {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(IntervalViewController.updateTimer), userInfo: nil, repeats: true)
            startAndPauseButton.title = "Pause"
            UIApplication.shared.isIdleTimerDisabled = true
            if(!hasStarted) {
                delayTime = _delayTime
            }
        }
        else {
            startAndPauseButton.title = "Start"
            timer.invalidate()
        }
    }
    @IBAction func ResetAction(_ sender: AnyObject) {
        resetValuesFromPicker()
        
    }
    func showAlert() {
        if(_soundIsOn) {
            if(_soundEffect == true) {
                audioPlayerFinish.play()
            }
            else {
                audioPlayer.play()
            }
        }
        if(_vibratorOn) {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        let title = "Timer"
        let message = "Time is up"
        let alert:UIAlertView = UIAlertView()
        alert.title = title
        alert.delegate = self
        alert.message = message
        alert.addButton(withTitle: "ok")
        alert.show()
        
    }
    func alertView(_ View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        resetValuesFromPicker()
    }
    func updateTimer() {
        if(isInWorkoutMode) {
            updateTimer_(&workTimeValues)
        }
        else {
            updateTimer_(&restTimeValues)
        }
    }
    func updateTimer_(_ timerValues : inout [Int]) {
        if(delayTime > 0) {
            if(delayTime == 3) {
                if(_soundIsOn) {
                    audioPlayerDelay.play()
                }
            }
            timerText.alpha = 0.2
            currentRoundText.alpha = 0.2
            delayText.alpha = 1.0
            delayText.text = String(delayTime)
            delayTime -= 1
            return
        }
        timerText.alpha = 1.0
        currentRoundText.alpha = 1.0
        delayText.alpha = 0.0
        if(hasStarted == false) {
            hasStarted = true
            if(_soundIsOn) {
                if(_soundEffect) {
                    audioPlayerGoGo.play();
                }
                else {
                    //audioPlayerstartSound.play()
                    audioPlayerRound.play()
                }
            }
            return
        }
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
            workTimeValues = workTimePicker.getTimerValues()
            restTimeValues = restTimePicker.getTimerValues()
            
            if(isInWorkoutMode) {
                currentRoundValue += 1
            }
            else {
                currentRoundText.text = "Round: " + String(currentRoundValue) + "/" + String(roundValue[0])
            }
            if((currentRoundValue-1) == roundPicker.getTimerValues()[0]) {
                let realValue = String(currentRoundValue-1)
                currentRoundText.text = "Round: " + realValue + "/" + String(roundPicker.getTimerValues()[0])
                timer.invalidate()
                showAlert()
                return
            }
            if(_soundIsOn) {
                if(currentRoundValue == roundValue[0] && _soundEffect == true && !isInWorkoutMode) {
                    audiPlayerFinalRound.play()
                }
                else {
                    audioPlayerRound.play()
                }
            }
            if(_vibratorOn) {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            isInWorkoutMode = !isInWorkoutMode
            if(isInWorkoutMode) {
                setTimerTextValue(workTimeValues)
            }
            else {
                setTimerTextValue(restTimeValues)
            }
        }
        else {
            setTimerTextValue(timerValues)
        }
    }
    
    
}

