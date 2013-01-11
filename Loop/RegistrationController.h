//
//  RegistrationController.h
//  Loop
//
//  Created by Fletcher Fowler on 1/10/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface RegistrationController : UIViewController

@property IBOutlet UITextField *emailField;
@property IBOutlet UITextField *passwordField;
@property IBOutlet UITextField *passwordConfirmationField;

- (IBAction)sendRegistration;

@end
