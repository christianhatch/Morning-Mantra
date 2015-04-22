//
//  MMViewController.m
//  Morning Mantra
//
//  Created by Christian Hatch on 8/7/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "MMViewController.h"
#import "MMDataStoreController.h"
#import "MMNotificationController.h"
#import "MMTableViewCell.h"

@interface MMViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation MMViewController

NSString *const MMTableViewCellID = @"MMTableViewCellID";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"MMTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:MMTableViewCellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MMNotificationController requestPermissionForNotifications];
    [MMNotificationController scheduleLocalNotificationWithText:[MMDataStoreController randomMantraWithNameGreeting]];
    
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self.tableView setEditing:editing animated:animated];
    [super setEditing:editing animated:animated]; 
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MMTableViewCellID forIndexPath:indexPath];
    
    cell.textLabel.text = [[MMDataStoreController allMantras] objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - UITableView Editing

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [MMDataStoreController removeMantra:[[MMDataStoreController allMantras] objectAtIndex:indexPath.row]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }
}

#pragma mark - Copy Menu

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [[UIPasteboard generalPasteboard] setString:cell.textLabel.text];
    }
}

#pragma mark - Font Size

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}


@end
