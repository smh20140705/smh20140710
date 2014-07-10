//
//  SMHDataControllerTests.m
//  smh20140710
//
//  Created by Shah Hussain on 10/07/2014.
//  Copyright (c) 2014 smh20140705. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SMHDataController.h"
#import "SMHContacts.h"

@interface SMHDataControllerTests : XCTestCase

@end

@implementation SMHDataControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchDataWithCompletionHandler
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    SMHDataController *dataController = [SMHDataController sharedController];
    [dataController fetchDataWithCompletionHandler:^void(NSArray *result) {
        
        {
            NSNumber *expectedNumberOfContacts = @4;
            NSNumber *actualNumberOfContacts = [NSNumber numberWithUnsignedInteger:result.count];
            XCTAssert([actualNumberOfContacts isEqualToNumber:expectedNumberOfContacts],
                      @"Incorrect number of contacts: expected: %@; got:%@",
                      expectedNumberOfContacts, actualNumberOfContacts);
        }
        
        SMHContacts *tempContact = result.firstObject;
        
        {
            NSString *expectedFirstName = @"Steve";
            NSString *actualFirstName = tempContact.firstName;
            XCTAssert([actualFirstName isEqualToString:expectedFirstName],
                      @"Incorrect contact firstName: expected: %@; got:%@",
                      expectedFirstName, actualFirstName);
        }
        
        {
            NSString *expectedLastName = @"Jobs";
            NSString *actualLastName = tempContact.lastName;
            XCTAssert([actualLastName isEqualToString:expectedLastName],
                      @"Incorrect contact lastName: expected: %@; got:%@",
                      expectedLastName, actualLastName);
        }
        
        {
            NSNumber *expectedAge = @56;
            NSNumber *actualAge = tempContact.age;
            XCTAssert([actualAge isEqualToNumber:expectedAge],
                      @"Incorrect contact age: expected: %@; got:%@",
                      expectedAge, actualAge);
        }
        
        {
            NSString *expectedSex = @"m";
            NSString *actualSex = tempContact.sex;
            XCTAssert([actualSex isEqualToString:expectedSex],
                      @"Incorrect contact sex: expected: %@; got:%@",
                      expectedSex, actualSex);
        }
        
        {
            NSString *expectedPicture = @"http://upload.wikimedia.org/wikipedia/commons/b/b9/Steve_Jobs_Headshot_2010-CROP.jpg";
            NSString *actualPicture = tempContact.pictureURL;
            XCTAssert([actualPicture isEqualToString:expectedPicture],
                      @"Incorrect contact picture: expected: %@; got:%@",
                      expectedPicture, actualPicture);
        }
        
        {
            NSString *expectedNotes = @"Co-founder, Chairman and CEO, Apple Inc., CEO, Pixar, Co-founder and CEO, NeXT Inc.";
            NSString *actualNotes = tempContact.notes;
            XCTAssert([actualNotes isEqualToString:expectedNotes],
                      @"Incorrect contact notes: expected: %@; got:%@",
                      expectedNotes, actualNotes);
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testParseOneContact
{
    NSString *path = [[NSBundle bundleForClass: [self class]] pathForResource: @"one_contact" ofType: @"xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:NULL];
    SMHDataController *dataController = [SMHDataController sharedController];
    NSArray *result = [dataController parseData:data];
    
    {
        NSNumber *expectedNumberOfContacts = @1;
        NSNumber *actualNumberOfContacts = [NSNumber numberWithUnsignedInteger:result.count];
        XCTAssert([actualNumberOfContacts isEqualToNumber:expectedNumberOfContacts],
                  @"Incorrect number of contacts: expected: %@; got:%@",
                  expectedNumberOfContacts, actualNumberOfContacts);
    }
    
    SMHContacts *tempContact = result.firstObject;
    
    {
        XCTAssertNotNil(tempContact, @"tempContact is nil.");
    }
    
    {
        NSString *expectedFirstName = @"Steve";
        NSString *actualFirstName = tempContact.firstName;
        XCTAssert([actualFirstName isEqualToString:expectedFirstName],
                  @"Incorrect contact firstName: expected: '%@'; got:'%@'",
                  expectedFirstName, actualFirstName);
    }
    
    {
        NSString *expectedLastName = @"Jobs";
        NSString *actualLastName = tempContact.lastName;
        XCTAssert([actualLastName isEqualToString:expectedLastName],
                  @"Incorrect contact lastName: expected: %@; got:%@",
                  expectedLastName, actualLastName);
    }
    
    {
        NSNumber *expectedAge = @56;
        NSNumber *actualAge = tempContact.age;
        XCTAssert([actualAge isEqualToNumber:expectedAge],
                  @"Incorrect contact age: expected: %@; got:%@",
                  expectedAge, actualAge);
    }
    
    {
        NSString *expectedSex = @"m";
        NSString *actualSex = tempContact.sex;
        XCTAssert([actualSex isEqualToString:expectedSex],
                  @"Incorrect contact sex: expected: %@; got:%@",
                  expectedSex, actualSex);
    }
    
    {
        NSString *expectedPicture = @"http://upload.wikimedia.org/wikipedia/commons/b/b9/Steve_Jobs_Headshot_2010-CROP.jpg";
        NSString *actualPicture = tempContact.pictureURL;
        XCTAssert([actualPicture isEqualToString:expectedPicture],
                  @"Incorrect contact picture: expected: %@; got:%@",
                  expectedPicture, actualPicture);
    }
    
    {
        NSString *expectedNotes = @"Co-founder, Chairman and CEO, Apple Inc., CEO, Pixar, Co-founder and CEO, NeXT Inc.";
        NSString *actualNotes = tempContact.notes;
        XCTAssert([actualNotes isEqualToString:expectedNotes],
                  @"Incorrect contact notes: expected: %@; got:%@",
                  expectedNotes, actualNotes);
    }
}

- (void)testParseFourContacts
{
    NSString *path = [[NSBundle bundleForClass: [self class]] pathForResource: @"four_contacts" ofType: @"xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:NULL];
    SMHDataController *dataController = [SMHDataController sharedController];
    NSArray *result = [dataController parseData:data];
    
    {
        NSNumber *expectedNumberOfContacts = @4;
        NSNumber *actualNumberOfContacts = [NSNumber numberWithUnsignedInteger:result.count];
        XCTAssert([actualNumberOfContacts isEqualToNumber:expectedNumberOfContacts],
                  @"Incorrect number of contacts: expected: %@; got:%@",
                  expectedNumberOfContacts, actualNumberOfContacts);
    }
    
    SMHContacts *tempContact = result.lastObject;
    
    {
        NSString *expectedFirstName = @"Steve";
        NSString *actualFirstName = tempContact.firstName;
        XCTAssert([actualFirstName isEqualToString:expectedFirstName],
                  @"Incorrect contact firstName: expected: %@; got:%@",
                  expectedFirstName, actualFirstName);
    }
    
    {
        NSString *expectedLastName = @"Wozniak";
        NSString *actualLastName = tempContact.lastName;
        XCTAssert([actualLastName isEqualToString:expectedLastName],
                  @"Incorrect contact lastName: expected: %@; got:%@",
                  expectedLastName, actualLastName);
    }
    
    {
        NSNumber *expectedAge = @61;
        NSNumber *actualAge = tempContact.age;
        XCTAssert([actualAge isEqualToNumber:expectedAge],
                  @"Incorrect contact age: expected: %@; got:%@",
                  expectedAge, actualAge);
    }
    
    {
        NSString *expectedSex = @"m";
        NSString *actualSex = tempContact.sex;
        XCTAssert([actualSex isEqualToString:expectedSex],
                  @"Incorrect contact sex: expected: %@; got:%@",
                  expectedSex, actualSex);
    }
    
    {
        NSString *expectedPicture = @"http://upload.wikimedia.org/wikipedia/commons/f/f6/Steve_Wozniak.jpg";
        NSString *actualPicture = tempContact.pictureURL;
        XCTAssert([actualPicture isEqualToString:expectedPicture],
                  @"Incorrect contact picture: expected: %@; got:%@",
                  expectedPicture, actualPicture);
    }
    
    {
        NSString *expectedNotes = @"American computer engineer and programmer who founded Apple Computer, Co. (now Apple Inc.) with Steve Jobs and Ronald Wayne.";
        NSString *actualNotes = tempContact.notes;
        XCTAssert([actualNotes isEqualToString:expectedNotes],
                  @"Incorrect contact notes: expected: %@; got:%@",
                  expectedNotes, actualNotes);
    }
}

@end
