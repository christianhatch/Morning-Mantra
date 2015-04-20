//
//  MMViewController.m
//  Morning Mantra
//
//  Created by Christian Hatch on 8/7/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "MMViewController.h"
#import "MMDataStoreController.h"
#import "MMTableViewCell.h"

@interface MMViewController ()

@end


@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self.tableView registerClass:[MMTableViewCell class] forCellReuseIdentifier:@"MMTableViewCell"];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MMDataStoreController scheduleLocalNotifications];
    
    if ([MMDataStoreController shouldPresentAddNameUI]) {
        [MMDataStoreController presentAddNameUIWithCompletion:nil];
    }
}

- (IBAction)addMantraButtonTapped:(id)sender
{
    [MMDataStoreController presentAddMantraUIWithCompletion:^{
        [self.tableView reloadData];
    }];
}


#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MMDataStoreController allMantras].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMTableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[MMDataStoreController allMantras] objectAtIndex:indexPath.row];
    
    return cell;
}

@end
