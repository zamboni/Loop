//
//  ABPerson+Implementation.m
//  Loop
//
//  Created by Fletcher Fowler on 2/8/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "ABContact+Implementation.h"
#import "ABAddress.h"
#import "ABDate.h"
#import "ABEmail.h"
#import "ABInstantMessage.h"
#import "ABName.h"
#import "ABPhone.h"
#import "ABSocial.h"
#import "ABUrl.h"

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

    for (int index = 0; index < [rhPerson.addresses count] ; index++) {
        ABAddress *address      = [ABAddress MR_createInContext:context];
        address.label           = [rhPerson.addresses labelAtIndex:index];
        address.city            = [[rhPerson.addresses valueAtIndex:index] objectForKey:@"City"];
        address.country         = [[rhPerson.addresses valueAtIndex:index] objectForKey:@"Country"];
        address.countryCode     = [[rhPerson.addresses valueAtIndex:index] objectForKey:@"CountryCode"];
        address.state           = [[rhPerson.addresses valueAtIndex:index] objectForKey:@"State"];
        address.street          = [[rhPerson.addresses valueAtIndex:index] objectForKey:@"Street"];
        address.zip             = [[rhPerson.addresses valueAtIndex:index] objectForKey:@"ZIP"];
        [person addAddressesObject:address];
    }
    
    for (int index = 0; index < [rhPerson.dates count] ; index++) {
        ABDate *date    = [ABDate MR_createInContext:context];
        date.label      = [rhPerson.dates labelAtIndex:index];
        date.date       = [rhPerson.dates valueAtIndex:index];
        [person addDatesObject:date];
    }
    
    for (int index = 0; index < [rhPerson.emails count] ; index++) {
        ABEmail *email  = [ABEmail MR_createInContext:context];
        email.label     = [rhPerson.emails labelAtIndex:index];
        email.email     = [rhPerson.emails valueAtIndex:index];
        [person addEmailsObject:email];
    }
    
    for (int index = 0; index < [rhPerson.instantMessageServices count] ; index++) {
        ABInstantMessage *instantMessage    = [ABInstantMessage MR_createInContext:context];
        instantMessage.label                = [rhPerson.instantMessageServices labelAtIndex:index];
        instantMessage.service              = [[rhPerson.instantMessageServices valueAtIndex:index] objectForKey:@"service"];
        instantMessage.userName             = [[rhPerson.instantMessageServices valueAtIndex:index] objectForKey:@"username"];
        
        [person addInstantMessagesObject:instantMessage];
    }
    
    for (int index = 0; index < [rhPerson.relatedNames count] ; index++) {
        ABName *name    = [ABName MR_createInContext:context];
        name.label      = [rhPerson.relatedNames labelAtIndex:index];
        name.name       = [rhPerson.relatedNames valueAtIndex:index];
        [person addNamesObject:name];
    }

    for (int index = 0; index < [rhPerson.phoneNumbers count] ; index++) {
        ABPhone *phone  = [ABPhone MR_createInContext:context];
        phone.label     = [rhPerson.relatedNames labelAtIndex:index];
        phone.phone     = [rhPerson.relatedNames valueAtIndex:index];
        [person addPhonesObject:phone];
    }
    
    for (int index = 0; index < [rhPerson.socialProfiles count] ; index++) {
        ABSocial *social    = [ABSocial MR_createInContext:context];
        social.label        = [rhPerson.socialProfiles labelAtIndex:index];
        social.service      = [[rhPerson.socialProfiles valueAtIndex:index] objectForKey:@"service"];
        social.url          = [[rhPerson.socialProfiles valueAtIndex:index] objectForKey:@"url"];
        social.userName     = [[rhPerson.socialProfiles valueAtIndex:index] objectForKey:@"userName"];
        [person addSocialsObject:social];
    }
    
    for (int index = 0; index < [rhPerson.urls count] ; index++) {
        ABUrl *url  = [ABUrl MR_createInContext:context];
        url.label   = [rhPerson.urls labelAtIndex:index];
        url.url     = [rhPerson.urls valueAtIndex:index];
        [person addUrlsObject:url];
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
