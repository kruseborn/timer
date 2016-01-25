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
    var delayPicker = TimerPicker();
    var themePicker = NamePicker();
    var themeValues = ["White", "Pink", "Dark"]
    var totalDelayValues = [10]
    let delayToolBar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
    let themeToolBar = UIToolbar(frame: CGRectMake(0, 0, 100, 50))
    
    @IBOutlet weak var delayTime: UIToolbar!
    @IBOutlet weak var vibratorOnOrOff: UISwitch!
    @IBOutlet weak var soundOnOrOff: UISwitch!
    
    @IBOutlet weak var soundEffectSwitch: UISwitch!
    
    override func viewDidLoad() {
        delayText.text = String(_delayTime)
        let delayValue = [_delayTime]
        soundOnOrOff.on = _soundIsOn
        vibratorOnOrOff.on = _vibratorOn
        soundEffectSwitch.on = _soundEffect
        
        self.view.backgroundColor = globals.backgroundColor;
    
        delayPicker.delegate = delayPicker
        delayPicker.dataSource = delayPicker
        delayPicker.initialize(delayText, initValues: delayValue, valuesPerComponent: totalDelayValues, addPrefix: false)
        let barButton = UIBarButtonItem(title: "Done", style: .Plain, target:self, action: "delayPickerDone")
        let toolbarButtons = [barButton];
        delayToolBar.setItems(toolbarButtons, animated: true)
        
        
        //theme
        themePicker.delegate = themePicker
        themePicker.dataSource = themePicker
        themePicker.initialize(themeText, initValues: themeValues);
        let barButton2 = UIBarButtonItem(title: "Done", style: .Plain, target:self, action: "themePickerDone")
        let toolbarButtons2 = [barButton2];
        themeToolBar.setItems(toolbarButtons2, animated: true)
    }
    
    
    
    @IBOutlet weak var themeText: UITextField!
    @IBAction func themeButton(sender: UITextField) {
        themeText.inputView = themePicker;
        themeText.inputAccessoryView = themeToolBar;
    }
    func themePickerDone() {
        print(themePicker.getCurrentValue())
        globals.backgroundColor = UIColor(colorLiteralRed: 250, green: 0, blue: 0, alpha: 255)
        themeText.resignFirstResponder()
    }
    
    @IBOutlet weak var delayText: UITextField!
    @IBAction func delayAction(sender: AnyObject) {
        delayText.inputView = delayPicker
        delayText.inputAccessoryView = delayToolBar
    }
    func delayPickerDone() {
        _delayTime = delayPicker.getTimerValues()[0]
        let delayTimeDefault = NSUserDefaults.standardUserDefaults()
        delayTimeDefault.setValue(_delayTime, forKey: _delayKey)
        delayTimeDefault.synchronize()
        
        delayText.resignFirstResponder()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    @IBAction func soundEffectAction(sender: UISwitch) {
        _soundEffect = !_soundEffect;
        let soundEffectDefault = NSUserDefaults.standardUserDefaults()
        soundEffectDefault.setValue(_soundEffect, forKey: _soundEffectKey)
        soundEffectDefault.synchronize()
    }
    
    @IBAction func SoundSwitchAction(sender: UISwitch) {
        _soundIsOn = !_soundIsOn
        let soundTimeDefault = NSUserDefaults.standardUserDefaults()
        soundTimeDefault.setValue(_soundIsOn, forKey: _soundKey)
        soundTimeDefault.synchronize()
    }
    @IBAction func vibratorAction(sender: UISwitch) {
        _vibratorOn = !_vibratorOn
        let vibrateTimeDefault = NSUserDefaults.standardUserDefaults()
        vibrateTimeDefault.setValue(_vibratorOn, forKey: _vibrateKey)
        vibrateTimeDefault.synchronize()
    }
 
    
}