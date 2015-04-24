//
//  ViewController.m
//  StudyAid
//
//  Created by Woudini on 12/28/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import "HWGTextViewController.h"
#import "HiddenWordGame.h"
#import "HWGTextViewText.h"
#import "HWGOptionsViewController.h"
#import "HWGOptionsColorToStore.h"
#import "HWGOptionsCharactersToTrim.h"
#import "HWGOptionsWordsToIgnore.h"
#import "HWGDefaultPreferences.h"
#import <DBChooser/DBChooser.h>
#import "MBProgressHUD.h"

@interface HWGTextViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *uploadBarButton;
@property (weak, nonatomic) IBOutlet UIView *viewToInsertBackgroundImage;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) HiddenWordGame *wordGame;
@property (strong, nonatomic) HWGTextViewText *textStorage;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *hintButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *percentHiddenLabel;
@property (nonatomic) NSMutableArray *filteredWordArray;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property BOOL buttonPressed;
@property (nonatomic) HWGDefaultPreferences *defaultPreferences;
@property (nonatomic) HWGOptionsColorToStore *optionsColorToLoad;
@property (nonatomic) HWGOptionsCharactersToTrim *optionsCharToTrim;
@property (nonatomic) HWGOptionsWordsToIgnore *optionsWordsToIgnore;

@end

@implementation HWGTextViewController

# pragma mark - Dropbox -

- (IBAction)loadFileButtonTapped:(UIBarButtonItem *)sender
{
    [self removeKeyboard];
    //NSLog(@"button tapped");
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypeDirect fromViewController:self completion:^(NSArray *results)
     {
         if ([results count])
         {
             DBChooserResult *result = [results firstObject];
             NSURL *url = result.link;
             //NSLog(@"link is %@", url);
             [self loadTextFileFromURL:url];
         }
     }];
}

-(void)loadTextFileFromURL:(NSURL *)url
{
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@",url];
    if ([URLString containsString:@".txt"])
    {
        NSError *error = nil;
        NSString *textString = [[NSString alloc] initWithContentsOfURL:url
                                                              encoding: NSUTF8StringEncoding
                                                                 error: &error];
        self.textView.text = textString;
        [self.textStorage saveText:self.textView.text];
    }
    else
    {
        [self alertUserThatFileSelectedWasNotTextFile];
    }
}

-(void)alertUserThatFileSelectedWasNotTextFile
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid File Format" message:@"Only .txt files are currently supported. Please select a .txt file to load." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

# pragma mark - Segue to options -

-(void)removeNavBarTapToRemoveKeyboardView
{
    for (UIView *inappropriateView in self.navigationController.navigationBar.subviews)
    {
        if (inappropriateView.tag == 999)
        {
            //NSLog(@"inappropriate view found");
            [inappropriateView removeFromSuperview];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"options"])
    {
        HWGOptionsViewController *ovc = segue.destinationViewController;
        
        // Initialize arrays for the NSUserDefaults to be temporarily stored to display
        ovc.charactersToTrimMutableArray = [[NSMutableArray alloc] init];
        ovc.wordsToIgnoreMutableArray = [[NSMutableArray alloc] init];
        //NSLog(@"number of subviews in navbar:%d", [self.navigationController.navigationBar.subviews count]);
        [self removeNavBarTapToRemoveKeyboardView];
    }
}

#pragma mark - Load preferences from options -

-(HWGDefaultPreferences *)defaultPreferences
{
    if (!_defaultPreferences) _defaultPreferences = [[HWGDefaultPreferences alloc] init];
    return _defaultPreferences;
}

-(HWGOptionsColorToStore *)optionsColorToLoad
{
    if (!_optionsColorToLoad) _optionsColorToLoad = [[HWGOptionsColorToStore alloc] init];
    return _optionsColorToLoad;
}

-(HWGOptionsCharactersToTrim *)optionsCharToTrim
{
    if (!_optionsCharToTrim) _optionsCharToTrim = [[HWGOptionsCharactersToTrim alloc] init];
    return _optionsCharToTrim;
}

-(HWGOptionsWordsToIgnore *)optionsWordsToIgnore
{
    if (!_optionsWordsToIgnore) _optionsWordsToIgnore = [[HWGOptionsWordsToIgnore alloc] init];
    return _optionsWordsToIgnore;
}

# pragma mark - TextView -

-(HWGTextViewText *)textStorage
{
    if (!_textStorage) _textStorage = [[HWGTextViewText alloc] init];
    return _textStorage;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *checkIfEmptyString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL isOnlySpaces = [checkIfEmptyString isEqualToString:@""];
    
    if (isOnlySpaces)
    {
        (self.startButton.enabled = NO);
    }
    else
    {
        (self.startButton.enabled = YES);
    }
    self.hintButton.enabled = NO;
    self.checkButton.enabled = NO;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    //NSLog(@"textview ended editing");
    [self.textStorage saveText:self.textView.text];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self enableScrollView];
}

#pragma mark - Setup -

-(void)setupDefaults
{
    [self.defaultPreferences loadDefaults];
}

#pragma mark - Word game initializers -

-(HiddenWordGame *)wordGame
{
    if (!_wordGame) _wordGame = [[HiddenWordGame alloc] init];
    return _wordGame;
}

- (void)setFilteredWordArray:(NSMutableArray *)filteredWordArray
{
    self.wordGame.filteredWordArray = filteredWordArray;
    _filteredWordArray = filteredWordArray;
}

# pragma mark - Buttons -

-(void)disableButtons
{
    self.hintButton.enabled = NO;
    self.checkButton.enabled = NO;
}

-(void)enableButtons
{
    self.hintButton.enabled = YES;
    self.checkButton.enabled = YES;
}

- (IBAction)hideWordsButton:(UIButton *)sender
{
    self.buttonPressed = YES;
    [self dismissKeyboard];
    
    // Inform the user that the system is busy
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hiding words..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];

    // Create an indicator for the alert and show the alert
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    [alertView setValue:indicator forKey:@"accessoryView"];
    [alertView show];
    
    // Allow the game to iterate through the words again
    self.wordGame.gameOver = NO;
    
    // Reset the textfield text
    self.textField.text = @"";

    // Reset buttons
    [self enableButtons];
    
    // Get a background thread to run on
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self filterAndCalculateWords];
        float percentToHide = self.slider.value;
        
        // NSLog(@"Slider at %f", percentToHide);
        self.wordGame.percentToHide = percentToHide;
        
        // update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.wordGame startWordGame:self.textView withHighlighterColor:[self.optionsColorToLoad loadColor] InSequence:[[NSUserDefaults standardUserDefaults] boolForKey:StudyAidWillHighlightInSequencePrefKey]];
        });
        
    });
    
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
- (IBAction)hintButton:(UIButton *)sender
{
    self.textField.text = [self.wordGame giveHint];
    //NSLog(@"HINT BUTTON PRESSED");
    self.buttonPressed = YES;
}
- (IBAction)checkButton:(UIButton *)sender
{
    if ([self.wordGame checkString:self.textField.text withTextView:self.textView])
    {
        self.textField.text = @"";
        if(self.wordGame.gameOver)
        {
            [self disableButtons];
        }
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Try again";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }
    self.buttonPressed = YES;
    [self.view endEditing:YES];
}

- (IBAction)restoreButton:(UIButton *)sender
{
    [self.wordGame.wordHighlighter removeHighlightsFromTextView:self.textView];
    [self disableButtons];
    self.buttonPressed = YES;
    [self dismissKeyboard];
}

# pragma mark - Slider -

- (void)filterAndCalculateWords
{
    NSArray *untrimmedWordArray = [self.wordGame.commonWordFilter filterWordsFromString:self.textView.text];
    
    // Reset the filteredWordArray
    [self.filteredWordArray removeAllObjects];
    
    NSMutableArray *trimmedWordMutableArray = [[NSMutableArray alloc] initWithArray:untrimmedWordArray];
    
    for (NSString *untrimmedWord in untrimmedWordArray)
    {
        [trimmedWordMutableArray addObject:[self.wordGame.invalidCharacterRemover removeInvalidCharactersFromString:untrimmedWord]];
        [self.filteredWordArray addObject:[self.wordGame.invalidCharacterRemover removeInvalidCharactersFromString:untrimmedWord]];
    }
    
    for (NSString *invalidString in trimmedWordMutableArray)
    {
        if ([invalidString isEqualToString:@""])
        {
            [self.filteredWordArray removeObject:invalidString];
        }
    }
    
    self.filteredWordArray = [self.wordGame.commonWordFilter filterWordsFromMutableArray:self.filteredWordArray];
    
    //NSLog(@"Filtered and trimmed:%@",self.filteredWordArray);
}


- (void)sliderChanged
{
    [self.defaultPreferences setSliderValueUsingInt:self.slider.value];
    float percentToHide = self.slider.value;
    
    //NSLog(@"Slider at %f", percentToHide);
    self.wordGame.percentToHide = percentToHide;
    [self disableButtons];

    [self filterAndCalculateWords];
    
    int numberOfWords = (int)[self.filteredWordArray count];
    //NSLog(@"Percent to hide: %f", self.wordGame.percentToHide);
    int numberOfWordsToHide = self.wordGame.percentToHide * numberOfWords;
    if (numberOfWordsToHide == 0)
    {
        numberOfWordsToHide = 1;
    }
    
    self.percentHiddenLabel.text = [[NSString alloc] initWithFormat:@"Hiding %d of %d filtered words", numberOfWordsToHide, numberOfWords];
}

# pragma mark - Keyboard -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self checkButton:self.checkButton];
    [textField resignFirstResponder];
    return YES;
}
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // Enable scrolling
    [self enableScrollView];
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    /*
    if ([self.textView isFirstResponder])
    {
        UITextRange *range = self.textView.selectedTextRange;
        UITextPosition *position = range.start;
        CGRect cursorRect = [self.textView caretRectForPosition:position];
        CGPoint cursorPoint = CGPointMake(self.textView.frame.origin.x + cursorRect.origin.x, self.textView.frame.origin.y + cursorRect.origin.y);
        if (!CGRectContainsPoint(aRect, cursorPoint) ) {
            [self.scrollView scrollRectToVisible:cursorRect animated:YES];
        }
    }
    */
    // Only scroll down if the textField is the responder; it should not scroll if the textView is the responder
    if ([self.textField isFirstResponder])
    {
        // If active text field is hidden by keyboard, scroll it so it's visible
        if (!CGRectContainsPoint(aRect, self.textField.frame.origin) ) {
            [self.scrollView scrollRectToVisible:self.textField.frame animated:YES];
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
    
    // Prevent extra space from being created
    // self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-25);

    [self.scrollView scrollRectToVisible:CGRectMake(1,1,1,1) animated:YES];
    // This *should* make the scroll view go back up
    
    [self disableScrollView];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    //NSLog(@"TAP RECEIVED");
    [self removeKeyboard];

}

-(void)removeKeyboard
{
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    }
    else if ([self.textView isFirstResponder])
    {
        [self.textView resignFirstResponder];
    }
}

-(CGRect)getLargestSizeOfFrameSize:(CGSize)size
{
    CGFloat largestLengthOrWidth = (size.height > size.width) ? size.height : size.width;
    CGRect largestSize = CGRectMake(0, 0, largestLengthOrWidth, largestLengthOrWidth);
    return largestSize;
}

-(void)loadBackground
{
    //NSLog(@"iPad model is %@", [[UIDevice currentDevice] model]);
    UIImage *backgroundImage = [UIImage imageNamed:@"NotebookLarge.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:[self getLargestSizeOfFrameSize:self.view.frame.size]];
    backgroundImageView.alpha = 0.3f;
    backgroundImageView.image=backgroundImage;
    [self.viewToInsertBackgroundImage insertSubview:backgroundImageView atIndex:0];

}

#pragma mark - View methods -
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaults];
    
    [self loadBackground];

    if ([[self.textStorage loadText] length] > 0)
    {
        self.textView.text = [self.textStorage loadText];
    }
    
    // Get the array ready to calculate the number needed for the slider
    self.filteredWordArray = [[NSMutableArray alloc] init];
    NSInteger hiddenWordPercentageValue = [self.defaultPreferences getSliderValue];
    self.slider.value = hiddenWordPercentageValue;
    
    // Reset textField, navbartitle and buttons
    self.textField.text = @"";
    self.navigationItem.title = @"Blankout";
    [self disableButtons];
    [self.slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    [self sliderChanged];
    
    // Keyboard notifications
    [self registerForKeyboardNotifications];
    
    
    //self.scrollView.contentSize = self.view.frame.size;
    
    // Tap to make keyboard disappear
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // Sign up for orientation notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetContentSize) name:UIDeviceOrientationDidChangeNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) setupNavbarGestureRecognizer {
    // recognise taps on navigation bar to hide
    [self removeNavBarTapToRemoveKeyboardView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    gestureRecognizer.numberOfTapsRequired = 1;
    // create a view which covers most of the tap bar to
    // manage the gestures - if we use the navigation bar
    // it interferes with the nav buttons
    CGRect frame = CGRectMake(80, 0, self.view.frame.size.width-160, self.navigationController.navigationBar.frame.size.height);
    UIView *navBarTapView = [[UIView alloc] initWithFrame:frame];
    [self.navigationController.navigationBar addSubview:navBarTapView];
    navBarTapView.backgroundColor = [UIColor clearColor];
    [navBarTapView setUserInteractionEnabled:YES];
    [navBarTapView addGestureRecognizer:gestureRecognizer];
    navBarTapView.tag = 999;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove self as an observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)resetContentSize
{
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height*2);
}

- (void)disableScrollView
{
    self.scrollView.scrollEnabled = NO;
}

- (void)enableScrollView
{
    self.scrollView.scrollEnabled = YES;
}

- (void)viewDidLayoutSubviews
{
    [self setupNavbarGestureRecognizer];
    [self enableScrollView];
    if (!self.buttonPressed)
    {
        [self.scrollView setContentInset:UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)];
        [self disableScrollView];
    }
    self.buttonPressed = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self setupNavbarGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
