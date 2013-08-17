//
//  Event+Implementation.m
//  Loop
//
//  Created by Fletcher Fowler on 1/16/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "Event+Implementation.h"

@implementation Event (Implementation)

+ (RKEntityMapping *)entityMappingInManagedObjectStore:(RKManagedObjectStore *)managedObjectStore
{
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:managedObjectStore];
    entityMapping.identificationAttributes = @[@"rid"];
    [entityMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid"}];
    return entityMapping;
}

- (NSString *)formattedStartDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy h:mma"];
    return [formatter stringFromDate:self.startDate];
}

@end
