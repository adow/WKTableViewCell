//
//  TestTableViewCell.m
//  WKTableViewCell
//
//  Created by 秦 道平 on 13-11-10.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "TestTableViewCell.h"

@implementation TestTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTableView:(UITableView *)tableView withRightButtonTitles:(NSArray *)rightButtonTitles{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier inTableView:tableView withRightButtonTitles:rightButtonTitles];
    if (self){
        _contentLabel=[[UILabel alloc]initWithFrame:self.bounds];
        _contentLabel.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        //_contentLabel.backgroundColor=[UIColor grayColor];
        [self.cellContentView addSubview:_contentLabel];
    }
    return self;
}
-(void)dealloc{
    [_contentLabel release];
    [super dealloc];
}
@end
