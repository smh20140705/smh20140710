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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert(contact, @"No contact data");
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    contactPicture.image = [UIImage imageNamed:@"SMHContactPlaceholder"];
    if (contact.picture) {
        contactPicture.image = contact.picture;
    }
    contactNotes.text = contact.notes;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
