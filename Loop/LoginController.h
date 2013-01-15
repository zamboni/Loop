//
//  LoginController.h
//  Loop
//
//  Created by Fletcher Fowler on 1/11/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "User+Implementation.h"

@interface LoginController : UIViewController <UITextFieldDelegate>

@property IBOutlet UITextField *emailField;
@property IBOutlet UITextField *passwordField;

@end
