//
//  SMHDataController.h
//  smh20140710
//
//  Created by Shah Hussain on 09/07/2014.
//  Copyright (c) 2014 smh20140705. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMHContacts.h"

@interface SMHDataController : NSObject

+ (id)sharedController;

- (void)fetchDataWithCompletionHandler:(void(^)(NSArray*))completion;
- (NSArray *)parseData:(NSData *) data;

@end
