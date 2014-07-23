//
//  MMDataStoreController.h
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kMMDataStoreControllerUserGreetingNameKey;

@interface MMDataStoreController : NSObject


+ (NSArray *)allMantras;

+ (NSString *)randomNonRepeatingMantra;


+ (void)addMantra:(NSString *)mantra;

+ (void)removeMantra:(NSString *)mantra;

@end
