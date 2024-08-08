//
//  ViewController.m
//  IQKeyboardReturnManager_ObjcExample
//
//  Created by Iftekhar on 8/8/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

#import "ViewController.h"
#import <IQKeyboardReturnManager/IQKeyboardReturnManager-Swift.h>
#import <IQKeyboardCore/IQKeyboardCore-Swift.h>

@interface ViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITextField *textField1 = [[UITextField alloc] init];

    IQKeyboardReturnManager *manager = [[IQKeyboardReturnManager alloc] init];

    manager.delegate = self;
    manager.lastTextInputViewReturnKeyType = UIReturnKeyDone;
    manager.dismissTextViewOnReturn = false;

    [manager addWithTextInputView: textField1];
    [manager removeWithTextInputView: textField1];
    [manager addResponderSubviewsOf:self.view recursive:true];
    [manager removeResponderSubviewsOf:self.view recursive:true];
    [manager goToNextResponderOrResignFrom: textField1];
}

@end
