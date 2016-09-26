//
//  ViewController.m
//  AssociateMenuView
//
//  Created by yxhe on 16/9/22.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "ViewController.h"
#import "MenuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 先初始化菜单控制的视图（列表之类的），确保放在最底层
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 + kTitleHeight, self.view.frame.size.width, self.view.frame.size.height - 50 - kTitleHeight)];
    testLabel.backgroundColor = [UIColor yellowColor];
    testLabel.text = @"ready";
    [self.view addSubview: testLabel];
    
    // 初始化menu
    MenuView *menuView = [[MenuView alloc] init];
    menuView.userInteractionEnabled = YES;
    menuView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50); // 菜单空间的尺寸范围必须设置大一些，不然下拉列表不响应事件
    [self.view addSubview:menuView];
    // 填充数据
    NSArray *titleArray = @[@"Subject", @"Field", @"Order"];
    NSArray *tableData = @[
                           @{
                               @"Math" : @[],
                               @"Language" : @[],
                               @"Computer" : @[],
                               @"Art" : @[],
                               @"Finance" : @[],
                               @"Biology" : @[],
                               @"Social" : @[],
                               @"Engineering" : @[],
                               @"Medicine" : @[],
                               @"Media" : @[]
                               },
                           @{
                               @"Calculus" : @[],
                               @"English" : @[],
                               @"VR" : @[],
                               @"Drawing" : @[],
                               @"Botanic" : @[],
                               @"Economy" : @[],
                               @"Autamation" : @[],
                               @"Quant" : @[],
                               @"Weibo" : @[]
                               },
                           @{
                               @"Alphabet" : @[],
                               @"Ascend" : @[],
                               @"Descend" : @[],
                               @"Interest" : @[]
                               }
                           ];
    [menuView setMenuTitle:titleArray withTableData:tableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
