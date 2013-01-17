#import "Kiwi.h"
//#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import <CoreData.h>
#import <CoreData+MagicalRecord.h>
#import "Event.h"

SPEC_BEGIN(EventTests)

describe(@"Event", ^{

    beforeAll(^{
        NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:@"zamb.LoopTests"];
        [RKTestFixture setFixtureBundle:testTargetBundle];
    });
    
    beforeEach(^{
        [RKTestFactory setUp];
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
        [RKTestFactory tearDown];
    });
    
    
    it(@"creates a new event", ^{
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
        
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:persistentStoreCoordinator];
        [managedObjectStore createManagedObjectContexts];
        
        RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:managedObjectStore];
        entityMapping.identificationAttributes = @[@"rid"];
        [entityMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid"}];
        
        NSDictionary *articleRepresentation = [RKTestFixture parsedObjectWithContentsOfFixture:@"event.json"];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:entityMapping sourceObject:articleRepresentation destinationObject:nil];
        
        // Configure Core Data
        mappingTest.managedObjectContext = managedObjectStore.persistentStoreManagedObjectContext;
        
        // Create an object to match our criteria
        Event *event = [Event MR_createInContext:managedObjectStore.persistentStoreManagedObjectContext];
        [event setValue:@"50f62753fe68113c8d000012" forKey:@"rid"];
        
        // Let the test perform the mapping
        [mappingTest performMapping];
        [[event should] equal:mappingTest.destinationObject];
    });

//    it(@"creates a new events", ^{
//        NSPersistentStoreCoordinator *persistentStoreCoordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
//        
//        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:persistentStoreCoordinator];
//        [managedObjectStore createManagedObjectContexts];
//        
//        RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:managedObjectStore];
//        entityMapping.identificationAttributes = @[@"rid"];
//        [entityMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid"}];
//        
//        NSDictionary *eventsRepresentation = [RKTestFixture parsedObjectWithContentsOfFixture:@"events.json"];
//        RKMappingTest *mappingTest = [RKMappingTest testForMapping:entityMapping sourceObject:eventsRepresentation destinationObject:nil];
//        mappingTest.rootKeyPath = @"events";
//        // Configure Core Data
//        mappingTest.managedObjectContext = managedObjectStore.persistentStoreManagedObjectContext;
//        
//        // Create an object to match our criteria
//        Event *event = [Event MR_createInContext:managedObjectStore.persistentStoreManagedObjectContext];
//        [event setValue:@"50f62753fe68113c8d000012" forKey:@"rid"];
//        
//        // Let the test perform the mapping
//        [mappingTest performMapping];
//        [[event should] equal:mappingTest.destinationObject];
//    });

//    it(@"creates new events", ^{
//        NSPersistentStoreCoordinator *persistentStoreCoordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
//        
//        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:persistentStoreCoordinator];
//        [managedObjectStore createManagedObjectContexts];
//        
//        RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore:managedObjectStore];
//        entityMapping.identificationAttributes = @[@"rid"];
//        [entityMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid"}];
//        
//        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping pathPattern:@"/events" keyPath:@"events" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//        
//        NSURL *URL = [NSURL URLWithString:@"http://localhost:4567/events"];
//        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//        
//        RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
//        
//        [requestOperation start];
//        [requestOperation waitUntilFinished];
//        [[theValue([requestOperation.mappingResult count]) should] equal:theValue(1)];
//
//    });

});

SPEC_END