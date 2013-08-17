//
//  Constants.h
//  Loop
//
//  Created by Fletcher Fowler on 8/16/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#define Constants_h

#pragma mark - Instances
#ifdef DEVELOPMENT
#if TARGET_IPHONE_SIMULATOR
#define ROOT_URL @"http://localhost:3000/api/v1.0/"
#else
//#define ROOT_URL @"http://10.5.1.150:3000/api/v1.0/"
#define ROOT_URL @"http://192.168.1.100:3000/api/v1.0/"
#endif
#endif

#ifdef STAGING
#define ROOT_URL @"http://intheloopapp.herokuapp.com/api/v1.0/"
#endif
