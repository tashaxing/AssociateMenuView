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
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
        [tapGR addTarget:self action:@selector(titleClicked:)];
        [gestureArray addObject:tapGR]; // 添加到数组便于后面索引
        [titleLabel addGestureRecognizer:tapGR];
        [self addSubview:titleLabel];
    }
    
    // 初始化所有栏目都未选中
    curSelectTitleIndex = -1;
    
}

#pragma mark - 标题栏点击事件
- (void)titleClicked:(UITapGestureRecognizer *)tapTitleGesture
{
    // 根据点击的索引展开下拉的tableview，实时创建和remove
    // 初始化tableview，纵深干脆直接定为三级算了，没有的就不显示
    curSelectTitleIndex = [gestureArray indexOfObject:tapTitleGesture];
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
    
    // 动态添加和移除一层半透明的膜
    UIView *alphaLayerView = [[UIView alloc] init];
    
    // 动态添加、显示、隐藏tableview
    UITableView *tableView1 = [[UITableView alloc] init];
    tableView1.frame = CGRectMake(0, kTitleHeight, kTitleWidth, kTableHeight);
    tableView1.delegate = self;
    tableView1.dataSource = self;
    [self addSubview:tableView1];
    
    
    NSLog(@"select %ld", curSelectTitleIndex);
    
}

#pragma mark - tableview 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [downTableViewArray[curSelectTitleIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }

    cell.textLabel.text = [downTableViewArray[curSelectTitleIndex] allKeys][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选择table项，展开子菜单或者调用block刷新UI
}



@end
