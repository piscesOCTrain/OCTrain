//
//  SearchResultViewController.m
//  lyfzw
//
//  Created by 成城 on 14-8-17.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "SearchResultViewController.h"
#import "Model.h"
#import "InfoViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *srvtable = [[UITableView alloc] init];
    srvtable.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, self.view.frame.size.height);
    srvtable.delegate = self;
    srvtable.dataSource = self;
    [self.view addSubview:srvtable];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _result.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"result";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellname];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    cell.textLabel.text = ((Model *)[_result objectAtIndex:indexPath.row]).newsTitle;

    return cell;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoViewController *infoview = [[InfoViewController alloc] init];
    infoview.info = ((Model *)[_result objectAtIndex:indexPath.row]).newsContent;
    
    [self.navigationController pushViewController:infoview animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
