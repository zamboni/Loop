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
    
});

SPEC_END