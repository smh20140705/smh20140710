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
    NSOperationQueue *_queue;
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

- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self) {
        _queue = [NSOperationQueue new];
    }
    
    return self;
}

- (void)fetchImageWithCompletionHandler:(void (^)())completion
{
    NSURL *url = [NSURL URLWithString:self.picture];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSString *hash = [NSString stringWithFormat:@"%016lx", (unsigned long)[self.picture hash]];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:hash];
    
    // check whether we have a cached version of the image we can return straight away
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:NULL];
    if (data && (self.pictureImage = [UIImage imageWithData:data])) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }
    else {
        [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             if(data) {
                 // save it to the cache directory
                 NSError *err = nil;
                 if(![data writeToFile:path options:NSDataWritingAtomic error:&err]) {
                     NSLog(@"couldn't write image to cache at '%@': %@", path, err);
                 }
                 
                 self.pictureImage = [UIImage imageWithData: data];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion();
             });
         }];
    }
}

@end
