//
//  Server.h
//  Loop
//
//  Created by Fletcher Fowler on 1/6/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Pods/Pods.h>

@interface Server : AFHTTPClient

+ (Server *)sharedClient;

@end
