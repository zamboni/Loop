//
//  User.h
//  Loop
//
//  Created by Fletcher Fowler on 1/15/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * contactId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * rid;

@end
