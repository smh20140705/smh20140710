//
//  SMHDataController.m
//  smh20140710
//
//  Created by Shah Hussain on 09/07/2014.
//  Copyright (c) 2014 smh20140705. All rights reserved.
//

#import "SMHDataController.h"
#import "SMHContacts.h"
#import "SMHAppDelegate.h"

NSString *const SourceURL = @"http://demo.monitise.net/download/tests/Data.xml";

@interface SMHDataController () <NSXMLParserDelegate>
{
    NSOperationQueue *_queue;
    
    NSMutableArray *_result;
    SMHContacts *_currentContact;
    NSManagedObjectContext *_backgroundContext;
    
    NSXMLParser *_parser;
    NSMutableString *_workingString;
}

@end

@implementation SMHDataController

+ (id)sharedController
{
    static SMHDataController *controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[SMHDataController alloc] init];
    });
    return controller;
}

- (id)init
{
    self = [super init];
    if (self) {
        _queue = [NSOperationQueue new];
        NSManagedObjectContext *context = [(SMHAppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
        _backgroundContext = [[NSManagedObjectContext alloc] init];
        [_backgroundContext setPersistentStoreCoordinator:[context persistentStoreCoordinator]];
    }
    return self;
}

- (void)fetchDataWithCompletionHandler:(void(^)(NSArray*))completion
{
    [self fetchOnlineDataWithCompletionHandler:completion];
}

- (void)fetchOnlineDataWithCompletionHandler:(void(^)(NSArray*))completion
{
    NSURL *reqURL = [NSURL URLWithString:SourceURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:reqURL];
    [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!data) {
             [self fetchLocalData];
         }
         else {
             // save it to the cache directory
             NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: @"data"];
             NSError *err = nil;
             if (![data writeToFile:path options:NSDataWritingAtomic error:&err]) {
                 NSLog(@"couldn't write data to cache at '%@': %@", path, err);
             }
             
             {
                 NSError *error = nil;
                 NSFetchRequest *requestAll = [[NSFetchRequest alloc] init];
                 [requestAll setEntity:[NSEntityDescription entityForName:@"SMHContacts" inManagedObjectContext:_backgroundContext]];
                 [requestAll setIncludesPropertyValues:NO];
                 error = nil;
                 NSArray *allItems = [_backgroundContext executeFetchRequest:requestAll error:&error];
                 if (!error) {
                     for (SMHContacts *contact in allItems) {
                         [_backgroundContext deleteObject:contact];
                     }
                 }
             }
             
             [self parseData:data];
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             completion([_result copy]);
         });
     }];
}

- (void)fetchLocalData
{
    NSEntityDescription *description = [NSEntityDescription entityForName:@"SMHContacts" inManagedObjectContext:_backgroundContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSError *error;
    _result = [NSMutableArray arrayWithArray:[_backgroundContext executeFetchRequest:request error:&error]];
}

- (NSArray *)parseData:(NSData *)data
{
    _result = [[NSMutableArray alloc] init];
    _workingString = nil;
    
    _parser = [[NSXMLParser alloc] initWithData:data];
    [_parser setDelegate:self];
    [_parser parse];

    return _result;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"contacts"]) {
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"contact"]) {
        _workingString = nil;
        _currentContact = [NSEntityDescription insertNewObjectForEntityForName:@"SMHContacts"inManagedObjectContext:_backgroundContext];
    }
    else {
        _workingString = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!_workingString) {
        _workingString = [[NSMutableString alloc] initWithString:string];
    }
    else {
        [_workingString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"contacts"]) {
        NSError *error;
        if (![_backgroundContext save:&error]) {
            NSLog(@"Failed to save data");
        }
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"contact"]) {
        [_result addObject:_currentContact];
        _currentContact = nil;
        _workingString = nil;
    }
    else {
        [_currentContact setValue:_workingString forKey:elementName];
        _workingString = nil;
    }
}

@end
