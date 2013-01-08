//
//  User+Implementation.m
//  Loop
//
//  Created by Fletcher Fowler on 1/3/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "User+Implementation.h"
#import <RestKit/RestKit.h>

@implementation User (Implementation)

+ (RKObjectMapping *)objectMapping
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[User class]];
    [objectMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid" }];
    return objectMapping;
}

+ (void)registerUserWithEmail:(NSString *)email andPassword:(NSString *)password
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Loop" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[self class] pathPattern:@"/users/" method:RKRequestMethodPOST]];
    [objectManager postObject:[User class] path:nil parameters:@{@"user" : @{@"email" : email, @"password" : password } } success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
    
}

@end
