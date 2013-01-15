//
//  User+Implementation.h
//  Loop
//
//  Created by Fletcher Fowler on 1/3/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "User.h"
#import <RestKit/RestKit.h>
#import "ACSimpleKeychain.h"

@interface User (Implementation)

+ (RKEntityMapping *)entityMappingInManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;
+ (void)registerUserWithEmail:(NSString *)email andPassword:(NSString *)password;
+ (void)setAccessTokenWithDictionary:(NSDictionary *)userDictionary;
+ (void)logout;

@end
