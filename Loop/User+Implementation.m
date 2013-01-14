//
//  User+Implementation.m
//  Loop
//
//  Created by Fletcher Fowler on 1/3/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "User+Implementation.h"

@implementation User (Implementation)

+ (RKEntityMapping *)entityMappingInManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;
{
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    entityMapping.identificationAttributes = @[@"rid"];
    [entityMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid" }];
    return entityMapping;
}

+ (void)registerUserWithEmail:(NSString *)email andPassword:(NSString *)password
{
    
    [[RKObjectManager sharedManager] postObject:[User class] path:@"/users" parameters:@{@"user" : @{@"email" : email, @"password" : password } } success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
    
}

@end
