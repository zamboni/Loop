//
//  Server.h
//  Loop
//
//  Created by Fletcher Fowler on 1/6/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//
#import "AFHTTPClient.h"

@interface Server : AFHTTPClient

+ (Server *)sharedClient;

- (void)registerUserWithEmail:(NSString *)email andPassword:(NSString *)password;

@end
