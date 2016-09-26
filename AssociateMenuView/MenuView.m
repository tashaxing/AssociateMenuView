//
//  MenuView.m
//  AssociateMenuView
//
//  Created by yxhe on 16/9/22.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

// ---- 封装的分级菜单类 ---- //

#import "MenuView.h"

#define kTitleWidth self.frame.size.width / topButtonArray.count
#define kTitleHeight 30

@interface MenuView ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *topButtonArray; // 顶部buttonView数组
    NSMutableArray *downTableViewArray; // 下拉的tableview数组
}
@end

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

#pragma mark - 设置控件数据
- (void)setMenuTitle:(NSArray *)titleArray withTableData:(NSArray *)tableData
{
    // tilte是数组，tabledata是字典数组
    topButtonArray = (NSMutableArray *)titleArray;
    downTableViewArray = (NSMutableArray *)tableData;
    
    // 初始化头部栏
    for (int i = 0; i < titleArray.count; i++)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(kTitleWidth * i, 0, kTitleWidth, kTitleHeight);
        titleLabel.text = (NSString *)titleArray[i];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
        [tapGR addTarget:self action:@selector(titleClicked:)];
        [titleLabel addGestureRecognizer:tapGR];
    }
    
}

#pragma mark - 标题栏点击事件
- (void)titleClicked:(UILabel *)sender
{
    // 根据点击的索引展开下拉的tableview，实时创建和remove
    // 初始化tableview，纵深干脆直接定为三级算了，没有的就不显示
    
    if ()
    
    
}


@end
