//
//  MMConstants.h
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kMMCrashlyticsID;

extern NSString *const kMMParseAppID;
extern NSString *const kMMParseClientKey;



#pragma mark - Macros

#ifdef DEBUG
#define DebugLog( s, ... ) NSLog(@"%@:(%d) %@", [NSString stringWithUTF8String:__PRETTY_FUNCTION__], __LINE__, [NSString stringWithFormat:(s), __VA_ARGS__])
#else
#define DebugLog( s, ... )
#endif
