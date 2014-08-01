//
//  MMTableViewController.m
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "MMTableViewController.h"
#import "MMDataStoreController.h"
#import "MMConstants.h"
#import "MMTableViewCell.h"

static NSString *MMTableViewCellID = @"MMTableViewCell";


@interface MMTableViewController () <UIAlertViewDelegate>

- (IBAction)addMantraButtonTapped:(id)sender;
@property (nonatomic, strong) MMTableViewCell *prototypeCell;

@end

@implementation MMTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MMDataStoreController scheduleLocalNotifications];
    
    BOOL noGreetingNameSaved = [[NSUserDefaults standardUserDefaults] stringForKey:kMMDataStoreControllerUserGreetingNameKey] == nil;
    
    if (noGreetingNameSaved)
    {
        [self inputName];
    }
}

- (IBAction)addMantraButtonTapped:(id)sender
{
    [self addMantra];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MMDataStoreController allMantras].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MMTableViewCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    // Need to set the width of the prototype cell to the width of the table view
    // as this will change when the device is rotated.
    
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MMTableViewCell *cell = (MMTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString *mantra = cell.mantraLabel.text;
        [MMDataStoreController removeMantra:mantra];
        
        [tableView reloadData];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }   
}



- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[MMTableViewCell class]])
    {
        MMTableViewCell *textCell = (MMTableViewCell *)cell;
        textCell.mantraLabel.text = [MMDataStoreController allMantras][indexPath.row];
        textCell.mantraLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}


#pragma mark - Internal

- (void)showRandomMantra
{
    if ([MMDataStoreController allMantras].count > 0)
    {
        NSString *title = [NSString stringWithFormat:@"Hey %@,", [[NSUserDefaults standardUserDefaults] stringForKey:kMMDataStoreControllerUserGreetingNameKey]];
                           
        [[[UIAlertView alloc] initWithTitle:title
                                    message:[MMDataStoreController randomNonRepeatingMantra]
                                   delegate:nil
                          cancelButtonTitle:@"Thank You"
                          otherButtonTitles:nil, nil]
         show];
    }
}

- (void)addMantra
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Mantra"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Add Mantra", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert show];
}

- (void)inputName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What's your name?"
                                                    message:@"Enter your name below to personalize your Morning Mantra"
                                                   delegate:self
                                          cancelButtonTitle:@"No Thanks"
                                          otherButtonTitles:@"Save", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 2;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([title isEqualToString:@"Add Mantra"])
        {
            NSString *mantra = [alertView textFieldAtIndex:0].text;
            
            DebugLog(@"new mantra to add %@", mantra);
            
            [MMDataStoreController addMantra:mantra];
            [self.tableView reloadData];
        }
    }
    else if (alertView.tag == 2)
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        
        if([title isEqualToString:@"Save"])
        {
            NSString *name = [alertView textFieldAtIndex:0].text;
            
            if (name && name.length > 0)
            {
                DebugLog(@"name was input %@", name);
                
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:kMMDataStoreControllerUserGreetingNameKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}

#pragma mark - Getters

- (MMTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:MMTableViewCellID];
    }
    return _prototypeCell;
}

@end
