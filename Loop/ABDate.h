//
//  ABDate.h
//  Loop
//
//  Created by Fletcher Fowler on 2/20/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ABContact;

@interface ABDate : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) ABContact *contact;

@end
