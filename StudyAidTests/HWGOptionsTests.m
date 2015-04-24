//
//  HWGOptionsTests.m
//  StudyAid
//
//  Created by Woudini on 4/24/15.
//  Copyright (c) 2015 Hi Range. All rights reserved.
//

#import "HWGOptionsViewController.h"
#import <XCTest/XCTest.h>

@interface HWGOptionsViewController (Test)
-(void)restrictUserToYellowHighlighterTest;
@end

@implementation HWGOptionsViewController (Test)

-(void)restrictUserToYellowHighlighterTest
{
    
}

@end

@interface HWGOptionsTests : XCTestCase
@property (nonatomic) HWGOptionsViewController *optionsViewController;
@end

@implementation HWGOptionsTests

- (void)setUp {
    [super setUp];
    self.optionsViewController = [[HWGOptionsViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = self.optionsViewController;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testItemsHaveNotBeenPurchased
{
    // This is an example of a functional test case.
    XCTAssertFalse([[NSUserDefaults standardUserDefaults] boolForKey:@"purchased"]
, @"Purchased should be false");
    XCTAssertFalse(self.optionsViewController.hasPurchasedEditingFeatures, @"Purchased should be false");

}

@end
