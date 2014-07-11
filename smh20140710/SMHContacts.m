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
@dynamic picture;
@dynamic notes;

@synthesize pictureImage;

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
    NSString *hash = [NSString stringWithFormat:@"%016x", [self.picture hash]];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:hash];
    
    // check whether we have a cached version of the image we can return straight away
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:NULL];
    if (data && (self.pictureImage = [UIImage imageWithData:data])) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self.pictureImage, self.picture, nil);
        });
        return; // we could disable this to perform the check for updated images
    }
    
    @synchronized(self) {
        if (!runOnce) {
            runOnce = YES;
            __weak SMHContacts *wself = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSURL *reqURL = [NSURL URLWithString:wself.picture];
                NSURLRequest *request = [NSURLRequest requestWithURL:reqURL];
                NSHTTPURLResponse *response;
                NSError *error;
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                
                if (data && !error) {
                    // save it to the cache directory
                    NSError *err = nil;
                    if (![data writeToFile:path options:NSDataWritingAtomic error:&err]) {
                        NSLog(@"couldn't write image to cache at '%@': %@", path, err);
                    }
                    wself.pictureImage = [UIImage imageWithData:data];
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    completion();
                });
            });
        }
    }
}

@end
