//
//  MMDataStoreController.h
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

@import Foundation;


extern NSString *const kMMDataStoreControllerUserGreetingNameKey;

@interface MMDataStoreController : NSObject


+ (NSArray *)allMantras;

+ (NSString *)randomMantra;


+ (void)addMantra:(NSString *)mantra;

+ (void)removeMantra:(NSString *)mantra;


+ (void)scheduleLocalNotifications;


@end



@interface MMDataStoreController (UIAdditions)

+ (void)presentAddMantraUIWithCompletion:(void(^)(void))completion;

+ (void)presentAddNameUIWithCompletion:(void(^)(void))completion;

+ (BOOL)shouldPresentAddNameUI;

@end