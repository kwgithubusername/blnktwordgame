//
//  HiddenWordGame.h
//  StudyAid
//
//  Created by Woudini on 12/28/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWGWordHighlighter.h"
#import "HWGCommonWordFilter.h"
#import "HWGInvalidCharacterRemover.h"
@interface HiddenWordGame : NSObject

@property (nonatomic, strong) NSMutableDictionary *selectedWords;
@property BOOL gameOver;
@property (nonatomic) int hintIndex;
@property (nonatomic) float percentToHide;
@property (nonatomic) HWGWordHighlighter *wordHighlighter;
@property (nonatomic) HWGCommonWordFilter *commonWordFilter;
@property (nonatomic) HWGInvalidCharacterRemover *invalidCharacterRemover;
@property (nonatomic) NSMutableArray *filteredWordArray;

-(instancetype)init;
-(void)startWordGame:(UITextView *)words withHighlighterColor:(UIColor *)color InSequence:(BOOL)willHighlightInSequence;
-(NSString *)giveHint;
-(BOOL)checkString:(NSString *)text withTextView:(UITextView *)words;

@end
