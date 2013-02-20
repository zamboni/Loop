//
//  ABContact.h
//  Loop
//
//  Created by Fletcher Fowler on 2/20/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABAddress, ABDate, ABEmail, ABNames, User;

@interface ABContact : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * firstNamePhonetic;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSNumber * kind;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * lastNamePhonetic;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * middleNamePhonetic;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * organization;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) NSSet *addresses;
@property (nonatomic, retain) NSSet *emails;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *dates;
@property (nonatomic, retain) NSSet *instantMessages;
@property (nonatomic, retain) NSSet *names;
@property (nonatomic, retain) NSSet *phones;
@property (nonatomic, retain) NSSet *social;
@property (nonatomic, retain) NSSet *urls;
@end

@interface ABContact (CoreDataGeneratedAccessors)

- (void)addAddressesObject:(ABAddress *)value;
- (void)removeAddressesObject:(ABAddress *)value;
- (void)addAddresses:(NSSet *)values;
- (void)removeAddresses:(NSSet *)values;

- (void)addEmailsObject:(ABEmail *)value;
- (void)removeEmailsObject:(ABEmail *)value;
- (void)addEmails:(NSSet *)values;
- (void)removeEmails:(NSSet *)values;

- (void)addDatesObject:(ABDate *)value;
- (void)removeDatesObject:(ABDate *)value;
- (void)addDates:(NSSet *)values;
- (void)removeDates:(NSSet *)values;

- (void)addInstantMessagesObject:(NSManagedObject *)value;
- (void)removeInstantMessagesObject:(NSManagedObject *)value;
- (void)addInstantMessages:(NSSet *)values;
- (void)removeInstantMessages:(NSSet *)values;

- (void)addNamesObject:(ABNames *)value;
- (void)removeNamesObject:(ABNames *)value;
- (void)addNames:(NSSet *)values;
- (void)removeNames:(NSSet *)values;

- (void)addPhonesObject:(NSManagedObject *)value;
- (void)removePhonesObject:(NSManagedObject *)value;
- (void)addPhones:(NSSet *)values;
- (void)removePhones:(NSSet *)values;

- (void)addSocialObject:(NSManagedObject *)value;
- (void)removeSocialObject:(NSManagedObject *)value;
- (void)addSocial:(NSSet *)values;
- (void)removeSocial:(NSSet *)values;

- (void)addUrlsObject:(NSManagedObject *)value;
- (void)removeUrlsObject:(NSManagedObject *)value;
- (void)addUrls:(NSSet *)values;
- (void)removeUrls:(NSSet *)values;

@end
