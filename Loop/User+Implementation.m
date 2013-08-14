//
//  User+Implementation.m
//  Loop
//
//  Created by Fletcher Fowler on 1/3/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "User+Implementation.h"
#import "RHAddressBook.h"
#import "ABContact+Implementation.h"

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
    [SSKeychain setPassword:[userDictionary objectForKey:@"access_token"] forService:@"loop" account:@"access"];
}

+ (NSString *)getAccessToken
{
    return [SSKeychain passwordForService:@"loop" account:@"access"];
}

+ (void)logout
{
    [SSKeychain deletePasswordForService:@"loop" account:@"access"];
}

- (ABContact *)createOrUpdateContact:(ABRecordRef)person{
    RHAddressBook *ab = [[RHAddressBook alloc] init];
    RHPerson *rhPerson = [ab personForABRecordID:ABRecordGetRecordID(person)];
    
    ABContact *contact = [ABContact createPersonFromRHPerson:rhPerson forUser:self inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    self.ab_contact = contact;
    
    NSNumber *contact_id = [NSNumber numberWithInt:ABRecordGetRecordID(person)];
    self.contactId = contact_id;
    
    return contact;
}


@end
