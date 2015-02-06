//
//  HWGWordAndRangeStorageToHighlight.h
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWGWordAndRangeStorageToHighlight : NSObject
@property (nonatomic) NSMutableArray *unpackedSelectedWords;
@property (nonatomic) NSMutableArray *indexMutableArray;
@property (nonatomic) NSString *selectedWord;

- (instancetype)init;
- (void)storeRangeForWord:(NSMutableArray *)word;
- (NSMutableArray *)getRandomRangeAndWord;
- (void)removeRangeForWord:(NSMutableArray *)wordArray;
- (NSMutableArray *)getRangeAndWordInSequence;
@end


