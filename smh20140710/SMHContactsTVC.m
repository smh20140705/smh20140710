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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showActivityIndicator];
    SMHDataController *dataController = [SMHDataController sharedController];
    [dataController fetchDataWithCompletionHandler: ^void(NSArray *result){
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
    SMHContacts *tempContact = [contacts objectAtIndex:indexPath.row];
    
    // Basic cell setup w. placeholder image
    cell.lblFirstName.text = tempContact.firstName;
    cell.lblLastName.text = tempContact.lastName;
    cell.lblAge.text = [tempContact.age stringValue];
    cell.lblSex.text = tempContact.sex;
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SMHContactDetailsVC *destinationVC = [segue destinationViewController];
    SMHContacts *tempContact = [contacts objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    
    [destinationVC setContact:tempContact];
}

@end
