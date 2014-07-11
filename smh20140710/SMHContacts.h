//
//  SMHContacts.h
//  smh20140710
//
//  Created by Shah Hussain on 09/07/2014.
//  Copyright (c) 2014 smh20140705. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SMHContacts : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * notes;

@property (nonatomic, strong) UIImage * pictureImage;

- (void)fetchImageWithCompletionHandler:(void(^)())completion;

@end
