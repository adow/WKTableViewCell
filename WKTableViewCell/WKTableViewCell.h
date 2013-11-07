//
//  WKTableViewCell.h
//  WKTableViewCell
//
//  Created by 秦 道平 on 13-11-4.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum WKTableViewCellState:NSUInteger{
    WKTableViewCellStateUnexpanded=0,
    WKTableViewCellStateExpended=1,
} WKTableViewCellState;
@class WKTableViewCell;
@protocol WKTableViewCellDelegate <NSObject>
-(void)button_1_touched_on_cell:(WKTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
-(void)button_2_touched_on_cell:(WKTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;


@end
@interface WKTableViewCell : UITableViewCell{
    UIButton* _button_1;
    UIButton* _button_2;
    WKTableViewCellState _state;
}
@property (nonatomic,retain) UIButton* button_1;
@property (nonatomic,retain) UIButton* button_2;
@property (nonatomic,assign) WKTableViewCellState state;///当前的状态
@property (nonatomic,assign) UITableView* tableView;
@property (nonatomic,retain) UIView* buttonsView;
@property (nonatomic,retain) UIScrollView* scrollView;
@property (nonatomic,retain) UIView* cellContentView;
@property (nonatomic,assign) id<WKTableViewCellDelegate> delegate;
@end
