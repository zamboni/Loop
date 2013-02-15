//
//  Venue.h
//  Loop
//
//  Created by Fletcher Fowler on 2/14/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * rid;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * stateCode;
@property (nonatomic, retain) NSString * streetAddress;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSSet *events;
@end

@interface Venue (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
