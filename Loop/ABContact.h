//
//  ABContact.h
//  Loop
//
//  Created by Fletcher Fowler on 2/14/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABEmail, User;

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
@property (nonatomic, retain) NSSet *emails;
@property (nonatomic, retain) User *user;
@end

@interface ABContact (CoreDataGeneratedAccessors)

- (void)addEmailsObject:(ABEmail *)value;
- (void)removeEmailsObject:(ABEmail *)value;
- (void)addEmails:(NSSet *)values;
- (void)removeEmails:(NSSet *)values;

@end
