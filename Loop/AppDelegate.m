//
//  AppDelegate.m
//  Loop
//
//  Created by Fletcher Fowler on 12/31/12.
//  Copyright (c) 2012 ZamboniDev. All rights reserved.
//

#import "AppDelegate.h"

#import <RestKit/RestKit.h>
#import "ACSimpleKeychain.h"

#import "MasterViewController.h"
#import "LoginController.h"
#import "ProfileController.h"

#import "User+Implementation.h"
#import "Event+Implementation.h"
#import "Checkin+Implementation.h"
#import "ABContact+Implementation.h"
#import "ABEmail+Implementation.h"

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

    // User
    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    userMapping.identificationAttributes = @[@"rid"];
    [userMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid", @"email" : @"email", @"first_name" : @"firstName", @"last_name" : @"lastName" }];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"users" keyPath:@"user" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"user" keyPath:@"user" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"session" keyPath:@"user" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)] ];
    
    // Venue
    RKEntityMapping *venueMapping = [RKEntityMapping mappingForEntityForName:@"Venue" inManagedObjectStore:managedObjectStore];
    venueMapping.identificationAttributes = @[@"rid"];
    [venueMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"latitude", @"longitude", @"name", @"state" ]];
    [venueMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid" , @"country_code" : @"countryCode", @"state_code" : @"stateCode", @"zip_code" : @"zipCode" }];

    // Event
    RKEntityMapping *eventMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:managedObjectStore];
    eventMapping.identificationAttributes = @[@"rid"];
    [eventMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid", @"title" : @"title"}];
    [eventMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"venue" toKeyPath:@"venue" withMapping:venueMapping]];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:eventMapping pathPattern:nil keyPath:@"events" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:eventMapping pathPattern:nil keyPath:@"events" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // Checkin
    RKEntityMapping *checkinMapping = [RKEntityMapping mappingForEntityForName:@"Checkin" inManagedObjectStore:managedObjectStore];
    checkinMapping.identificationAttributes = @[@"rid"];
    [checkinMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid" }];
    [checkinMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"event" toKeyPath:@"event" withMapping:eventMapping]];
    [checkinMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:userMapping]];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:checkinMapping pathPattern:nil keyPath:@"checkin" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:checkinMapping pathPattern:nil keyPath:@"checkins" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // ABEmail
    RKEntityMapping *abEmailMapping = [RKEntityMapping mappingForEntityForName:@"ABEmail" inManagedObjectStore:managedObjectStore];
    [abEmailMapping addAttributeMappingsFromArray:@[@"email", @"title"]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abEmailMapping pathPattern:nil keyPath:@"email" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    // ABContact
    RKEntityMapping *abContactMapping = [RKEntityMapping mappingForEntityForName:@"ABContact" inManagedObjectStore:managedObjectStore];
    [abContactMapping addAttributeMappingsFromArray:@[@"firstName", @"lastName"]];
    [abContactMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"emails" toKeyPath:@"emails" withMapping:abEmailMapping]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:abContactMapping pathPattern:nil keyPath:@"contact" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    // Request
    // ABEmail Request
    RKObjectMapping *abEmailRequestMapping = [RKObjectMapping requestMapping];
    [abEmailRequestMapping addAttributeMappingsFromArray:@[@"email", @"label"]];
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abEmailRequestMapping objectClass:[ABEmail class] rootKeyPath:@"emails"]];
    
    
    // ABContact Request
    RKObjectMapping *abContactRequestMapping = [RKObjectMapping requestMapping];
    [abContactRequestMapping addAttributeMappingsFromDictionary:@{@"firstName" : @"first_name", @"lastName" : @"last_name"}];
    [abContactRequestMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"emails" toKeyPath:@"emails" withMapping:abEmailRequestMapping]];
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:abContactRequestMapping objectClass:[ABContact class] rootKeyPath:@"contact"]];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *viewController;
    NSString *accessToken = [[[ACSimpleKeychain defaultKeychain] credentialsForIdentifier:@"accessToken" service:@"loop"] valueForKey:ACKeychainPassword];
    User *currentUser = [User MR_findFirst];
    if ( accessToken && currentUser ) {
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
