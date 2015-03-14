//
//  HWGOptionsDataSource.h
//  StudyAid
//
//  Created by Woudini on 3/14/15.
//  Copyright (c) 2015 Hi Range. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSInteger (^RowsInSectionBlock)(UITableView *tableView);
typedef UITableViewCell* (^CellForRowAtIndexPathBlock)(NSIndexPath *indexPath, UITableView *tableView);
typedef BOOL (^CanEditRowAtIndexPathBlock)();
typedef void (^DeleteCellBlock)(NSIndexPath *indexPath, UITableView *tableView);

@interface HWGOptionsDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

-(id)initWithRowsInSectionBlock:(RowsInSectionBlock)aRowsInSectionBlock
     CellForRowAtIndexPathBlock:(CellForRowAtIndexPathBlock)aCellForRowAtIndexPathBlock
     CanEditRowAtIndexPathBlock:(CanEditRowAtIndexPathBlock)aCanEditRowAtIndexPathBlock
                DeleteCellBlock:(DeleteCellBlock)aDeleteCellBlock;

@end
