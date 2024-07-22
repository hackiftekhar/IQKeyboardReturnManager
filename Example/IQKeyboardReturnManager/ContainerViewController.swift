//
//  ContainerViewController.swift
//  IQKeyboardReturnManager_Example
//
//  Created by Iftekhar on 7/22/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import IQKeyboardReturnManager

class ContainerViewController: UIViewController {

    @IBOutlet private var textView22: UITextView!

    let returnManager: IQKeyboardReturnManager = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        returnManager.lastTextInputViewReturnKeyType = .done
        returnManager.addResponderSubviews(of: self.view, recursive: true)
    }

    @IBAction func onDismissSwitchChanged(_ sender: UISwitch) {
        returnManager.dismissTextViewOnReturn = sender.isOn
    }
}

extension ContainerViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // This is customized handling based on the need
        if textView == textView22 {
            if text == "\n" {
                returnManager.goToNextResponderOrResign(from: textView)
                return false
            }
        }
        return true
    }
}
