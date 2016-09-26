//
//  MenuView.h
//  AssociateMenuView
//
//  Created by yxhe on 16/9/22.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitleWidth self.frame.size.width / topButtonArray.count
#define kTitleHeight 30
#define kTableHeight 200

typedef void (^tableFinishedClickBlock)(NSMutableArray *); // 定义block用于外部回调

@interface MenuView : UIView

// 设置菜单数据
- (void)setMenuTitle:(NSArray *)titleArray withTableData:(NSArray *)tableData;

@end
