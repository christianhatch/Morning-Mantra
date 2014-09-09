//
//  MMViewController.m
//  Morning Mantra
//
//  Created by Christian Hatch on 8/7/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "MMViewController.h"
#import "MMDataStoreController.h"
#import "MMCollectionViewCell.h"


@interface MMViewController ()

@property (nonatomic, strong) MMCollectionViewCell *prototypeCell;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end



@implementation MMViewController

static NSString * CellIdentifier = @"MMCollectionViewCell";


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.prompt = [MMDataStoreController randomMantraGreeting];
    
    UINib *cellNib = [UINib nibWithNibName:@"MMCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"MMCollectionViewCell"];
    
    self.prototypeCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MMDataStoreController scheduleLocalNotifications];
    
    if ([MMDataStoreController shouldPresentAddNameUI]) {
        [MMDataStoreController presentAddNameUIWithCompletion:nil];
    }
}

- (void)viewDidLayoutSubviews
{
//    [self.collectionView layoutIfNeeded];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}

- (IBAction)addMantraButtonTapped:(id)sender
{
    [MMDataStoreController presentAddMantraUIWithCompletion:^{
        [self.collectionView reloadData];
    }];
}


#pragma mark - UICollectionView Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [MMDataStoreController allMantras].count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1; 
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    CGSize size = [self.prototypeCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
//    NSLog(@"size %@", NSStringFromCGSize(size));
    
    return size;
}




#pragma Mark - Internal

- (void)configureCell:(UICollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MMCollectionViewCell class]])
    {
//        NSLog(@"mantra %@", [MMDataStoreController allMantras][indexPath.row]);

        MMCollectionViewCell *textCell = (MMCollectionViewCell *)cell;
        textCell.label.text = [MMDataStoreController allMantras][indexPath.section];
        textCell.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
}


- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}




@end
