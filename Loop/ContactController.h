//
//  ContactController.h
//  Loop
//
//  Created by Fletcher Fowler on 3/6/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface ContactController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) User *user;

@property IBOutlet UILabel *nameLabel;
@property IBOutlet UILabel *organizationLabel;
@property IBOutlet UILabel *jobTitleLabel;
@property IBOutlet UIImageView *thumbnailImageView;

@property (strong, nonatomic) IBOutlet UITableView *sharedEventsTable;


-(IBAction)showPersonViewController:(id)sender;

@end
