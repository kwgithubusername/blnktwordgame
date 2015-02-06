//
//  HWGWordSearcher.m
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import "HWGWordSearcher.h"

@implementation HWGWordSearcher

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (NSMutableArray *)searchForRangesOfString:(NSString *)searchString inString:(NSString *)string
{
    // If the range already exists for the string, search again!
    
    // Create an array to contain the results
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    // Get the range of all the text in the textview
    NSRange searchRange = NSMakeRange(0, [string length]);
    //NSLog(@"SearchRange = %@", NSStringFromRange(searchRange));
    
    NSRange range;
    //NSLog(@"%@",NSStringFromRange([words.text rangeOfString:searchString]));
    while ((range = [string rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound)
    {
        [results addObject:[NSValue valueWithRange:range]];
        searchRange = NSMakeRange(NSMaxRange(range), [string length] - NSMaxRange(range));
    }

    //NSLog(@"The WordSearcher searched for l%@l and found results:%@", searchString, results);
    
//    NSLog(@"The WordSearcher searched for l%@l and found results:%@. Current rangeArray has %@", searchString, results, [self.rangeTransferBlock() objectAtIndex:2]);
    return results;
}


@end
