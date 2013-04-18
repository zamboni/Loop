//
//  ABContact.h
//  Loop
//
//  Created by Fletcher Fowler on 4/17/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABAddress, ABDate, ABEmail, ABInstantMessage, ABName, ABPhone, ABSocial, ABUrl, User;

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
@property (nonatomic, retain) id thumbnail;
@property (nonatomic, retain) NSSet *addresses;
@property (nonatomic, retain) NSSet *dates;
@property (nonatomic, retain) NSSet *emails;
@property (nonatomic, retain) NSSet *instantMessages;
@property (nonatomic, retain) NSSet *names;
@property (nonatomic, retain) NSSet *phones;
@property (nonatomic, retain) NSSet *socials;
@property (nonatomic, retain) NSSet *urls;
@property (nonatomic, retain) User *user;
@end

@interface ABContact (CoreDataGeneratedAccessors)

- (void)addAddressesObject:(ABAddress *)value;
- (void)removeAddressesObject:(ABAddress *)value;
- (void)addAddresses:(NSSet *)values;
- (void)removeAddresses:(NSSet *)values;

- (void)addDatesObject:(ABDate *)value;
- (void)removeDatesObject:(ABDate *)value;
- (void)addDates:(NSSet *)values;
- (void)removeDates:(NSSet *)values;

- (void)addEmailsObject:(ABEmail *)value;
- (void)removeEmailsObject:(ABEmail *)value;
- (void)addEmails:(NSSet *)values;
- (void)removeEmails:(NSSet *)values;

- (void)addInstantMessagesObject:(ABInstantMessage *)value;
- (void)removeInstantMessagesObject:(ABInstantMessage *)value;
- (void)addInstantMessages:(NSSet *)values;
- (void)removeInstantMessages:(NSSet *)values;

- (void)addNamesObject:(ABName *)value;
- (void)removeNamesObject:(ABName *)value;
- (void)addNames:(NSSet *)values;
- (void)removeNames:(NSSet *)values;

- (void)addPhonesObject:(ABPhone *)value;
- (void)removePhonesObject:(ABPhone *)value;
- (void)addPhones:(NSSet *)values;
- (void)removePhones:(NSSet *)values;

- (void)addSocialsObject:(ABSocial *)value;
- (void)removeSocialsObject:(ABSocial *)value;
- (void)addSocials:(NSSet *)values;
- (void)removeSocials:(NSSet *)values;

- (void)addUrlsObject:(ABUrl *)value;
- (void)removeUrlsObject:(ABUrl *)value;
- (void)addUrls:(NSSet *)values;
- (void)removeUrls:(NSSet *)values;

@end
