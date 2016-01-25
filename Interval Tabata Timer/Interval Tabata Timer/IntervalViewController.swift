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
    var alarmSound = NSURL(fileURLWithPath: (NSBundle.mainBundle().pathForResource("alarmSound", ofType: "mp3"))!)
    var roundSounds = NSURL(fileURLWithPath: (NSBundle.mainBundle().pathForResource("round_sound", ofType: "mp3"))!)
    var delaySound = NSURL(fileURLWithPath: (NSBundle.mainBundle().pathForResource("warning_beep", ofType: "mp3"))!)
    
    var finalRoundSound = NSURL(fileURLWithPath: (NSBundle.mainBundle().pathForResource("final_round", ofType: "mp3"))!)
    var gogoSound = NSURL(fileURLWithPath: (NSBundle.mainBundle().pathForResource("gogo", ofType: "wav"))!)
    var finishSound = NSURL(fileURLWithPath: (NSBundle.mainBundle().pathForResource("outstanding", ofType: "mp3"))!)
    
    
    var audioPlayer = AVAudioPlayer()
    var audioPlayerRound = AVAudioPlayer()
    
    //var audioPlayerstartSound = AVAudioPlayer()
    var audioPlayerDelay = AVAudioPlayer()
    var audiPlayerFinalRound = AVAudioPlayer()
    var audioPlayerGoGo = AVAudioPlayer()
    var audioPlayerFinish = AVAudioPlayer()
    
    
    
    @IBOutlet weak var currentRoundText: UITextField!
    @IBOutlet weak var timerText: UITextField!
    var timer = NSTimer()
    @IBOutlet weak var startAndPauseButton: UIBarButtonItem!
    var isInWorkoutMode = true
    
    @IBOutlet weak var roundText: UITextField!
    let roundPicker  : TimerPicker = TimerPicker()
    var roundValue = [8]
    var currentRoundValue = 1
    
    var totalRoundValues = [100]
    let roundToolBar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
    
    @IBOutlet weak var workTimeText: UITextField!
    let workTimePicker  : TimerPicker = TimerPicker()
    var workTimeValues = [0,0,20]
    var workTimeTotals = [60,60,60]
    let workTimeToolBar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
    
    @IBOutlet weak var delayText: UITextField!
    
    @IBOutlet weak var restTimeText: UITextField!
    let restTimePicker  : TimerPicker = TimerPicker()
    var restTimeValues = [0,0,10]
    var restTimeTotals = [60,60,60]
    let restTimeToolBar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
    var hasStarted = false
    var delayTime = _delayTime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delayTime = _delayTime
        let defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.valueForKey(_delayKey) != nil) {
            _delayTime = defaults.valueForKey(_delayKey) as! NSInteger!
        }
        if(defaults.valueForKey(_soundKey) != nil) {
            _soundIsOn = defaults.valueForKey(_soundKey) as! Bool!
        }
        if(defaults.valueForKey(_vibrateKey) != nil) {
            _vibratorOn = defaults.valueForKey(_vibrateKey) as! Bool!
        }
        if(defaults.valueForKey(_soundEffectKey) != nil) {
            _soundEffect = defaults.valueForKey(_soundEffectKey) as! Bool!
        }
        if(defaults.valueForKey(_workTimeKey) != nil) {
            workTimeValues = defaults.valueForKey(_workTimeKey) as! [Int]
        }
        if(defaults.valueForKey(_restTimeKey) != nil) {
            restTimeValues = defaults.valueForKey(_restTimeKey) as! [Int]
        }
        if(defaults.valueForKey(_roundKey) != nil) {
            roundValue = defaults.valueForKey(_roundKey) as! [Int]
        }
        audioPlayer = try! AVAudioPlayer(contentsOfURL: alarmSound);
        audioPlayer.prepareToPlay()
        
        audioPlayerRound = try! AVAudioPlayer(contentsOfURL: roundSounds)
        audioPlayerRound.prepareToPlay()
        
        //audioPlayerstartSound = AVAudioPlayer(contentsOfURL: startSound, error: nil)
        //audioPlayerstartSound.prepareToPlay()
        audioPlayerDelay = try! AVAudioPlayer(contentsOfURL: delaySound)
        audioPlayerDelay.prepareToPlay()
        audiPlayerFinalRound = try! AVAudioPlayer(contentsOfURL: finalRoundSound)
        audiPlayerFinalRound.prepareToPlay()
        audioPlayerGoGo = try! AVAudioPlayer(contentsOfURL: gogoSound)
        audioPlayerGoGo.prepareToPlay()
        audioPlayerFinish = try! AVAudioPlayer(contentsOfURL: finishSound)
        audioPlayerFinish.prepareToPlay()
      
        

        delayText.alpha = 0.0
        //round picker
        roundPicker.delegate = roundPicker
        roundPicker.dataSource = roundPicker
        roundPicker.initialize(roundText, initValues: roundValue, valuesPerComponent: totalRoundValues, addPrefix: false, zeroIndex: false)
        var barButton = UIBarButtonItem(title: "Done", style: .Plain, target:self, action: "roundPickerDone")
        var toolbarButtons = [barButton];
        roundToolBar.setItems(toolbarButtons, animated: true)
       
        //worktime picker
        workTimePicker.delegate = workTimePicker
        workTimePicker.dataSource = workTimePicker
        workTimePicker.initialize(workTimeText, initValues: workTimeValues, valuesPerComponent: workTimeTotals, addPrefix: true)
        var workTimeBarButton = UIBarButtonItem(title: "Done", style: .Plain, target:self, action: "workTimePickerDone")
        var workTimeToolbarButtons = [workTimeBarButton];
        workTimeToolBar.setItems(workTimeToolbarButtons, animated: true)
        
        //resttime picker
        restTimePicker.delegate = restTimePicker
        restTimePicker.dataSource = restTimePicker
        restTimePicker.initialize(restTimeText, initValues: restTimeValues, valuesPerComponent: restTimeTotals, addPrefix: true)
        var restTimeBarButton = UIBarButtonItem(title: "Done", style: .Plain, target:self, action: "restTimePickerDone")
        var restTimeToolbarButtons = [restTimeBarButton];
        restTimeToolBar.setItems(restTimeToolbarButtons, animated: true)
        resetValuesFromPicker();

        
        //set colors
        self.view.backgroundColor = UIColor(red: 255, green: 0, blue: 255, alpha: 255);
    
        
    }
    
    func setTimerTextValue(values : [Int]) {
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
        UIApplication.sharedApplication().idleTimerDisabled = false
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
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(workTimeValues, forKey: _workTimeKey)
        defaults.synchronize()
        defaults.setValue(restTimeValues, forKey: _restTimeKey)
        defaults.synchronize()
        defaults.setValue(roundValue, forKey: _roundKey)
        defaults.synchronize()
        
        timer.invalidate()
    }
  
    @IBAction func roundAction(sender: UITextField) {
        roundText.inputView = roundPicker
        roundText.inputAccessoryView = roundToolBar
    }
    @IBAction func workTimeAction(sender: UITextField) {
        workTimeText.inputView = workTimePicker
        workTimeText.inputAccessoryView = workTimeToolBar
    }
    @IBAction func restTimeAction(sender: UITextField) {
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
    
    @IBAction func StartAndPauseAction(sender: UIBarButtonItem) {
        if(startAndPauseButton.title == "Start") {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
            startAndPauseButton.title = "Pause"
            UIApplication.sharedApplication().idleTimerDisabled = true
            if(!hasStarted) {
                delayTime = _delayTime
            }
        }
        else {
            startAndPauseButton.title = "Start"
            timer.invalidate()
        }
    }
    @IBAction func ResetAction(sender: AnyObject) {
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
        alert.addButtonWithTitle("ok")
        alert.show()
        
    }
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
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
    func updateTimer_(inout timerValues : [Int]) {
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
            delayTime--
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
            workTimeValues = workTimePicker.getTimerValues()
            restTimeValues = restTimePicker.getTimerValues()
            
            if(isInWorkoutMode) {
                currentRoundValue++
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

