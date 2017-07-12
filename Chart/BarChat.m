//
//  BarChat.m
//  Chart
//
//  Created by 聂康  on 2017/7/12.
//  Copyright © 2017年 com.nk. All rights reserved.
//

#import "BarChat.h"

@interface BarChat ()

@property (nonatomic, assign) float maxY;

@end

@implementation BarChat

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

/**
 初始化
 */
- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.mainLineColor = [UIColor lightGrayColor];
    self.fillColor = [UIColor grayColor];
    self.lineWidth = 1;
    self.space = 20;
}

- (void)setYValues:(NSArray *)yValues {
    _yValues = yValues;
    // 找到最大Y值
    _maxY = 0;
    for (NSNumber *number in yValues) {
        float v = number.floatValue;
        if (_maxY < v) {
            _maxY = v;
        }
    }
    [self setNeedsDisplay];
}

- (void)setColorArr:(NSArray *)colorArr {
    _colorArr = colorArr;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

/**
 colorArr未设置时，为colorArr设置随机色
 */
- (void)randomColor{
    NSMutableArray *colors = [NSMutableArray array];
    for (id obj in self.xValues) {
        CGFloat r = arc4random_uniform(255)/255.0;
        CGFloat g = arc4random_uniform(255)/255.0;
        CGFloat b = arc4random_uniform(255)/255.0;
        UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1];
        [colors addObject:color];
    }
    _colorArr = colors;
}

- (void)drawRect:(CGRect)rect {
    //无数据不显示
    if (!self.xValues || !self.yValues) {
        return;
    }
    
    //设置随机色
    if (!self.colorArr) {
        [self randomColor];
    }
    
    //坐标轴距离视图左边距离
    CGFloat leftMargin = 60;
    //坐标轴距离视图底部距离
    CGFloat bottomMargin = 25;
    //视图宽度
    CGFloat width = rect.size.width;
    //视图高度
    CGFloat height = rect.size.height;
    
    //画X、Y轴
    UIBezierPath *mainPath = [UIBezierPath bezierPath];
    [mainPath moveToPoint:CGPointMake(leftMargin, 0)];
    [mainPath addLineToPoint:CGPointMake(leftMargin, height-bottomMargin)];
    [mainPath addLineToPoint:CGPointMake(width, height-bottomMargin)];
    mainPath.lineWidth = self.lineWidth;
    [self.mainLineColor setStroke];
    [mainPath stroke];
    
    // Y轴画箭头
    UIBezierPath *yArrowPath = [UIBezierPath bezierPath];
    [yArrowPath moveToPoint:CGPointMake(leftMargin-5, 5)];
    [yArrowPath addLineToPoint:CGPointMake(leftMargin, 0)];
    [yArrowPath addLineToPoint:CGPointMake(leftMargin + 5 , 5)];
    yArrowPath.lineWidth = self.lineWidth;
    [self.mainLineColor setStroke];
    [yArrowPath stroke];
    
    // X轴画箭头
    UIBezierPath *xArrowPath = [UIBezierPath bezierPath];
    [xArrowPath moveToPoint:CGPointMake(width-5, height-bottomMargin-5)];
    [xArrowPath addLineToPoint:CGPointMake(width, height-bottomMargin)];
    [xArrowPath addLineToPoint:CGPointMake(width - 5 , height-bottomMargin+5)];
    xArrowPath.lineWidth = self.lineWidth;
    [self.mainLineColor setStroke];
    [xArrowPath stroke];
    
    //创建Y轴
    //柱状图刻度 上部留出5 显示4等分刻度
    CGFloat top = 10;
    CGFloat h = (height - bottomMargin - top)/4.0;
    for (int i=0; i<5; i++) {
        //创建Y轴lab
        CGFloat tail = 5;
        UILabel *yLab = [[UILabel alloc] init];
        yLab.frame = CGRectMake(0, top + h * i, leftMargin-tail, 20);
        yLab.font = [UIFont systemFontOfSize:14];
        yLab.textAlignment = NSTextAlignmentRight;
        yLab.text = [NSString stringWithFormat:@"%.2f",_maxY * (4-i)/4];
        yLab.textColor = [UIColor lightGrayColor];
        [self addSubview:yLab];
    }
    
    //创建X轴
    //柱状图宽度
    CGFloat w = (width-leftMargin-(self.xValues.count+1) * self.space)/(self.xValues.count);
    for (int i=0; i<_xValues.count; i++) {
        //X轴label
        UILabel *xLab = [[UILabel alloc] init];
        xLab.frame = CGRectMake(leftMargin + (self.space + w) * i, height-bottomMargin, 2*self.space+w, bottomMargin);
        xLab.font = [UIFont systemFontOfSize:14];
        xLab.textAlignment = NSTextAlignmentCenter;
        xLab.text = [NSString stringWithFormat:@"%.2f",[_xValues[i] floatValue]];
        xLab.textColor = [UIColor lightGrayColor];
        [self addSubview:xLab];
        
        //画柱状图
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat x = leftMargin + self.space + (w + self.space) * i;
        CGFloat y = height - bottomMargin - [_yValues[i] floatValue]/_maxY * (height - bottomMargin - top);
        [path moveToPoint:CGPointMake(x, height - bottomMargin)];
        [path addLineToPoint:CGPointMake(x, y)];
        [path addLineToPoint:CGPointMake(x+w, y)];
        [path addLineToPoint:CGPointMake(x+w, height-bottomMargin)];
        if (self.colorArr) {
            [(UIColor *)self.colorArr[i] setFill];
        }else{
            [self.fillColor setFill];
        }
        [path fill];
        
        //显示数据label
        CGFloat valueLabH = 20;
        UILabel *valueLab = [[UILabel alloc] init];
        valueLab.frame = CGRectMake(leftMargin + (self.space + w) * i, y-valueLabH, 2*self.space+w, valueLabH);
        valueLab.font = [UIFont systemFontOfSize:14];
        valueLab.textAlignment = NSTextAlignmentCenter;
        valueLab.text = [NSString stringWithFormat:@"%.2f",[_yValues[i] floatValue]];
        valueLab.textColor = [UIColor lightGrayColor];
        [self addSubview:valueLab];

    }
}

@end
