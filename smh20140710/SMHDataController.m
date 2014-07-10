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
        NSManagedObjectContext *context = [(SMHAppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
        _backgroundContext = [[NSManagedObjectContext alloc] init];
        [_backgroundContext setPersistentStoreCoordinator:[context persistentStoreCoordinator]];
    }
    return self;
}

- (void)fetchDataWithCompletionHandler:(void(^)(NSArray*))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fetchOnlineData];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([_result copy]);
        });
    });
}

- (void)fetchOnlineData
{
    _result = [[NSMutableArray alloc] init];
    NSURL *reqURL = [NSURL URLWithString:SourceURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:reqURL];
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (data && !error) {
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
        [self parseData:data];
    }
    else {
        [self fetchLocalData];
    }
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
    else if ([elementName isEqualToString:@"firstName"]) {
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"lastName"]) {
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"age"]) {
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"sex"]) {
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"picture"]) {
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"notes"]) {
        _workingString = nil;
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
    else if ([elementName isEqualToString:@"firstName"]) {
        _currentContact.firstName = _workingString;
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"lastName"]) {
        _currentContact.lastName = [_workingString uppercaseString];
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"age"]) {
        _currentContact.age = [[NSNumberFormatter alloc] numberFromString:_workingString];
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"sex"]) {
        _currentContact.sex = _workingString;
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"picture"]) {
        _currentContact.pictureURL = _workingString;
        _workingString = nil;
    }
    else if ([elementName isEqualToString:@"notes"]) {
        _currentContact.notes = _workingString;
        _workingString = nil;
    }
    else {
        _workingString = nil;
    }
}

@end
