//
//  ABPhone.h
//  Loop
//
//  Created by Fletcher Fowler on 2/20/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABContact;

@interface ABPhone : NSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) ABContact *contact;

@end
