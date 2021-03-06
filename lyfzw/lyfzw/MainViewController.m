//
//  mainViewController.m
//  lyfzw
//
//  Created by 成城 on 14-8-3.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "MainViewController.h"
#import "InfoViewController.h"
#import "LoginViewController.h"
#import "RegViewController.h"
#import "QuoteViewController.h"
#import "ConsultViewController.h"
#import "Model.h"
#import "SearchResultViewController.h"

// @Fixme correct MainViewController to XIEPINGJIA
@interface MainViewController ()

@end

// @Fixme correct MainViewController to XIEPINGJIA
@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/**
 *  setup UISearchBar and UITableView
 *  add imageView in tableviewheader
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *LoginButton = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(clickLoginButton:)];
    UIBarButtonItem *RegButton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(clickRegButton:)];
    UIBarButtonItem *BackButton = [[UIBarButtonItem alloc] init];
    BackButton.title = @"返回";
    LoginButton.tintColor = [UIColor whiteColor];
    RegButton.tintColor = [UIColor whiteColor];
    
    
    self.navigationItem.leftBarButtonItem = LoginButton;
    self.navigationItem.rightBarButtonItem = RegButton;
    self.navigationItem.backBarButtonItem = BackButton;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    searchBar.placeholder = @"在此键入";
//    searchBar.keyboardType = UIKeyboardType;
    searchBar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height+20, 320, 40);
    searchBar.delegate = self;

    
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    imageview.image = [UIImage imageNamed:@"SelectBack"];

    // key---UIImageView默认不参与交互
    imageview.userInteractionEnabled = YES;
    
    UIButton *quote = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *consult = [UIButton buttonWithType:UIButtonTypeCustom];
    quote.frame = CGRectMake(0, 0, 160, 80);
    consult.frame = CGRectMake(160, 0, 160, 80);
    
    
    [quote addTarget:self action:@selector(clickQuoteButton:) forControlEvents:UIControlEventTouchUpInside];
    [consult addTarget:self action:@selector(clickConsultButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *waitload = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    waitload.backgroundColor = [UIColor blackColor];
    waitload.alpha = 0.2;
    waitload.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    
    
    [imageview addSubview:quote];
    [imageview addSubview:consult];
    [self.view addSubview:waitload];
    
    
    tableview = [[UITableView alloc] init];
    tableview.frame = CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height, 320, self.view.frame.size.height);
    tableview.tableHeaderView = imageview;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:searchBar];
    [self.view addSubview:tableview];
    /**
     *  add refresh
     */
    if (_refreshTableView == nil) {
        //初始化下拉刷新控件
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableview.bounds.size.height, self.view.frame.size.width, tableview.bounds.size.height)];
        refreshView.delegate = self;
        [refreshView refreshLastUpdatedDate];
        //将下拉刷新控件作为子控件添加到UITableView中
        [tableview addSubview:refreshView];
        _refreshTableView = refreshView;
    }
    
    [waitload startAnimating];
    
    MKNetworkEngine *getnews = [[MKNetworkEngine alloc] initWithHostName:@"www.zglyfzw.com/webapp/api" customHeaderFields:nil];
    MKNetworkOperation *op = [getnews operationWithPath:@"index.php?page_no=1" params:nil httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
//        NSLog(@"%@",[completedOperation responseJSON]);
        NSData *topnews = [completedOperation responseData];
        newsTitle = [[NSMutableArray alloc] init];
        newsContent = [[NSMutableArray alloc] init];
        newsTime = [[NSMutableArray alloc] init];
        
        // return type id
        id data = [NSJSONSerialization JSONObjectWithData:topnews options:NSJSONReadingMutableContainers error:nil];
        
        // if data is type NSDictionary
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataDict = (NSDictionary *)data;
            
            // if return msg is ok.get msg
            NSString *message = [dataDict objectForKey:@"msg"];
            if (![message isEqualToString:@"ok"]) {
                return;
            }
            
            // get data
            NSDictionary *dataValue = dataDict[@"data"];
            
            // get all values of data
            NSArray *topnews = [dataValue objectForKey:@"topnews"];
            for (id topnewsDict in topnews) {
                if ([topnewsDict isKindOfClass:[NSDictionary class]]) {

                    topnewsTitle = [topnewsDict objectForKey:@"title"];
                    topnewsContent = [topnewsDict objectForKey:@"content"];
                    Model *model = [[Model alloc] initWithnewsTitle:topnewsTitle];
                    Model *content = [[Model alloc] initWithnewsContent:topnewsContent];
                    
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[topnewsDict objectForKey:@"addtime"] integerValue]];
                    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
                    [dateformat setDateFormat:@"yyyy-MM-dd"];
                    topnewstime = [dateformat stringFromDate:date];
                    Model *time = [[Model alloc] initWithnewsTime:topnewstime];
                    [newsTitle addObject:model];
                    [newsContent addObject:content];
                    [newsTime addObject:time];
//                    NSLog(@"%@",topnewsTitle);
                    
                }
            }
            NSArray *dataAllValues = [dataValue allValues];
            
            // for loop
            for (id valueDict in dataAllValues) {
                
                if ([valueDict isKindOfClass:[NSDictionary class]]) {
                    // get title
                    NSString *title = valueDict[@"title"];
                    if (title) {
//                        NSLog(@"%@", title);
                        Model *model = [[Model alloc] initWithnewsTitle:title];
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[valueDict objectForKey:@"addtime"] integerValue]];
                        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
                        [dateformat setDateFormat:@"yyyy-MM-dd"];
                        NSString *datestr = [dateformat stringFromDate:date];
                        Model *time = [[Model alloc] initWithnewsTime:datestr];
                        [newsTitle addObject:model];
                        [newsTime addObject:time];
                    }
                    NSString *contents = [valueDict objectForKey:@"content"];
                    if (contents) {
                        Model *content = [[Model alloc] initWithnewsContent:contents];
                        [newsContent addObject:content];
                    }
                }
            }
            
            if (newsTitle.count > 0) {
                [tableview reloadData];
            }
        }
        
        [waitload stopAnimating];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"error");
    }];
    [getnews enqueueOperation:op];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return newsTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"newscell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellname];

        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        UIImage *header = [UIImage imageNamed:@"HeaderIcon"];
        [cell.imageView setImage:header];
        cell.textLabel.text = ((Model *)[newsTitle objectAtIndex:indexPath.row]).newsTitle;
        cell.detailTextLabel.text = ((Model *)[newsTime objectAtIndex:indexPath.row]).newsTime;
    } else {
        [cell.imageView setImage:nil];
    }
    
    
    cell.textLabel.text = ((Model *)[newsTitle objectAtIndex:indexPath.row]).newsTitle;
    cell.detailTextLabel.text = ((Model *)[newsTime objectAtIndex:indexPath.row]).newsTime;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Model *model = newsContent[indexPath.row];
    InfoViewController *infoView = [[InfoViewController alloc] init];
    infoView.info = model.newsContent;
    
    [self.navigationController pushViewController:infoView animated:YES];
}


/**
 *  user UISearchBarDelegate to control CancelButton show or not
 *
 *  @param searchBar showsCancelButton
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.showsCancelButton = NO;
    [self.view endEditing:YES];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchresult = [[NSMutableArray alloc] init];
    NSString *keyword = [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [NSString stringWithFormat:@"search.php?keyword=%@",keyword];
    MKNetworkEngine *search = [[MKNetworkEngine alloc] initWithHostName:@"www.zglyfzw.com/webapp/api"];
    MKNetworkOperation *sch = [search operationWithPath:path];
    [sch addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *data = [completedOperation responseData];
        id newsdata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([newsdata isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)newsdata;
            if ([[dict objectForKey:@"msg"] isEqualToString:@"ok"]) {
                NSArray *dataValue = [dict objectForKey:@"data"];
                for (id valueDict in dataValue) {
                    if ([valueDict isKindOfClass:[NSDictionary class]]) {
                        NSString *title = [valueDict objectForKey:@"title"];
                        NSString *content = [valueDict objectForKey:@"content"];
                        if (title && content) {
                            Model *result = [[Model alloc] initWithnewsContent:content :title];
                            [searchresult addObject:result];
                            
                        }
                        
                        
                    }
                }
                
            }
        }
        
        
        SearchResultViewController *srv = [[SearchResultViewController alloc] init];\
        srv.result = searchresult;
        [self.navigationController pushViewController:srv animated:YES];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"error");
    }];
    [search enqueueOperation:sch];
}
/**
 *  EGORefresh
 *
 */
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date];
}
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
     [self reloadTableViewDataSource];
}
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading;
}

//开始重新加载时调用的方法
- (void)reloadTableViewDataSource{
    _reloading = YES;
    //开始刷新后执行后台线程，在此之前可以开启HUD或其他对UI进行阻塞
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}

//完成加载时调用的方法
- (void)doneLoadingTableViewData{
    NSLog(@"doneLoadingTableViewData");
    
    _reloading = NO;
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:tableview];
    //刷新表格内容
    [tableview reloadData];
}

-(void)doInBackground
{
    NSLog(@"doInBackground");
    
    
    MKNetworkEngine *getnews = [[MKNetworkEngine alloc] initWithHostName:@"www.zglyfzw.com/webapp/api" customHeaderFields:nil];
    MKNetworkOperation *op = [getnews operationWithPath:@"index.php?page_no=1" params:nil httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        //        NSLog(@"%@",[completedOperation responseJSON]);
        NSData *topnews = [completedOperation responseData];
//        newsTitle = [[NSMutableArray alloc] init];
//        newsContent = [[NSMutableArray alloc] init];
        
        // return type id
        id data = [NSJSONSerialization JSONObjectWithData:topnews options:NSJSONReadingMutableContainers error:nil];
        
        // if data is type NSDictionary
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataDict = (NSDictionary *)data;
            
            // if return msg is ok.get msg
            NSString *message = [dataDict objectForKey:@"msg"];
            if (![message isEqualToString:@"ok"]) {
                return;
            }
            
            // get data
            NSDictionary *dataValue = dataDict[@"data"];
            
            // get all values of data
            NSArray *topnews = [dataValue objectForKey:@"topnews"];
            for (id topnewsDict in topnews) {
                if ([topnewsDict isKindOfClass:[NSDictionary class]]) {
                    
                    topnewsTitle = [topnewsDict objectForKey:@"title"];
                    topnewsContent = [topnewsDict objectForKey:@"content"];
                    Model *model = [[Model alloc] initWithnewsTitle:topnewsTitle];
                    Model *content = [[Model alloc] initWithnewsContent:topnewsContent];
                    [newsTitle addObject:model];
                    [newsContent addObject:content];
                    //                    NSLog(@"%@",topnewsTitle);
                    
                }
            }
            NSArray *dataAllValues = [dataValue allValues];
            
            // for loop
            for (id valueDict in dataAllValues) {
                
                if ([valueDict isKindOfClass:[NSDictionary class]]) {
                    // get title
                    NSString *title = valueDict[@"title"];
                    if (title) {
                        //                        NSLog(@"%@", title);
                        Model *model = [[Model alloc] initWithnewsTitle:title];
                        [newsTitle addObject:model];
                    }
                    NSString *contents = [valueDict objectForKey:@"content"];
                    if (contents) {
                        Model *content = [[Model alloc] initWithnewsContent:contents];
                        [newsContent addObject:content];
                    }
                }
            }
            
//            if (newsTitle.count > 0) {
//                [tableview reloadData];
//            }
            [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
        }
        
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"error");
    }];
    [getnews enqueueOperation:op];
    
    
    //后台操作线程执行完后，到主线程更新UI
    
}
//滚动控件的委托方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
}

/**
 *  Button event
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickLoginButton:(id)sender
{
    LoginViewController *LoginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:LoginView];
    
    [self presentViewController:nav animated:YES completion:NULL];

}
- (void)clickRegButton:(id)sender
{
    RegViewController *RegView = [[RegViewController alloc] initWithNibName:@"RegViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:RegView];
    
    [self presentViewController:nav animated:YES completion:NULL];

}



- (void)clickQuoteButton:(id)sender
{
    QuoteViewController *quoteView = [[QuoteViewController alloc] init];
    
    [self.navigationController pushViewController:quoteView animated:YES];
}

- (void)clickConsultButton:(id)sender
{
    ConsultViewController *consultView = [[ConsultViewController alloc] init];
    
    [self.navigationController pushViewController:consultView animated:YES];
}




@end
