//
//  MMDataStoreController.m
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "MMDataStoreController.h"
#import "NSURL+MMExtended.h"

#define kMMDataStoreControllerUsedMantrasURL   [NSURL libraryFileURLWithDirectory:@"mantras" filename:@"unusedMantras" extension:nil]
#define kMMDataStoreControllerUnUsedMantrasURL [NSURL libraryFileURLWithDirectory:@"mantras" filename:@"usedMantras" extension:nil]

@interface MMDataStoreController ()

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

+ (NSString *)randomMantra
{
    NSInteger index = [[MMDataStoreController sharedController] randomIndex];
    
    NSString *mantra = [MMDataStoreController sharedController].unUsedMantras[index];
    
    [[MMDataStoreController sharedController].unUsedMantras removeObjectAtIndex:index];
    
    [[MMDataStoreController sharedController].usedMantras addObject:mantra];
    
    [[MMDataStoreController sharedController] persistAllData];
    
    return mantra;
}

+ (void)addMantra:(NSString *)mantra
{
    if (mantra && mantra.length > 0)
    {
        [[MMDataStoreController sharedController].unUsedMantras addObject:mantra];
        [[MMDataStoreController sharedController] persistAllData];
    }
}

+ (void)removeMantra:(NSString *)mantra
{
    if (mantra && mantra.length > 0)
    {
        [[MMDataStoreController sharedController].unUsedMantras addObject:mantra];
        [[MMDataStoreController sharedController] persistAllData];
    }
}

#pragma mark - Internal

- (NSInteger)randomIndex
{
    NSInteger rando = 0;
    int limit = (int)self.unUsedMantras.count;
    
    if (self.unUsedMantras.count > 1)
    {
        rando = arc4random_uniform(limit);
    }
    else
    {
        [self reFillUnusedMantras];
    }
    
    return rando;
}

- (void)reFillUnusedMantras
{
    [self.unUsedMantras addObjectsFromArray:self.usedMantras];
    
    [self.usedMantras removeAllObjects];
    
    [self persistAllData];
}

- (void)persistAllData
{
    [self.usedMantras writeToURL:kMMDataStoreControllerUsedMantrasURL
                      atomically:YES];
    
    [self.unUsedMantras writeToURL:kMMDataStoreControllerUnUsedMantrasURL
                        atomically:YES];
}


#pragma mark - Getters

- (NSMutableArray *)unUsedMantras
{
    if (!_unUsedMantras)
    {
        _unUsedMantras = [NSMutableArray arrayWithContentsOfURL:kMMDataStoreControllerUnUsedMantrasURL];
    }
    return _unUsedMantras;
}

- (NSMutableArray *)usedMantras
{
    if (!_usedMantras)
    {
        _usedMantras = [NSMutableArray arrayWithContentsOfURL:kMMDataStoreControllerUsedMantrasURL];
    }
    return _usedMantras;
}



@end
