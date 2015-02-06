//
//  HWGOptionsCharactersToTrim.m
//  StudyAid
//
//  Created by Woudini on 1/5/15.
//  Copyright (c) 2015 Hi Range. All rights reserved.
//

#import "HWGOptionsCharactersToTrim.h"

@implementation HWGOptionsCharactersToTrim

NSString * const StudyAidCharactersToTrimPrefKey = @"StudyAidCharactersToTrimPrefKey";

NSString * const pathStringToStoreCharacters = @"/charactersToTrim.txt";

-(instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

-(void)saveCharacters:(NSArray *)characters
{
    /*
    NSString *documentDirectories = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // Get one and only one document directory from that list
    NSString *path = [documentDirectories stringByAppendingPathComponent:pathStringToStoreCharacters];
    NSError *error;
    if (![characters writeToFile:path atomically:YES])
    {
        NSLog(@"Error saving text: %@", error);
    }*/
    
    [[NSUserDefaults standardUserDefaults] setValue:characters forKey:StudyAidCharactersToTrimPrefKey];
    
}

-(NSArray *)loadCharacters
{/*
    NSString *documentDirectories = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // Get one and only one document directory from that list
    NSString *path = [documentDirectories stringByAppendingPathComponent:pathStringToStoreCharacters];
    NSError *error;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    NSMutableArray *charactersToReturn = [[NSMutableArray alloc] init];
    
    if (fileExists)
    {
        NSArray *characters = [NSArray arrayWithContentsOfFile:path];
        if (!characters)
        {
            NSLog(@"Error loading words: %@", error);
        }
        else
        {
            [charactersToReturn addObjectsFromArray:characters];
        }
    }*/
    
    NSMutableArray *charactersToReturn = [[NSMutableArray alloc] init];
    
    [charactersToReturn addObjectsFromArray:[[NSUserDefaults standardUserDefaults] valueForKey:StudyAidCharactersToTrimPrefKey]];
    
    return charactersToReturn;
}

@end
