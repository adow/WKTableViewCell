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
static WKTableViewCell *_edingCell;///正在编辑中的cell
@dynamic state;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        //self.backgroundColor=[UIColor lightGrayColor];
        _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.contentSize=CGSizeMake(self.bounds.size.width+WKTableViewCellButtonWidth*2, self.bounds.size.height);
        _scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.delegate=self;
        _scrollView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_scrollView];
        
        _buttonsView=[[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width-WKTableViewCellButtonWidth*2+1, 0, WKTableViewCellButtonWidth*2, self.bounds.size.height)];
        _buttonsView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.scrollView addSubview:_buttonsView];
        
        CGFloat buttonWidth=WKTableViewCellButtonWidth;
        CGFloat buttonHeight=self.bounds.size.height;
        _button_1=[[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, buttonWidth, buttonHeight)];
        _button_1.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        _button_1.backgroundColor=[UIColor redColor];
        [_button_1 setTitle:@"Delete" forState:UIControlStateNormal];
        [_button_1 addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonsView addSubview:_button_1];
        
        _button_2=[[UIButton alloc]initWithFrame:CGRectMake(buttonWidth+1, 0.0f, buttonWidth, buttonHeight)];
        _button_2.backgroundColor=[UIColor redColor];
        _button_2.autoresizingMask=UIViewAutoresizingFlexibleHeight;
        [_button_2 setTitle:@"More" forState:UIControlStateNormal];
        [_button_2 addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonsView addSubview:_button_2];
        
        _cellContentView=[[UIView alloc]initWithFrame:self.bounds];
        _cellContentView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _cellContentView.backgroundColor=[UIColor whiteColor];
        [_scrollView addSubview:_cellContentView];
        
        UITapGestureRecognizer* tapGesture=[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture:)] autorelease];
        [self.cellContentView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc{
    [_button_1 release];
    [_button_2 release];
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
-(void)setButton_1:(UIButton *)button_1{
    [button_1 retain];
    [_button_1 release];
    _button_1=button_1;
}
-(UIButton*)button_1{
    return _button_1;
}
-(void)setButton_2:(UIButton *)button_2{
    [button_2 retain];
    [_button_2 release];
    _button_2=button_2;
}
-(UIButton*)button_2{
    return _button_2;
}
-(void)setState:(WKTableViewCellState)state{
    _state=state;
    if (state==WKTableViewCellStateExpended){
        [self.scrollView setContentOffset:CGPointMake(WKTableViewCellButtonWidth*2, 0.0f) animated:YES];
        self.tableView.scrollEnabled=NO;
        self.tableView.allowsSelection=NO;
        _edingCell=self;
        for (UITableViewCell* view in self.tableView.visibleCells) {
            if ([view isKindOfClass:[WKTableViewCell class]] && view !=self){
                WKTableViewCell* cell=(WKTableViewCell*)view;
                cell.scrollView.scrollEnabled=NO;
            }
        }
    }
    else if(state==WKTableViewCellStateUnexpanded){
        _edingCell=nil;
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
    if (sender==self.button_1){
        NSLog(@"button_1");
        if ([self.delegate respondsToSelector:@selector(button_1_touched_on_cell:atIndexPath:)]){
            [self.delegate button_1_touched_on_cell:self atIndexPath:indexPath];
        }
    }
    else if (sender==self.button_2){
        NSLog(@"button_2");
        if ([self.delegate respondsToSelector:@selector(button_2_touched_on_cell:atIndexPath:)]){
            [self.delegate button_2_touched_on_cell:self atIndexPath:indexPath];
        }
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
    if (scrollView.contentOffset.x>=WKTableViewCellButtonWidth){
        self.state=WKTableViewCellStateExpended;
    }
    else{
        self.state=WKTableViewCellStateUnexpanded;
    }
}
@end
