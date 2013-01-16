//
//  Event.h
//  Loop
//
//  Created by Fletcher Fowler on 1/15/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * rid;
@property (nonatomic, retain) NSDate * timeStamp;

@end
