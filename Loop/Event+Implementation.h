//
//  Event+Implementation.h
//  Loop
//
//  Created by Fletcher Fowler on 1/16/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "Event.h"
#import <RestKit/RestKit.h>

@interface Event (Implementation)

+ (RKEntityMapping *)entityMappingInManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;
- (NSString *)formattedStartDate;

@end
