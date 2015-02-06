//
//  HWGOptionsWordsToIgnore.h
//  StudyAid
//
//  Created by Woudini on 1/5/15.
//  Copyright (c) 2015 Hi Range. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HWGOptionsWordsToIgnore : NSObject

-(instancetype)init;
-(void)saveWords:(NSArray *)words;
-(NSArray *)loadWords;

@end
