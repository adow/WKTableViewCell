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
@property (nonatomic,retain) UIView* controlView;
@property (nonatomic,retain) UIScrollView* scrollView;
@property (nonatomic,retain) UIView* cellContentView;
@end

@implementation WKTableViewCell
#define  WKTableViewCellButtonWidth 60.0f
@dynamic state;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.translatesAutoresizingMaskIntoConstraints=NO;
        self.contentView.translatesAutoresizingMaskIntoConstraints=NO;
        _controlView=[[UIView alloc]initWithFrame:self.bounds];
        _controlView.backgroundColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.05f];
        //_controlView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.contentView addSubview:_controlView];
        NSArray* controlViewConstraintsH=
            [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0.0-[_controlView]-0.0-|"
                                                    options:0
                                                    metrics:nil
                                                      views:NSDictionaryOfVariableBindings(_controlView)];
        [self.contentView addConstraints:controlViewConstraintsH];
        NSArray* controlViewConstraintsV=
            [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0.0-[_controlView]-0.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_controlView)];
        [self.contentView addConstraints:controlViewConstraintsV];
        
        CGFloat buttonWidth=WKTableViewCellButtonWidth;
        CGFloat buttonHeight=self.bounds.size.height;
        _button_1=[[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-buttonWidth, 0.0f, buttonWidth, buttonHeight)];
        _button_1.translatesAutoresizingMaskIntoConstraints=NO;
        _button_1.backgroundColor=[UIColor redColor];
        [_button_1 setTitle:@"Delete" forState:UIControlStateNormal];
        [_controlView addSubview:_button_1];
        
        _button_2=[[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-buttonWidth*2-1, 0.0f, buttonWidth, buttonHeight)];
        _button_2.translatesAutoresizingMaskIntoConstraints=NO;
        _button_2.backgroundColor=[UIColor redColor];
        [_button_2 setTitle:@"More" forState:UIControlStateNormal];
        [_controlView addSubview:_button_2];
        
        NSArray* buttonConstraintsH=[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_button_2(_button_1)]-1-[_button_1(60)]-0.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_button_1,_button_2)];
        [self.controlView addConstraints:buttonConstraintsH];
        NSArray* buttonConstraintsV_1=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0.0-[_button_1]-0.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_button_1)];
        [self.controlView addConstraints:buttonConstraintsV_1];
        NSArray* buttonConstraintsV_2=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0.0-[_button_2]-0.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_button_2)];
        [self.controlView addConstraints:buttonConstraintsV_2];

        _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.contentSize=CGSizeMake(self.bounds.size.width+WKTableViewCellButtonWidth*2, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.translatesAutoresizingMaskIntoConstraints=NO;
        _scrollView.delegate=self;
        //_scrollView.userInteractionEnabled=NO;
        [self.contentView addSubview:_scrollView];
        NSArray* scrollViewConstraintsH=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0.0-[_scrollView]-0.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)];
        [self.contentView addConstraints:scrollViewConstraintsH];
        NSArray* scrollViewConstraintsV=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0.0-[_scrollView]-0.0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)];
        [self.contentView addConstraints:scrollViewConstraintsV];
        

        _cellContentView=[[UIView alloc]initWithFrame:self.bounds];
        _cellContentView.backgroundColor=[UIColor whiteColor];
        [_scrollView addSubview:_cellContentView];
        
        UITapGestureRecognizer* tapGesture=[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture:)] autorelease];
        [self addGestureRecognizer:tapGesture];
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
    [_controlView release];
    [_cellContentView release];
    [_scrollView release];
    [super dealloc];
}
-(void)prepareForReuse{
    [super prepareForReuse];
    [self.scrollView setContentOffset:CGPointZero];
    self.state=WKTableViewCellStateUnexpanded;
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
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
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
