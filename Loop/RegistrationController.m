//
//  RegistrationController.m
//  Loop
//
//  Created by Fletcher Fowler on 1/10/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "RegistrationController.h"

@interface RegistrationController ()

@end

@implementation RegistrationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRegistration
{
    NSString *email                 = self.emailField.text;
    NSString *password              = self.passwordField.text;
    NSString *password_confirmation = self.passwordConfirmationField.text;
    if([password isEqualToString:password_confirmation]){
        [[RKObjectManager sharedManager] postObject:nil path:@"users" parameters:@{@"user" : @{@"email" : email, @"password" : password } } success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:nil];
            [User setAccessTokenWithDictionary:response];

            [self performSegueWithIdentifier:@"registrationSegue" sender:self];
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Passwords do not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    };
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendRegistration];
    return true;
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
	}
}

@end
