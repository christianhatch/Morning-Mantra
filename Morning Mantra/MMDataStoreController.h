//
//  MMDataStoreController.h
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

@import Foundation;


@interface MMDataStoreController : NSObject

+ (NSArray *)allMantras;

+ (NSString *)randomMantraWithNameGreeting;

+ (void)addMantra:(NSString *)mantra;

+ (void)removeMantra:(NSString *)mantra;

@end


@interface MMDataStoreController (Notifications)

+ (void)scheduleLocalNotifications;

@end


@interface MMDataStoreController (UIAdditions)

+ (void)presentAddMantraUIWithCompletion:(void(^)(void))completion;

+ (void)presentAddNameUIWithCompletion:(void(^)(void))completion;

+ (BOOL)shouldPresentAddNameUI;

@end