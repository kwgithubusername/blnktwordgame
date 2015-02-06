//
//  HWGWordAndRangeStorage.m
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import "HWGWordAndRangeStorage.h"

@interface HWGWordAndRangeStorage ()

@property int randomIndexForArray;

@end

@implementation HWGWordAndRangeStorage

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.indexMutableArray = [[NSMutableArray alloc] init];
        self.rangesMutableSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)storeRanges:(NSArray *)ranges forWord:(NSString *)string
{
    
    for (NSValue *rangeValue in ranges)
    {
        NSRange range;
        [rangeValue getValue:&range];
        if (![self.rangesMutableSet containsObject:[NSNumber numberWithUnsignedInteger:range.location]])
        {
            NSMutableArray *WordAndRangeMutableArray = [[NSMutableArray alloc] init];
            [WordAndRangeMutableArray addObject:rangeValue];
            [WordAndRangeMutableArray addObject:string];
            [self.indexMutableArray addObject:WordAndRangeMutableArray];
            
            // Prevent embedded words from being added
            for (NSUInteger i = range.location; i < NSMaxRange(range); i++)
            {
                [self.rangesMutableSet addObject:[NSNumber numberWithUnsignedInteger:i]];
                //NSLog(@"NSRangesmutableset is %@", self.rangesMutableSet);
            }
            //NSLog(@"rangeadded");
        }
        
        {
            //NSLog(@"rangenotadded");
        }
    }

    //NSLog(@"self.indexmutablearray is %@", self.indexMutableArray);
    
}

- (NSMutableArray *)getRandomRangeAndWord
{
    
    // Get a random int within the bounds of the indexArray - not safe for 64 bit even with less than 2^31-1 elements

    // Just do arc4random- all ranges are unique and therefore each will be different
    
    int randomIndexForRange = arc4random_uniform((int)[self.indexMutableArray count]);
    
    self.randomIndexForArray = randomIndexForRange;

    NSMutableArray *pair = [self.indexMutableArray objectAtIndex:randomIndexForRange];
    
    // NSLog(@"Got range %@ from array %@ with index %d", NSStringFromRange(range), arrayOfRanges, self.randomIndexForArray);
    // NSLog(@"Removing index %d for word %@", self.rangeIndexStorage.index, word);

    return pair;
}

- (void)removeRangeForWord
{

    [self.indexMutableArray removeObjectAtIndex:self.randomIndexForArray];
    
     //NSLog(@"After removal, arrayofranges is %@", self.indexMutableArray);
    // If the array of ranges is empty, all occurrences of the word have been used; delete the word
}

@end
