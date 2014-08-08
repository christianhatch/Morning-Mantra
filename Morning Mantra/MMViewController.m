//
//  MMViewController.m
//  Morning Mantra
//
//  Created by Christian Hatch on 8/7/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "MMViewController.h"
#import "MMDataStoreController.h"

@interface MMViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MMViewController

static NSString * CellIdentifier = @"cellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MMDataStoreController scheduleLocalNotifications];
    
    if ([MMDataStoreController shouldPresentAddNameUI])
    {
        [MMDataStoreController presentAddNameUIWithCompletion:nil];
    }
}

- (IBAction)addMantraButtonTapped:(id)sender
{
    [MMDataStoreController presentAddMantraUIWithCompletion:^{
        [self.collectionView reloadData];
    }];
}


#pragma mark - UICollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [MMDataStoreController allMantras].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *otherCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
    
    
    
    
    return otherCell;
}









@end
