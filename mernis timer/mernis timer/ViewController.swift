//
//  ViewController.swift
//  mernis timer
//
//  Created by Tobias Kruseborn on 28/02/15.
//  Copyright (c) 2015 mesa mingi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func play(sender: UIBarButtonItem) {
        
        self.timerText.text = "02:00:02"
        
    }
}

