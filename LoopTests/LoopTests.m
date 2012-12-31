#import "Kiwi.h"

SPEC_BEGIN(SpecName)

describe(@"TestClass", ^{
    it(@"should have tests", ^{
        NSString *string = @"yada";
        [string shouldNotBeNil];
    });
});

SPEC_END