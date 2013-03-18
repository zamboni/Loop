//
//  ContactController.h
//  Loop
//
//  Created by Fletcher Fowler on 3/6/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface ContactController : UIViewController

@property (nonatomic, retain) User *user;

@property IBOutlet UILabel *nameLabel;
@property IBOutlet UILabel *organizationLabel;
@property IBOutlet UILabel *jobTitleLabel;


-(IBAction)showPersonViewController:(id)sender;

@end
