//
//  HWGCommonWordFilter.h
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWGCommonWordFilter : NSObject

-(instancetype)init;
-(NSArray *)filterWordsFromString:(NSString *)string;
-(NSMutableArray *)filterWordsFromMutableArray:(NSMutableArray *)mutableArray;
@end
