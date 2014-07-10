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
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) NSString * notes;

@property (nonatomic, strong) UIImage * picture;

- (void)fetchImageWithCompletionHandler:(void(^)())completion;

@end
