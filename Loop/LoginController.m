//
//  LoginController.m
//  Loop
//
//  Created by Fletcher Fowler on 1/11/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

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

- (void)loginUser
{
    NSString *email                 = self.emailField.text;
    NSString *password              = self.passwordField.text;
    [[RKObjectManager sharedManager] postObject:nil path:@"session" parameters:@{@"user" : @{@"email" : email, @"password" : password } } success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:0 error:nil];
        [User setAccessTokenWithDictionary:[response objectForKey:@"user"]];

        [self performSegueWithIdentifier:@"loginSegue" sender:self];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loginUser];
    return true;
}

@end
