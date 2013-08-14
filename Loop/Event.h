//
//  Event.h
//  Loop
//
//  Created by Fletcher Fowler on 8/13/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Checkin, User, Venue;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * rid;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *checkins;
@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) NSSet *shared_users;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addCheckinsObject:(Checkin *)value;
- (void)removeCheckinsObject:(Checkin *)value;
- (void)addCheckins:(NSSet *)values;
- (void)removeCheckins:(NSSet *)values;

- (void)addShared_usersObject:(User *)value;
- (void)removeShared_usersObject:(User *)value;
- (void)addShared_users:(NSSet *)values;
- (void)removeShared_users:(NSSet *)values;

@end
