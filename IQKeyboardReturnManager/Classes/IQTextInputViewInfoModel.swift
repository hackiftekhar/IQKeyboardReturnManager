//
//  IQTextInputViewInfoModel.swift
//  https://github.com/hackiftekhar/IQKeyboardReturnManager
//  Copyright (c) 2013-24 Iftekhar Qurashi.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

@available(iOSApplicationExtension, unavailable)
@MainActor
internal final class IQTextInputViewInfoModel: NSObject {

    weak var textFieldDelegate: (any UITextFieldDelegate)?
    weak var textViewDelegate: (any UITextViewDelegate)?
    weak var textInputView: UIView?
    let originalReturnKeyType: UIReturnKeyType

    init(textInputView: UITextField) {
        self.textInputView = textInputView
        self.textFieldDelegate = textInputView.delegate
        self.originalReturnKeyType = textInputView.returnKeyType
    }

    init(textInputView: UITextView) {
        self.textInputView = textInputView
        self.textViewDelegate = textInputView.delegate
        self.originalReturnKeyType = textInputView.returnKeyType
    }

    func restore() {
        if let textInputView = textInputView as? UITextField {
            textInputView.returnKeyType = originalReturnKeyType
            textInputView.delegate = textFieldDelegate
        } else if let textInputView = textInputView as? UITextView {
            textInputView.returnKeyType = originalReturnKeyType
            textInputView.delegate = textViewDelegate
        }
    }
}
