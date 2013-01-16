//
//  EventDelegate.h
//  Loop
//
//  Created by Fletcher Fowler on 12/5/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EventManager;

@protocol EventSingletonDelegate <NSObject>

@optional

- (void)eventsUpdated;

@end
