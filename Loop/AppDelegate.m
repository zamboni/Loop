//
//  AppDelegate.m
//  Loop
//
//  Created by Fletcher Fowler on 12/31/12.
//  Copyright (c) 2012 ZamboniDev. All rights reserved.
//

#import "AppDelegate.h"

#import <RestKit/RestKit.h>
#import "SSKeychain.h"

#import "MasterViewController.h"
#import "LoginController.h"
#import "ProfileController.h"

#import "User+Implementation.h"
#import "Event+Implementation.h"
#import "Checkin+Implementation.h"
#import "ABContact+Implementation.h"

#import "ABAddress.h"
#import "ABDate.h"
#import "ABEmail.h"
#import "ABInstantMessage.h"
#import "ABName.h"
#import "ABPhone.h"
#import "ABSocial.h"
#import "ABUrl.h"


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Loop.sqlite"];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:persistentStoreCoordinator];
    [managedObjectStore createManagedObjectContexts];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost:3000/api/v1.0/"]];
    objectManager.managedObjectStore = managedObjectStore;

    // Venue
    RKEntityMapping *venueMapping = [RKEntityMapping mappingForEntityForName:@"Venue" inManagedObjectStore:managedObjectStore];
    venueMapping.identificationAttributes = @[@"rid"];
    [venueMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"distance", @"latitude", @"longitude", @"name", @"state" ]];
    [venueMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid" , @"country_code" : @"countryCode", @"state_code" : @"stateCode", @"zip_code" : @"zipCode" }];

    // Event
    RKEntityMapping *eventMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:managedObjectStore];
    eventMapping.identificationAttributes = @[@"rid"];
    [eventMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid", @"title" : @"title"}];
    [eventMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"venue" toKeyPath:@"venue" withMapping:venueMapping]];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:eventMapping pathPattern:nil keyPath:@"events" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:eventMapping pathPattern:nil keyPath:@"events" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    // User
    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    userMapping.identificationAttributes = @[@"rid"];
    [userMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid", @"email" : @"email", @"first_name" : @"firstName", @"last_name" : @"lastName" }];
    [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"shared_events" toKeyPath:@"shared_events" withMapping:eventMapping]];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"users" keyPath:@"user" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"user" keyPath:@"user" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"session" keyPath:@"user" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)] ];
    
    // Checkin
    RKEntityMapping *checkinMapping = [RKEntityMapping mappingForEntityForName:@"Checkin" inManagedObjectStore:managedObjectStore];
    checkinMapping.identificationAttributes = @[@"rid"];
    [checkinMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid" }];
    [checkinMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"event" toKeyPath:@"event" withMapping:eventMapping]];
    [checkinMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:userMapping]];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:checkinMapping pathPattern:nil keyPath:@"checkin" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:checkinMapping pathPattern:nil keyPath:@"checkins" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];


    // ABAddress
    RKEntityMapping *abAddressMapping = [RKEntityMapping mappingForEntityForName:@"ABAddress" inManagedObjectStore:managedObjectStore];
    [abAddressMapping addAttributeMappingsFromArray:@[@"city", @"country", @"label", @"state", @"street", @"zip"]];
    [abAddressMapping addAttributeMappingsFromDictionary:@{@"countryCode": @"country_code"}];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abAddressMapping pathPattern:nil keyPath:@"address" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // ABDate
    RKEntityMapping *abDateMapping = [RKEntityMapping mappingForEntityForName:@"ABDate" inManagedObjectStore:managedObjectStore];
    [abDateMapping addAttributeMappingsFromArray:@[@"date", @"label"]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abDateMapping pathPattern:nil keyPath:@"date" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // ABEmail
    RKEntityMapping *abEmailMapping = [RKEntityMapping mappingForEntityForName:@"ABEmail" inManagedObjectStore:managedObjectStore];
    [abEmailMapping addAttributeMappingsFromArray:@[@"email", @"label"]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abEmailMapping pathPattern:nil keyPath:@"email" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // ABInstantMessage
    RKEntityMapping *abInstantMessageMapping = [RKEntityMapping mappingForEntityForName:@"ABInstantMessage" inManagedObjectStore:managedObjectStore];
    [abInstantMessageMapping addAttributeMappingsFromArray:@[@"label", @"service"]];
    [abInstantMessageMapping addAttributeMappingsFromDictionary:@{@"user_name" : @"userName"}];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abInstantMessageMapping pathPattern:nil keyPath:@"instant_message" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // ABName
    RKEntityMapping *abNameMapping = [RKEntityMapping mappingForEntityForName:@"ABName" inManagedObjectStore:managedObjectStore];
    [abNameMapping addAttributeMappingsFromArray:@[@"label", @"name"]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abNameMapping pathPattern:nil keyPath:@"name" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    // ABPhone
    RKEntityMapping *abPhoneMapping = [RKEntityMapping mappingForEntityForName:@"ABPhone" inManagedObjectStore:managedObjectStore];
    [abPhoneMapping addAttributeMappingsFromArray:@[@"label", @"phone"]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abPhoneMapping pathPattern:nil keyPath:@"phone" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    // ABSocial
    RKEntityMapping *abSocialMapping = [RKEntityMapping mappingForEntityForName:@"ABSocial" inManagedObjectStore:managedObjectStore];
    [abSocialMapping addAttributeMappingsFromArray:@[@"label", @"service", @"url"]];
    [abSocialMapping addAttributeMappingsFromDictionary:@{@"user_name": @"userName"}];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abSocialMapping pathPattern:nil keyPath:@"social" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    // ABUrl
    RKEntityMapping *abUrlMapping = [RKEntityMapping mappingForEntityForName:@"ABUrl" inManagedObjectStore:managedObjectStore];
    [abUrlMapping addAttributeMappingsFromArray:@[@"label", @"url"]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abUrlMapping pathPattern:nil keyPath:@"url" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    
    // ABContact
    RKEntityMapping *abContactMapping = [RKEntityMapping mappingForEntityForName:@"ABContact" inManagedObjectStore:managedObjectStore];
    [abContactMapping addAttributeMappingsFromDictionary:@{@"first_name" : @"firstName", @"last_name" : @"lastName"}];
    [abContactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:userMapping]];
    [abContactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"addresses" toKeyPath:@"addresses" withMapping:abAddressMapping]];
    [abContactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dates" toKeyPath:@"dates" withMapping:abDateMapping]];
    [abContactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"emails" toKeyPath:@"emails" withMapping:abEmailMapping]];
    [abContactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"instant_messages" toKeyPath:@"instantMessages" withMapping:abInstantMessageMapping]];
    [abContactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"names" toKeyPath:@"names" withMapping:abNameMapping]];
    [abContactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"phones" toKeyPath:@"phones" withMapping:abPhoneMapping]];
    [abContactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"socials" toKeyPath:@"socials" withMapping:abSocialMapping]];
    [abContactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"urls" toKeyPath:@"urls" withMapping:abUrlMapping]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abContactMapping pathPattern:nil keyPath:@"contact" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // Request
    // ABAddress Request
    RKObjectMapping *abAddressRequestMapping = [RKObjectMapping requestMapping];
    [abAddressRequestMapping addAttributeMappingsFromArray:@[@"city", @"country", @"label", @"state", @"street", @"zip"]];
    [abAddressRequestMapping addAttributeMappingsFromDictionary:@{@"countryCode": @"country_code"}];
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abAddressRequestMapping objectClass:[ABAddress class] rootKeyPath:@"addresses"]];

    // ABDate Request
    RKObjectMapping *abDateRequestMapping = [RKObjectMapping requestMapping];
    [abDateRequestMapping addAttributeMappingsFromArray:@[@"date", @"label"]];
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abDateRequestMapping objectClass:[ABDate class] rootKeyPath:@"dates"]];

    // ABEmail Request
    RKObjectMapping *abEmailRequestMapping = [RKObjectMapping requestMapping];
    [abEmailRequestMapping addAttributeMappingsFromArray:@[@"email", @"label"]];
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abEmailRequestMapping objectClass:[ABEmail class] rootKeyPath:@"emails"]];

    // ABInstantMessage Request
    RKObjectMapping *abInstantMessageRequestMapping = [RKObjectMapping requestMapping];
    [abInstantMessageRequestMapping addAttributeMappingsFromArray:@[@"label", @"service"]];
    [abInstantMessageRequestMapping addAttributeMappingsFromDictionary:@{@"userName": @"user_name"}];
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abInstantMessageRequestMapping objectClass:[ABInstantMessage class] rootKeyPath:@"instantMessages"]];

    // ABName Request
    RKObjectMapping *abNameRequestMapping = [RKObjectMapping requestMapping];
    [abNameRequestMapping addAttributeMappingsFromArray:@[@"label", @"name"]];
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abNameRequestMapping objectClass:[ABName class] rootKeyPath:@"names"]];

    // ABPhone Request
    RKObjectMapping *abPhoneRequestMapping = [RKObjectMapping requestMapping];
    [abPhoneRequestMapping addAttributeMappingsFromArray:@[@"label", @"phone"]];
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abPhoneRequestMapping objectClass:[ABPhone class] rootKeyPath:@"phones"]];

    // ABSocial Request
    RKObjectMapping *abSocialRequestMapping = [RKObjectMapping requestMapping];
    [abSocialRequestMapping addAttributeMappingsFromArray:@[@"label", @"service", @"url"]];
    [abSocialRequestMapping addAttributeMappingsFromDictionary:@{@"userName": @"user_name"}];
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abSocialRequestMapping objectClass:[ABSocial class] rootKeyPath:@"socials"]];

    // ABUrl Request
    RKObjectMapping *abUrlRequestMapping = [RKObjectMapping requestMapping];
    [abUrlRequestMapping addAttributeMappingsFromArray:@[@"label", @"url"]];
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abUrlRequestMapping objectClass:[ABUrl class] rootKeyPath:@"urls"]];
    
    // ABContact Request
    RKObjectMapping *abContactRequestMapping = [RKObjectMapping requestMapping];
    [abContactRequestMapping addAttributeMappingsFromDictionary:@{@"firstName" : @"first_name", @"lastName" : @"last_name"}];
    [abContactRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"addresses"          toKeyPath:@"addresses" withMapping:abAddressRequestMapping]];
    [abContactRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"dates"              toKeyPath:@"dates" withMapping:abDateRequestMapping]];
    [abContactRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"emails"             toKeyPath:@"emails" withMapping:abEmailRequestMapping]];
    [abContactRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"instantMessages"    toKeyPath:@"instant_messages" withMapping:abInstantMessageRequestMapping]];
    [abContactRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"names"              toKeyPath:@"names" withMapping:abNameRequestMapping]];
    [abContactRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"phones"             toKeyPath:@"phones" withMapping:abPhoneRequestMapping]];
    [abContactRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"socials"            toKeyPath:@"socials" withMapping:abSocialRequestMapping]];
    [abContactRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"urls"               toKeyPath:@"urls" withMapping:abUrlRequestMapping]];

    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abContactRequestMapping objectClass:[ABContact class] rootKeyPath:@"contact"]];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *viewController;
    if ( [User getAccessToken] != nil ) {
        viewController = (ProfileController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"UserTabBarController"];
    }
    else{
        viewController = (LoginController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    }
    self.window.rootViewController = viewController;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Loop" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Loop.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
