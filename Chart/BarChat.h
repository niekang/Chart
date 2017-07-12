//
//  BarChat.h
//  Chart
//
//  Created by 聂康  on 2017/7/12.
//  Copyright © 2017年 com.nk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarChat : UIView

@property (nonatomic, strong) NSArray * xValues ;//必须设置 X轴

@property (nonatomic, strong) NSArray * yValues ;//必须设置 Y轴

@property (nonatomic, strong) NSArray * colorArr ;//不设置颜色的话会填充fillColor

@property (nonatomic, strong) UIColor * fillColor ;//默认填充灰色

@property (nonatomic, strong) UIColor * mainLineColor ;//坐标轴颜色

@property (nonatomic, assign) CGFloat lineWidth ;//线宽

@property (nonatomic, assign) CGFloat space ;//柱状图之间的距离

@end
