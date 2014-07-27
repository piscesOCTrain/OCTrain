//
//  mainViewController.m
//  NoSecret
//
//  Created by 成城 on 14-7-23.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "mainViewController.h"
#import "TableViewCell.h"

@interface mainViewController ()

@end

@implementation mainViewController

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
    UIView *TopView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 60)];
    TopView.backgroundColor = [UIColor grayColor];
    UIButton *TopButton =[UIButton buttonWithType:UIButtonTypeCustom];
    TopButton.frame = CGRectMake(0, 0, 60, 60);
    [TopView addSubview:TopButton];
    TopButton.backgroundColor = [UIColor blackColor];

    
    UITableView *TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 470)];
    
    
    [self.view addSubview:TopView];
    [self.view addSubview:TableView];
    UITabBar *bottomBar = [[UITabBar alloc] init];
    bottomBar.frame = CGRectMake(0, 530, 320, 40);
    TableView.dataSource = self;
    TableView.delegate = self;

    data = [[NSArray alloc]init];
    
    NSString *str1 = @"中国人思维定式：一提到女秘，就想到小蜜；一提到女官，就想到被窝； 一提到领导，就想到贪污；一提到贪官，就想到二奶； 一提到桑拿，就想到小姐；一提到办事，就想到关系； 一提到工程，就想到腐败；一提到垄断，就想到奸商； 一提到打假，就想到假打。";
    NSString *str2 = @"明明人在线，明明想说话，还要学隐身；明明很难过，明明很想哭，还要裂嘴笑；明明很孤单，明明很害怕，还要一个人；明明想见面，明明很期待，还要去拒绝；明明心很乱，明明想人陪，还要装沉默；明明舍不得，明明放不下，还要去放手；明明在心里，明明很在乎，还要无所谓！";
    NSString *str3 = @"Active long will be very tired, care about for a long time will crash!----主动久了会很累，在乎久了会崩溃!";
    NSString *str4 = @"可口可乐总裁曾说过：我们每个人都像小丑，玩着五个球。五个球是你的工作、健康、家庭、朋友、灵魂，这五个球只有一个是用橡胶做的，掉下去会弹起来，那就是工作。另外四个球都是用玻璃做的，掉了，就碎了。";
    
    data = [NSArray arrayWithObjects:str1,str2,str3,str4, nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *text = [data objectAtIndex:indexPath.row];
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0], NSFontAttributeName,nil];
//    CGRect size = [text boundingRectWithSize:CGSizeMake(320, 220) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"cell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellname];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    
    //config the cell
    NSString *text = [data objectAtIndex:indexPath.row];
    cell.label.text = text;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:cell.label.font,NSFontAttributeName,nil];
    CGRect size = [text boundingRectWithSize:CGSizeMake(320, 220) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    cell.label.frame = size;
    }
    
    return cell;
}

@end