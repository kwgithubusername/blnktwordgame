//
//  HiddenWordGame.m
//  StudyAid
//
//  Created by Woudini on 12/28/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import "HiddenWordGame.h"
#import "HWGWordAndRangeStorage.h"
#import "HWGWordAndRangeStorageToHighlight.h"
#import "HWGWordSearcher.h"
// #import <CoreText/CoreText.h>

@interface HiddenWordGame ()

@property (nonatomic) HWGWordAndRangeStorage *wordAndRangeStorage;
@property (nonatomic) HWGWordAndRangeStorageToHighlight *wordAndRangeStorageToHighlight;
@property (nonatomic) HWGWordSearcher *wordSearcher;
@property (nonatomic) NSString *selectedWordToHighlight;
@property (nonatomic) NSRange selectedWordRange;
@property (nonatomic) NSMutableArray *rangesMutableArray;
@property (nonatomic) NSMutableDictionary *rangesMutableDictionary;
@property (nonatomic) NSMutableArray *storedWordMutableArray;
@property (nonatomic) NSMutableArray *tempWordMutableArray;
@property (nonatomic) UIColor *highlighterColor;
@property (nonatomic) BOOL willHighlightInSequence;
@end

@implementation HiddenWordGame

#pragma mark - Initializer -

-(void)setup
{
    self.filteredWordArray = [[NSMutableArray alloc] init];
    self.storedWordMutableArray = [[NSMutableArray alloc] init];
    self.tempWordMutableArray = [[NSMutableArray alloc] init];
}

-(instancetype)init;
{
    self = [super init];
    if (self)
    {
        [self setup];
        [self resetGame];
    }
    return self;
}


#pragma mark - Create classes -

-(HWGInvalidCharacterRemover *)invalidCharacterRemover
{
    if (!_invalidCharacterRemover) _invalidCharacterRemover = [[HWGInvalidCharacterRemover alloc] init];
    return _invalidCharacterRemover;
}

-(HWGCommonWordFilter *)commonWordFilter
{
    if (!_commonWordFilter) _commonWordFilter = [[HWGCommonWordFilter alloc] init];
    return _commonWordFilter;
}

-(HWGWordHighlighter *)wordHighlighter
{
    if (!_wordHighlighter) _wordHighlighter = [[HWGWordHighlighter alloc] init];
    return _wordHighlighter;
}

-(HWGWordAndRangeStorage *)wordAndRangeStorage
{
    if (!_wordAndRangeStorage) _wordAndRangeStorage = [[HWGWordAndRangeStorage alloc] init];
    return _wordAndRangeStorage;
}

-(HWGWordAndRangeStorageToHighlight *)wordAndRangeStorageToHighlight
{
    if (!_wordAndRangeStorageToHighlight) _wordAndRangeStorageToHighlight = [[HWGWordAndRangeStorageToHighlight alloc] init];
    return _wordAndRangeStorageToHighlight;
}

-(HWGWordSearcher *)wordSearcher
{
    if (!_wordSearcher) _wordSearcher = [[HWGWordSearcher alloc] init];
    return _wordSearcher;
}

#pragma mark - Preparing/Resetting the game -

-(void)resetFormattingInTextView:(UITextView *)textView
{
    [self.wordHighlighter removeHighlightsFromTextView:textView];
}

-(void)clearAllWordAndRangeStorage
{
    self.wordAndRangeStorage = nil;
    self.wordAndRangeStorageToHighlight = nil;
    self.wordHighlighter = nil;
    self.wordSearcher = nil;
}

-(void)loadColor:(UIColor *)color
{
    if (color)
    {
        // Use the color that was loaded
        self.highlighterColor = color;
    }
    else
    {
        // Safely let the game continue with the default color but log an error
        NSLog(@"Error: User defaults for color were not initally registered- selecting yellow");
        self.highlighterColor = [UIColor yellowColor];
    }
}

-(NSArray *)loadWordsToHideFromMutableArray:(NSMutableArray *)wordArray
{
    //NSLog(@"Filtered word array is %@", self.filteredWordArray);
    
    // Use an NSSet to get unique words only so that the HWGWordSearcher is only searching for the ranges of each word once
    [wordArray setArray:[[NSSet setWithArray:wordArray] allObjects]];
    //NSLog(@"Unique words array is %@", wordArray);
    
    // Reset the words from longest to shortest so that the HWGWordAndRangeStorage can properly block any embedded words
    NSArray *array = [wordArray sortedArrayUsingComparator:^NSComparisonResult(NSString *value1, NSString *value2) {
        NSComparisonResult result = NSOrderedSame;
        if (value1.length > value2.length) {
            result = NSOrderedAscending;
        } else if (value1.length < value2.length) {
            result = NSOrderedDescending;
        }
        return result;
    }];
    return array;
}

-(int)loadNumberOfWordsToHideFromMutableArray:(NSMutableArray *)wordArray
{
    // Count the number of words - not safe for 64 bit even with less than 2^31-1 elements
    int numberOfWords = (int)[wordArray count];
    
    // Figure out how many words to hide
    //NSLog(@"Percent to hide: %f", self.percentToHide);
    int numberOfWordsToHide = self.percentToHide * numberOfWords;
    if (numberOfWordsToHide == 0)
    {
        numberOfWordsToHide = 1;
    }
    //NSLog(@"Hiding %d of %d words", numberOfWordsToHide, numberOfWords);
    return numberOfWordsToHide;
    
}

-(void)loadRangesFromArrayOfWords:(NSArray *)wordsToHide inTextView:(UITextView *)textView
{
    for (NSString *word in wordsToHide)
    {
        // Find all unique occurrences of the word
        NSArray *rangesArray = [self.wordSearcher searchForRangesOfString:word inString:textView.text];
        
        // Store each occurrence with an instance of the word
        [self.wordAndRangeStorage storeRanges:rangesArray forWord:word];
    }
}

#pragma mark - Hide Words methods -

-(void)hideNumberOfWords:(int)numberOfWordsToHide inTextView:(UITextView *)textView
{
    for (int i = 0; i < numberOfWordsToHide; i++)
    {
        // Draw a random word and range
        
        // Store the range and word
        self.tempWordMutableArray = [self.wordAndRangeStorage getRandomRangeAndWord];
        
        NSRange range;
        NSValue *unwrapper = [self.tempWordMutableArray objectAtIndex:0];
        [unwrapper getValue:&range];
        
        // Hide the word
        [self.wordHighlighter hideWordsInTextView:textView inWordRange:range];
        //NSLog(@"Hiding %@ with range %@ at range %@", [self.tempWord objectAtIndex:1], [self.tempWord objectAtIndex:0], NSStringFromRange(range));
        
        // Store each word and range that is hidden for the highlighter method to choose from
        [self.wordAndRangeStorageToHighlight storeRangeForWord:self.tempWordMutableArray];
        
        // Ensure that the next word that is hidden is unique
        [self.wordAndRangeStorage removeRangeForWord];
    }
}

-(void)startWordGame:(UITextView *)textView withHighlighterColor:(UIColor *)color InSequence:(BOOL)willHighlightInSequence
{
    // If the colorStorage was able to load a color (and it should, since it was registered as a default in the view controller
    [self loadColor:color];
    
    // New game needs a hint index of 0
    self.hintIndex = 0;

    // Reset formatting
    [self resetFormattingInTextView:textView];
    
    // Clear all word and range storage
    [self clearAllWordAndRangeStorage];
    
    // Remove invalid characters (e.g. ;,:)
    NSMutableArray *wordArray = self.filteredWordArray;
    
    //NSLog(@"wordArray is %@", self.filteredWordArray);
    
    int numberOfWordsToHide = [self loadNumberOfWordsToHideFromMutableArray:wordArray];
    //NSLog(@"word array is %d", [wordArray count]);
    
    NSArray *wordsToHide = [[NSArray alloc] initWithArray:[self loadWordsToHideFromMutableArray:self.filteredWordArray]];
    
    
    
    // Get the ranges for every word
    [self loadRangesFromArrayOfWords:wordsToHide inTextView:textView];
    
    // Hide only a certain number of words
    [self hideNumberOfWords:numberOfWordsToHide inTextView:textView];
    
    [self highlightRandomWordInTextView:textView InSequence:willHighlightInSequence];
}

#pragma mark - Highlight methods -

-(void)highlightRandomWordInTextView:(UITextView *)textView InSequence:(BOOL)willHighlightInSequence;
{
    
    // Randomly select a word and its range
    if (willHighlightInSequence)
    {
        self.storedWordMutableArray = [self.wordAndRangeStorageToHighlight getRangeAndWordInSequence];
    }
    else
    {
        self.storedWordMutableArray = [self.wordAndRangeStorageToHighlight getRandomRangeAndWord];
    }


    NSRange range;
    NSValue *unwrapper = [self.storedWordMutableArray objectAtIndex:0];
    [unwrapper getValue:&range];
    
    //NSLog(@"Word selected to highlight:%@", self.storedWordMutableArray);
    
    // Highlight the word at that range
    [self.wordHighlighter highlightTextView:textView withColor:self.highlighterColor inRange:range];

    // Store the range
    self.selectedWordRange = range;
    //NSLog(@"HRange is %@", NSStringFromRange(self.selectedWordRange));
    // Scroll to the next word
    [textView scrollRangeToVisible:self.selectedWordRange];
    
    // Remove the range and index range for that word
    [self.wordAndRangeStorageToHighlight removeRangeForWord:self.storedWordMutableArray];
    
    self.willHighlightInSequence = willHighlightInSequence;
}

-(BOOL)checkString:(NSString *)text withTextView:(UITextView *)words
{
    if ([self.wordAndRangeStorageToHighlight.selectedWord caseInsensitiveCompare:text] == NSOrderedSame)
    {
        self.hintIndex = 0;
        
        // Reveal the word
        [words.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:self.selectedWordRange];
        
        //NSLog(@"HRange is %@", NSStringFromRange(self.selectedWordRange));
        // If the user has iterated through all words in selectedWords, end the game; if not, continue to the next word
        if (self.wordAndRangeStorageToHighlight.indexMutableArray == nil || [self.wordAndRangeStorageToHighlight.indexMutableArray count] == 0)
        {
            //NSLog(@"Array is empty- game over");
            self.gameOver = YES;
        }
        else
        {
        [self highlightRandomWordInTextView:words InSequence:self.willHighlightInSequence];
        }
        // User has submitted the correct string
        return YES;
    }
    else
    {
        // User has submitted the incorrect string
        return NO;
    }
}

#pragma mark - Hint methods -

-(NSString *)giveHint
{
    NSMutableString *hint = [[NSMutableString alloc] init];
    for (int i = 0; i <= self.hintIndex; i++)
    {
        [hint appendString:[NSString stringWithFormat:@"%c", [[self.storedWordMutableArray objectAtIndex:1] characterAtIndex:i]]];
    }
    self.hintIndex++;
    return hint;
}

-(void)setHintIndex:(int)hintIndex
{
    if ([self.storedWordMutableArray count] > 0)
    {
        if (hintIndex < [[self.storedWordMutableArray objectAtIndex:1] length] && hintIndex >= 0)
        {
            _hintIndex = hintIndex;
        }
    }
    else
    {
        _hintIndex = hintIndex;
    }
}

-(void)setPercentToHide:(float)percentToHide
{
    _percentToHide = percentToHide * 0.01;
}

-(void)resetGame
{
    self.hintIndex = 0;
}

@end

