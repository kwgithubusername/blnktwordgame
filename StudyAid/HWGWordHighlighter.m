//
//  HWGWordHighlighter.m
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import "HWGWordHighlighter.h"

@implementation HWGWordHighlighter



- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)hideWordsInTextView:(UITextView *)words inWordRange:(NSRange)range
{
    [words.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:range];
}


-(void)highlightTextView:(UITextView *)words withColor:(UIColor *)color inRange:(NSRange)range
{
    [words.textStorage addAttribute:NSForegroundColorAttributeName
                              value:color
                              range:range];
    [words.textStorage addAttribute:NSBackgroundColorAttributeName
                              value:color
                              range:range];
    /*[words.textStorage addAttribute:(NSString*)kCTUnderlineStyleAttributeName
     value:[NSNumber numberWithInt:kCTUnderlineStyleThick]
     range:self.selectedWordRange];
     [words.textStorage addAttribute:NSUnderlineColorAttributeName
     value:[UIColor blackColor]
     range:self.selectedWordRange]; */
}

-(void)removeHighlightsFromTextView:(UITextView *)words
{
    [words.textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[words.text rangeOfString:words.text]];
    
    /*[words.textStorage addAttribute:(NSString*)kCTUnderlineStyleAttributeName
     value:[NSNumber numberWithInt:kCTUnderlineStyleNone]
     range:[words.text rangeOfString:words.text]];*/
    
    [words.textStorage addAttribute:NSBackgroundColorAttributeName
                              value:[UIColor whiteColor]
                              range:[words.text rangeOfString:words.text]];
}
@end
