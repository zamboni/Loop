//
//  EventsController.h
//  Loop
//
//  Created by Fletcher Fowler on 1/15/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "Event.h"
#import "RCLocationManager.h"
#import "EventController.h"

@interface EventsController : UITableViewController

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIAlertView *alert;

@end
