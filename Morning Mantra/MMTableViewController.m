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

@interface MMTableViewController () <UIAlertViewDelegate>

- (IBAction)addMantraButtonTapped:(id)sender;

@end

@implementation MMTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"MMTableViewCell"];
        
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL noGreetingNameSaved = [[NSUserDefaults standardUserDefaults] stringForKey:kMMDataStoreControllerUserGreetingNameKey] == nil;
    
    if (noGreetingNameSaved)
    {
        [self inputName];
    }
    else
    {
        [self showRandomMantra];
    }
}

- (IBAction)addMantraButtonTapped:(id)sender
{
    [self addMantra];
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
            
            DebugLog(@"name was input %@", name);
            
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:kMMDataStoreControllerUserGreetingNameKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }
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
    
    NSString *mantra = [MMDataStoreController allMantras][indexPath.row];
    
    cell.textLabel.text = mantra;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *mantra = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [MMDataStoreController removeMantra:mantra];
        
        [tableView reloadData];
//        [tableView deleteRowsAtIndexPaths:@[indexPath]
//                         withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }   
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


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
