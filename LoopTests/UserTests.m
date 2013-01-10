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
        RKManagedObjectStore *managedObjectStore = [RKTestFactory managedObjectStore];
        [managedObjectStore createManagedObjectContexts];

        RKObjectManager *objectManager = [RKTestFactory objectManager];
        objectManager.managedObjectStore = managedObjectStore;

        RKEntityMapping *userMapping = [User objectMappingInManagedObjectStore:managedObjectStore];
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:responseDescriptor];

        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"/users" statusCodes:[NSIndexSet indexSetWithIndex:200]];

        [objectManager postObject:[User class] path:@"/users" parameters:@{@"user" : @{@"email" : @"test@example.com", @"password" : @"password"}} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog([[User MR_findFirst] rid]);
            NSLog(@"success");
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
        
        [[theValue([[User MR_findAll] count]) should] beGreaterThan:theValue(0)];
        
    });
    
//    it(@"maps _id to rid", ^{
//        RKManagedObjectStore *managedObjectStore = [RKTestFactory managedObjectStore];
//        RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
//        [entityMapping addAttributeMappingsFromDictionary:@{
//             @"user._id":		@"rid",
//         }];
//        id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"user.json"];
//        RKMappingTest *mappingTest = [RKMappingTest testForMapping:entityMapping sourceObject:parsedJSON destinationObject:nil];
//        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"user._id" destinationKeyPath:@"rid" value:@"50e65e35fe68115180000001"]];
//        
//        // Configure Core Data
//        mappingTest.managedObjectContext = managedObjectStore.persistentStoreManagedObjectContext;
//                
//        // Let the test perform the mapping
//        [mappingTest performMapping];
//        
//        [[theValue([mappingTest evaluate]) should] beTrue];
//    });
});

SPEC_END