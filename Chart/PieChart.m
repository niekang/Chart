
//
//  PieChart.m
//  Chart
//
//  Created by 聂康  on 2017/7/12.
//  Copyright © 2017年 com.nk. All rights reserved.
//

#import "PieChart.h"

@interface PieChart ()

@property (nonatomic, strong)NSMutableArray *percentArr;// 百分比数组

@end

@implementation PieChart

- (NSMutableArray *)percentArr {
    if (!_percentArr) {
        _percentArr = [NSMutableArray array];
    }
    return _percentArr;
}


- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    
    // 计算百分比
    float total = 0;
    for (NSNumber *number in dataArr) {
        // 数据总大小
        total += number.floatValue;
    }
    
    for (NSNumber *number in dataArr) {
        [self.percentArr addObject:@(number.floatValue/total)];
    }
    
    [self setNeedsDisplay];
}

- (void)setColorArr:(NSArray *)colorArr {
    _colorArr = colorArr;
    [self setNeedsDisplay];
}


/**
 colorArr未设置时，为colorArr设置随机色
 */
- (void)randomColor{
    NSMutableArray *colors = [NSMutableArray array];
    for (id obj in self.dataArr) {
        CGFloat r = arc4random_uniform(255)/255.0;
        CGFloat g = arc4random_uniform(255)/255.0;
        CGFloat b = arc4random_uniform(255)/255.0;
        UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1];
        [colors addObject:color];
    }
    _colorArr = colors;
}

- (void)drawRect:(CGRect)rect {
    //无数据源无需绘制
    if (!self.dataArr.count) {
        return;
    }
    //未设置颜色随机生成
    if (!self.colorArr.count) {
        [self randomColor];
    }
    //设置颜色出错，颜色与数据源不能一一对应,不绘制
    if (self.colorArr.count != self.dataArr.count) {
        return;
    }
    
    //起始弧度
    CGFloat startAngle = 0;
    //结束弧度
    CGFloat endAngle = 0;
    //圆心
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    //半径
    CGFloat radius = rect.size.width/2;
    
    for (int i=0; i<self.percentArr.count; i++) {
        //起始弧度为上次的结束弧度
        startAngle = endAngle;
        //根据比例计算结束弧度
        endAngle += [self.percentArr[i] floatValue] * M_PI * 2;
        //准备路径
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        //结束时需要与圆心连线
        [path addLineToPoint:center];
        //设置线的颜色
        [[UIColor clearColor] setStroke];
        //设置填充颜色
        [(UIColor *)self.colorArr[i] setFill];
        //填充
        [path fill];
        //划线
        [path stroke];
    }
}

@end
