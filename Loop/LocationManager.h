//
//  LocationManager.h
//  Loop
//
//  Created by Fletcher Fowler on 12/2/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManagerDelegate.h"

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *startLocation;
}

@property (nonatomic, assign) id<LocationManagerDelegate> delegate;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;

+ (LocationManager *)sharedInstance;
- (void)getLocation;
- (void)stopUpdatingLocation;

@end
