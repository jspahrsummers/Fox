#import <Cedar.h>
#import "Fox.h"
#import "FOXSpecHelper.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(FOXDoubleSpec)

describe(@"FOXDouble", ^{
    it(@"should generate non-integers", ^{
        FOXRunnerResult *result = [FOXSpecHelper resultForAll:FOXDouble() then:^BOOL(NSNumber *value) {
            return fmod([value doubleValue], 1) == 0;
        }];
        result.succeeded should be_falsy;
    });

    it(@"should shrink towards zero", ^{
        FOXRunnerResult *result = [FOXSpecHelper resultForAll:FOXDouble() then:^BOOL(id value) {
            return NO;
        }];

        result.succeeded should be_falsy;
        result.smallestFailingValue should equal(@0);
    });

    it(@"should never shrink to a value further from zero", ^{
        NSArray *values = FOXSampleShrinkingWithCount(FOXDouble(), 100);
        NSNumber *originalValue = values[0];
        for (NSNumber *value in values) {
            ABS([value doubleValue]) should be_less_than_or_equal_to(ABS([originalValue doubleValue]));
        }
    });

    it(@"should shrink to smaller exponents if whole integers are not valid", ^{
        FOXRunnerResult *result = [FOXSpecHelper resultForAll:FOXDouble() then:^BOOL(NSNumber *value) {
            return fmod([value doubleValue], 1) == 0;
        }];
        result.succeeded should be_falsy;
        ABS([result.smallestFailingValue doubleValue]) should be_less_than_or_equal_to(0.00000001);
    });

    it(@"should shrink negative values to zero", ^{
        FOXRunnerResult *result = [FOXSpecHelper resultForAll:FOXDouble() then:^BOOL(NSNumber *value) {
            return [value doubleValue] >= 0;
        }];

        result.succeeded should be_falsy;
        result.smallestFailingValue should be_greater_than_or_equal_to(@(-0.00000001));
    });
});

SPEC_END
