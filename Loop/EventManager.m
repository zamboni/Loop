//
//  EventSingleton.m
//  Loop
//
//  Created by Fletcher Fowler on 12/5/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import "EventManager.h"

@implementation EventManager 

static EventManager *sharedObject;
+ (EventManager *)sharedInstance
{
    if (sharedObject == nil){
        sharedObject = [[super allocWithZone:NULL] init];
    }
    return sharedObject;
}

- (void)getEvents
{
}

- (void)locationDidUpdate:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSNumber *lat = [NSNumber numberWithFloat:location.coordinate.latitude];
    NSNumber *lng = [NSNumber numberWithFloat:location.coordinate.longitude];
    
    NSDictionary *searchDictionary = @{@"lat":[NSString stringWithFormat:@"%@", lat], @"lng":[NSString stringWithFormat:@"%@", lng]};
    
}

- (void)eventsCreated
{
    [[self delegate] eventsUpdated];
}

@end
