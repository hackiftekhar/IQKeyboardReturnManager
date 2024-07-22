//
//  ViewController.swift
//  IQKeyboardReturnManager
//
//  Created by hackiftekhar on 07/22/2024.
//  Copyright (c) 2024 hackiftekhar. All rights reserved.
//

import UIKit
import IQKeyboardReturnManager

class ViewController: UIViewController {

    @IBOutlet private var textField11: UITextField!
    @IBOutlet private var textView12: UITextView!
    @IBOutlet private var textField13: UITextField!
    @IBOutlet private var textView14: UITextView!

    @IBOutlet private var textField21: UITextField!
    @IBOutlet private var textView22: UITextView!
    @IBOutlet private var textField23: UITextField!
    @IBOutlet private var textView24: UITextView!

    let returnManager1: IQKeyboardReturnManager = .init()
    let returnManager2: IQKeyboardReturnManager = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        returnManager1.dismissTextViewOnReturn = true
        returnManager1.lastTextInputViewReturnKeyType = .continue
        returnManager1.add(textInputView: textField11)
        returnManager1.add(textInputView: textView12)
        returnManager1.add(textInputView: textField13)
        returnManager1.add(textInputView: textView14)

        returnManager2.dismissTextViewOnReturn = true
        returnManager2.lastTextInputViewReturnKeyType = .go
        returnManager2.add(textInputView: textField21)
        returnManager2.add(textInputView: textView22)
        returnManager2.add(textInputView: textField23)
        returnManager2.add(textInputView: textView24)
    }
}

