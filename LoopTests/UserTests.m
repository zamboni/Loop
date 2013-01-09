#import "Kiwi.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "User+Implementation.h"
#import <CoreData.h>
#import <CoreData+MagicalRecord.h>

SPEC_BEGIN(UserTests)

describe(@"User", ^{
    beforeAll(^{
        NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:@"zamb.LoopTests"];
        [RKTestFixture setFixtureBundle:testTargetBundle];
    });
    
    beforeEach(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
        [RKTestFactory setUp];
    });
    
    afterEach(^{
        [MagicalRecord cleanUp];
        [RKTestFactory tearDown];
    });
    
    it(@"creates a new user", ^{
        RKObjectManager *objectManager = [RKTestFactory objectManager];
        [[objectManager shouldNot] beNil];
//        NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Loop" ofType:@"momd"]];
//        NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
//        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
//        objectManager.managedObjectStore = managedObjectStore;
        
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
        objectManager.managedObjectStore = managedObjectStore;
        
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
        [userMapping addAttributeMappingsFromDictionary:@{
         @"_id" : @"rid"
         }];
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"/users" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:responseDescriptor];
        
        [managedObjectStore createPersistentStoreCoordinator];
        NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Loop.sqlite"];
        NSError *error;
        NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
        NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
        
        // Create the managed object contexts
        [managedObjectStore createManagedObjectContexts];
        
        // Configure a managed object cache to ensure we do not create duplicate objects
        managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];

        
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[User class] pathPattern:@"/users" method:RKRequestMethodPOST]];
        
        
        [objectManager getObjectsAtPath:@"/users" parameters:@{@"user" : @{@"email" : @"test@example.com", @"password" : @"password" } } success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"success");
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
        
        RKObjectRequestOperation *operation = [[objectManager.operationQueue operations] objectAtIndex:0];
        [operation waitUntilFinished];
        [[theValue([operation.mappingResult count]) should] equal:theValue(1)];
        
//        [[theValue([[User MR_findAllInContext:[NSManagedObjectContext MR_contextForCurrentThread]] count]) should] beGreaterThan:theValue(0)];
        
    });
    
    it(@"maps _id to rid", ^{
        RKManagedObjectStore *managedObjectStore = [RKTestFactory managedObjectStore];
        RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
        [entityMapping addAttributeMappingsFromDictionary:@{
             @"user._id":		@"rid",
         }];
        id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"user.json"];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:entityMapping sourceObject:parsedJSON destinationObject:nil];
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"user._id" destinationKeyPath:@"rid" value:@"50e65e35fe68115180000001"]];
        
        // Configure Core Data
        mappingTest.managedObjectContext = managedObjectStore.persistentStoreManagedObjectContext;
                
        // Let the test perform the mapping
        [mappingTest performMapping];
        
        [[theValue([mappingTest evaluate]) should] beTrue];
    });
});

SPEC_END