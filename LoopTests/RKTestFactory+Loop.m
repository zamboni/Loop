//
//  RKTestFactory+Loop.m
//  Loop
//
//  Created by Fletcher Fowler on 1/7/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "RKTestFactory+Loop.h"
#import <RestKit/RestKit.h>


static NSString * const kServerBaseURLString = @"http://localhost:3000/";

@implementation RKTestFactory (Loop)

+ (void)load
{
    [self setSetupBlock:^{
        [self setBaseURL:[NSURL URLWithString:kServerBaseURLString]];
    }];
}
@end
