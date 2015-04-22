//
//  MMNotificationController.m
//  Morning Mantra
//
//  Created by Christian Hatch on 4/20/15.
//  Copyright (c) 2015 Knot Labs. All rights reserved.
//

@import UIKit;

#import "MMNotificationController.h"

@implementation MMNotificationController

+ (void)requestPermissionForNotifications
{
    UIUserNotificationSettings *settings = [UIApplication sharedApplication].currentUserNotificationSettings;
    BOOL hasPermission = settings.types == UIUserNotificationTypeAlert;
   
    if (!hasPermission) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}


+ (void)scheduleLocalNotificationWithText:(NSString *)text
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:9];
    [components setMinute:0];
    [components setSecond:0];
    [calendar setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDate *dateToFire = [calendar dateFromComponents:components];
    
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    localNote.timeZone = [NSTimeZone defaultTimeZone];
    localNote.fireDate = dateToFire;
//    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:5]; //this is just for testing!
    localNote.alertBody = text;
    localNote.alertAction = @"view";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

@end
