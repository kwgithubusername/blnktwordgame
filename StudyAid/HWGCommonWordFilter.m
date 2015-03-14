//
//  HWGCommonWordFilter.m
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import "HWGCommonWordFilter.h"

NSString * const StudyAidWordsToIgnoreAltPrefKey = @"StudyAidWordsToIgnorePrefKey";

@implementation HWGCommonWordFilter

- (instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (NSArray *)separateArray:(NSArray *)array ByString:(NSString *)separatingString
{
    NSString *wordsJoined = [array componentsJoinedByString:separatingString];
    NSArray *usableWords = [wordsJoined componentsSeparatedByString:separatingString];
    return usableWords;
}

- (NSArray *)separateStringIntoWords:(NSString *)string
{   /*
    NSLog(@"usable words are %@", [string componentsSeparatedByString:@" "]);
    return [string componentsSeparatedByString:@" "];
    */
    NSArray *spacedWords = [string componentsSeparatedByString:@" "];
    NSMutableArray *separatedWords = [[NSMutableArray alloc] initWithArray:spacedWords];
    //NSLog(@"usable words are %@", usableWords);
    
    // Separate line breaks
    return [self separateArray:[self separateArray:separatedWords ByString:@"\n"] ByString:@"\r"];
}

- (NSArray *)filterWordsFromString:(NSString *)string
{
    // Separate body text into lower case words
    NSMutableArray *filteredWordArray = [NSMutableArray arrayWithArray:[self separateStringIntoWords:string]];
    
    // Combine ignored words into one array
    return [self filterWordsFromMutableArray:filteredWordArray];
}

-(NSMutableArray *)filterWordsFromMutableArray:(NSMutableArray *)mutableArray
{
    NSMutableArray *ignoredWords = [[NSMutableArray alloc] init];
    [ignoredWords addObjectsFromArray:[[[NSUserDefaults standardUserDefaults] objectForKey:StudyAidWordsToIgnoreAltPrefKey] allObjects]];
    
    // Get rid of invalid spaces
    [ignoredWords addObjectsFromArray:@[@" ",@""]];
    
    // Remove ignored words from the array
    NSMutableArray *mutableArrayToReturn = [[NSMutableArray alloc] initWithArray:mutableArray];
    
    for (NSString *ignoredWord in ignoredWords)
    {
        for (NSString *word in mutableArray)
        {
            if ([word caseInsensitiveCompare:ignoredWord] == NSOrderedSame)
            {
                [mutableArrayToReturn removeObject:word];
            }
        }
        
    }
    
    //NSLog(@"Filtered Words:%@", mutableArrayToReturn);
    
    return mutableArrayToReturn;
}


@end
