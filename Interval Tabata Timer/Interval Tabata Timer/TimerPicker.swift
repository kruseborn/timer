//
//  TimerPicker.swift
//  Interval Tabata Timer
//
//  Created by Tobias Kruseborn on 01/03/15.
//  Copyright (c) 2015 mesa mingi. All rights reserved.
//

import UIKit

class TimerPicker : UIPickerView {
    
    func initialize(_ timerText: UITextField!, initValues : [Int], valuesPerComponent : [Int], addPrefix : Bool, zeroIndex : Bool = true) {
        _zeroIndex = zeroIndex
        _timerText = timerText
        _valueArray = initValues
        _strArray = [String](repeating: "", count: initValues.count)
        _valuesPerComponent = valuesPerComponent
        _addPrefix = addPrefix
        for i in 0 ..< initValues.count {
            if(!_zeroIndex) {
                self.selectRow(_valueArray[i]-1, inComponent: i, animated: true)
            }
            else {
                self.selectRow(_valueArray[i], inComponent: i, animated: true)
            }
        }
        setTextValues()
    }
    func setTimerValues(_ values : [Int]) {
        _valueArray = values
        for i in 0..<_valueArray.count {
            if(!_zeroIndex) {
                self.selectRow(_valueArray[i]-1, inComponent: i, animated: true)
            }
            else {
                self.selectRow(_valueArray[i], inComponent: i, animated: true)
            }
        }
    }
    func getTimerValues() -> [Int] {
        return _valueArray
    }
    
    func setTextValues() {
        for i in 0..<_valueArray.count {
            _strArray[i] = (_valueArray[i] < 10 && _addPrefix ? "0" + String(_valueArray[i]) : String(_valueArray[i]))
        }
        var str = ""
        for i in 0..<_valueArray.count {
            if(i > 0) {
                str += ":"
            }
            str += _strArray[i]
        }
        _timerText.text = str
    }
    
    var _timerText: UITextField! = nil
    var _valueArray = [Int]()
    var _valuesPerComponent = [Int]()
    var _strArray = [String]()
    var _addPrefix = true
    var _zeroIndex = true
}
extension TimerPicker: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return _valueArray.count;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _valuesPerComponent[component]
    }
}
extension TimerPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(_zeroIndex == false) {
            return String(row + 1);
        }
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _valueArray[component] = row
        if(_zeroIndex == false) {
            _valueArray[component] = row + 1
        }
        setTextValues()

    }
    
}
