//
//  ViewController.m
//  WKTableViewCell
//
//  Created by 秦 道平 on 13-11-4.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "ViewController.h"
#import "WKTableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView* tableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (!_tableView){
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
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
    [_tableView release];
    [super dealloc];
}
#pragma mark - UITableDataSource and UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identity=@"cell-identity";
    WKTableViewCell* cell=(WKTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell){
        cell=[[[WKTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity] autorelease];
        cell.tableView=tableView;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath:%d",indexPath.row);
}
@end