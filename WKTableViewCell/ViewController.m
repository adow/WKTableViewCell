//
//  ViewController.m
//  WKTableViewCell
//
//  Created by 秦 道平 on 13-11-4.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "ViewController.h"
#import "WKTableViewCell.h"
#import "TestTableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,WKTableViewCellDelegate,UIActionSheetDelegate>{
    NSMutableArray* _rows;
}
@property (nonatomic,retain) UITableView* tableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (!_rows){
        _rows=[[NSMutableArray alloc]init];
    }
    for (int a=0; a<30; a++) {
        [_rows addObject:[NSString stringWithFormat:@"Cell in Table at Row :%d",a]];
    }
    if (!_tableView){
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        [self.view addSubview:_tableView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (!self.view.window){
        self.tableView=nil;
        self.view=nil;
    }
}
-(void)dealloc{
    [_rows release];
    [_tableView release];
    [super dealloc];
}
#pragma mark - UITableDataSource and UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rows.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identity=@"cell-identity";
//    WKTableViewCell* cell=(WKTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identity];
//    if (!cell){
//        cell=[[[WKTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                    reuseIdentifier:identity
//                                        inTableView:tableView
//                               withRightButtonTitles:@[@"More",@"Delete"]] autorelease];
//        cell.delegate=self;
//    }
//    UILabel* titleLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, tableView.rowHeight)] autorelease];
//    titleLabel.autoresizingMask=UIViewAutoresizingFlexibleHeight;
//    titleLabel.text=_rows[indexPath.row];
//    [cell.cellContentView addSubview:titleLabel];
//    return cell;
    TestTableViewCell* cell=(TestTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell){
        cell=[[[TestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identity
                                             delegate:self
                                          inTableView:tableView withRightButtonTitles:@[@"More",@"Delete"]] autorelease];
    }
    cell.contentLabel.text=_rows[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select row at indexPath:%ld",(long)indexPath.row);
}
#pragma mark - WKTableViewCellDelegate
-(void)buttonTouchedOnCell:(WKTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath atButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"row:%ld,buttonIndex:%d",(long)indexPath.row,buttonIndex);
    if (buttonIndex==1){
        [_rows removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter] postNotificationName:WKTableViewCellNotificationChangeToUnexpanded object:nil];
    }
    else if (buttonIndex==0){
        UIActionSheet* actionSheet=[[[UIActionSheet alloc]initWithTitle:@"Action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"View" otherButtonTitles:@"Edit", nil] autorelease];
        [actionSheet showInView:self.view];
    }
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[NSNotificationCenter defaultCenter] postNotificationName:WKTableViewCellNotificationChangeToUnexpanded object:nil];
}
@end
