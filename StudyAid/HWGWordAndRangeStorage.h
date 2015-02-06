//
//  HWGWordAndRangeStorage.h
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HWGWordAndRangeStorage : NSObject

@property (nonatomic) NSMutableArray *indexMutableArray;
@property (nonatomic) NSMutableSet *rangesMutableSet;

- (instancetype)init;
- (void)storeRanges:(NSArray *)ranges forWord:(NSString *)string;
- (NSMutableArray *)getRandomRangeAndWord;
- (void)removeRangeForWord;

@end
