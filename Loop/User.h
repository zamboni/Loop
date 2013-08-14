//
//  User.h
//  Loop
//
//  Created by Fletcher Fowler on 8/13/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABContact, Checkin, Event;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * contactId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * rid;
@property (nonatomic, retain) ABContact *ab_contact;
@property (nonatomic, retain) NSSet *checkins;
@property (nonatomic, retain) NSSet *shared_events;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCheckinsObject:(Checkin *)value;
- (void)removeCheckinsObject:(Checkin *)value;
- (void)addCheckins:(NSSet *)values;
- (void)removeCheckins:(NSSet *)values;

- (void)addShared_eventsObject:(Event *)value;
- (void)removeShared_eventsObject:(Event *)value;
- (void)addShared_events:(NSSet *)values;
- (void)removeShared_events:(NSSet *)values;

@end
