//
//  SMHContactDetailsVC.m
//  smh20140710
//
//  Created by Shah Hussain on 10/07/2014.
//  Copyright (c) 2014 smh20140705. All rights reserved.
//

#import "SMHContactDetailsVC.h"
#import "SMHContacts.h"

@interface SMHContactDetailsVC ()

@property (weak, nonatomic) IBOutlet UIImageView *contactPicture;
@property (weak, nonatomic) IBOutlet UITextView *contactNotes;

@end

@implementation SMHContactDetailsVC
@synthesize contact;
@synthesize contactPicture;
@synthesize contactNotes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert(contact, @"No contact data");
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName]];
    [contactPicture setImage:contact.picture];
    [contactNotes setText:contact.notes];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
