//
//  HWGTextViewText.h
//  StudyAid
//
//  Created by Woudini on 1/1/15.
//  Copyright (c) 2015 Hi Range. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWGTextViewText : NSObject

@property (nonatomic) NSString *stringToStore;

-(instancetype)init;
-(void)saveText:(NSString *)text;
-(NSString *)loadText;


@end
