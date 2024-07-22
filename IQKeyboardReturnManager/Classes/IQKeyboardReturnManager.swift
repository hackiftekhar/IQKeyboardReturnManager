//
//  IQKeyboardReturnManager.swift
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

/**
Manages the return key to work like next/done in a view hierarchy.
*/
@available(iOSApplicationExtension, unavailable)
@MainActor
@objc public final class IQKeyboardReturnManager: NSObject {

    // MARK: Private variables
    private var textInputViewInfoCache: [IQTextInputViewInfoModel] = []

    // MARK: Settings

    /**
     Delegate of textInputView
     */
    @objc public weak var delegate: (any UITextFieldDelegate & UITextViewDelegate)?

    /**
     Set the last textInputView return key type. Default is UIReturnKeyDefault.
     */
    @objc public var lastTextInputViewReturnKeyType: UIReturnKeyType = UIReturnKeyType.default {

        didSet {
            for model in textInputViewInfoCache {
                if let view: UIView = model.textInputView {
                    updateReturnKey(textInputView: view)
                }
            }
        }
    }

    @objc public var dismissTextViewOnReturn: Bool = false

    // MARK: Initialization/De-initialization

    @objc public override init() {
        super.init()
    }

    deinit {

        //        for model in textInputViewInfoCache {
        //            model.restore()
        //        }

        textInputViewInfoCache.removeAll()
    }
}

// MARK: Registering/Unregistering textInputView

public extension IQKeyboardReturnManager {

    /**
     Should pass TextInputView instance. Assign textInputView delegate to self, change it's returnKeyType.

     @param view TextInputView object to register.
     */
    @objc func add(textInputView: UIView) {

        if let view: UITextField = textInputView as? UITextField {
            let model = IQTextInputViewInfoModel(textInputView: view)
            textInputViewInfoCache.append(model)
            view.delegate = self

        } else if let view: UITextView = textInputView as? UITextView {
            let model = IQTextInputViewInfoModel(textInputView: view)
            textInputViewInfoCache.append(model)
            view.delegate = self
        }
    }

    /**
     Should pass TextInputView instance. Restore it's textInputView delegate and it's returnKeyType.

     @param view TextInputView object to unregister.
     */
    @objc func remove(textInputView: UIView) {

        guard let index: Int = textInputViewInfoCache.firstIndex(where: { $0.textInputView == textInputView}) else { return }
        let model = textInputViewInfoCache.remove(at: index)
        model.restore()
    }

    /**
     Add all the TextInputView responderView's.

     @param view UIView object to register all it's responder subviews.
     */
    @objc func addResponderSubviews(of view: UIView, recursive: Bool) {

        let textInputViews: [UIView]
        if recursive {
            textInputViews = view.deepResponderSubviews()
        } else {
            textInputViews = view.responderSubviews()
        }

        for view in textInputViews {
            add(textInputView: view)
        }
    }

    /**
     Remove all the TextInputView responderView's.

     @param view UIView object to unregister all it's responder subviews.
     */
    @objc func removeResponderSubviews(of view: UIView, recursive: Bool) {

        let textInputViews: [UIView]
        if recursive {
            textInputViews = view.deepResponderSubviews()
        } else {
            textInputViews = view.responderSubviews()
        }

        for view in textInputViews {
            remove(textInputView: view)
        }
    }
}

public extension IQKeyboardReturnManager {
    @discardableResult
    func goToNextResponderOrResign(from textInputView: UIView) -> Bool {

        guard let index: Int = textInputViewInfoCache.firstIndex(where: { $0.textInputView == textInputView}) else { return false }

        let isNotLast: Bool = index != textInputViewInfoCache.count - 1

        if isNotLast, let textInputView = textInputViewInfoCache[index+1].textInputView {
            textInputView.becomeFirstResponder()
            return false
        } else {
            textInputView.resignFirstResponder()
            return true
        }
    }
}

// MARK: Internal Functions
internal extension IQKeyboardReturnManager {

    func textInputViewCachedInfo(_ textInputView: UIView) -> IQTextInputViewInfoModel? {

        for model in textInputViewInfoCache {

            if let view: UIView = model.textInputView {
                if view == textInputView {
                    return model
                }
            }
        }

        return nil
    }

    func updateReturnKey(textInputView: UIView) {

        guard let index: Int = textInputViewInfoCache.firstIndex(where: { $0.textInputView == textInputView}) else { return }

        let isLast: Bool = index == textInputViewInfoCache.count - 1

        let returnKey: UIReturnKeyType = isLast ? lastTextInputViewReturnKeyType: UIReturnKeyType.next
        if let view: UITextField = textInputView as? UITextField, view.returnKeyType != returnKey {

            // If it's the last textInputView in responder view, else next
            view.returnKeyType = returnKey
            view.reloadInputViews()
        } else if let view: UITextView = textInputView as? UITextView, view.returnKeyType != returnKey {

            // If it's the last textInputView in responder view, else next
            view.returnKeyType = returnKey
            view.reloadInputViews()
        }
    }
}

fileprivate extension UIView {

    func responderSubviews() -> [UIView] {

        // Array of TextInputViews.
        var textInputViews: [UIView] = []

        for view in subviews {

            var canBecomeFirstResponder: Bool = false

            if view.conforms(to: (any UITextInput).self) == true {
                //  Setting toolbar to keyboard.
                if let view: UITextView = view as? UITextView {
                    canBecomeFirstResponder = view.isEditable
                } else if let view: UITextField = view as? UITextField {
                    canBecomeFirstResponder = view.isEnabled
                }
            }

            // Sometimes there are hidden or disabled views and textInputView inside them still recorded,
            // so we added some more validations here
            if canBecomeFirstResponder,
               self.isUserInteractionEnabled == true,
               self.isHidden == false, self.alpha != 0.0 {
                textInputViews.append(view)
            }
        }

        // subviews are returning in opposite order. Sorting according the frames 'y'.
        return textInputViews.sorted(by: { (view1: UIView, view2: UIView) -> Bool in

            let frame1: CGRect = view1.convert(view1.bounds, to: self)
            let frame2: CGRect = view2.convert(view2.bounds, to: self)

            if frame1.minY != frame2.minY {
                return frame1.minY < frame2.minY
            } else {
                return frame1.minX < frame2.minX
            }
        })
    }

    func deepResponderSubviews() -> [UIView] {

        // Array of TextInputViews.
        var textInputViews: [UIView] = []

        for view in subviews {

            var canBecomeFirstResponder: Bool = false

            if view.conforms(to: (any UITextInput).self) == true {
                //  Setting toolbar to keyboard.
                if let view: UITextView = view as? UITextView {
                    canBecomeFirstResponder = view.isEditable
                } else if let view: UITextField = view as? UITextField {
                    canBecomeFirstResponder = view.isEnabled
                }
            }

            if canBecomeFirstResponder {
                textInputViews.append(view)
            }
            // Sometimes there are hidden or disabled views and textInputView inside them still recorded,
            // so we added some more validations here (Bug ID: #458)
            // Uncommented else (Bug ID: #625)
            else if view.subviews.count != 0,
                    self.isUserInteractionEnabled == true,
                    self.isHidden == false, self.alpha != 0.0 {
                for deepView in view.deepResponderSubviews() {
                    textInputViews.append(deepView)
                }
            }
        }

        // subviews are returning in opposite order. Sorting according the frames 'y'.
        return textInputViews.sorted(by: { (view1: UIView, view2: UIView) -> Bool in

            let frame1: CGRect = view1.convert(view1.bounds, to: self)
            let frame2: CGRect = view2.convert(view2.bounds, to: self)

            if frame1.minY != frame2.minY {
                return frame1.minY < frame2.minY
            } else {
                return frame1.minX < frame2.minX
            }
        })
    }
}

@available(*, unavailable, renamed: "IQKeyboardReturnManager")
@MainActor
@objc public final class IQKeyboardReturnKeyHandler: NSObject {}
