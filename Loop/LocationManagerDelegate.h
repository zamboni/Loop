//
//  LocationManagerDelegate.h
//  Loop
//
//  Created by Fletcher Fowler on 12/3/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocationManager;

@protocol LocationManagerDelegate <NSObject>

@optional

- (void)locationDidUpdate:(NSArray *)locations;

@end
