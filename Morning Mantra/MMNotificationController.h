//
//  MMNotificationController.h
//  Morning Mantra
//
//  Created by Christian Hatch on 4/20/15.
//  Copyright (c) 2015 Knot Labs. All rights reserved.
//

@import Foundation;

@interface MMNotificationController : NSObject

+ (void)requestPermissionForNotifications;

+ (void)scheduleLocalNotificationWithText:(NSString *)text;

@end
