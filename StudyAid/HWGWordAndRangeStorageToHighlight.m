//
//  HWGWordAndRangeStorageToHighlight.m
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import "HWGWordAndRangeStorageToHighlight.h"


@interface HWGWordAndRangeStorageToHighlight ()
@property int randomIndexForArray;



@end
@implementation HWGWordAndRangeStorageToHighlight

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.indexMutableArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)storeRangeForWord:(NSMutableArray *)word
{

    [self.indexMutableArray addObject:word];
        //NSLog(@"Self.indexmutablearray has stored a word and is now %@", self.indexMutableArray);
}

- (NSMutableArray *)getRandomRangeAndWord
{
    
    // Get a random int within the bounds of the indexArray - not safe for 64 bit even with less than 2^31-1 elements
    
    // Just do arc4random- all ranges are unique and therefore each will be different
    //NSLog(@"Self.indexmutablearray is %@", self.indexMutableArray);
    
    int randomIndexForRange = arc4random_uniform((int)[self.indexMutableArray count]);
    
    self.randomIndexForArray = randomIndexForRange;
    
    NSMutableArray *pair = [self.indexMutableArray objectAtIndex:randomIndexForRange];
    
    // NSLog(@"Got range %@ from array %@ with index %d", NSStringFromRange(range), arrayOfRanges, self.randomIndexForArray);
    // NSLog(@"Removing index %d for word %@", self.rangeIndexStorage.index, word);
    
    self.selectedWord = [pair objectAtIndex:1];
    
    return pair;
}

-(NSMutableArray *)getRangeAndWordInSequence
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:[self.indexMutableArray sortedArrayUsingComparator:^NSComparisonResult(NSArray *value1, NSArray *value2) {
        NSComparisonResult result = NSOrderedSame;
        NSRange range1;
        NSRange range2;
        [[value1 objectAtIndex:0] getValue:&range1];
        [[value2 objectAtIndex:0] getValue:&range2];
        if (range1.location > range2.location) {
            result = NSOrderedDescending;
        } else if (range1.location < range2.location) {
            result = NSOrderedAscending;
        }
        return result;
    }]];
    //NSLog(@"In sequence is %@", mutableArray);
    self.selectedWord = [[mutableArray objectAtIndex:0] objectAtIndex:1];
    return [mutableArray objectAtIndex:0];
}


- (void)removeRangeForWord:(NSMutableArray *)wordArray
{
    
    [self.indexMutableArray removeObject:wordArray];

}

@end
