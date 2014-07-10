//
//  SMHContactCell.h
//  smh20140710
//
//  Created by Shah Hussain on 09/07/2014.
//  Copyright (c) 2014 smh20140705. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMHContactCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgPicture;
@property (strong, nonatomic) IBOutlet UILabel *lblFirstName;
@property (strong, nonatomic) IBOutlet UILabel *lblLastName;
@property (strong, nonatomic) IBOutlet UILabel *lblAge;
@property (strong, nonatomic) IBOutlet UILabel *lblSex;

@end
