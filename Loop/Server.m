//
//  Server.m
//  Loop
//
//  Created by Fletcher Fowler on 1/6/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "Server.h"

static NSString * const kServerBaseURLString = @"http://localhost:3000/";

@implementation Server

+ (Server *)sharedClient
{
    static Server *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Server alloc] initWithBaseURL:[NSURL URLWithString:kServerBaseURLString]];
    });
    
    return _sharedClient;
}
@end
