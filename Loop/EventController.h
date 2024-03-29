//
//  EventController.h
//  Loop
//
//  Created by Fletcher Fowler on 1/17/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "ContactController.h"

#import "Event.h"
#import "User.h"
#import "Venue.h"

@interface EventController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) Event *event;

@property IBOutlet UIButton *checkinButton;
@property IBOutlet UILabel *eventTitle;
@property IBOutlet UILabel *venueTitle;
@property IBOutlet UILabel *venueAddress;
@property IBOutlet UIImageView *thumbnailImageView;


@property (strong, nonatomic) IBOutlet UITableView *contactsTable;

- (IBAction)checkIn:(id)sender;

@end
