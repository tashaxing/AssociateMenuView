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

@property (nonatomic, strong) UILabel *testLabel;;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 先初始化菜单控制的视图（列表之类的），确保放在最底层
    self.testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 + kTitleHeight, self.view.frame.size.width, self.view.frame.size.height - 50 - kTitleHeight)];
    self.testLabel.backgroundColor = [UIColor yellowColor];
    self.testLabel.text = @"ready";
    self.testLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: _testLabel];
    
    // 初始化menu
    MenuView *menuView = [[MenuView alloc] init];
    menuView.userInteractionEnabled = YES;
    menuView.frame = CGRectMake(0, 50, self.view.frame.size.width, kTableHeight); // 菜单控件尺寸高度定为table那么高或者动态去调节，使得手势触摸得到响应
    [self.view addSubview:menuView];
    // 填充数据
    NSArray *titleArray = @[@"Subject", @"Field", @"Order"];
    NSArray *tableData = @[
                           @{
                               @"Math" : @[@"m1", @"m2", @"m3", @"m4", @"m5", @"m6", @"m7", @"m8", @"m9", @"m10"],
                               @"Language" : @[@"l1", @"l2", @"l3", @"l4", @"l5", @"l6", @"l7", @"l8", @"l9", @"l10"],
                               @"Computer" : @[@"c1", @"c2", @"c3", @"c4", @"c5", @"c6", @"c7", @"c8", @"c9", @"c10"],
                               @"Art" : @[@"a1", @"a2", @"a3", @"a4", @"a5", @"a6", @"a7", @"a8", @"a9", @"a10"],
                               @"Finance" : @[@"f1", @"f2", @"f3", @"f4", @"f5", @"f6", @"f7", @"f8", @"f9", @"f10"],
                               @"Biology" : @[@"b1", @"b2", @"b3", @"b4", @"b5", @"b6", @"b7", @"b8", @"b9", @"b10"],
                               @"Social" : @[@"s1", @"s2", @"s3", @"s4", @"s5", @"s6", @"s7", @"s8", @"s9", @"s10"],
                               @"Engineering" : @[@"e1", @"e2", @"e3", @"e4", @"e5", @"e6", @"e7", @"e8", @"e9", @"e10"],
                               @"Medicine" : @[@"y1", @"y2", @"y3", @"y4", @"y5", @"y6", @"y7", @"y8", @"y9", @"y10"],
                               @"Media" : @[@"t1", @"t2", @"t3", @"t4", @"t5", @"t6", @"t7", @"t8", @"t9", @"t10"]
                               },
                           @{
                               @"Calculus" : @[@"weifen", @"jifen"],
                               @"English" : @[@"reading", @"talking"],
                               @"VR" : @[@"game", @"movie", @"science"],
                               @"Drawing" : @[@"picture", @"sketching"],
                               @"Botanic" : @[@"flower", @"tree", @"grass"],
                               @"Economy" : @[@"stock", @"bond", @"security", @"CDO", @"CDS"],
                               @"Autamation" : @[@"electric", @"robot"],
                               @"Quant" : @[@"IQ", @"smart", @"money"],
                               @"Weibo" : @[@"caogen", @"spread", @"boring"]
                               },
                           @{
                               @"Alphabet" : @[],
                               @"Ascend" : @[],
                               @"Descend" : @[],
                               @"Interest" : @[]
                               }
                           ];
    [menuView setMenuTitle:titleArray withTableData:tableData];
    __weak typeof(self) wself = self;
    menuView.updateBlock = ^(NSString *result){
        wself.testLabel.text = result;
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
