//
//  EventSingleton.h
//  Loop
//
//  Created by Fletcher Fowler on 12/5/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"
#import "EventSingletonDelegate.h"
#import <RestKit/RestKit.h>

@interface EventManager : NSObject <EventSingletonDelegate>

@property (nonatomic, assign) id<EventSingletonDelegate> delegate;

+ (EventManager *)sharedInstance;
- (void)getEvents;

@end
