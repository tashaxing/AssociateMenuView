//
//  MenuView.m
//  AssociateMenuView
//
//  Created by yxhe on 16/9/22.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

// ---- 封装的分级菜单类 ---- //

#import "MenuView.h"

@interface MenuView ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *topButtonArray; // 顶部buttonView数组
    NSMutableArray *downTableViewArray; // 下拉的tableview数组
    NSMutableArray *gestureArray; // 存储手势的数组
    NSInteger curSelectTitleIndex; // 当前选中的title栏目索引
    NSInteger curSelectTableIndex; // 当前选中的一级table索引
    
    UIView *alphaLayerView; // 遮罩半透明层
    
    UITableView *tableview1; // 一级列表
    UITableView *tableview2; // 二级列表
}
@end

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - 设置控件数据
- (void)setMenuTitle:(NSArray *)titleArray withTableData:(NSArray *)tableData
{
    // tilte是数组，tabledata是字典数组
    topButtonArray = (NSMutableArray *)titleArray;
    downTableViewArray = (NSMutableArray *)tableData;
    
    gestureArray = [[NSMutableArray alloc] init];
    
    // 初始化头部栏
    for (int i = 0; i < topButtonArray.count; i++)
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(kTitleWidth * i, 0, kTitleWidth, kTitleHeight);
        titleLabel.layer.borderWidth = 1;
        titleLabel.layer.backgroundColor = [[UIColor greenColor] CGColor];
        titleLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
        titleLabel.text = (NSString *)titleArray[i];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.tag = 1000 + i;
        titleLabel.userInteractionEnabled = YES; // 普通view必须打开这个项
        UITapGestureRecognizer *titleTapGR = [[UITapGestureRecognizer alloc] init];
        [titleTapGR addTarget:self action:@selector(titleClicked:)];
        [gestureArray addObject:titleTapGR]; // 添加到数组便于后面索引
        [titleLabel addGestureRecognizer:titleTapGR];
        [self addSubview:titleLabel];
    }
    
    // 初始化所有栏目都未选中
    curSelectTitleIndex = -1;
    curSelectTableIndex = -1;
    
}

#pragma mark - 标题栏点击事件
- (void)titleClicked:(UITapGestureRecognizer *)tapTitleGesture
{
    if (curSelectTitleIndex == [gestureArray indexOfObject:tapTitleGesture])
    {
        [self hideAll];
        return;
    }
    
    // 根据点击的索引展开下拉的tableview，实时创建和remove
    // 初始化tableview，纵深干脆直接定为三级算了，没有的就不显示
    curSelectTitleIndex = [gestureArray indexOfObject:tapTitleGesture];
    
    // 切换title标签时要隐藏二级tableview
    tableview2.hidden = YES;
    
    // 设置选中效果（可以自行添加一些高级的）
    for (int i = 0; i < topButtonArray.count; i++)
    {
        UILabel *titleLabel = [self viewWithTag:1000 + i];
        if (i == curSelectTitleIndex)
        {
            titleLabel.layer.backgroundColor = [[UIColor blueColor] CGColor];
        }
        else
        {
            titleLabel.layer.backgroundColor = [[UIColor greenColor] CGColor];
        }
    }
        
    // 显示遮罩层修改可触摸范围，懒加载
    if (!alphaLayerView)
    {
        // 添加遮罩层
        alphaLayerView = [[UIView alloc] init];
        alphaLayerView.frame = CGRectMake(0, kTitleHeight, self.frame.size.width, kTableHeight * 3); // 遮盖住屏幕就可以，具体尺寸自定义
        alphaLayerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self insertSubview:alphaLayerView atIndex:0]; // 放在最底层
        
        UITapGestureRecognizer *layerTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(layerTapped)];
        [alphaLayerView addGestureRecognizer:layerTapGR]; // 触摸
    }
    [alphaLayerView setHidden:NO];
    self.frame = CGRectMake(0, 50, self.frame.size.width, kTableHeight * 3);
    
    // 动态添加、显示、隐藏tableview，懒加载
    if (!tableview1)
    {
        tableview1 = [[UITableView alloc] init];
        tableview1.delegate = self;
        tableview1.dataSource = self;
        [self addSubview:tableview1];
    }
    tableview1.frame = CGRectMake(kTitleWidth * curSelectTitleIndex, kTitleHeight, kTitleWidth, 0);
    [tableview1 reloadData];
    tableview1.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        // 动画下拉
        tableview1.frame = CGRectMake(kTitleWidth * curSelectTitleIndex, kTitleHeight, kTitleWidth, kTableHeight); // 在不同栏目下面出现
    }];
    
    
    NSLog(@"select %ld", curSelectTitleIndex);
    
}

- (void)layerTapped
{
    [self hideAll];
}

// 手气所有table和遮罩层
- (void)hideAll
{
    // 修改触摸区域
    self.frame = CGRectMake(0, 50, self.frame.size.width, kTableHeight);
    
    // 收起tableview
    [tableview2 setHidden:YES];
    [UIView animateWithDuration:0.3
                     animations:^{
                         tableview1.frame = CGRectMake(kTitleWidth * curSelectTitleIndex, kTitleHeight, kTitleWidth, 0);
                     } completion:^(BOOL finished) {
                         // 动画完成回调
                         // 隐藏table
                         tableview1.hidden = YES;
                         // 隐藏遮罩层
                         [alphaLayerView setHidden:YES];
                     }];
    // 修改title样式
    [self viewWithTag:1000 + curSelectTitleIndex].layer.backgroundColor = [[UIColor greenColor] CGColor];

    
    // 恢复未选中
    curSelectTitleIndex = -1;
}

#pragma mark - tableview 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableview1)
    {
        return [downTableViewArray[curSelectTitleIndex] count];
    }
    else if (tableView == tableview2)
    {
        NSString *key = [downTableViewArray[curSelectTitleIndex] allKeys][curSelectTableIndex];
        return [[downTableViewArray[curSelectTitleIndex] objectForKey:key] count];
    }
    return 0; // 必须最后返回值
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }

    if (tableView == tableview1)
    {
        cell.textLabel.text = [downTableViewArray[curSelectTitleIndex] allKeys][indexPath.row];
    }
    else if (tableView == tableview2)
    {
        NSString *key = [downTableViewArray[curSelectTitleIndex] allKeys][curSelectTableIndex];
        cell.textLabel.text = [[downTableViewArray[curSelectTitleIndex] objectForKey:key] objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选择table项，展开子菜单或者调用block刷新UI
    if (tableView == tableview1)
    {
        // 此处必须先改变一级索引，否则crash
        curSelectTableIndex = indexPath.row;
        // 选中一级菜单，弹出二级table,懒加载
        if (!tableview2)
        {
            tableview2 = [[UITableView alloc] init];
            tableview2.delegate = self;
            tableview2.dataSource = self;
            [self addSubview:tableview2];
        }
        
        // 先判断如果不存在二级table，直接输出值
        NSString *key = [downTableViewArray[curSelectTitleIndex] allKeys][curSelectTableIndex];
        if ([[downTableViewArray[curSelectTitleIndex] objectForKey:key] count] == 0)
        {
            NSString *result = [NSString stringWithFormat:@"%@--%@", topButtonArray[curSelectTitleIndex], key];
            [self hideAll];
            self.updateBlock(result);
            return;
        }
        
        // 其他情况就展开二级菜单
        tableview2.frame = CGRectMake(kTitleWidth * curSelectTitleIndex + kTitleWidth, kTitleHeight, 0, kTableHeight);
        tableview2.hidden = NO;
        [tableview2 reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            // 动画展开
            tableview2.frame = CGRectMake(kTitleWidth * curSelectTitleIndex + kTitleWidth, kTitleHeight, kTitleWidth, kTableHeight);
        }];
    }
    else if (tableView == tableview2)
    {
        NSString *key1 = [downTableViewArray[curSelectTitleIndex] allKeys][curSelectTableIndex];
        NSString *key2 = [[downTableViewArray[curSelectTitleIndex] objectForKey:key1] objectAtIndex:indexPath.row];
        NSString *result = [NSString stringWithFormat:@"%@--%@--%@", topButtonArray[curSelectTitleIndex], key1, key2];
        [self hideAll];
        self.updateBlock(result);
        
    }
}

@end
