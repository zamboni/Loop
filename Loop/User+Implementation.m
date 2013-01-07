//
//  User+Implementation.m
//  Loop
//
//  Created by Fletcher Fowler on 1/3/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "User+Implementation.h"
#import "RKObjectMapping.h"
#import "RKObjectManager.h"

@implementation User (Implementation)

+ (RKObjectMapping *)objectMapping
{
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[User class]];
    [objectMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid" }];
    return objectMapping;
}

+ (id)registerUserWithEmail:(NSString *)email andPassword:(NSString *)password
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
}

@end
