//
//  Event.h
//  Loop
//
//  Created by Fletcher Fowler on 1/29/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Checkin, Venue;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * rid;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *checkins;
@property (nonatomic, retain) Venue *venue;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addCheckinsObject:(Checkin *)value;
- (void)removeCheckinsObject:(Checkin *)value;
- (void)addCheckins:(NSSet *)values;
- (void)removeCheckins:(NSSet *)values;

@end
