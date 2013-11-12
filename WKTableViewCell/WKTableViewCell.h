//
//  WKTableViewCell.h
//  WKTableViewCell
//
//  Created by 秦 道平 on 13-11-4.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WKTableViewCellNotificationChangeToUnexpanded @"WKTableViewCellNotificationChangeToUnexpanded"
typedef enum WKTableViewCellState:NSUInteger{
    WKTableViewCellStateUnexpanded=0,
    WKTableViewCellStateExpanded=1,
} WKTableViewCellState;
@class WKTableViewCell;
@protocol WKTableViewCellDelegate <NSObject>
-(void)buttonTouchedOnCell:(WKTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath atButtonIndex:(NSInteger)buttonIndex;
@end
@interface WKTableViewCell : UITableViewCell{
    WKTableViewCellState _state;
}
@property (nonatomic,assign) WKTableViewCellState state;///当前的状态
@property (nonatomic,assign) UITableView* tableView;
@property (nonatomic,retain) UIView* buttonsView;
@property (nonatomic,retain) UIScrollView* scrollView;
@property (nonatomic,retain) UIView* cellContentView;
@property (nonatomic,assign) id<WKTableViewCellDelegate> delegate;
@property (nonatomic,copy) NSArray* rightButtonTitles;///按钮的标题
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           delegate:(id<WKTableViewCellDelegate>)delegate 
        inTableView:(UITableView*)tableView
withRightButtonTitles:(NSArray*)rightButtonTitles;
@end
