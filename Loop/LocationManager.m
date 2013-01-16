//
//  LocationManager.m
//  Loop
//
//  Created by Fletcher Fowler on 12/2/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import "LocationManager.h"


@implementation LocationManager

@synthesize locationManager;
@synthesize startLocation = _startLocation;

static LocationManager *sharedObject;
+ (LocationManager *)sharedInstance
{
    if (sharedObject == nil){
        sharedObject = [[super allocWithZone:NULL] init];
    }
    return sharedObject;
}

- (void)getLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1000.0f;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [self.delegate locationDidUpdate:locations];
}
@end
