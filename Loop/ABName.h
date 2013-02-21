//
//  ABName.h
//  Loop
//
//  Created by Fletcher Fowler on 2/20/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABContact;

@interface ABName : NSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ABContact *contact;

@end
