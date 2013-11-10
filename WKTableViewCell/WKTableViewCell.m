//
//  WKTableViewCell.m
//  WKTableViewCell
//
//  Created by 秦 道平 on 13-11-4.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "WKTableViewCell.h"
@interface WKTableViewCell()<UIScrollViewDelegate>{
    
}
@end

@implementation WKTableViewCell
#define  WKTableViewCellButtonWidth 60.0f
@dynamic state;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withLeftButtonTitles:(NSArray *)leftButtonTitles{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //self.backgroundColor=[UIColor lightGrayColor];
        _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.contentSize=CGSizeMake(self.bounds.size.width+WKTableViewCellButtonWidth*(leftButtonTitles.count), self.bounds.size.height);
        _scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.delegate=self;
        _scrollView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_scrollView];
        
        self.leftButtonTitles=leftButtonTitles;
        CGFloat leftButtonViewWidth=WKTableViewCellButtonWidth*self.leftButtonTitles.count+1*(self.leftButtonTitles.count-1);
        _buttonsView=[[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width-leftButtonViewWidth, 0,
                                                             leftButtonViewWidth, self.bounds.size.height)];
        _buttonsView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.scrollView addSubview:_buttonsView];
        
        CGFloat buttonWidth=WKTableViewCellButtonWidth;
        CGFloat buttonHeight=self.bounds.size.height;
        for (int a=0; a<self.leftButtonTitles.count; a++) {
            CGFloat left=a*(WKTableViewCellButtonWidth+1);
            UIButton* button=[[[UIButton alloc]initWithFrame:CGRectMake(left, 0, buttonWidth,buttonHeight)] autorelease];
            button.tag=a;
            button.autoresizingMask=UIViewAutoresizingFlexibleHeight;
            button.backgroundColor=[UIColor redColor];
            [button setTitle:self.leftButtonTitles[a] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonsView addSubview:button];
        }
        
        _cellContentView=[[UIView alloc]initWithFrame:self.bounds];
        _cellContentView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _cellContentView.backgroundColor=[UIColor whiteColor];
        [_scrollView addSubview:_cellContentView];
        
        UITapGestureRecognizer* tapGesture=[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture:)] autorelease];
        [self.cellContentView addGestureRecognizer:tapGesture];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationChangeToUnexpanded:) name:WKTableViewCellNotificationChangeToUnexpanded object:nil];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_buttonsView release];
    [_cellContentView release];
    [_scrollView release];
    [super dealloc];
}
-(void)prepareForReuse{
    [super prepareForReuse];
    [self.scrollView setContentOffset:CGPointZero];
    //self.state=WKTableViewCellStateUnexpanded;
    for (UIView* subView in self.cellContentView.subviews) {
        [subView removeFromSuperview];
    }
}
#pragma mark - Properties
-(void)setState:(WKTableViewCellState)state{
    _state=state;
    if (state==WKTableViewCellStateExpended){
        [self.scrollView setContentOffset:CGPointMake(self.buttonsView.frame.size.width, 0.0f) animated:YES];
        self.tableView.scrollEnabled=NO;
        self.tableView.allowsSelection=NO;
        for (UITableViewCell* view in self.tableView.visibleCells) {
            if ([view isKindOfClass:[WKTableViewCell class]] && view !=self){
                WKTableViewCell* cell=(WKTableViewCell*)view;
                cell.scrollView.scrollEnabled=NO;
            }
        }
    }
    else if(state==WKTableViewCellStateUnexpanded){
        self.scrollView.scrollEnabled=YES;
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        self.tableView.scrollEnabled=YES;
        self.tableView.allowsSelection=YES;
    }
}
-(WKTableViewCellState)state{
    return _state;
}
#pragma mark - Action
-(IBAction)onButton:(id)sender{
    NSIndexPath* indexPath=[self.tableView indexPathForCell:self];
    UIButton* button=(UIButton*)sender;
    if ([self.delegate respondsToSelector:@selector(buttonTouchedOnCell:atIndexPath:atButtonIndex:)]){
        [self.delegate buttonTouchedOnCell:self atIndexPath:indexPath atButtonIndex:button.tag];
    }
}
#pragma mark Gesture
-(void)onTapGesture:(UITapGestureRecognizer*)recognizer{
    if (!self.tableView.allowsSelection){
        ///为了不让快速按下时鼓动状态固定在一半，一开始就先停止触摸
        self.tableView.userInteractionEnabled=NO;
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.tableView.userInteractionEnabled=YES;
        });
        ///
        for (UITableViewCell* view in self.tableView.visibleCells) {
            if ([view isKindOfClass:[WKTableViewCell class]]){
                WKTableViewCell* cell=(WKTableViewCell*)view;
                cell.state=WKTableViewCellStateUnexpanded;
            }
        }
    }
    else{
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:cellIndexPath];
        }
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    self.buttonsView.transform=CGAffineTransformMakeTranslation(scrollView.contentOffset.x, 0.0f);
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.x>=self.buttonsView.frame.size.width/2){
        self.state=WKTableViewCellStateExpended;
    }
    else{
        self.state=WKTableViewCellStateUnexpanded;
    }
}
#pragma mark - Notififcation
-(void)notificationChangeToUnexpanded:(NSNotification*)notification{
    self.state=WKTableViewCellStateUnexpanded;
}
@end
