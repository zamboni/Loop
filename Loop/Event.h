//
//  Event.h
//  Loop
//
//  Created by Fletcher Fowler on 8/15/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Checkin, User, Venue;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * rid;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSSet *checkins;
@property (nonatomic, retain) NSSet *shared_users;
@property (nonatomic, retain) Venue *venue;
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
