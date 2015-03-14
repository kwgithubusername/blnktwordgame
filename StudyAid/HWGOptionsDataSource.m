//
//  HWGOptionsDataSource.m
//  StudyAid
//
//  Created by Woudini on 3/14/15.
//  Copyright (c) 2015 Hi Range. All rights reserved.
//

#import "HWGOptionsDataSource.h"

@interface HWGOptionsDataSource ()
@property (nonatomic, copy) RowsInSectionBlock rowsInSectionBlock;
@property (nonatomic, copy) CellForRowAtIndexPathBlock cellForRowAtIndexPathBlock;
@property (nonatomic, copy) CanEditRowAtIndexPathBlock canEditRowAtIndexPathBlock;
@property (nonatomic, copy) DeleteCellBlock deleteCellBlock;
@end

@implementation HWGOptionsDataSource

-(id)initWithRowsInSectionBlock:(RowsInSectionBlock)aRowsInSectionBlock
     CellForRowAtIndexPathBlock:(CellForRowAtIndexPathBlock)aCellForRowAtIndexPathBlock
     CanEditRowAtIndexPathBlock:(CanEditRowAtIndexPathBlock)aCanEditRowAtIndexPathBlock
                DeleteCellBlock:(DeleteCellBlock)aDeleteCellBlock
{
    self = [super init];
    if (self)
    {
        self.rowsInSectionBlock = aRowsInSectionBlock;
        self.cellForRowAtIndexPathBlock = aCellForRowAtIndexPathBlock;
        self.canEditRowAtIndexPathBlock = aCanEditRowAtIndexPathBlock;
        self.deleteCellBlock = aDeleteCellBlock;
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowsInSectionBlock(tableView);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellForRowAtIndexPathBlock(indexPath, tableView);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.canEditRowAtIndexPathBlock();
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.deleteCellBlock(indexPath, tableView);
    }
}

@end
