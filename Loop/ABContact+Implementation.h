//
//  ABPerson+Implementation.h
//  Loop
//
//  Created by Fletcher Fowler on 2/8/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "ABContact.h"
#import <RHAddressBook/AddressBook.h>
#import <RHAddressBook/RHPerson.h>
#import "User+Implementation.h"

@interface ABContact (Implementation)

- (NSString *)fullName;
+ (ABContact *)createPersonFromRHPerson:(RHPerson *)rhPerson forUser:(User *)user inContext:(NSManagedObjectContext *)context;
- (RHPerson *)createRHPerson;

@end
