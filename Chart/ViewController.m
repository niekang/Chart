//
//  ViewController.m
//  Chart
//
//  Created by 聂康  on 2017/7/12.
//  Copyright © 2017年 com.nk. All rights reserved.
//

#import "ViewController.h"
#import "PieChart.h"
#import "BarChat.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet PieChart *pieChart;
@property (weak, nonatomic) IBOutlet BarChat *barChart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //饼状图
    //设置数据源
    _pieChart.dataArr = @[@1,@2,@3];
    
    _barChart.xValues = @[@1,@2,@3];
    
    _barChart.yValues = @[@5,@10,@15];

    //设置各部分颜色
//    _pieChart.colorArr = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor]];
}


@end
