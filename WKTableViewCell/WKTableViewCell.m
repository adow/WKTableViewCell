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

        self.backgroundColor=[UIColor lightGrayColor];
        _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.contentSize=CGSizeMake(self.bounds.size.width+WKTableViewCellButtonWidth*2, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.delegate=self;
        _scrollView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_scrollView];
        
        _buttonsView=[[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width-WKTableViewCellButtonWidth*2, 0, WKTableViewCellButtonWidth*2, self.bounds.size.height)];
        [self.scrollView addSubview:_buttonsView];
        
        CGFloat buttonWidth=WKTableViewCellButtonWidth;
        CGFloat buttonHeight=self.bounds.size.height;
        _button_1=[[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, buttonWidth, buttonHeight)];
        _button_1.backgroundColor=[UIColor redColor];
        [_button_1 setTitle:@"Delete" forState:UIControlStateNormal];
        [_button_1 addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonsView addSubview:_button_1];
        
        _button_2=[[UIButton alloc]initWithFrame:CGRectMake(buttonWidth, 0.0f, buttonWidth, buttonHeight)];
        _button_2.backgroundColor=[UIColor redColor];
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
    self.state=WKTableViewCellStateUnexpanded;
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
    }
    else if(state==WKTableViewCellStateUnexpanded){
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
}
-(WKTableViewCellState)state{
    return _state;
}
#pragma mark - Action
-(void)onTapGesture:(UITapGestureRecognizer*)recognizer{
    if (self.state==WKTableViewCellStateUnexpanded){
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:self];
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:cellIndexPath];
        }
    }
    else{
        self.state=WKTableViewCellStateUnexpanded;
        
    }
}
-(IBAction)onButton:(id)sender{
    if (sender==self.button_1){
        NSLog(@"button_1");
    }
    else if (sender==self.button_2){
        NSLog(@"button_2");
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
