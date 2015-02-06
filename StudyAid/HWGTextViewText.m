//
//  HWGTextViewText.m
//  StudyAid
//
//  Created by Woudini on 1/1/15.
//  Copyright (c) 2015 Hi Range. All rights reserved.
//

#import "HWGTextViewText.h"

NSString *const pathStringToStoreString = @"/stringToStore.txt";

@implementation HWGTextViewText

-(instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

-(void)saveText:(NSString *)text
{
    NSString *documentDirectories = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // Get one and only one document directory from that list
    NSString *path = [documentDirectories stringByAppendingPathComponent:pathStringToStoreString];
    NSError *error;
    if (![text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        //NSLog(@"Error saving text: %@", error);
    }
}

-(NSString *)loadText
{
    NSString *documentDirectories = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // Get one and only one document directory from that list
    NSString *path = [documentDirectories stringByAppendingPathComponent:pathStringToStoreString];
    NSError *error;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    NSString *textToReturn = @"Enter/Paste text here";
    
    if (fileExists)
    {
        NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (!text)
        {
            //NSLog(@"Error loading text: %@", error);
        }
        else
        {
            textToReturn = text;
        }
    }
    return textToReturn;
}

@end
