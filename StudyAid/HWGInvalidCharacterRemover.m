//
//  HWGInvalidCharacterRemover.m
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import "HWGInvalidCharacterRemover.h"

NSString * const StudyAidCharactersToTrimAltPrefKey = @"StudyAidCharactersToTrimPrefKey";

@implementation HWGInvalidCharacterRemover

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (NSString *)removeInvalidCharactersFromString:(NSString *)string
{
    NSArray *arrayOfInvalidCharacters = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:StudyAidCharactersToTrimAltPrefKey]];
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (NSString *invalidCharacter in arrayOfInvalidCharacters)
    {
        [mutableString appendString:invalidCharacter];
    }
    NSString *invalidCharacterString = mutableString;
    NSString *fixedWord = string;
    NSCharacterSet *invalidSet = [NSCharacterSet characterSetWithCharactersInString:invalidCharacterString];
    // NSLog(@"fixedword is %@", fixedWord);
    fixedWord = [fixedWord stringByTrimmingCharactersInSet:invalidSet];
    
    //wordToFix = [@"poop," stringByReplacingOccurrencesOfString:@"," withString:@""];
    //NSString *fixedWord2 = [wordToFix stringByReplacingOccurrencesOfString:@"." withString:@""];
    // NSLog(@"Word %@ fixed to %@", string, fixedWord);
    
    return fixedWord;
}

@end
