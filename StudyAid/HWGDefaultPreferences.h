//
//  HWGDefaultPreferences.h
//  StudyAid
//
//  Created by Woudini on 1/16/15.
//  Copyright (c) 2015 Hi Range. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const StudyAidHiddenWordPercentagePrefKey = @"StudyAidHiddenWordPercentagePrefKey";
static NSString * const StudyAidWordsToIgnoreDPPrefKey = @"StudyAidWordsToIgnorePrefKey";
static NSString * const StudyAidCharactersToTrimDPPrefKey = @"StudyAidCharactersToTrimPrefKey";
static NSString * const StudyAidWillHighlightInSequencePrefKey = @"StudyAidWillHighlightInSequencePrefKey";

@interface HWGDefaultPreferences : NSObject

-(instancetype)init;
-(void)loadDefaults;
-(void)setSliderValueUsingInt:(int)value;
-(int)getSliderValue;
- (NSSet *)defaultCharactersToTrim;
- (NSSet *)defaultWordsToIgnore;

@end
