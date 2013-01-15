//
//  EventsController.h
//  Loop
//
//  Created by Fletcher Fowler on 1/15/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"

@interface EventsController : UITableViewController <LocationManagerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end