//
//  ABEmail.h
//  Loop
//
//  Created by Fletcher Fowler on 2/10/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABContact;

@interface ABEmail : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) ABContact *person;

@end
