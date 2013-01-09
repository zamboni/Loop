//
//  Server.m
//  Loop
//
//  Created by Fletcher Fowler on 1/6/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "Server.h"
#import "AFJSONRequestOperation.h"

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

- (void)registerUserWithEmail:(NSString *)email andPassword:(NSString *)password
{
    NSURLRequest *request = [self requestWithMethod:@"POST" path:@"/users" parameters:@{@"user" : @{@"email" : email, @"password" : password }}];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"success");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure");
    }];
    [operation start];
    
}
@end
