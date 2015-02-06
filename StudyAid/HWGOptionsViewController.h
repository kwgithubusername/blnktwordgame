//
//  HWGOptionsViewController.h
//  StudyAid
//
//  Created by Woudini on 12/30/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface HWGOptionsViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITabBarDelegate, UIAlertViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property BOOL hasPurchasedEditingFeatures;
- (IBAction)purchase:(SKProduct *)product;
- (IBAction)restorePurchase;

@property (nonatomic) UIColor *highlighterColor;
@property (nonatomic) NSMutableArray *wordsToIgnoreMutableArray;
@property (nonatomic) NSMutableArray *charactersToTrimMutableArray;

@end
