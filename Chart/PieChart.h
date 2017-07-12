//
//  PieChart.h
//  Chart
//
//  Created by 聂康  on 2017/7/12.
//  Copyright © 2017年 com.nk. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 饼状图
 */
@interface PieChart : UIView

@property (nonatomic, strong) NSArray * dataArr ;//必须设置 存放number类型

@property (nonatomic, strong) NSArray * colorArr ;//不设置颜色的话会填充随机色

@end
