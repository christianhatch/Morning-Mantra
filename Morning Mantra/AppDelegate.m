//
//  AppDelegate.m
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "AppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "MMDataStoreController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [self scheduleLocalNotifications];
    
    self.window.tintColor = [UIColor purpleColor];

    [Crashlytics startWithAPIKey:@"36aebc5d6093c8a7cc64fae3d769bf41933d7919"];
    
    return YES;
}

- (void)scheduleLocalNotifications
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:kMMDataStoreControllerUserGreetingNameKey];
    NSString *mantra = [MMDataStoreController randomNonRepeatingMantra];
    
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    [components setDay: 3];
//    [components setMonth: 7];
//    [components setYear: 2012];
//    [components setHour:8];
//    [components setMinute:0];
//    [components setSecond:0];
//    [calendar setTimeZone:[NSTimeZone defaultTimeZone]];
//    NSDate *dateToFire = [calendar dateFromComponents:components];

    
    
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    localNote.repeatInterval = NSCalendarUnitDay;
    localNote.timeZone = [NSTimeZone defaultTimeZone];
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:120];
    
    localNote.alertBody = [NSString stringWithFormat:@"Hey %@, %@", userName, mantra];
    localNote.alertAction = mantra;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
