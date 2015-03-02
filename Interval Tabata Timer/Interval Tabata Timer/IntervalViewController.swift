//
//  FirstViewController.swift
//  Interval Tabata Timer
//
//  Created by Tobias Kruseborn on 28/02/15.
//  Copyright (c) 2015 mesa mingi. All rights reserved.
//

import UIKit

class IntervalViewController: UIViewController {
    
    
    @IBOutlet weak var currentRoundText: UITextField!
    @IBOutlet weak var timerText: UITextField!
    var timer = NSTimer()
    @IBOutlet weak var startAndPauseButton: UIBarButtonItem!
    var isInWorkoutMode = true
    
    @IBOutlet weak var roundText: UITextField!
    let roundPicker  : TimerPicker = TimerPicker()
    var roundValue = [8]
    var totalRoundValues = [100]
    let roundToolBar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
    
    @IBOutlet weak var workTimeText: UITextField!
    let workTimePicker  : TimerPicker = TimerPicker()
    var workTimeValues = [0,0,20]
    var workTimeTotals = [60,60,60]
    let workTimeToolBar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
    
    
    @IBOutlet weak var restTimeText: UITextField!
    let restTimePicker  : TimerPicker = TimerPicker()
    var restTimeValues = [0,0,10]
    var restTimeTotals = [60,60,60]
    let restTimeToolBar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //round picker
        roundPicker.delegate = roundPicker
        roundPicker.dataSource = roundPicker
        roundPicker.initialize(roundText, initValues: roundValue, valuesPerComponent: totalRoundValues, addPrefix: false)
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
        roundValue = roundPicker.getTimerValues()
        workTimeValues = workTimePicker.getTimerValues()
        restTimeValues = restTimePicker.getTimerValues()
        setTimerTextValue(workTimeValues)
        currentRoundText.text = "Round: " + String(roundValue[0]) + "/" + String(roundValue[0])
    }
  
    @IBAction func roundAction(sender: UITextField) {
        roundText.inputView = roundPicker
        roundText.inputAccessoryView = roundToolBar
        roundPicker.setTimerValues(roundValue)
    }
    
    @IBAction func workTimeAction(sender: UITextField) {
        workTimeText.inputView = workTimePicker
        workTimeText.inputAccessoryView = workTimeToolBar
        workTimePicker.setTimerValues(workTimeValues)
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
  
    @IBAction func restTimeAction(sender: UITextField) {
        resetValuesFromPicker()
        startAndPauseButton.title = "Start"
    }
    
    @IBAction func StartAndPauseAction(sender: UIBarButtonItem) {
        if(roundValue[0] == 0) {
            return
        }
        if(startAndPauseButton.title == "Start") {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
            startAndPauseButton.title = "Pause"
        }
        else {
            startAndPauseButton.title = "Start"
            timer.invalidate()
        }
    }
    @IBAction func ResetAction(sender: AnyObject) {
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
                roundValue[0]--
            }
            else {
                currentRoundText.text = "Round: " + String(roundValue[0]) + "/" + String(roundPicker.getTimerValues()[0])
            }
            if(roundValue[0] == 0) {
                currentRoundText.text = "Round: " + String(roundValue[0]) + "/" + String(roundPicker.getTimerValues()[0])
                timer.invalidate()
                return
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

