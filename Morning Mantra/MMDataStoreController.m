//
//  MMDataStoreController.m
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "MMDataStoreController.h"
#import "NSURL+MMExtended.h"
#import "MMConstants.h"
#import <UIKit/UIKit.h>

#define kMMDataStoreControllerUsedMantrasURL   [NSURL libraryFileURLWithDirectory:@"mantras" filename:@"unusedMantras" extension:nil]
#define kMMDataStoreControllerUnUsedMantrasURL [NSURL libraryFileURLWithDirectory:@"mantras" filename:@"usedMantras" extension:nil]
#define kMMDataStoreControllerAllMantrasURL    [NSURL libraryFileURLWithDirectory:@"mantras" filename:@"allMantras" extension:nil]


NSString *const kMMDataStoreControllerUserGreetingNameKey = @"com.knotlabs.kMMDataStoreControllerUserGreetingNameKey"; 


@interface MMDataStoreController ()

//An array of all the Mantras, in the order the user entered them.
@property (nonatomic, strong) NSMutableArray *allMantras;

///An array of fresh, not previously displayed Mantras.
@property (nonatomic, strong) NSMutableArray *freshMantras;

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

+ (NSString *)randomNonRepeatingMantra
{
    if ([MMDataStoreController sharedController].allMantras.count == 0 || [MMDataStoreController sharedController].freshMantras.count == 0)
    {
//        DebugLog(@"Arrays are empty. Returning nil for random. %@", @"");
        
        return nil;
    }
    
    NSInteger index = [[MMDataStoreController sharedController] randomValidIndex];
    NSString *mantra = [MMDataStoreController sharedController].freshMantras[index];
    
//    DebugLog(@"Random Mantra: %@", mantra);

    [[MMDataStoreController sharedController].freshMantras removeObjectAtIndex:index];
    [[MMDataStoreController sharedController].freshMantras addObject:mantra];
    
    [[MMDataStoreController sharedController] persistAllData];
    
    return mantra;
}

+ (void)addMantra:(NSString *)mantra
{
    if (mantra && mantra.length > 0)
    {
//        DebugLog(@"Adding Mantra: %@", mantra);

        [[MMDataStoreController sharedController].allMantras addObject:mantra];
        
        if (![[MMDataStoreController sharedController].freshMantras containsObject:mantra])
        {
            [[MMDataStoreController sharedController].freshMantras addObject:mantra];
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
        
        if ([[MMDataStoreController sharedController].freshMantras containsObject:mantra])
        {
            [[MMDataStoreController sharedController].freshMantras removeObject:mantra];
        }
        
        if ([[MMDataStoreController sharedController].freshMantras containsObject:mantra])
        {
            [[MMDataStoreController sharedController].freshMantras removeObject:mantra];
        }
        
//        BOOL success =
        [[MMDataStoreController sharedController] persistAllData];
        
//        DebugLog(@"Removed Mantra %@: Success=%i", mantra, success);
    }
}

+ (void)scheduleLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:kMMDataStoreControllerUserGreetingNameKey];
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:kMMDataStoreControllerUserGreetingNameKey])
    {
        userName = @"friend";
    }
    
    NSString *mantra = [MMDataStoreController randomNonRepeatingMantra];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:8];
    [components setMinute:0];
    [components setSecond:0];
    [calendar setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDate *dateToFire = [calendar dateFromComponents:components];
    
    UILocalNotification *localNote = [[UILocalNotification alloc] init];

    localNote.repeatInterval = NSCalendarUnitDay;
    localNote.timeZone = [NSTimeZone defaultTimeZone];
    localNote.fireDate = dateToFire;
    
    localNote.alertBody = [NSString stringWithFormat:@"Hi %@, %@", userName, mantra];
    localNote.alertAction = mantra;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

#pragma mark - Internal

- (NSInteger)randomValidIndex
{
    NSInteger rando = 0;
    
    if (self.freshMantras.count == 1)
    {
        rando = 0;
    }
    else if (self.freshMantras.count > 1)
    {
        int limit = (int)self.freshMantras.count;
        rando = arc4random_uniform(limit);
    }
    
//    DebugLog(@"Random Index: %li", rando);

    return rando;
}

- (void)reFillUnusedMantras
{
    DebugLog(@"Refilling Unused from Used: %@", self.freshMantras);

    [self.freshMantras addObjectsFromArray:self.freshMantras];
    
    [self.freshMantras removeAllObjects];
    
    [self persistAllData];
}

- (BOOL)persistAllData
{
    BOOL used = [self.freshMantras writeToURL:kMMDataStoreControllerUsedMantrasURL
                                  atomically:YES];
    
    BOOL unUsed = [self.freshMantras writeToURL:kMMDataStoreControllerUnUsedMantrasURL
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

- (NSMutableArray *)freshMantras
{
    if (!_freshMantras)
    {
        _freshMantras = [NSMutableArray arrayWithContentsOfURL:kMMDataStoreControllerUnUsedMantrasURL];
        
        if (_freshMantras.count == 0 || _freshMantras == nil)
        {
            _freshMantras = [[NSMutableArray alloc] initWithArray:[MMDataStoreController sharedController].allMantras copyItems:YES];
        }
    }
    return _freshMantras;
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
        
        if (_allMantras.count == 0 || _allMantras == nil)
        {
            _allMantras = [[NSMutableArray alloc] initWithArray:@[@"Have a mantra.",
                                                                  @"Life is a marathon, not a sprint.",
                                                                  @"Everything is built in small steps.",
                                                                  @"Write stuff down.",
                                                                  @"A goal isn’t a goal unless you have to reach for it.",
                                                                  ] copyItems:YES];
        }

    }
    return _allMantras;
}



@end
