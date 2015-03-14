//
//  HWGOptionsViewController.m
//  StudyAid
//
//  Created by Woudini on 12/30/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import "HWGOptionsViewController.h"
#import "HWGInvalidCharacterRemover.h"
#import "HWGCommonWordFilter.h"
#import "HWGOptionsWordsToIgnore.h"
#import "HWGOptionsCharactersToTrim.h"
#import "HWGOptionsColorToStore.h"
#import "HWGCharacterToTrimTableViewCell.h"
#import "HWGWordToIgnoreTableViewCell.h"
#import "HWGDefaultPreferences.h"
#import "HWGOptionsDataSource.h"

#define kRemoveAdsProductIdentifier @"com.hirange.woudini.StudyAid.unlockfeatures"

@interface HWGOptionsViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewToInsertBackgroundImage;
@property (nonatomic) HWGOptionsDataSource *dataSource;
@property (weak, nonatomic) IBOutlet UITextField *wordToIgnoreTextField;
@property (weak, nonatomic) IBOutlet UITableView *wordToIgnoreTableView;
@property (weak, nonatomic) IBOutlet UITextField *characterToTrimTextField;
@property (weak, nonatomic) IBOutlet UITableView *characterToTrimTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) UIAlertView *restorePurchaseAlertView;

@property (weak, nonatomic) IBOutlet UIButton *yellowHighlighterButton;
@property (weak, nonatomic) IBOutlet UIButton *greenHighlighterButton;
@property (weak, nonatomic) IBOutlet UIButton *blueHighlighterButton;
@property (weak, nonatomic) IBOutlet UIButton *magentaHighlighterButton;

@property BOOL willHighlightInSequence;
@property (weak, nonatomic) IBOutlet UISwitch *willHighlightInSequenceSwitch;
@property (nonatomic) HWGDefaultPreferences *defaultPreferences;
@property (nonatomic) HWGOptionsWordsToIgnore *wordsToIgnore;
@property (nonatomic) HWGOptionsCharactersToTrim *charactersToTrim;
@property (nonatomic) HWGOptionsColorToStore *colorToStore;

@end

@implementation HWGOptionsViewController

-(void)requestProduct
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        //NSLog(@"Products Available!");
        [self purchase:validProduct];
        
    }
    else if(!validProduct){
        //NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}


-(void)purchase:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

-(IBAction)restorePurchase
{
    // Inform the user that the system is busy
    self.restorePurchaseAlertView = [[UIAlertView alloc] initWithTitle:@"Retrieving purchase..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    
    // Create an indicator for the alert and show the alert
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    [self.restorePurchaseAlertView setValue:indicator forKey:@"accessoryView"];
    [self.restorePurchaseAlertView show];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    [self.restorePurchaseAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    //NSLog(@"received restored transactions: %i", queue.transactions.count);
    if (queue.transactions.count == 0)
    {
        [self alertUserThatRestoreTransactionFailed];
    }
    
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if(SKPaymentTransactionStateRestored){
            //NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
            [self unlockFeatures];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
        //[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)alertUserThatRestoreTransactionFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Restore Transaction Failed" message:@"No previous purchase was found for your account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: //NSLog(@"Transaction state -> Purchasing");
                
                break;
            case SKPaymentTransactionStateDeferred:
                
                break;
            case SKPaymentTransactionStatePurchased:
                [self unlockFeatures];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                //NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                [self unlockFeatures];
                //NSLog(@"Transaction state -> Restored");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finnish
                
                if(transaction.error.code != SKErrorPaymentCancelled){
                    //NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
        //[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (IBAction)tappedSequenceSwitch:(UISwitch *)sender
{
    self.willHighlightInSequence = sender.on;
    [[NSUserDefaults standardUserDefaults] setBool:self.willHighlightInSequence forKey:StudyAidWillHighlightInSequencePrefKey];
}

-(IBAction)clearAllWordsForTableViewsButton:(UIButton *)sender
{
    [self alertUserBeforeChangingTableViewsWithCode:100];
}

-(IBAction)clearAllCharactersForTableViewsButton:(UIButton *)sender
{
    [self alertUserBeforeChangingTableViewsWithCode:101];
}

-(void)clearAllEntriesForTableView:(UITableView *)tableView
{
    NSArray *emptyArray = [[NSArray alloc] init];
    
    if ([tableView isEqual:self.wordToIgnoreTableView])
    {
        [self.wordsToIgnore saveWords:emptyArray];
    }
    else if ([tableView isEqual:self.characterToTrimTableView])
    {
        [self.charactersToTrim saveCharacters:emptyArray];
    }
    [self.scrollView scrollRectToVisible:CGRectMake(1,1,1,1) animated:YES];
    [self loadColorAndWordsAndCharacters];
    [tableView reloadData];
}

-(IBAction)restoreDefaultsButton
{
    [self alertUserBeforeChangingTableViewsWithCode:102];
}

-(void)restoreDefaults
{
    [self.charactersToTrim saveCharacters:[self.defaultPreferences defaultCharactersToTrim]];
    [self.wordsToIgnore saveWords:[self.defaultPreferences defaultWordsToIgnore]];
    [self.defaultPreferences setSliderValueUsingInt:10];
    [self.scrollView scrollRectToVisible:CGRectMake(1,1,1,1) animated:YES];
    [self loadColorAndWordsAndCharacters];
    [self.wordToIgnoreTableView reloadData];
    [self.characterToTrimTableView reloadData];
}

-(void)disableTextFields
{
    self.wordToIgnoreTextField.enabled = NO;
    self.characterToTrimTextField.enabled = NO;
}

-(void)enableTextFields
{
    self.wordToIgnoreTextField.enabled = YES;
    self.characterToTrimTextField.enabled = YES;
}

-(void)alertUserBeforeChangingTableViewsWithCode:(int)code
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"All previous changes will be lost." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    alertView.tag = code;
    [alertView show];
}

-(void)alertUserThatPurchaseIsRequired
{
    
    if([SKPaymentQueue canMakePayments]){
        //NSLog(@"User can make payments");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Feature Locked" message:@"Unlock all highlighter colors and word/character filter customization for $0.99 USD. You may restore your purchase by tapping \"Restore Purchase\" at the bottom of this screen."
                                                           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Unlock", nil];
        alertView.tag = 109;
        [alertView show];
        
    }
    else{
        //NSLog(@"User cannot make payments due to parental controls");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to Pay" message:@"Payments cannot be made through your account"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = 108;
        [alertView show];
    }
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        switch (alertView.tag)
        {
            case 100:
                [self clearAllEntriesForTableView:self.wordToIgnoreTableView];
                break;
            case 101:
                [self clearAllEntriesForTableView:self.characterToTrimTableView];
                break;
            case 102:
                [self restoreDefaults];
                break;
            case 109:
                //NSLog(@"User has confirmed desire to purchase");
                
                [self requestProduct];
                break;
        }
    }
}

-(void)unlockFeatures
{
    self.hasPurchasedEditingFeatures = YES;
    [[NSUserDefaults standardUserDefaults] setBool:self.hasPurchasedEditingFeatures forKey:@"purchased"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self enableTextFields];
    [self loadColorAndWordsAndCharacters];
    //NSLog(@"BOOL hasPurchasedEditingFeatures is %hhd", self.hasPurchasedEditingFeatures);
}

#pragma mark purchasing

-(void)restrictUserToYellowHighlighter
{
    [self.yellowHighlighterButton setTitle:@"✍" forState:UIControlStateNormal];
    //NSLog(@"button pressed");
    [self.colorToStore saveColor:self.yellowHighlighterButton.backgroundColor];
    
    for (UIButton *button in [self highlighterButtonsArray])
    {
        if (button != self.yellowHighlighterButton)
        {
            [button setTitle:@"☒" forState:UIControlStateNormal];
        }
    }
}

#pragma mark initializers

-(HWGDefaultPreferences *)defaultPreferences
{
    if (!_defaultPreferences) _defaultPreferences = [[HWGDefaultPreferences alloc] init];
    return _defaultPreferences;
}

-(HWGOptionsCharactersToTrim *)charactersToTrim
{
    if (!_charactersToTrim) _charactersToTrim = [[HWGOptionsCharactersToTrim alloc] init];
    return _charactersToTrim;
}

-(HWGOptionsWordsToIgnore *)wordsToIgnore
{
    if (!_wordsToIgnore) _wordsToIgnore = [[HWGOptionsWordsToIgnore alloc] init];
    return _wordsToIgnore;
}

-(HWGOptionsColorToStore *)colorToStore
{
    if (!_colorToStore) _colorToStore = [[HWGOptionsColorToStore alloc] init];
    return _colorToStore;
}


#pragma mark Button methods

-(NSArray *)highlighterButtonsArray
{
    return @[self.yellowHighlighterButton, self.greenHighlighterButton, self.blueHighlighterButton, self.magentaHighlighterButton];
}

- (IBAction)userClickedHighlighterButton:(UIButton *)sender
{
    if (self.hasPurchasedEditingFeatures)
    {
        for (UIButton *button in [self highlighterButtonsArray])
        {
            [button setTitle:@"" forState:UIControlStateNormal];
        }
        self.highlighterColor = sender.backgroundColor;
        [sender setTitle:@"✍" forState:UIControlStateNormal];
        //NSLog(@"button pressed");
        [self.colorToStore saveColor:sender.backgroundColor];
    }
    else if ([sender.titleLabel.text isEqualToString:@"☒"])
    {
        [self alertUserThatPurchaseIsRequired];
    }
    else if (sender == self.yellowHighlighterButton)
    {
        
    }
    else
    {
        //NSLog(@"Error: Button does not have an X on it");
    }
}

#pragma mark Keyboard methods

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if ([self.characterToTrimTextField isFirstResponder])
    {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, kbSize.height, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, self.characterToTrimTextField.frame.origin) ) {
            [self.scrollView scrollRectToVisible:self.characterToTrimTextField.frame animated:YES];
        }
    }
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Prevent the navigation bar from swallowing the top of the view
    [self.scrollView setContentInset:UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)];
}

-(void)alertUserOfDuplicateEntryOfString:(NSString *)string
{
    UIAlertView *alreadyInArray = [[UIAlertView alloc] initWithTitle:@"Duplicate Entry"
                                                             message:[[NSString alloc] initWithFormat:@"The store already contains %@", string]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alreadyInArray show];
}

-(void)displayMutableArrayWithoutParentheses:(NSMutableArray *)mutableArray inTextView:(UITextView *)textView
{
    NSString *stringToTrim = [[NSString alloc] initWithFormat:@"%@", mutableArray];
    NSCharacterSet *invalidSet = [NSCharacterSet characterSetWithCharactersInString:@"()"];
    NSString *stringToDisplay = [stringToTrim stringByTrimmingCharactersInSet:invalidSet];
    textView.text = stringToDisplay;
}

-(NSIndexPath*)indexPathForLastRowInTableView:(UITableView *)tableView
{
    return [NSIndexPath indexPathForRow:[tableView numberOfRowsInSection:tableView.numberOfSections - 1] - 1 inSection:tableView.numberOfSections - 1];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.characterToTrimTextField])
    {
        NSString *characterToAdd = self.characterToTrimTextField.text;
        if ([self.charactersToTrimMutableArray containsObject:characterToAdd] && [characterToAdd length] > 0)
        {
            [self alertUserOfDuplicateEntryOfString:characterToAdd];
            // Pass mutablearray through a delegate method back to view controller
        }
        else if ([characterToAdd isEqualToString:@""])
        {
            //NSLog(@"blank entry");
        }
        else
        {
            //NSLog(@"recognized charactertotrimtextfield");
            
            [self.charactersToTrimMutableArray addObject:characterToAdd];
            
            NSIndexPath *indexPathForCharacter = [self indexPathForLastRowInTableView:self.characterToTrimTableView];
            
            [self.characterToTrimTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForCharacter] withRowAnimation:UITableViewRowAnimationFade];
            
            // Write to file
            [self.charactersToTrim saveCharacters:self.charactersToTrimMutableArray];
            
            [self.characterToTrimTableView reloadData];
            
            [self.characterToTrimTableView scrollToRowAtIndexPath:indexPathForCharacter atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            // Clear the textField
            self.characterToTrimTextField.text = @"";
        }

    }
    if ([textField isEqual:self.wordToIgnoreTextField])
    {
        NSString *characterToAdd = self.wordToIgnoreTextField.text;
        if ([self.wordsToIgnoreMutableArray containsObject:characterToAdd] && [characterToAdd length] > 0)
        {
            [self alertUserOfDuplicateEntryOfString:characterToAdd];
        }
        else if ([characterToAdd isEqualToString:@""])
        {
            
        }
        else
        {
            //NSLog(@"recognized wordtoignoretextfield");
            
            [self.wordsToIgnoreMutableArray addObject:characterToAdd];
            
            [self.wordsToIgnoreMutableArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            NSIndexPath *indexPathForWord = [NSIndexPath indexPathForRow:[self.wordsToIgnoreMutableArray indexOfObject:characterToAdd] inSection:self.wordToIgnoreTableView.numberOfSections-1];
            
            [self.wordToIgnoreTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForWord] withRowAnimation:UITableViewRowAnimationFade];
            
            // Write to file
            [self.wordsToIgnore saveWords:self.wordsToIgnoreMutableArray];
            
            [self.wordToIgnoreTableView reloadData];
            
            [self.wordToIgnoreTableView scrollToRowAtIndexPath:indexPathForWord atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            // Clear the textField
            self.wordToIgnoreTextField.text = @"";
        }
    }
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //NSLog(@"Touches began");
    [self.characterToTrimTextField resignFirstResponder];
    [self.wordToIgnoreTextField resignFirstResponder];
}

#pragma mark Table View Delegate methods

-(void)setupDataSource
{
    UITableViewCell* (^cellForRowAtIndexPathBlock)(NSIndexPath *indexPath, UITableView *tableView) = ^UITableViewCell*(NSIndexPath *indexPath, UITableView *tableView) {
        return (tableView == self.characterToTrimTableView) ?
        [self configureCharCellUsingTableView:self.characterToTrimTableView atIndexPath:indexPath] :
        [self configureWordCellUsingTableView:self.wordToIgnoreTableView atIndexPath:indexPath];
    };
    
    void (^deleteCellBlock)(NSIndexPath *indexPath, UITableView *tableView) = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
        (tableView == self.characterToTrimTableView) ?
        [self.charactersToTrimMutableArray removeObjectAtIndex:indexPath.row]:
        [self.wordsToIgnoreMutableArray removeObjectAtIndex:indexPath.row];
        
        (tableView == self.characterToTrimTableView) ?
        [self.charactersToTrim saveCharacters:self.charactersToTrimMutableArray]:
        [self.wordsToIgnore saveWords:self.wordsToIgnoreMutableArray];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    NSInteger (^numberOfRowsInSectionBlock)(UITableView *tableView) = ^NSInteger(UITableView *tableView) {
        int numberOfRowsToReturn = 0;
        if (tableView == self.wordToIgnoreTableView)
        {
            numberOfRowsToReturn = (int)[self.wordsToIgnoreMutableArray count];
            //NSLog(@"Counting rows:%d", numberOfRowsToReturn);
        }
        if (tableView == self.characterToTrimTableView)
        {
            numberOfRowsToReturn = (int)[self.charactersToTrimMutableArray count];
        }
        return numberOfRowsToReturn;
    };
    
    BOOL (^canEditRowsBlock)() = ^BOOL() {
        
        return self.hasPurchasedEditingFeatures ? YES : NO;
    };
    
    self.dataSource = [[HWGOptionsDataSource alloc] initWithRowsInSectionBlock:numberOfRowsInSectionBlock CellForRowAtIndexPathBlock:cellForRowAtIndexPathBlock CanEditRowAtIndexPathBlock:canEditRowsBlock DeleteCellBlock:deleteCellBlock];
    
    self.wordToIgnoreTableView.dataSource = self.dataSource;
    self.wordToIgnoreTableView.delegate = self.dataSource;
    self.characterToTrimTableView.dataSource = self.dataSource;
    self.characterToTrimTableView.delegate = self.dataSource;
}

-(HWGWordToIgnoreTableViewCell *)configureWordCellUsingTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    HWGWordToIgnoreTableViewCell *cell = (HWGWordToIgnoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"wordToIgnoreTableViewCell" forIndexPath:indexPath];
    cell.label.text = @"No words in storage";
    if ([self.wordsToIgnoreMutableArray count] > 0)
    {
        cell.label.text = [self.wordsToIgnoreMutableArray objectAtIndex:indexPath.row];
    }
    return cell;
}

-(HWGCharacterToTrimTableViewCell *)configureCharCellUsingTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    HWGCharacterToTrimTableViewCell *cell = (HWGCharacterToTrimTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"characterToTrimTableViewCell" forIndexPath:indexPath];
    cell.label.text = @"No characters in storage";
    if ([self.charactersToTrimMutableArray count] > 0)
    {
        cell.label.text = [self.charactersToTrimMutableArray objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark View methods

-(void)tapReceived:(UITapGestureRecognizer *)gesture
{
    if ([self.characterToTrimTextField isFirstResponder])
    {
        [self.characterToTrimTextField resignFirstResponder];
    }
    else if ([self.wordToIgnoreTextField isFirstResponder])
    {
        [self.wordToIgnoreTextField resignFirstResponder];
    }
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded && !self.characterToTrimTextField.enabled && !self.wordToIgnoreTextField.enabled)
    {
        CGRect wordTextFieldSize = [self getTextFieldSizeOfTextField:self.wordToIgnoreTextField];
        CGRect charTextFieldSize = [self getTextFieldSizeOfTextField:self.characterToTrimTextField];
        
        if (CGRectContainsPoint(wordTextFieldSize, point) || CGRectContainsPoint(charTextFieldSize, point))
        {
            [self alertUserThatPurchaseIsRequired];
        }
    }
}

-(CGRect)getTextFieldSizeOfTextField:(UITextField *)textField
{
    return CGRectMake(textField.frame.origin.x, textField.frame.origin.y+self.scrollView.frame.origin.y-self.scrollView.contentOffset.y, textField.frame.size.width, textField.frame.size.height);
}

-(CGRect)getLargestSize
{
    CGRect largestSize = CGRectMake(0, -200,
                                    (self.view.frame.size.height > self.view.frame.size.width) ? self.view.frame.size.height : self.view.frame.size.width,
                                    (self.view.frame.size.height > self.view.frame.size.width) ? self.view.frame.size.height+15*self.navigationController.navigationBar.frame.size.height : self.view.frame.size.width+15*self.navigationController.navigationBar.frame.size.height);
    return largestSize;
}

-(void)loadBackground
{
    
    //NSLog(@"iPad model is %@", [[UIDevice currentDevice] model]);
    UIImage *backgroundImage = [UIImage imageNamed:@"NotebookLarge.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:[self getLargestSize]];
    backgroundImageView.alpha = 0.3f;
    backgroundImageView.image=backgroundImage;
    [self.viewToInsertBackgroundImage insertSubview:backgroundImageView atIndex:0];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hasPurchasedEditingFeatures = [[NSUserDefaults standardUserDefaults] boolForKey:@"purchased"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadBackground];
    self.willHighlightInSequenceSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:StudyAidWillHighlightInSequencePrefKey];
    self.characterToTrimTableView.rowHeight = 27;
    self.wordToIgnoreTableView.rowHeight = 27;
    
    [self setupDataSource];
    
    [self registerForKeyboardNotifications];
    //self.scrollView.contentSize = self.view.frame.size;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLayoutSubviews
{
    [self.scrollView setContentInset:UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)];
    // self.characterToTrimTextView.text = @"";
    // self.wordToIgnoreTextView.text = @"";
    
    [self loadColorAndWordsAndCharacters];

    if (!self.hasPurchasedEditingFeatures)
    {
        [self disableTextFields];
        [self restrictUserToYellowHighlighter];
    }

}

-(void)unlockColors
{
    self.highlighterColor = [self.colorToStore loadColor];
    
    if (self.colorToStore)
    {
        for (UIButton *button in [self highlighterButtonsArray])
        {
            [button setTitle:@"" forState:UIControlStateNormal];
            
            if ([self.highlighterColor isEqual:button.backgroundColor])
            {
                [button setTitle:@"✍" forState:UIControlStateNormal];
            }
        }
        
    }
}

-(void)loadColorAndWordsAndCharacters
{
    
    // NSLog(@"Highlightercolor is %@", self.highlighterColor);
    [self unlockColors];
    
        [self.wordsToIgnoreMutableArray removeAllObjects];
        [self.wordsToIgnoreMutableArray addObjectsFromArray:[self.wordsToIgnore loadWords]];
        [self.wordsToIgnoreMutableArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

        [self.charactersToTrimMutableArray removeAllObjects];
        [self.charactersToTrimMutableArray addObjectsFromArray:[self.charactersToTrim loadCharacters]];

}

#pragma mark TextField Limits

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.characterToTrimTextField)
    {
        // Prevent crashing undo bug – if the user copies and pastes text longer than the limit and tries to undo
        // Make sure the range the app proposes to replace exists
        if(range.length + range.location > textField.text.length || [string isEqualToString:@" "])
        {
            return NO;
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range                          withString:string];
        return !([newString length] > 1);
    }
    else
    {
        if ([string isEqualToString:@" "] )
        {
            return NO;
        }
    return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
