//
//  Checkin.h
//  Loop
//
//  Created by Fletcher Fowler on 2/14/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, User;

@interface Checkin : NSManagedObject

@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * rid;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) User *user;

@end
