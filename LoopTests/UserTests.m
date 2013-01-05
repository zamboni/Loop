#import "Kiwi.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "User.h"
#import <CoreData.h>
#import <CoreData+MagicalRecord.h>

SPEC_BEGIN(UserTests)

describe(@"User", ^{
    beforeAll(^{
        NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:@"zamb.LoopTests"];
        [RKTestFixture setFixtureBundle:testTargetBundle];
    });
    
    it(@"creates a new user", ^{
        
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