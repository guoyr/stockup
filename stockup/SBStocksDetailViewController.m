//
//  SBStocksDetailViewController.m
//  StockBot
//
//  Created by Robert Guo on 2/26/14.
//  Copyright (c) 2014 Robert Guo. All rights reserved.
//

#import <AFNetworking.h>
#import "SBStocksDetailViewController.h"
#import "SBConstants.h"
#import "SBStock.h"
#import "SBDataManager.h"
#import "SBStockGraphView.h"
#import <CorePlot-CocoaTouch.h>
#import "APFinancialData.h"
#import "APYahooDataPuller.h"
#import "NSDateFormatterExtensions.h"

#define ROWS_FIRST_DATA_ORDER 1

@interface SBStocksDetailViewController ()<APYahooDataPullerDelegate,CPTPlotDataSource,CPTAxisDelegate>
//上下两个图的View 盛放两个 Plot
@property(nonatomic,strong)UIView *KstickGraphView;
@property(nonatomic,strong)UIView *VstickGraphView;
//股票走势图的属性
@property(nonatomic,strong)CPTGraphHostingView *KgraphHostView;
@property(nonatomic,strong)CPTGraphHostingView *VolumehostView;

@property (nonatomic, strong) CPTXYGraph *Kgraph;
@property (nonatomic, strong) CPTXYGraph *Vgraph;
@property (nonatomic, strong) APYahooDataPuller *datapuller;

@property (nonatomic, strong) CPTMutableLineStyle *majorGridLineStyle;
@property (nonatomic, strong) CPTMutableLineStyle *minorGridLineStyle;

@property (nonatomic,strong) CPTXYAxisSet *KxyAxisSet;
@property (nonatomic,strong) CPTXYAxisSet *VxyAxisSet;

@property (nonatomic,strong)CPTXYPlotSpace *KplotSpace;
@property (nonatomic,strong)CPTXYPlotSpace *VplotSpace;
@property (nonatomic,strong)CPTXYPlotSpace *scatterplotSpace;

@property(nonatomic,strong)CPTBarPlot *volumeplot;
@property(nonatomic,strong)CPTScatterPlot *scatterplot;
@property(nonatomic,strong)CPTTradingRangePlot *TradingRangePlot;

//存放X轴上日期的Label
@property (nonatomic,strong)NSMutableArray *XdataLabelArray;
@property(nonatomic,strong)NSMutableArray *VdateLabelArray;

@property(nonatomic,strong)NSMutableArray *KmajorTickLocations;

@property(nonatomic,strong)NSMutableArray *VmajorTickLocations;

//虚线样式
@property(nonatomic,strong)CPTMutableLineStyle *tickLinestyle;
//x y 及 边框的样式
@property(nonatomic,strong)CPTMutableLineStyle *borderLineStyle;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) SBStockGraphView *kChartView;
@property (nonatomic, strong) SBStockGraphView *macdView;

@property (nonatomic, strong) SBStock *stock;

//创建一个滚动视图用于时间选择
@property (nonatomic,strong)UIScrollView *datePickerView;

@property (nonatomic,strong) NSString *datestr;

//K线图 上显示的股票简介 时间 日期、、
@property (nonatomic,strong)UILabel *IntroduceStockLabel;

//定义一个股票编号 用于切换股票的类型
@property (nonatomic,copy)NSString *stockId;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *todayOpeningPriceLabel;
@property (nonatomic, strong) UILabel *yesterdayClosingPriceLabel;
@property (nonatomic, strong) UILabel *todayHighLabel;
@property (nonatomic, strong) UILabel *todayLowLabel;
@property (nonatomic, strong) UILabel *currentPriceLabel;
@property (nonatomic, strong) UILabel *buyPriceLabel;
@property (nonatomic, strong) UILabel *sellPriceLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, assign) NSInteger labelHeight;
@property (nonatomic, assign) NSInteger labelWidth;

@property(nonatomic,strong)NSDate *startdate;

//用于显示第二幅图的数据
@property(nonatomic,strong)NSDecimalNumber *low;
@property(nonatomic,strong)NSDecimalNumber *high;
@property(nonatomic,strong)NSDecimalNumber *length;
@property(nonatomic,strong)NSDecimalNumber *overallVolumeHigh;
@property(nonatomic,strong)NSDecimalNumber *overallVolumeLow;
@property(nonatomic,strong)NSDecimalNumber *volumeLength;
@property(nonatomic,strong)NSDecimalNumber *volumePlotSpaceDisplacementPercent;
@property(nonatomic,strong)NSDecimalNumber *volumeLengthDisplacementValue;


@end

@implementation SBStocksDetailViewController
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.XdataLabelArray = [NSMutableArray arrayWithCapacity:30];
    self.VdateLabelArray = [[NSMutableArray alloc]init];
    self.KmajorTickLocations = [[NSMutableArray alloc]init];
    self.VmajorTickLocations = [[NSMutableArray alloc]init];
    [self LineStyleOfThePlot];
    [self createKplot];
    
    [self createVplot];
    

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
    self.scrollView.frame = self.view.bounds;
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:BLACK_BG];
    
    
    //显示股票名称，日期信息
    _IntroduceStockLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 15, 430, 30)];
    _IntroduceStockLabel.backgroundColor = [UIColor clearColor];
    
    _IntroduceStockLabel.font = [UIFont boldSystemFontOfSize:15];
    _IntroduceStockLabel.textColor = [UIColor whiteColor];
    
    NSDate *nowdate  = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.datestr = [formatter stringFromDate:nowdate];
    NSLog(@"%@",self.datestr);
    [self createBottomLabels];
    
    [self.KstickGraphView addSubview:self.KgraphHostView];
    [self.scrollView addSubview:self.KstickGraphView];
    [self.scrollView addSubview:_IntroduceStockLabel];
    [self.scrollView addSubview:_VstickGraphView];
    
    
    UIButton *ChangeButtonS = [[UIButton alloc]initWithFrame:CGRectMake(80, 330, 50, 30)];
    ChangeButtonS.tag = 1000;
    ChangeButtonS.backgroundColor = [UIColor purpleColor];
    [ChangeButtonS setTitle:@"S" forState:UIControlStateNormal];
    [ChangeButtonS addTarget:self action:@selector(changeTheplot:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:ChangeButtonS];
    
    UIButton *ChangeButtonV = [[UIButton alloc]initWithFrame:CGRectMake(80, 370, 50, 30)];
    ChangeButtonV.tag = 1001;
    ChangeButtonV.backgroundColor = [UIColor purpleColor];
    [ChangeButtonV setTitle:@"V" forState:UIControlStateNormal];
    [ChangeButtonV addTarget:self action:@selector(changeTheplot:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:ChangeButtonV];
    
    [self.view addSubview:self.scrollView];
    
    [self createFiveTimeButtons];


}
- (void)changeTheplot:(UIButton *)sender{
    
    if (sender.tag == 1000) {
        
        NSLog(@"%lu",sender.tag);
        //创建scatter plot
        
        [self createScatterPlot];
        self.scatterplotSpace       = (CPTXYPlotSpace *)self.VolumehostView.hostedGraph.defaultPlotSpace;
        [self createXaxis];
        
        self.scatterplotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromUnsignedInteger(self.datapuller.financialData.count + 1)];
        self.scatterplotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[self.low decimalValue] length:self.length.decimalValue];
        
        //self.xybottomAxisSet.xAxis.orthogonalCoordinateDecimal = self.low.decimalValue;
        
        //        CPTConstraints *constence = [CPTConstraints constraintWithLowerOffset:[self.low floatValue]];
        //        self.xybottomAxisSet.xAxis.axisConstraints = constence;
        
        if ([self.Vgraph allPlots].count > 0) {
            
            NSLog(@"lllllllllllllll%lu",self.Vgraph.allPlots.count);
            
            for (unsigned long int i = 0 ; i<[self.Vgraph allPlots].count; i++) {
                
                [self.Vgraph removePlot:[self.Vgraph allPlots][i]];
            }
            [self.Vgraph addPlot:self.scatterplot];
        }
        else{
            
            [self.Vgraph addPlot:self.scatterplot];
        }
        
        
    }
    
    if (sender.tag == 1001) {
        
        // volume plotspace 的xrange  yrange
        NSLog(@"%lu",sender.tag);
         self.VplotSpace = (CPTXYPlotSpace *)self.VolumehostView.hostedGraph.defaultPlotSpace;
        [self createXaxis];
        [self createYAxis];
        
        self.VplotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromUnsignedInteger(self.datapuller.financialData.count + 1)];
        
        NSDecimalNumber *NumPercent = [NSDecimalNumber decimalNumberWithString:@"0.3"];
        NSDecimalNumber *volumeLengthDisplacementValue = [self.volumeLength decimalNumberByMultiplyingBy:NumPercent];
        
        NSDecimalNumber *volumeLowDisplayLocation      = 0;
        
        NSDecimalNumber *volumeLengthDisplayLocation   = [self.overallVolumeHigh decimalNumberByAdding:volumeLengthDisplacementValue];
        self.VplotSpace.yRange = [CPTPlotRange plotRangeWithLocation:volumeLowDisplayLocation.decimalValue length:volumeLengthDisplayLocation.decimalValue];
        
        if ([self.Vgraph allPlots].count > 0) {
            for (unsigned long int i = 0 ; i<[self.Vgraph allPlots].count; i++) {
                [self.Vgraph removePlot:[self.Vgraph allPlots][i]];
            }
            [self.Vgraph addPlot:self.volumeplot];
        }
        else{
            [self.Vgraph addPlot:self.volumeplot];
            
        }
        
        
    }
    
    
}
#pragma Mark CreateFiveTimeButtons

-(void)createFiveTimeButtons{
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(136, 321, 56, 38)];
    button1.backgroundColor = [UIColor grayColor];
    [button1 setTitle:@"分时" forState:UIControlStateNormal];
    [self.scrollView addSubview:button1];
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(193, 321, 56, 38)];
    
    button2.backgroundColor = [UIColor grayColor];
    [button2 setTitle:@"五日" forState:UIControlStateNormal];
    [self.scrollView addSubview:button2];
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(250, 321, 56, 38)];
    
    button3.backgroundColor = [UIColor grayColor];
    [button3 setTitle:@"日K" forState:UIControlStateNormal];
    [self.scrollView addSubview:button3];
    [button3 addTarget:self action:@selector(dayStock) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button4 = [[UIButton alloc]initWithFrame:CGRectMake(307, 321, 56, 38)];
    
    button4.backgroundColor = [UIColor grayColor];
    [button4 setTitle:@"周K" forState:UIControlStateNormal];
    [self.scrollView addSubview:button4];
    UIButton *button5 = [[UIButton alloc]initWithFrame:CGRectMake(364, 321, 56, 38)];
    
    button5.backgroundColor = [UIColor grayColor];
    [button5 setTitle:@"月K" forState:UIControlStateNormal];
    [self.scrollView addSubview:button5];


}

-(void)dayStock{
    
    self.startdate         = [NSDate dateWithTimeIntervalSinceNow:-60.0 * 60.0 * 24.0 * 30]; // 30 days ago
    NSDate *end           = [NSDate date];
    self.datapuller = [[APYahooDataPuller alloc] initWithTargetSymbol:self.stockId targetStartDate:self.startdate targetEndDate:end];
    NSLog(@"**************sel.stockid = %@",self.stockId);
    [self.datapuller setDelegate:self ];
    
    
}





#pragma Mark LineStyleOfthePlot
-(void)LineStyleOfThePlot{
    
    self.tickLinestyle = [CPTMutableLineStyle lineStyle];
    self.tickLinestyle.lineWidth = 1.0f;
    self.tickLinestyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithFloat:2.0f], [NSNumber numberWithFloat:2.0f], nil];
    self.tickLinestyle.patternPhase = 0.0f;
    self.tickLinestyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];
    
    //外框的颜色和宽度
    self.borderLineStyle = [CPTMutableLineStyle lineStyle];
    self.borderLineStyle.lineColor              = [CPTColor whiteColor];
    self.borderLineStyle.lineWidth              = 1.0;

}
#pragma Mark create K plot
-(void)createKplot{
    
    NSLog(@"%lu",(unsigned long)self.Kgraph.allPlots.count);
    if (self.Kgraph.allPlots.count > 0) {
        [self.Kgraph removePlot:self.TradingRangePlot];
    }
  
    //创建一个view用于显示股票的K线图
    _KstickGraphView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 410, 350)];
    _KstickGraphView.backgroundColor = [UIColor whiteColor];

    
    //K线图
    CPTXYGraph *newGraph = [[CPTXYGraph alloc] initWithFrame:self.view.bounds xScaleType:CPTScaleTypeDateTime yScaleType:CPTScaleTypeDateTime];
    self.KgraphHostView = [[CPTGraphHostingView alloc]initWithFrame:_KstickGraphView.bounds];
    
    CPTTheme *theme      = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    CPTMutableTextStyle *titleTextStyle = [CPTMutableTextStyle textStyle];
    titleTextStyle.color                = [CPTColor whiteColor];
    titleTextStyle.fontName             = @"Helvetica-Bold";
    titleTextStyle.fontSize             = 16;
    
    newGraph.titleTextStyle = titleTextStyle;
    
    [newGraph applyTheme:theme];
    
    self.kgraph = newGraph;
    //左右的间距
    newGraph.paddingRight                = 10.0;
    newGraph.paddingLeft                 = 50.0;
    newGraph.paddingBottom =  50;
    newGraph.plotAreaFrame.masksToBorder = NO;
    newGraph.plotAreaFrame.cornerRadius  = 0.0;
    self.KgraphHostView.hostedGraph             = newGraph;
    self.KplotSpace = (CPTXYPlotSpace *) self.Kgraph.defaultPlotSpace;
    
    // Axes
    self.KxyAxisSet        = (CPTXYAxisSet *)newGraph.axisSet;
    newGraph.plotAreaFrame.borderLineStyle =self.borderLineStyle;
    self.KxyAxisSet.yAxis.axisLineStyle  = self.borderLineStyle;
    self.KxyAxisSet.xAxis.axisLineStyle  = self.borderLineStyle;
    
    // 改变线条的颜色和宽度
    CPTMutableLineStyle *whiteLineStyle = [CPTMutableLineStyle lineStyle];
    whiteLineStyle.lineColor = [CPTColor whiteColor];
    whiteLineStyle.lineWidth = 1.0;
    self.TradingRangePlot = [[CPTTradingRangePlot alloc] initWithFrame:newGraph.bounds];
    
    self.TradingRangePlot.identifier = @"OHLC";
    self.TradingRangePlot.lineStyle  = whiteLineStyle;
    //每条竖线控制的间距
    self.TradingRangePlot.dataSource     = self;
    
    //Trading 的样子
    self.TradingRangePlot.plotStyle      = CPTPlotCachePrecisionDouble;
    
    //柱状图边框颜色
    CPTMutableLineStyle *decreaseLineStyle = [CPTMutableLineStyle lineStyle];
    decreaseLineStyle.lineColor = [CPTColor greenColor];
    
    decreaseLineStyle.lineWidth = 2.0;
    self.TradingRangePlot.decreaseFill = [CPTFill fillWithColor:[CPTColor greenColor] ];
    self.TradingRangePlot.decreaseLineStyle = decreaseLineStyle;
    
    CPTMutableLineStyle *increaseLineStyle = [CPTMutableLineStyle lineStyle];
    increaseLineStyle.lineColor = [CPTColor redColor];
    increaseLineStyle.lineFill = [CPTFill fillWithColor:[CPTColor redColor]];
    self.TradingRangePlot.increaseFill = [CPTFill fillWithColor:[CPTColor redColor] ];
    increaseLineStyle.lineWidth = 2.0;
    
    self.TradingRangePlot.increaseLineStyle = increaseLineStyle;
    [self.Kgraph addPlot:self.TradingRangePlot];

    
}
#pragma Mark Creat V plot
-(void)createVplot{
    
    _VstickGraphView= [[UIView alloc]initWithFrame:CGRectMake(20, 340, 410, 300)];
    _VstickGraphView.backgroundColor = [UIColor redColor];
    
    //第二个Volume图
    
    //创建volumeGraph
    CPTXYGraph *VolumeGraph = [[CPTXYGraph alloc]initWithFrame:_VstickGraphView.bounds];
    //左右的间距
    VolumeGraph.paddingRight                = 10.0;
    VolumeGraph.paddingLeft                 = 50.0;
    VolumeGraph.paddingBottom               = 50;
    VolumeGraph.plotAreaFrame.masksToBorder = NO;
    VolumeGraph.borderWidth = 0.0;
    
    VolumeGraph.plotAreaFrame.cornerRadius  = 100.0;
    self.VolumehostView = [[CPTGraphHostingView alloc]initWithFrame:_VstickGraphView.bounds];
    self.VolumehostView.hostedGraph = VolumeGraph;
    CPTTheme *volumetheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    VolumeGraph.fill = [CPTFill fillWithColor:[CPTColor grayColor]];
    [VolumeGraph applyTheme:volumetheme];
    VolumeGraph.cornerRadius = 0.0;
    
    [_VstickGraphView addSubview:self.VolumehostView];
    
    self.Vgraph = VolumeGraph;
    VolumeGraph.plotAreaFrame.borderLineStyle = self.borderLineStyle;
    
    //创建X轴 Y轴
    self.VxyAxisSet        = (CPTXYAxisSet *)self.Vgraph.axisSet;
    
    self.VxyAxisSet.xAxis.axisLineStyle            = self.borderLineStyle;
    self.VxyAxisSet.yAxis.axisLineStyle            = self.borderLineStyle;
    
    self.VxyAxisSet.yAxis.majorIntervalLength         = CPTDecimalFromDouble(1.0);
    
    //设置X Y的坐标轴自定义
    self.VxyAxisSet.yAxis.labelingPolicy              = CPTAxisLabelingPolicyNone;
    self.VxyAxisSet.xAxis.labelingPolicy              = CPTAxisLabelingPolicyNone;
    
    
    //Y轴距屏幕边框的距离
    self.VxyAxisSet.yAxis.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    self.VxyAxisSet.xAxis.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    
    CPTBarPlot *volumePlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor orangeColor] horizontalBars:NO];
    //volumePlot.barBasesVary = NO;
    volumePlot.cornerRadius = 0.0;
    volumePlot.plotArea.cornerRadius = 0.0;
    volumePlot.dataSource = self;
    CPTMutableLineStyle *lineStyleXY = [self.VxyAxisSet.xAxis.axisLineStyle mutableCopy];
    lineStyleXY.lineColor          = [CPTColor whiteColor];
    lineStyleXY            = [volumePlot.lineStyle mutableCopy];
    lineStyleXY.lineColor  = [CPTColor whiteColor];
    //volumePlot.lineStyle = lineStyleXY;
    volumePlot.borderWidth = 0;
    volumePlot.identifier = @"VolumePlot";
    volumePlot.fill           = [CPTFill fillWithColor:[CPTColor greenColor]];
    
    volumePlot.barWidth       = CPTDecimalFromCGFloat(0.8);
    
    self.volumeplot = volumePlot;
    [self.Vgraph addPlot:self.volumeplot];
    

}
#pragma Mark create VolumeGraph X Y
- (void)createXaxis{
    
    //构造一个TextStyle
    CPTMutableTextStyle *titleTextStyle = [CPTMutableTextStyle textStyle];
    titleTextStyle.color                = [CPTColor whiteColor];
    titleTextStyle.fontName             = @"Helvetica-Bold";
    titleTextStyle.fontSize             = 14;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    unsigned long int FinacialDataCount = self.datapuller.financialData.count;
    [self.VmajorTickLocations removeAllObjects];
    [self.VdateLabelArray removeAllObjects];
    
    for (unsigned long int i = 0; i < FinacialDataCount - 1; i++) {
        
        NSString *MonthStr = [dateFormatter stringFromDate:self.datapuller.financialData[i][@"date"]];
        NSString *NextMonthStr = [dateFormatter stringFromDate:self.datapuller.financialData[i+1][@"date"]];
        
        if (![MonthStr isEqualToString:NextMonthStr]) {
            NSLog(@"初始数量%@%lu",MonthStr,i);
            NSLog(@"初始数量%@%lu",NextMonthStr,i+1);
            
            
            NSDateFormatter *monthdataFormatter = [[NSDateFormatter alloc]init];
            [monthdataFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *MonthlyChart = [monthdataFormatter stringFromDate:self.datapuller.financialData[i][@"date"]];
            
            
            CPTAxisLabel *newLabel =[[CPTAxisLabel alloc] initWithText: [NSString stringWithFormat:@"%@",MonthlyChart ]textStyle:titleTextStyle];
            
            newLabel.tickLocation = CPTDecimalFromUnsignedLongLong(self.datapuller.financialData.count - i);
            
            newLabel.offset = 5;
            
            newLabel.alignment = NSTextAlignmentNatural;
            
            [self.VdateLabelArray addObject:newLabel];
            NSString *TickLocationStr = [NSString stringWithFormat:@"%lu",self.datapuller.financialData.count - i];
            
            NSLog(@"ticklocation%@",TickLocationStr);
            
            [self.VmajorTickLocations addObject:TickLocationStr];
            NSLog(@"VmajorTickLocations%lu",self.VmajorTickLocations.count);
        }
    }
    
    self.VxyAxisSet.xAxis.majorIntervalLength = CPTDecimalFromInt(1);
    self.VxyAxisSet.xAxis.majorTickLocations = [NSSet setWithArray:self.VmajorTickLocations];
    self.VxyAxisSet.xAxis.majorGridLineStyle = self.tickLinestyle;
    self.VxyAxisSet.xAxis.labelTextStyle = titleTextStyle;
 
    
//        CPTConstraints *constence = [CPTConstraints constraintWithLowerOffset:15.0];
//        self.VxyAxisSet.xAxis.axisConstraints = constence;
    
}
- (void)createYAxis{
    
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1.0f;
    majorGridLineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithFloat:2.0f], [NSNumber numberWithFloat:2.0f], nil];
    majorGridLineStyle.patternPhase = 0.0f;
    majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];
    
    if ([self.overallVolumeHigh floatValue]!=0 || [self.overallVolumeLow floatValue]!=0) {
        
    self.VxyAxisSet.yAxis.majorTickLocations = [NSSet setWithArray:@[self.overallVolumeLow ,self.overallVolumeHigh]];
    }
    self.VxyAxisSet.yAxis.majorTickLineStyle = majorGridLineStyle;
    
   //构造MutableArray，用于存放自定义的轴标签
    NSMutableArray*customLabel = [NSMutableArray arrayWithCapacity:30];
    //构造一个TextStyle
    CPTMutableTextStyle *titleTextStyle1 = [CPTMutableTextStyle textStyle];
    titleTextStyle1.color                = [CPTColor whiteColor];
    titleTextStyle1.fontName             = @"Helvetica-Bold";
    titleTextStyle1.fontSize             = 14;
    
    
    
    CPTAxisLabel *Ylabel1 = [[CPTAxisLabel alloc]initWithText:[NSString stringWithFormat:@"%d",[self.overallVolumeLow intValue ]] textStyle:titleTextStyle1];
    CPTAxisLabel *Ylabel2 = [[CPTAxisLabel alloc]initWithText:[NSString stringWithFormat:@"%d",[self.overallVolumeHigh intValue]] textStyle:titleTextStyle1];
    Ylabel1.offset = 5;
    Ylabel2.offset = 5;
    Ylabel1.tickLocation = CPTDecimalFromCGFloat([self.overallVolumeLow floatValue]);
    Ylabel2.tickLocation = CPTDecimalFromCGFloat([self.overallVolumeHigh floatValue]);
    [customLabel addObject:Ylabel1];
    [customLabel addObject:Ylabel2];
    self.VxyAxisSet.yAxis.axisLabels = [NSSet setWithArray:customLabel];
    self.VxyAxisSet.yAxis.majorGridLineStyle = majorGridLineStyle;
    
}


#pragma Mark create scatterPlot
-(void)createScatterPlot{
    
    //创建ScatterPlot
    self.scatterplot = [[CPTScatterPlot alloc]initWithFrame:_VstickGraphView.bounds];
    //self.scatterplot = [[CPTScatterPlot alloc]init];
    self.scatterplot.identifier = @"scatterPlot";
    self.scatterplot.dataSource = self;
    //ScatterPlot的lineStyle
    CPTMutableLineStyle *scatterlineStyle = [[CPTMutableLineStyle alloc]init];
    scatterlineStyle.lineColor = [CPTColor redColor];
    self.scatterplot.dataLineStyle = scatterlineStyle;
    

    
}
#pragma Mark create BottomLabels
-(void)createBottomLabels{
    
    self.labelHeight = 650;
    self.labelWidth = 20;
    
    self.nameLabel = [self formatLabel:self.nameLabel];
    self.todayOpeningPriceLabel = [self formatLabel:self.todayOpeningPriceLabel];
    self.yesterdayClosingPriceLabel = [self formatLabel:self.yesterdayClosingPriceLabel];
    self.todayHighLabel = [self formatLabel:self.todayHighLabel];
    self.todayLowLabel = [self formatLabel:self.todayLowLabel];
    self.currentPriceLabel = [self formatLabel:self.currentPriceLabel];
    self.buyPriceLabel = [self formatLabel:self.buyPriceLabel];
    self.sellPriceLabel = [self formatLabel:self.sellPriceLabel];
    self.volumeLabel = [self formatLabel:self.volumeLabel];
    self.dateLabel = [self formatLabel:self.dateLabel];
    
    // hack to make the date show up entirely
    CGRect frame = self.dateLabel.frame;
    frame.origin.x = 20;
    frame.origin.y += 50;
    frame.size.width += 200;
    self.dateLabel.frame = frame;

}
-(void)viewWillAppear:(BOOL)animated
{
    [self.nameLabel setText:@"股票名称"];
    [self.todayOpeningPriceLabel setText:@"今日开盘价"];
    [self.yesterdayClosingPriceLabel setText:@"昨日开盘价"];
    [self.todayHighLabel setText:@"今日最高价"];
    [self.todayLowLabel setText:@"今日最低价"];
    [self.currentPriceLabel setText:@"当前价"];
    [self.buyPriceLabel setText:@"买入价"];
    [self.sellPriceLabel setText:@"卖出价"];
    [self.volumeLabel setText:@"成交量"];
    [self.dateLabel setText:@"数据日期"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateInfoForStock:(SBStock *)stock FromSinaData:(id)rawData
{
    
    @try {
        unsigned long encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *s = [[NSString alloc] initWithData:rawData encoding:encoding];
        NSArray *dataStringArray = [s componentsSeparatedByString:@","];
        
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        //        [numberFormatter setMaximumFractionDigits:2];
        //        [numberFormatter setPositiveFormat:@"###0.00"];
        //        NSLog(@"Sina Stock INFO: %@", dataStringArray);
        stock.name = [dataStringArray[0] componentsSeparatedByString:@"=\""][1];
        
        stock.todayOpeningPrice = [numberFormatter numberFromString:dataStringArray[1]];
        stock.yesterdayClosingPrice = [numberFormatter numberFromString:dataStringArray[2]];
        stock.currentPrice = [numberFormatter numberFromString:dataStringArray[3]];
        stock.todayHigh = [numberFormatter numberFromString:dataStringArray[4]];
        stock.todayLow = [numberFormatter numberFromString:dataStringArray[5]];
        stock.buyPrice = [numberFormatter numberFromString:dataStringArray[6]];
        stock.sellPrice = [numberFormatter numberFromString:dataStringArray[7]];
        stock.volume = [numberFormatter numberFromString:dataStringArray[8]];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        stock.fetchDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",dataStringArray[30],dataStringArray[31]]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        ;
    }
    
}

-(void)showStock:(SBStock *)stock
{
    
    self.stock = stock;
    NSURL *kChartImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@sh%ld.gif",IMAGE_DAILY_K_URL,[stock.stockID longValue]]];
    NSURL *macdImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@sh%ld.gif",IMAGE_MACD_URL,[stock.stockID longValue]]];
    NSString *infoURL = [NSString stringWithFormat:@"%@list=sh%ld",CURRENT_INFO_URL,[stock.stockID longValue]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // default serializer doesn't support this content type
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:infoURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self updateInfoForStock:stock FromSinaData:responseObject];
        [self.nameLabel setText:[NSString stringWithFormat:@"股票名称：%@",self.stock.name]];
        
        [self.dateLabel setText:[NSString stringWithFormat:@"%@",stock.fetchDate]];
        
        
        //k线图部分
        _IntroduceStockLabel.text = [NSString stringWithFormat:@"%@   %@ - 日K线图    %@",self.stock.stockID,self.stock.name,self.datestr];
        
        self.stockId = [NSString stringWithFormat:@"%@.ss",self.stock.stockID];
  

        [self.todayOpeningPriceLabel setText:[NSString stringWithFormat:@"今日开盘价：￥%.3f",[stock.todayOpeningPrice floatValue]]];
        
        [self.yesterdayClosingPriceLabel setText:[NSString stringWithFormat:@"昨日开盘价：￥%.3f",[stock.yesterdayClosingPrice floatValue]]];
        [self.todayHighLabel setText:[NSString stringWithFormat:@"今日最高价：￥%.3f",[stock.todayHigh floatValue]]];
        [self.todayLowLabel setText:[NSString stringWithFormat:@"今日最低价：￥%.3f",[stock.todayLow floatValue]]];
        [self.currentPriceLabel setText:[NSString stringWithFormat:@"当前价：￥%.3f",[stock.currentPrice floatValue]]];
        [self.buyPriceLabel setText:[NSString stringWithFormat:@"买入价：￥%.3f",[stock.buyPrice floatValue]]];
        [self.sellPriceLabel setText:[NSString stringWithFormat:@"卖出价：￥%.3f",[stock.sellPrice floatValue]]];
        [self.volumeLabel setText:[NSString stringWithFormat:@"成交量：%d",[stock.volume intValue]]];
        
        
        self.startdate         = [NSDate dateWithTimeIntervalSinceNow:-60.0 * 60.0 * 24.0 * 20]; // 12 weeks ago
        NSDate *end           = [NSDate date];
        self.datapuller = [[APYahooDataPuller alloc] initWithTargetSymbol:self.stockId targetStartDate:self.startdate targetEndDate:end];
        
        NSLog(@"stocksfinatialdata%lu",self.datapuller.financialData.count);
        NSLog(@"%f",[self.datapuller.overallLow floatValue]);
        [self.datapuller setDelegate:self];
       

      
//        if (self.datapuller.financialData.count == 0) {
//            NSLog(@"%lu",self.datapuller.financialData.count);
//            NSLog(@"%f",[self.datapuller.overallVolumeHigh floatValue]);
//            self.datapuller = [self.datapuller initWithTargetSymbol:@"AAPL" targetStartDate:self.startdate targetEndDate:end];
//            [self setDatapuller:self.datapuller];
//            [self.datapuller setDelegate:self];
//            UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"亲爱的用户您好" message:@"您请求的数据不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//            [AlertView show];
//        }
//        else{
//            [self setDatapuller:self.datapuller];
//            [self.datapuller setDelegate:self];
//        }

    
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fetching stock information failed %@", error);
       
    }];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

//    [manager GET:@"http://stockup-dev.cloudapp.net:9990/price?start_time=2014-09-05T15:00:00&end_time=2014-09-05T16:00:00&stock_ids=600028" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@", responseObject[0][@"doc"][@"d"][0]);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//    }];

    [self.kChartView setImageWithURL:kChartImageURL placeholderImage:nil];
    [self.macdView setImageWithURL:macdImageURL placeholderImage:nil];
}

#pragma mark Private Methods

-(UILabel *)formatLabel:(UILabel *)label
{
    int labelWidth = 220;
    label = [[UILabel alloc] initWithFrame:CGRectMake(self.labelWidth, self.labelHeight, labelWidth, 40)];
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = BLACK_BG;
    label.textColor = WHITE;
    if (self.labelWidth > 20) {
        self.labelWidth = 20;
        self.labelHeight += 30;
    } else {
        self.labelWidth = labelWidth + 20;
    }
    [self.scrollView addSubview:label];
    return label;
    
}
#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    
    return self.datapuller.financialData.count;
    
}

#if ROWS_FIRST_DATA_ORDER

-(CPTNumericData *)dataForPlot:(CPTPlot *)plot recordIndexRange:(NSRange)indexRange
{
    NSArray *financialData              = self.datapuller.financialData;
    
    const NSUInteger financialDataCount = financialData.count;
    
    NSLog(@"%lu",financialDataCount);
    
    const BOOL useDoubles = plot.doublePrecisionCache;
    
    NSLog(@"%d",useDoubles);
    
    NSUInteger numFields = plot.numberOfFields;
    
    NSLog(@"%lu",numFields);
    
    if ( [plot.identifier isEqual:@"VolumePlot"] ) {
        
       numFields = 2;
    }
    
    NSMutableData *data = [[NSMutableData alloc] initWithLength:indexRange.length * numFields * ( useDoubles ? sizeof(double) : sizeof(NSDecimal) )];
    
    const NSUInteger maxIndex = NSMaxRange(indexRange);
    
    if ( [plot.identifier isEqual:@"scatterPlot"] ) {
        if ( useDoubles ) {
            
            double *nextValue = data.mutableBytes;
            
            for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
                NSDictionary *fData = (NSDictionary *)financialData[financialDataCount - i - 1];
                NSNumber *value;
                
                for ( NSUInteger fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
                    switch ( fieldEnum ) {
                        case CPTScatterPlotFieldX:
                            *nextValue++ = (double)(i + 1);
                            break;
                            
                        case CPTScatterPlotFieldY:
                            value = fData[@"open"];
                            NSAssert(value, @"Close value was nil");
                            *nextValue++ = [value doubleValue];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
        else {
            NSDecimal *nextValue = data.mutableBytes;
            
            for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
                NSDictionary *fData = (NSDictionary *)financialData[financialDataCount - i - 1];
                NSNumber *value;
                
                for ( NSUInteger fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
                    switch ( fieldEnum ) {
                        case CPTScatterPlotFieldX:
                            *nextValue++ = CPTDecimalFromUnsignedInteger(i + 1);
                            break;
                            
                        case CPTScatterPlotFieldY:
                            value = fData[@"open"];
                            NSAssert(value, @"Close value was nil");
                            *nextValue++ = [value decimalValue];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
    }
    else if ( [plot.identifier isEqual:@"VolumePlot"] ) {
        if ( useDoubles ) {
            double *nextValue = data.mutableBytes;
            
            for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
                NSDictionary *fData = (NSDictionary *)financialData[financialDataCount - i - 1];
                NSNumber *value;
                for ( NSUInteger fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
                    switch ( fieldEnum ) {
                        case CPTBarPlotFieldBarLocation:
                            *nextValue++ = (double)(i + 1);
                            break;
                            
                        case CPTBarPlotFieldBarTip:
                            value = fData[@"volume"];
                            NSAssert(value, @"Volume value was nil");
                            *nextValue++ = [value doubleValue];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
        else {
            NSDecimal *nextValue = data.mutableBytes;
            
            for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
                NSDictionary *fData = (NSDictionary *)financialData[financialDataCount - i -1 ];
                NSNumber *value;
                
                for ( NSUInteger fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
                    switch ( fieldEnum ) {
                        case CPTBarPlotFieldBarLocation:
                            *nextValue++ = CPTDecimalFromUnsignedInteger(i + 1);
                            break;
                            
                        case CPTBarPlotFieldBarTip:
                            value = fData[@"volume"];
                            NSAssert(value, @"Volume value was nil");
                            *nextValue++ = [value decimalValue];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
    }
    else {
        if ( useDoubles ) {
            double *nextValue = data.mutableBytes;
            
            for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
                NSDictionary *fData = (NSDictionary *)financialData[financialDataCount - i - 1];
                NSNumber *value;
                
                for ( NSUInteger fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
                    switch ( fieldEnum ) {
                        case CPTTradingRangePlotFieldX:
                            *nextValue++ = (double)(i +1);
                            break;
                            
                        case CPTTradingRangePlotFieldOpen:
                            value = fData[@"open"];
                            NSAssert(value, @"Open value was nil");
                            *nextValue++ = [value doubleValue];
                            break;
                            
                        case CPTTradingRangePlotFieldHigh:
                            value = fData[@"high"];
                            NSAssert(value, @"High value was nil");
                            *nextValue++ = [value doubleValue];
                            break;
                            
                        case CPTTradingRangePlotFieldLow:
                            value = fData[@"low"];
                            NSAssert(value, @"Low value was nil");
                            *nextValue++ = [value doubleValue];
                            break;
                            
                        case CPTTradingRangePlotFieldClose:
                            value = fData[@"close"];
                            NSAssert(value, @"Close value was nil");
                            *nextValue++ = [value doubleValue];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
        else {
            NSDecimal *nextValue = data.mutableBytes;
            
            for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
                NSDictionary *fData = (NSDictionary *)financialData[financialDataCount - i - 1];
                NSNumber *value;
                
                for ( NSUInteger fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
                    switch ( fieldEnum ) {
                        case CPTTradingRangePlotFieldX:
                            *nextValue++ = CPTDecimalFromUnsignedInteger(i + 1);
                            break;
                            
                        case CPTTradingRangePlotFieldOpen:
                            value = fData[@"open"];
                            NSAssert(value, @"Open value was nil");
                            *nextValue++ = [value decimalValue];
                            break;
                            
                        case CPTTradingRangePlotFieldHigh:
                            value = fData[@"high"];
                            NSAssert(value, @"High value was nil");
                            *nextValue++ = [value decimalValue];
                            break;
                            
                        case CPTTradingRangePlotFieldLow:
                            value = fData[@"low"];
                            NSAssert(value, @"Low value was nil");
                            *nextValue++ = [value decimalValue];
                            break;
                            
                        case CPTTradingRangePlotFieldClose:
                            value = fData[@"close"];
                            NSAssert(value, @"Close value was nil");
                            *nextValue++ = [value decimalValue];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
    }
    
    CPTMutableNumericData *numericData = [CPTMutableNumericData numericDataWithData:data
                                                                           dataType:(useDoubles ? plot.doubleDataType : plot.decimalDataType)
                                                                              shape:@[@(indexRange.length),
                                                                                      @(numFields)]
                                                                          dataOrder:CPTDataOrderRowsFirst];
    
    return numericData;
}

#else

/*-(CPTNumericData *)dataForPlot:(CPTPlot *)plot recordIndexRange:(NSRange)indexRange
 {
 NSArray *financialData              = self.datapuller.financialData;
 const NSUInteger financialDataCount = financialData.count;
 
 const BOOL useDoubles = plot.doublePrecisionCache;
 
 NSUInteger numFields = plot.numberOfFields;
 
 if ( [plot.identifier isEqual:@"Volume Plot"] ) {
 numFields = 2;
 }
 
 NSMutableData *data = [[NSMutableData alloc] initWithLength:indexRange.length * numFields * ( useDoubles ? sizeof(double) : sizeof(NSDecimal) )];
 
 const NSUInteger maxIndex = NSMaxRange(indexRange);
 
 if ( [plot.identifier isEqual:@"Data Source Plot"] ) {
 if ( useDoubles ) {
 double *nextValue = data.mutableBytes;
 
 for ( int fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
 for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
 NSDictionary *fData = (NSDictionary *)[financialData objectAtIndex:financialDataCount - i - 1];
 NSNumber *value;
 
 switch ( fieldEnum ) {
 case CPTScatterPlotFieldX:
 *nextValue++ = (double)(i + 1);
 break;
 
 case CPTScatterPlotFieldY:
 value = [fData objectForKey:@"close"];
 NSAssert(value, @"Close value was nil");
 *nextValue++ = [value doubleValue];
 break;
 
 default:
 break;
 }
 }
 }
 }
 else {
 NSDecimal *nextValue = data.mutableBytes;
 
 for ( int fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
 for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
 NSDictionary *fData = (NSDictionary *)[financialData objectAtIndex:financialDataCount - i - 1];
 NSNumber *value;
 
 switch ( fieldEnum ) {
 case CPTScatterPlotFieldX:
 *nextValue++ = CPTDecimalFromUnsignedInteger(i + 1);
 break;
 
 case CPTScatterPlotFieldY:
 value = [fData objectForKey:@"close"];
 NSAssert(value, @"Close value was nil");
 *nextValue++ = [value decimalValue];
 break;
 
 default:
 break;
 }
 }
 }
 }
 }
 else if ( [plot.identifier isEqual:@"Volume Plot"] ) {
 if ( useDoubles ) {
 double *nextValue = data.mutableBytes;
 
 for ( int fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
 for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
 NSDictionary *fData = (NSDictionary *)[financialData objectAtIndex:financialDataCount - i - 1];
 NSNumber *value;
 
 switch ( fieldEnum ) {
 case CPTBarPlotFieldBarLocation:
 *nextValue++ = (double)(i + 1);
 break;
 
 case CPTBarPlotFieldBarTip:
 value = [fData objectForKey:@"volume"];
 NSAssert(value, @"Volume value was nil");
 *nextValue++ = [value doubleValue];
 break;
 
 default:
 break;
 }
 }
 }
 }
 else {
 NSDecimal *nextValue = data.mutableBytes;
 
 for ( int fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
 for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
 NSDictionary *fData = (NSDictionary *)[financialData objectAtIndex:financialDataCount - i - 1];
 NSNumber *value;
 
 switch ( fieldEnum ) {
 case CPTBarPlotFieldBarLocation:
 *nextValue++ = CPTDecimalFromUnsignedInteger(i + 1);
 break;
 
 case CPTBarPlotFieldBarTip:
 value = [fData objectForKey:@"volume"];
 NSAssert(value, @"Volume value was nil");
 *nextValue++ = [value decimalValue];
 break;
 
 default:
 break;
 }
 }
 }
 }
 }
 else {
 if ( useDoubles ) {
 double *nextValue = data.mutableBytes;
 
 for ( int fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
 for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
 NSDictionary *fData = (NSDictionary *)[financialData objectAtIndex:financialDataCount - i - 1];
 NSNumber *value;
 
 switch ( fieldEnum ) {
 case CPTTradingRangePlotFieldX:
 *nextValue++ = (double)(i + 1);
 break;
 
 case CPTTradingRangePlotFieldOpen:
 value = [fData objectForKey:@"open"];
 NSAssert(value, @"Open value was nil");
 *nextValue++ = [value doubleValue];
 break;
 
 case CPTTradingRangePlotFieldHigh:
 value = [fData objectForKey:@"high"];
 NSAssert(value, @"High value was nil");
 *nextValue++ = [value doubleValue];
 break;
 
 case CPTTradingRangePlotFieldLow:
 value = [fData objectForKey:@"low"];
 NSAssert(value, @"Low value was nil");
 *nextValue++ = [value doubleValue];
 break;
 
 case CPTTradingRangePlotFieldClose:
 value = [fData objectForKey:@"close"];
 NSAssert(value, @"Close value was nil");
 *nextValue++ = [value doubleValue];
 break;
 
 default:
 break;
 }
 }
 }
 }
 else {
 NSDecimal *nextValue = data.mutableBytes;
 
 for ( int fieldEnum = 0; fieldEnum < numFields; fieldEnum++ ) {
 for ( NSUInteger i = indexRange.location; i < maxIndex; i++ ) {
 NSDictionary *fData = (NSDictionary *)[financialData objectAtIndex:financialDataCount - i - 1];
 NSNumber *value;
 
 switch ( fieldEnum ) {
 case CPTTradingRangePlotFieldX:
 *nextValue++ = CPTDecimalFromUnsignedInteger(i + 1);
 break;
 
 case CPTTradingRangePlotFieldOpen:
 value = [fData objectForKey:@"open"];
 NSAssert(value, @"Open value was nil");
 *nextValue++ = [value decimalValue];
 break;
 
 case CPTTradingRangePlotFieldHigh:
 value = [fData objectForKey:@"high"];
 NSAssert(value, @"High value was nil");
 *nextValue++ = [value decimalValue];
 break;
 
 case CPTTradingRangePlotFieldLow:
 value = [fData objectForKey:@"low"];
 NSAssert(value, @"Low value was nil");
 *nextValue++ = [value decimalValue];
 break;
 
 case CPTTradingRangePlotFieldClose:
 value = [fData objectForKey:@"close"];
 NSAssert(value, @"Close value was nil");
 *nextValue++ = [value decimalValue];
 break;
 
 default:
 break;
 }
 }
 }
 }
 }
 
 CPTMutableNumericData *numericData = [CPTMutableNumericData numericDataWithData:data
 dataType:(useDoubles ? plot.doubleDataType : plot.decimalDataType)
 shape:@[@(indexRange.length), @(numFields)]
 dataOrder:CPTDataOrderColumnsFirst];
 [data release];
 
 return numericData;
 } */
#endif

#pragma Mark KtradingPlot

-(void)tradingRangePlot{
    
   self.KplotSpace       = (CPTXYPlotSpace *)self.Kgraph.defaultPlotSpace;
    
    APYahooDataPuller *thePuller = self.datapuller;
    
    
   
    NSDecimalNumber *high   = thePuller.overallHigh;
    NSDecimalNumber *low    = thePuller.overallLow ;
   
    NSDecimalNumber *halfPlotLength = [high decimalNumberBySubtracting:low];
    NSDecimalNumber *length = [high decimalNumberBySubtracting:low];
    
    
   
    
    
    //high 和 low距上下边框的距离
    NSDecimalNumber *pointfive = [NSDecimalNumber decimalNumberWithString:@"0.35"];
    NSDecimalNumber *oneEighth = [NSDecimalNumber decimalNumberWithString:@"0.175"];
    NSDecimalNumber *oneEighthLength = [length decimalNumberByMultiplyingBy:oneEighth];
    
    NSLog(@"high = %@, low = %@, length = %@", high, low, length);
    NSDecimalNumber *pricePlotSpaceDisplacementPercent = [NSDecimalNumber decimalNumberWithMantissa:33
                                                          
                                                          
                                                                                           exponent:-2
                                                                                         isNegative:NO];
    NSLog(@"%@",pricePlotSpaceDisplacementPercent);
    
    NSDecimalNumber *lengthDisplacementValue = [length decimalNumberByMultiplyingBy:pointfive];
    NSDecimalNumber *lowDisplayLocation      = [low decimalNumberBySubtracting:oneEighthLength];
    NSDecimalNumber *lengthDisplayLocation   = [length decimalNumberByAdding:lengthDisplacementValue];
    
    self.KplotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromUnsignedInteger(thePuller.financialData.count + 1)];
    
    self.KplotSpace.yRange = [CPTPlotRange plotRangeWithLocation:lowDisplayLocation.decimalValue length:lengthDisplayLocation.decimalValue];
    
    //横坐标
    
    self.KxyAxisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    //构造一个TextStyle
    CPTMutableTextStyle *titleTextStyle = [CPTMutableTextStyle textStyle];
    titleTextStyle.color                = [CPTColor whiteColor];
    titleTextStyle.fontName             = @"Helvetica-Bold";
    titleTextStyle.fontSize             = 14;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    unsigned long int FinacialDataCount = self.datapuller.financialData.count;
    [self.KmajorTickLocations removeAllObjects];
    [self.XdataLabelArray removeAllObjects];
    
    for (unsigned long int i = 0; i < FinacialDataCount - 1; i++) {
        
        NSString *MonthStr = [dateFormatter stringFromDate:self.datapuller.financialData[i][@"date"]];
        NSString *NextMonthStr = [dateFormatter stringFromDate:self.datapuller.financialData[i+1][@"date"]];
        
        if (![MonthStr isEqualToString:NextMonthStr]) {
            
            NSDateFormatter *monthdataFormatter = [[NSDateFormatter alloc]init];
            [monthdataFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *MonthlyChart = [monthdataFormatter stringFromDate:self.datapuller.financialData[i][@"date"]];
            
            
            CPTAxisLabel *newLabel =[[CPTAxisLabel alloc] initWithText: [NSString stringWithFormat:@"%@",MonthlyChart ]textStyle:titleTextStyle];
            
            newLabel.tickLocation = CPTDecimalFromUnsignedLongLong(self.datapuller.financialData.count - i);
            
            newLabel.offset = -15;
            newLabel.alignment = NSTextAlignmentNatural;
            [self.XdataLabelArray addObject:newLabel];
            NSString *TickLocationStr = [NSString stringWithFormat:@"%lu",self.datapuller.financialData.count - i];
            [self.KmajorTickLocations addObject:TickLocationStr];
            
        }
    }
    //日期的显示位置
    CPTConstraints *Dateconstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    self.KxyAxisSet.xAxis.axisConstraints = Dateconstraints;
    
    
    self.KxyAxisSet.xAxis.axisLabels =  [NSSet setWithArray:self.XdataLabelArray];
    
    self.KxyAxisSet.xAxis.majorIntervalLength = CPTDecimalFromInt(1);
    
    self.KxyAxisSet.xAxis.majorTickLocations = [NSSet setWithArray:self.KmajorTickLocations];
    
    
    self.KxyAxisSet.xAxis.majorGridLineStyle = self.tickLinestyle;
    self.KxyAxisSet.xAxis.labelTextStyle = titleTextStyle;
    self.KxyAxisSet.xAxis.plotSpace = self.KplotSpace;
    
    //Y轴两个格之间的差距
    self.KxyAxisSet.yAxis.majorIntervalLength         = CPTDecimalFromCGFloat(([high floatValue]  - [low floatValue] )/5);
    self.KxyAxisSet.yAxis.minorTicksPerInterval       = 5;//刻度值
    self.KxyAxisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    //构造MutableArray，用于存放自定义的轴标签
    NSMutableArray*KycustomLabels = [NSMutableArray arrayWithCapacity:30];
    //构造一个TextStyle
    CPTMutableTextStyle *titleTextStyle1 = [CPTMutableTextStyle textStyle];
    titleTextStyle1.color                = [CPTColor whiteColor];
    titleTextStyle1.fontName             = @"Helvetica-Bold";
    titleTextStyle1.fontSize             = 14;
    
    //每个数据点一个轴标签
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDecimalNumber *point25 = [NSDecimalNumber decimalNumberWithString:@"0.25"];
    NSDecimalNumber *secondtickdisplace = [halfPlotLength decimalNumberByMultiplyingBy:point25];
    NSDecimalNumber *secondtick   = [low decimalNumberByAdding:secondtickdisplace];
    
    
    NSDecimalNumber *point50 = [NSDecimalNumber decimalNumberWithString:@"0.50"];
    NSDecimalNumber *thirdtickdisplace = [halfPlotLength decimalNumberByMultiplyingBy:point50];
    NSDecimalNumber *thirdtick   = [low decimalNumberByAdding:thirdtickdisplace];
    
    NSDecimalNumber *point75 = [NSDecimalNumber decimalNumberWithString:@"0.75"];
    NSDecimalNumber *fourthtickdisplace = [halfPlotLength decimalNumberByMultiplyingBy:point75];
    NSDecimalNumber *fourthtick   = [low decimalNumberByAdding:fourthtickdisplace];
    
    
    
    self.KxyAxisSet.yAxis.majorTickLocations = [NSSet setWithArray:@[high,secondtick,fourthtick,thirdtick,low]];
    
    
    
    
    for (int i = 0; i<=4; i++) {
        
        
        CPTAxisLabel *newLabel =[[CPTAxisLabel alloc] initWithText: [NSString stringWithFormat:@"%0.2f",([low floatValue]+0.25*i*[halfPlotLength floatValue]) ]textStyle:titleTextStyle1];
        newLabel.tickLocation = CPTDecimalFromCGFloat([low floatValue]+0.25*i*[halfPlotLength floatValue]);
        
        
        newLabel.offset = 10;
        newLabel.alignment = NSTextAlignmentNatural;
        [KycustomLabels addObject:newLabel];
        
        
        
    }
    
    self.KxyAxisSet.yAxis.axisLabels =  [NSSet setWithArray:KycustomLabels];
    
    
    self.KxyAxisSet.yAxis.visibleRange   = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(999999)];
    
    //  k线图
    self.KxyAxisSet.yAxis.majorGridLineStyle = self.tickLinestyle;
    self.KxyAxisSet.yAxis.labelTextStyle = titleTextStyle1;
    self.KxyAxisSet.yAxis.plotSpace = self.KplotSpace;
    
    //k线图 设置high和low到边框的距离
//    NSDecimalNumber *pointsix = [NSDecimalNumber decimalNumberWithString:@"1"];
//    NSDecimalNumber *distancepercent = [secondtickdisplace decimalNumberByMultiplyingBy:pointsix];
//    NSDecimalNumber *globleYRange = [low decimalNumberBySubtracting:distancepercent];
//    NSDecimalNumber *lengthmultiplier = [NSDecimalNumber decimalNumberWithString:@"1.5"];
//    NSDecimalNumber *mutiplyLength = [halfPlotLength decimalNumberByMultiplyingBy:lengthmultiplier];
    //self.KplotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:globleYRange.decimalValue length:mutiplyLength.decimalValue];
    [self.Kgraph addPlot:self.TradingRangePlot];
}

-(void)dataPullerDidFinishFetch:(APYahooDataPuller *)dp
{
    self.VplotSpace = (CPTXYPlotSpace *)self.Vgraph.defaultPlotSpace;
    
    self.low     = self.datapuller.overallLow;
    
    self.high    = self.datapuller.overallHigh;
    
    self.length = [self.high decimalNumberBySubtracting:self.low];
    
    self.overallVolumeHigh = self.datapuller.overallVolumeHigh;
    
    self.overallVolumeLow  = self.datapuller.overallVolumeLow;
    
    self.volumeLength      = [self.overallVolumeHigh decimalNumberBySubtracting:self.overallVolumeLow];
    
    self.volumePlotSpaceDisplacementPercent = [NSDecimalNumber decimalNumberWithMantissa:10
                                                                                exponent:-2
                                                                              isNegative:NO];
    self.volumeLengthDisplacementValue = [self.volumeLength decimalNumberByMultiplyingBy:self.volumePlotSpaceDisplacementPercent];
    
    
    [self tradingRangePlot];

    self.VplotSpace = (CPTXYPlotSpace *)self.VolumehostView.hostedGraph.defaultPlotSpace;
    [self createXaxis];
    [self createYAxis];

    self.VplotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromUnsignedInteger(self.datapuller.financialData.count + 1)];
    NSDecimalNumber *NumPercent = [NSDecimalNumber decimalNumberWithString:@"0.3"];
    NSDecimalNumber *volumeLengthDisplacementValue = [self.volumeLength decimalNumberByMultiplyingBy:NumPercent];
    
    NSDecimalNumber *volumeLowDisplayLocation      = 0;
    NSDecimalNumber *volumeLengthDisplayLocation   = [self.overallVolumeHigh decimalNumberByAdding:volumeLengthDisplacementValue];
    self.VplotSpace.yRange = [CPTPlotRange plotRangeWithLocation:volumeLowDisplayLocation.decimalValue length:volumeLengthDisplayLocation.decimalValue];
    [self.Vgraph addPlot:self.volumeplot];
    NSUInteger count = self.datapuller.financialData.count*1.6;
    NSLog(@"mmmmmmmmmmmmmm%lu",count);
    self.TradingRangePlot.barWidth = 350.00/count;
    NSLog(@"%f",self.TradingRangePlot.barWidth);
    
    [self.Kgraph reloadData];
    [self.Vgraph reloadData];
}



@end
