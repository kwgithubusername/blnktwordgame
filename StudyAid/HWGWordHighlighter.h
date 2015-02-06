//
//  HWGWordHighlighter.h
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWGWordHighlighter : NSObject

-(instancetype)init;
-(void)hideWordsInTextView:(UITextView *)words inWordRange:(NSRange)range;
-(void)highlightTextView:(UITextView *)words withColor:(UIColor *)color inRange:(NSRange)range;
-(void)removeHighlightsFromTextView:(UITextView *)words;

@end
