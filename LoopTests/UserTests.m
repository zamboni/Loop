#import "Kiwi.h"
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "User.h"

SPEC_BEGIN(UserTests)

describe(@"User", ^{
    beforeAll(^{
        NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:@"zamb.LoopTests"];
        [RKTestFixture setFixtureBundle:testTargetBundle];
    });
    
    it(@"maps _id to rid", ^{
        id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"user.json"];
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
        [userMapping addAttributeMappingsFromDictionary:@{@"user.id" : @"rid"}];

        
        RKMappingTest *test = [RKMappingTest testForMapping:userMapping sourceObject:parsedJSON destinationObject:nil];
        RKPropertyMappingTestExpectation *expectation = [RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"user._id" destinationKeyPath:@"rid"];
        [test addExpectation:expectation];
        [[theBlock(^{
            [test evaluate];
        }) shouldNot] raise];
    });
    
    it(@"creates a user", ^{
        NSString *string = @"yada";
        [string shouldNotBeNil];
    });
});

SPEC_END