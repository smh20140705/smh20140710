//
//  SMHContactsTVC.m
//  smh20140710
//
//  Created by Shah Hussain on 09/07/2014.
//  Copyright (c) 2014 smh20140705. All rights reserved.
//

#import "SMHContactsTVC.h"
#import "SMHDataController.h"
#import "SMHContactCell.h"
#import "SMHContactDetailsVC.h"

@interface SMHContactsTVC ()
{
    UIView *activityIndicatorView;
}

@property (strong, nonatomic) NSArray *contacts;

@end

@implementation SMHContactsTVC
@synthesize contacts;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showActivityIndicator];
    SMHDataController *dataController = [SMHDataController sharedController];
    [dataController fetchDataWithCompletionHandler:^void(NSArray *result){
        contacts = result;
        [self.tableView reloadData];
        [self removeActivityIndicator];
    }];
    
    // Refresh control for pull-to-refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    
    [refreshControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showActivityIndicator
{
    activityIndicatorView = [[UIView alloc] initWithFrame:self.view.frame];
    [activityIndicatorView setBackgroundColor:[UIColor blackColor]];
    [activityIndicatorView setAlpha:0.5];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-40, (self.view.frame.size.height/2)-40, 80, 80)];
    [activityIndicatorView addSubview:spinner];
    [spinner startAnimating];
    [self.view addSubview:activityIndicatorView];
}

- (void)removeActivityIndicator
{
    [activityIndicatorView removeFromSuperview];
    activityIndicatorView = nil;
}

- (void)updateTable
{
    SMHDataController *dataController = [SMHDataController sharedController];
    [dataController fetchDataWithCompletionHandler:^void(NSArray *result){
        contacts = result;
        // Core Data order is not online order so table needs refresh.
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMHContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMHContactCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    SMHContacts *tempContact = [contacts objectAtIndex:indexPath.row];
    
    // Basic cell setup w. placeholder image
    [cell.lblFirstName setText:tempContact.firstName];
    [cell.lblLastName setText:[tempContact.lastName uppercaseString]];
    [cell.lblAge setText:[tempContact.age stringValue]];
    [cell.lblSex setText:tempContact.sex];
    
    cell.imgPicture.image = [UIImage imageNamed:@"SMHContactPlaceholder"];
    
    // Get the actual image if possible
    if (tempContact.picture) {
        cell.imgPicture.image = tempContact.picture;
    }
    else {
        [tempContact fetchImageWithCompletionHandler: ^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SMHContactDetailsVC *destinationVC = [segue destinationViewController];
    SMHContacts *tempContact = [contacts objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    
    [destinationVC setContact:tempContact];
}

@end