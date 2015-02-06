//
//  HWGOptionsWordsToIgnore.m
//  StudyAid
//
//  Created by Woudini on 1/5/15.
//  Copyright (c) 2015 Hi Range. All rights reserved.
//

#import "HWGOptionsWordsToIgnore.h"

@implementation HWGOptionsWordsToIgnore

NSString * const StudyAidWordsToIgnorePrefKey = @"StudyAidWordsToIgnorePrefKey";

NSString * const pathStringToStoreWords = @"/wordsToStore.txt";

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)saveWords:(NSArray *)words;
{/*
    NSString *documentDirectories = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // Get one and only one document directory from that list
    NSString *path = [documentDirectories stringByAppendingPathComponent:pathStringToStoreWords];
    NSError *error;
    if (![words writeToFile:path atomically:YES])
    {
        NSLog(@"Error saving text: %@", error);
    }
    */
    [[NSUserDefaults standardUserDefaults] setValue:words forKey:StudyAidWordsToIgnorePrefKey];
}

-(NSArray *)loadWords
{/*
    NSString *documentDirectories = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // Get one and only one document directory from that list
    NSString *path = [documentDirectories stringByAppendingPathComponent:pathStringToStoreWords];
    NSError *error;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    NSMutableArray *wordsToReturn = [[NSMutableArray alloc] init];
    
    if (fileExists)
    {
        NSArray *words = [NSArray arrayWithContentsOfFile:path];
        if (!words)
        {
            NSLog(@"Error loading words: %@", error);
        }
        else
        {
            [wordsToReturn addObjectsFromArray:words];
        }
    }*/
    NSMutableArray *wordsToReturn = [[NSMutableArray alloc] init];
    [wordsToReturn addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:StudyAidWordsToIgnorePrefKey]];
    return wordsToReturn;
}

@end
