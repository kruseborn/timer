//
//  settingViewController.swift
//  Interval Tabata Timer
//
//  Created by Tobias Kruseborn on 18/04/15.
//  Copyright (c) 2015 mesa mingi. All rights reserved.
//

import UIKit
import AVFoundation

class SettingViewController: UIViewController {
    var delayPicker = TimerPicker()
    var totalDelayValues = [10]
    let delayToolBar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
    
    override func viewDidLoad() {
        delayText.text = String(_delayTime)
        var delayValue = [_delayTime]
        soundOnOrOff.on = _soundIsOn
        vibratorOnOrOff.on = _vibratorOn
    
        delayPicker.delegate = delayPicker
        delayPicker.dataSource = delayPicker
        delayPicker.initialize(delayText, initValues: delayValue, valuesPerComponent: totalDelayValues, addPrefix: false)
        var barButton = UIBarButtonItem(title: "Done", style: .Plain, target:self, action: "delayPickerDone")
        var toolbarButtons = [barButton];
        delayToolBar.setItems(toolbarButtons, animated: true)
        
    }
    
    @IBAction func delayAction(sender: AnyObject) {
        delayText.inputView = delayPicker
        delayText.inputAccessoryView = delayToolBar
    }
    func delayPickerDone() {
        _delayTime = delayPicker.getTimerValues()[0]
        var delayTimeDefault = NSUserDefaults.standardUserDefaults()
        delayTimeDefault.setValue(_delayTime, forKey: _delayKey)
        delayTimeDefault.synchronize()
        
        delayText.resignFirstResponder()
    }

    @IBOutlet weak var delayText: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var delayTime: UIToolbar!
    @IBOutlet weak var vibratorOnOrOff: UISwitch!
    @IBOutlet weak var soundOnOrOff: UISwitch!
    @IBAction func SoundSwitchAction(sender: UISwitch) {
        _soundIsOn = !_soundIsOn
        var soundTimeDefault = NSUserDefaults.standardUserDefaults()
        soundTimeDefault.setValue(_soundIsOn, forKey: _soundKey)
        soundTimeDefault.synchronize()
    }
    @IBAction func vibratorAction(sender: UISwitch) {
        _vibratorOn = !_vibratorOn
        var vibrateTimeDefault = NSUserDefaults.standardUserDefaults()
        vibrateTimeDefault.setValue(_vibratorOn, forKey: _vibrateKey)
        vibrateTimeDefault.synchronize()
    }
 
    
}