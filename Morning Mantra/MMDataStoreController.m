//
//  MMDataStoreController.m
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

@import UIKit;

#import "MMDataStoreController.h"
#import "NSURL+MMExtended.h"
#import "MMConstants.h"

#define kMMDataStoreControllerUsedMantrasURL   [NSURL libraryFileURLWithDirectory:@"mantras" filename:@"unusedMantras" extension:nil]
#define kMMDataStoreControllerUnUsedMantrasURL [NSURL libraryFileURLWithDirectory:@"mantras" filename:@"usedMantras" extension:nil]
#define kMMDataStoreControllerAllMantrasURL    [NSURL libraryFileURLWithDirectory:@"mantras" filename:@"allMantras" extension:nil]


NSString *const kMMDataStoreControllerUserGreetingNameKey = @"com.knotlabs.kMMDataStoreControllerUserGreetingNameKey"; 


@interface MMDataStoreController ()

//An array of all the Mantras, in the order the user entered them.
@property (nonatomic, strong) NSMutableArray *allMantras;

///An array of fresh, not previously displayed Mantras.
@property (nonatomic, strong) NSMutableArray *unUsedMantras;

///An array of old, used, already displayed Mantras.
@property (nonatomic, strong) NSMutableArray *usedMantras;

@end


@implementation MMDataStoreController

#pragma mark - Alloc & Init

+ (instancetype)sharedController
{
    static MMDataStoreController *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[MMDataStoreController alloc] init];
    });
    return _sharedManager;
}


#pragma mark - Public API


+ (NSArray *)allMantras
{
    NSArray *all = [MMDataStoreController sharedController].allMantras;
    
//    DebugLog(@"All Mantras: %@", all);

    return all;
}

+ (NSString *)randomMantra
{
    if ([MMDataStoreController sharedController].allMantras.count == 0 || [MMDataStoreController sharedController].unUsedMantras.count == 0)
    {
//        DebugLog(@"Arrays are empty. Returning nil for random. %@", @"");
        
        return nil;
    }
    
    NSInteger index = [[MMDataStoreController sharedController] randomIndex];
    NSString *mantra = [MMDataStoreController sharedController].unUsedMantras[index];
    
//    DebugLog(@"Random Mantra: %@", mantra);

    [[MMDataStoreController sharedController].unUsedMantras removeObjectAtIndex:index];
    [[MMDataStoreController sharedController].unUsedMantras addObject:mantra];
    
    [[MMDataStoreController sharedController] persistAllData];
    
    return mantra;
}

+ (NSString *)randomMantraWithNameGreeting
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:kMMDataStoreControllerUserGreetingNameKey];
    if (![[NSUserDefaults standardUserDefaults] stringForKey:kMMDataStoreControllerUserGreetingNameKey]) {
        userName = @"friend";
    }
    
    return [NSString stringWithFormat:@"Hi %@, %@", userName, [MMDataStoreController randomMantra]];
}


+ (void)addMantra:(NSString *)mantra
{
    if (mantra && mantra.length > 0)
    {
//        DebugLog(@"Adding Mantra: %@", mantra);

        [[MMDataStoreController sharedController].allMantras addObject:mantra];
        
        if (![[MMDataStoreController sharedController].unUsedMantras containsObject:mantra])
        {
            [[MMDataStoreController sharedController].unUsedMantras addObject:mantra];
        }
        
//        BOOL success =
        [[MMDataStoreController sharedController] persistAllData];
        
//        DebugLog(@"Added Mantra %@: Success=%i", mantra, success);
    }
}

+ (void)removeMantra:(NSString *)mantra
{
    if (mantra && mantra.length > 0)
    {
//        DebugLog(@"Removing Mantra: %@", mantra);

        [[MMDataStoreController sharedController].allMantras removeObject:mantra];
        
        if ([[MMDataStoreController sharedController].unUsedMantras containsObject:mantra])
        {
            [[MMDataStoreController sharedController].unUsedMantras removeObject:mantra];
        }
        
        if ([[MMDataStoreController sharedController].unUsedMantras containsObject:mantra])
        {
            [[MMDataStoreController sharedController].unUsedMantras removeObject:mantra];
        }
        
//        BOOL success =
        [[MMDataStoreController sharedController] persistAllData];
        
//        DebugLog(@"Removed Mantra %@: Success=%i", mantra, success);
    }
}

#pragma mark - Internal

- (NSInteger)randomIndex
{
    NSInteger rando = 0;
    
    if (self.unUsedMantras.count == 1) {
        rando = 0;
    }
    else if (self.unUsedMantras.count > 1) {
        int limit = (int)self.unUsedMantras.count;
        rando = arc4random_uniform(limit);
    }
    
//    DebugLog(@"Random Index: %li", rando);

    return rando;
}

- (void)reFillUnusedMantras
{
    DebugLog(@"Refilling Unused from Used: %@", self.unUsedMantras);

    [self.unUsedMantras addObjectsFromArray:self.unUsedMantras];
    
    [self.unUsedMantras removeAllObjects];
    
    [self persistAllData];
}

- (BOOL)persistAllData
{
    BOOL used = [self.unUsedMantras writeToURL:kMMDataStoreControllerUsedMantrasURL
                                  atomically:YES];
    
    BOOL unUsed = [self.unUsedMantras writeToURL:kMMDataStoreControllerUnUsedMantrasURL
                                      atomically:YES];
    
    BOOL all = [self.allMantras writeToURL:kMMDataStoreControllerAllMantrasURL
                                atomically:YES];
    
    BOOL aggregate = (used && unUsed && all);
    
//    DebugLog(@"Persisted Used Data: %i", used);
//    DebugLog(@"Persisted UnUsed Data: %i", unUsed);
//    DebugLog(@"Persisted All Data: %i", all);
//
//    DebugLog(@"Persisted Aggregate Data: %i", aggregate);

    return aggregate;
}


#pragma mark - Getters

- (NSMutableArray *)unUsedMantras
{
    if (!_unUsedMantras)
    {
        _unUsedMantras = [NSMutableArray arrayWithContentsOfURL:kMMDataStoreControllerUnUsedMantrasURL];
        
        if (_unUsedMantras.count == 0 || _unUsedMantras == nil)
        {
            _unUsedMantras = [[NSMutableArray alloc] initWithArray:[MMDataStoreController sharedController].allMantras copyItems:YES];
        }
    }
    return _unUsedMantras;
}

- (NSMutableArray *)usedMantras
{
    if (!_usedMantras)
    {
        _usedMantras = [NSMutableArray arrayWithContentsOfURL:kMMDataStoreControllerUsedMantrasURL];
        
        if (_usedMantras.count == 0 || _usedMantras == nil)
        {
            _usedMantras = [NSMutableArray arrayWithArray:@[]];
        }
    }
    return _usedMantras;
}

- (NSMutableArray *)allMantras
{
    if (!_allMantras)
    {
        _allMantras = [NSMutableArray arrayWithContentsOfURL:kMMDataStoreControllerAllMantrasURL];
        
        if (_allMantras.count == 0)
        {
            _allMantras = [[NSMutableArray alloc] initWithArray:@[@"Have a mantra.",
                                                                  @"Life is a marathon, not a sprint.",
                                                                  @"Everything is built in small steps.",
                                                                  @"Write stuff down.",
                                                                  @"A goal isn’t a goal unless you have to reach for it.",
                                                                  ]
                                                      copyItems:YES];
        }

    }
    return _allMantras;
}



@end




@implementation MMDataStoreController (Notifications)

+ (void)scheduleLocalNotifications
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
    //    localNote.fireDate = [[NSDate date] dateByAddingTimeInterval:5]; //this is just for testing!
    localNote.alertBody = [MMDataStoreController randomMantraWithNameGreeting];
    localNote.alertAction = @"view";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

@end





#import <UIAlertView-Blocks/UIAlertView+Blocks.h>
#import <UIAlertView-Blocks/RIButtonItem.h>


@implementation MMDataStoreController (UIAdditions)

+ (void)presentAddMantraUIWithCompletion:(void (^)(void))completion
{
    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"Cancel"
                                                action:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Mantra"
                                                    message:nil
                                           cancelButtonItem:cancel
                                           otherButtonItems:nil, nil];
    
    RIButtonItem *addMantra = [RIButtonItem itemWithLabel:@"Add Mantra"
                                                   action:^{
                                                       NSString *mantra = [alert textFieldAtIndex:0].text;
                                                       
                                                       DebugLog(@"new mantra to add %@", mantra);
                                                       
                                                       [MMDataStoreController addMantra:mantra];
                                                       if (completion) {
                                                           completion();
                                                       }
                                                   }];
    
    [alert addButtonItem:addMantra];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
}

+ (void)presentAddNameUIWithCompletion:(void (^)(void))completion
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What's your name?"
                                                    message:@"Enter your name below to personalize your Morning Mantra"
                                           cancelButtonItem:nil
                                           otherButtonItems:nil, nil];
    
    RIButtonItem *addName = [RIButtonItem itemWithLabel:@"Continue"
                                                 action:^{
                                                     NSString *name = [alert textFieldAtIndex:0].text;
                                                     
                                                     if (name && name.length > 0)
                                                     {
                                                         DebugLog(@"greeting was added %@", name);
                                                         
                                                         [[NSUserDefaults standardUserDefaults] setObject:name
                                                                                                   forKey:kMMDataStoreControllerUserGreetingNameKey];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                     }
                                                 }];
    
    [alert addButtonItem:addName];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
}

+ (BOOL)shouldPresentAddNameUI
{
    BOOL noGreetingNameSaved = [[NSUserDefaults standardUserDefaults] stringForKey:kMMDataStoreControllerUserGreetingNameKey] == nil;
    return noGreetingNameSaved;
}

@end




