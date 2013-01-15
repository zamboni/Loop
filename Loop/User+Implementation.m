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
    [entityMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid", @"email" : @"email" }];
    return entityMapping;
}

+ (void)setAccessTokenWithDictionary:(NSDictionary *)userDictionary
{
    [[ACSimpleKeychain defaultKeychain] storeUsername:[userDictionary objectForKey:@"_id"] password:[userDictionary objectForKey:@"access_token"] identifier:@"accessToken" forService:@"loop"];
}

+ (void)logout
{
    [[ACSimpleKeychain defaultKeychain] deleteCredentialsForIdentifier:@"accessToken" service:@"loop"];
}
@end
