#import "Kiwi.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "User+Implementation.h"
#import <CoreData.h>
#import <CoreData+MagicalRecord.h>

SPEC_BEGIN(UserTests)

describe(@"User", ^{
    __block id objectManager = nil;
    
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
    
    it(@"creates a new user", ^{
        [[theValue([[User MR_findAll] count]) should] equal:theValue(0)];
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
        
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:persistentStoreCoordinator];
        [managedObjectStore createManagedObjectContexts];
        
        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost:4567/"]];
        objectManager.managedObjectStore = managedObjectStore;
        
        RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
        entityMapping.identificationAttributes = @[@"rid"];
        [entityMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid" }];
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:responseDescriptor];
        
//        [User registerUserWithEmail:@"test@example.com" andPassword:@"password"];
        
        [objectManager postObject:[User class] path:@"/users" parameters:@{@"user" : @{@"email" : @"test@example.com", @"password" : @"password"}} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"success");
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
      
//        [[[[objectManager operationQueue] operations] objectAtIndex:0] waitUntilFinished];

        NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:2];
        
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
            if([timeoutDate timeIntervalSinceNow] < 0.0)
                break;
        } while (TRUE);
        
        [[[[User MR_findFirst] rid] should] equal:@"1234"];
        [[theValue([[User MR_findAll] count]) should] beGreaterThan:theValue(0)];
        
    });
    
//    it(@"throws a error if user already exists", ^{
//        [[theValue([[User MR_findAll] count]) should] equal:theValue(0)];
//        
//        
//        NSPersistentStoreCoordinator *persistentStoreCoordinator = [NSPersistentStoreCoordinator MR_defaultStoreCoordinator];
//        
//        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:persistentStoreCoordinator];
//        [managedObjectStore createManagedObjectContexts];
//        
//        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost:4567/"]];
//        objectManager.managedObjectStore = managedObjectStore;
//        
//        RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
//        entityMapping.identificationAttributes = @[@"rid"];
//        [entityMapping addAttributeMappingsFromDictionary:@{ @"_id" : @"rid" }];
//        
//        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//        [objectManager addResponseDescriptor:responseDescriptor];
//        
//        
//        [objectManager postObject:[User class] path:@"/users" parameters:@{@"user" : @{@"email" : @"test@example.com", @"password" : @"password"}} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//            NSLog(@"success");
//        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//            NSLog(@"failure");
//        }];
//        
//        //        [[[[objectManager operationQueue] operations] objectAtIndex:0] waitUntilFinished];
//        
//        NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:1];
//        
//        do {
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
//            if([timeoutDate timeIntervalSinceNow] < 0.0)
//                break;
//        } while (TRUE);
//        
//        [[[[User MR_findFirst] rid] should] equal:@"1234"];
//        [[theValue([[User MR_findAll] count]) should] beGreaterThan:theValue(0)];
//        
//    });
    
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