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

- (NSString *)fullName{
    NSString *fullName = self.firstName;
    if (self.middleName)
        fullName = [fullName stringByAppendingString:[NSString stringWithFormat:@" %@", self.middleName]];
    if (self.lastName)
        fullName = [fullName stringByAppendingString:[NSString stringWithFormat:@" %@", self.lastName]];
    return fullName;
}

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
    person.thumbnail            = rhPerson.thumbnail;

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
        phone.label     = [rhPerson.phoneNumbers labelAtIndex:index];
        phone.phone     = [rhPerson.phoneNumbers valueAtIndex:index];
        [person addPhonesObject:phone];
    }
    
    for (int index = 0; index < [rhPerson.socialProfiles count] ; index++) {
        ABSocial *social    = [ABSocial MR_createInContext:context];
        social.label        = [rhPerson.socialProfiles labelAtIndex:index];
        social.service      = [[rhPerson.socialProfiles valueAtIndex:index] objectForKey:@"service"];
        social.url          = [[rhPerson.socialProfiles valueAtIndex:index] objectForKey:@"url"];
        social.userName     = [[rhPerson.socialProfiles valueAtIndex:index] objectForKey:@"username"];
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
    person.firstName            = self.firstName;
    person.lastName             = self.lastName;
    person.middleName           = self.middleName;
    person.nickname             = self.nickname;
    person.firstNamePhonetic    = self.firstNamePhonetic;
    person.lastNamePhonetic     = self.lastNamePhonetic;
    person.middleNamePhonetic   = self.middleNamePhonetic;
    person.organization         = self.organization;
    person.jobTitle             = self.jobTitle;
    person.department           = self.department;
    person.birthday             = self.birthday;
    person.note                 = self.note;
    
    RHMutableMultiDictionaryValue *mutableAddressMultiValue = [[RHMutableMultiDictionaryValue alloc] initWithType:kABMultiDictionaryPropertyType];
    
    for (ABAddress *address in self.addresses){
        NSDictionary *addressDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
            address.street, RHPersonAddressStreetKey,
            address.city, RHPersonAddressCityKey,
            address.state, RHPersonAddressStateKey,
            address.zip, RHPersonAddressZIPKey,
            address.country, RHPersonAddressCountryKey,
            address.countryCode, RHPersonAddressCountryCodeKey,
            nil];
        
        [mutableAddressMultiValue addValue:addressDictionary withLabel:address.label];
    }
    person.addresses = mutableAddressMultiValue;
    
    RHMutableMultiDateTimeValue *mutableDateMultiValue = [[RHMutableMultiDateTimeValue alloc] initWithType:kABMultiDateTimePropertyType];
    for (ABDate *date in self.dates){
        [mutableDateMultiValue addValue:date.date withLabel:date.label];
    }
    person.dates = mutableDateMultiValue;
    
    RHMutableMultiStringValue *mutableEmailMultiValue = [[RHMutableMultiStringValue alloc] initWithType:kABMultiStringPropertyType];
    
    for(ABEmail *email in self.emails){
        [mutableEmailMultiValue addValue:email.email withLabel:email.label];
    }
    person.emails = mutableEmailMultiValue;

    RHMutableMultiDictionaryValue *mutableInstantMessageMultiValue = [[RHMutableMultiDictionaryValue alloc] initWithType:kABMultiDictionaryPropertyType];
    for (ABInstantMessage *instantMessage in self.instantMessages){
        NSDictionary *instantMessageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
            instantMessage.service, RHPersonInstantMessageServiceKey,
            instantMessage.userName, RHPersonInstantMessageUsernameKey,
            nil];
        [mutableInstantMessageMultiValue addValue:instantMessageDictionary withLabel:instantMessage.label];
    }
    person.instantMessageServices = mutableInstantMessageMultiValue;

    RHMutableMultiStringValue *mutableNameMultiValue = [[RHMutableMultiStringValue alloc] initWithType:kABMultiStringPropertyType];
    for (ABName *name in self.names){
        [mutableNameMultiValue addValue:name.name withLabel:name.label];
    }
    person.relatedNames = mutableNameMultiValue;
    
    RHMutableMultiStringValue *mutablePhoneMultiValue = [[RHMutableMultiStringValue alloc] initWithType:kABMultiStringPropertyType];
    for (ABPhone *phone in self.phones){
        [mutablePhoneMultiValue addValue:phone.phone withLabel:phone.label];
    }
    person.phoneNumbers = mutablePhoneMultiValue;
    
    RHMutableMultiDictionaryValue *mutableSocialMultiValue = [[RHMutableMultiDictionaryValue alloc] initWithType:kABMultiDictionaryPropertyType];
    for (ABSocial *social in self.socials){
        NSDictionary *socialDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          social.service, RHPersonSocialProfileServiceKey,
                                          social.userName, RHPersonSocialProfileUsernameKey,
                                          social.url, RHPersonSocialProfileURLKey,
                                          nil];
        [mutableSocialMultiValue addValue:socialDictionary withLabel:social.label];
    }
    person.socialProfiles = mutableSocialMultiValue;
    
    RHMutableMultiStringValue *mutableUrlMultiValue = [[RHMutableMultiStringValue alloc] initWithType:kABMultiStringPropertyType];
    for (ABUrl *url in self.urls){
        [mutableUrlMultiValue addValue:url.url withLabel:url.label];
    }
    person.urls = mutableUrlMultiValue;
    
    [person save];
    return person;
}

@end
