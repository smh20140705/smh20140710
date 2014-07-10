//
//  SMHContacts.m
//  smh20140710
//
//  Created by Shah Hussain on 09/07/2014.
//  Copyright (c) 2014 smh20140705. All rights reserved.
//

#import "SMHContacts.h"

@interface SMHContacts ()
{
    BOOL runOnce;
}

@end

@implementation SMHContacts

@dynamic firstName;
@dynamic lastName;
@dynamic age;
@dynamic sex;
@dynamic pictureURL;
@dynamic notes;

@synthesize picture;

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self) {
        runOnce = NO;
    }
    
    return self;
}

- (void)fetchImageWithCompletionHandler:(void (^)())completion
{
    @synchronized(self) {
        if (!runOnce) {
            runOnce = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSURL *reqURL = [NSURL URLWithString:self.pictureURL];
                NSURLRequest *request = [NSURLRequest requestWithURL:reqURL];
                NSHTTPURLResponse *response;
                NSError *error;
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                
                if (data && !error)
                {
                    self.picture = [UIImage imageWithData:data];
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completion();
                });
            });
        }
    }
}

@end