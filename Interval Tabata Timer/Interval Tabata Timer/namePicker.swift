//
//  TimerPicker.swift
//  Interval Tabata Timer
//
//  Created by Tobias Kruseborn on 01/03/15.
//  Copyright (c) 2015 mesa mingi. All rights reserved.
//

import UIKit

class NamePicker : UIPickerView {
    
    func initialize(timerText: UITextField!, initValues : [String]) {
        _strArray = initValues;
        _timerText = timerText;
        _currentValue = initValues[0];
    }
    var _timerText: UITextField! = nil
    var _strArray = [String]()
    var _currentValue = String();
    func getCurrentValue() ->String { return _currentValue; }

}
extension NamePicker: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _strArray.count;
    }
}
extension NamePicker: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _strArray[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        _timerText.text = _strArray[row];
        _currentValue = _strArray[row];
    }
    
}