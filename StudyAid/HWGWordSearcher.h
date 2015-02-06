//
//  HWGWordSearcher.h
//  StudyAid
//
//  Created by Woudini on 12/31/14.
//  Copyright (c) 2014 Hi Range. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HWGWordSearcher : NSObject


-(instancetype)init;
-(NSMutableArray *)searchForRangesOfString:(NSString *)searchString inString:(NSString *)string;

@end
