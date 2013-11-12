# WKTableViewCell

## iOS7 邮件中那样的TableViewCell

* 类似下面图片这样的按钮;
* UITableView向右滑动出来两个操作的按钮;
* 然后点击（或者拖动）这行或者其他行都会缩回到原来的状态;

![image](http://images.techhive.com/images/article/2013/09/05-keep-left-100054439-large.png)


## 使用

* 引用 WKTableViewCell.h, WKTableViewCell.m;
* 继承 WKTableViewCell，在 `-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
          delegate:(id<WKTableViewCellDelegate>)delegate
       inTableView:(UITableView *)tableView
withRightButtonTitles:(NSArray *)rightButtonTitles` 中创建自己显示的内容元素，然后添加到`self.cellContentView`上;
	
		@implementation TestTableViewCell
		-(id)initWithStyle:(UITableViewCellStyle)style
		   reuseIdentifier:(NSString *)reuseIdentifier
		          delegate:(id<WKTableViewCellDelegate>)delegate
		       inTableView:(UITableView *)tableView
		withRightButtonTitles:(NSArray *)rightButtonTitles{
		    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier delegate:delegate inTableView:tableView withRightButtonTitles:rightButtonTitles];
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
	
* 使用这个来创建TableView的cell,定义往左滑动时出来的按钮的内容;

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


		#pragma mark - UITableDataSource and UITableViewDelegate
		-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
		    return 60.0f;
		}
		-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
		    return _rows.count;
		}
		-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
		    static NSString* identity=@"cell-identity";
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

* 实现 WKTableViewCellDelegate，响应按钮的事件,通过indexPath和buttonIndex来确定是那一行的哪一个按钮,在结束时需要发送`WKTableViewCellNotificationChangeToUnexpanded` 消息;

		#pragma mark - WKTableViewCellDelegate
		-(void)buttonTouchedOnCell:(WKTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath atButtonIndex:(NSInteger)buttonIndex{
		    NSLog(@"row:%ld,buttonIndex:%ld",(long)indexPath.row,(long)buttonIndex);
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


## 实现

WKTableViewCell中的UIView层次;

		- WKTableView (from UITableViewCell)
			- contentView (UIView from UITableViewCell)
				- scrollView (UIScrollView)
					- buttonsView (UIView)
						- button (UIButton)
						- button (UIButton)
					- cellContentView (UIView)
						- 自定义的内容 (UIView)
						
可以看出往右滚动其实就是滚动了scrollView而已，为了使那些按钮一直固定在右边，而不是滚动，在scrollViewDidScroll中固定了bottomsView的位置;

		-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
		self.buttonsView.transform=CGAffineTransformMakeTranslation(scrollView.contentOffset.x, 0.0f);
		}
		
Cell 有两种状态,用来表示是否显示出了操作按钮.

		typedef enum WKTableViewCellState:NSUInteger{
		    WKTableViewCellStateUnexpanded=0,
		    WKTableViewCellStateExpended=1,
		} WKTableViewCellState;
		
		
当变成WKTableViewCellStateExpanded时，就是进入了操作状态，这时tableView将不能滚动，而且其他行的cell中也不能滚动scrollView (在tableView上的拖动会变成当前编辑的这个cell中的scrollView的滚动),这样做只是为了使整个tableView中的状态简化。当回到WKTableViewCellStateUnexpanded状态时，tableView可以滚动，cell中的scrollView操作也可以进行了。