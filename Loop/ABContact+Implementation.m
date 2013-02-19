//
//  ABPerson+Implementation.m
//  Loop
//
//  Created by Fletcher Fowler on 2/8/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "ABContact+Implementation.h"
#import "ABEmail+Implementation.h"

@implementation ABContact (Implementation)

+ (ABContact *)createPersonFromRHPerson:(RHPerson *)rhPerson inContext:(NSManagedObjectContext *)context
{
    ABContact *person = [ABContact MR_createInContext:context];
    person.firstName            = rhPerson.firstName;
    person.lastName             = rhPerson.lastName;
    person.middleName           = rhPerson.middleName;
    person.nickname             = rhPerson.nickname;
    person.firstNamePhonetic    = rhPerson.firstNamePhonetic;
    person.lastNamePhonetic     = rhPerson.lastNamePhonetic;
    person.middleNamePhonetic   = rhPerson.middleNamePhonetic;
    person.organization         = rhPerson.organization;
    person.jobTitle             = rhPerson.jobTitle;
    person.department           = rhPerson.department;
    person.birthday             = rhPerson.birthday;
    person.note                 = rhPerson.note;
    person.created              = rhPerson.created;
    person.modified             = rhPerson.modified;
    
    for (int index = 0; index < [rhPerson.emails count] ; index++) {
        ABEmail *email = [ABEmail MR_createInContext:context];
        email.email = [rhPerson.emails valueAtIndex:index];
        email.label = [rhPerson.emails labelAtIndex:index];
        [person addEmailsObject:email];
    }
    
    return person;
};

- (RHPerson *)createRHPerson
{
    RHAddressBook *rh = [[RHAddressBook alloc] init];
    RHPerson *person = [rh newPersonInDefaultSource];
    person.firstName = self.firstName;
    person.lastName = self.lastName;
    
    RHMultiStringValue *emailMultiValue = [person emails];
    RHMutableMultiStringValue *mutableEmailMultiValue = [emailMultiValue mutableCopy];
    if (! mutableEmailMultiValue) mutableEmailMultiValue = [[RHMutableMultiStringValue alloc] initWithType:kABMultiStringPropertyType];
    
    //RHPersonPhoneIPhoneLabel casts kABPersonPhoneIPhoneLabel to the correct toll free bridged type, see RHPersonLabels.h
    for(ABEmail *email in self.emails){
        [mutableEmailMultiValue addValue:email.email withLabel:email.label];
    }
    person.emails = mutableEmailMultiValue;
    
    [person save];
    return person;
}

@end
