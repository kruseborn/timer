//
//  FirstViewController.swift
//  Interval Tabata Timer
//
//  Created by Tobias Kruseborn on 28/02/15.
//  Copyright (c) 2015 mesa mingi. All rights reserved.
//

import UIKit

class IntervalViewController: UIViewController {
    
    
    @IBOutlet weak var timerText: UITextField!
    
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
    
    func setWorkTimeValuesToText() {
        var strArray = ["", "", ""]
        for i in 0..<workTimeValues.count {
            strArray[i] = (workTimeValues[i] < 10 ? "0" + String(workTimeValues[i]) : String(workTimeValues[i]))
        }
        println("here we are")
        print(strArray[2] + " " + String(workTimeValues[2]))
        timerText.text = strArray[0] + ":" + strArray[1] + ":" + strArray[2]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func roundPickerDone() {
        roundValue = roundPicker.getTimerValues()
        roundText.resignFirstResponder()
    }
    @IBAction func roundAction(sender: UITextField) {
        roundText.inputView = roundPicker
        roundText.inputAccessoryView = roundToolBar
        roundPicker.setTimerValues(roundValue)
    }
    func workTimePickerDone() {
        workTimeValues = workTimePicker.getTimerValues()
        setWorkTimeValuesToText()
        workTimeText.resignFirstResponder()
    }
    @IBAction func workTimeAction(sender: UITextField) {
        workTimeText.inputView = workTimePicker
        workTimeText.inputAccessoryView = workTimeToolBar
        workTimePicker.setTimerValues(workTimeValues)
    }
    func restTimePickerDone() {
        restTimeValues = restTimePicker.getTimerValues()
        restTimeText.resignFirstResponder()
    }
    @IBAction func restTimeAction(sender: UITextField) {
        restTimeText.inputView = restTimePicker
        restTimeText.inputAccessoryView = restTimeToolBar
        restTimePicker.setTimerValues(restTimeValues)
    }
}

