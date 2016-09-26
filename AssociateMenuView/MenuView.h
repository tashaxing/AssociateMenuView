//
//  MenuView.h
//  AssociateMenuView
//
//  Created by yxhe on 16/9/22.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^tableFinishedClickBlock)(NSMutableArray *); // 定义block用于外部回调

@interface MenuView : UIView

// 设置菜单数据
- (void)setMenuTitle:(NSArray *)titleArray withTableData:(NSArray *)tableData;

@end
