//
//  ViewController.m
//  AreaPickView
//
//  Created by SY8 on 2018/12/28.
//  Copyright © 2018年 SY8. All rights reserved.
//

#import "ViewController.h"
#import "LNAreaPickView.h"
#import "LNAddressStreetModel.h"

@interface ViewController ()<NSURLSessionDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

/**
 当前选择的省份
 */
@property (nonatomic, copy) NSString *currentProvince;

/**
 当前选择的市
 */
@property (nonatomic, copy) NSString *currentCity;

/**
 当前选择的区县
 */
@property (nonatomic, copy) NSString *currentArea;

/**
 当前选择的区县编码
 */
@property (nonatomic, copy) NSString *currentCityId;

/**
 街道Array
 */
@property (nonatomic, strong) NSMutableArray *streetArray;
@property (nonatomic, strong) UILabel *lbl;
@property (nonatomic, strong) UILabel *lbl2;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic,strong)UIPickerView * pickerView;
// !!!:腾讯地图API key
/**
 MapKey 为腾讯地图API应用的key
 如果需要加入自己的项目，可以在开放平台创建APP，替换下面的key
 腾讯地图开放平台：https://lbs.qq.com/index.html
 */
#define MapKey @"UIZBZ-LHBWK-ZSRJE-AFYKK-PK7MS-AHBMO"
@end

@implementation ViewController
#pragma mark lifecycle 声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"地址选择";
    
    self.lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,  100, self.view.frame.size.width, 30)];
    _lbl.font = [UIFont systemFontOfSize:14];
    _lbl.textColor = [UIColor blackColor];
    _lbl.textAlignment = NSTextAlignmentCenter;
    _lbl.text = @"请选择收货地址";
    [self.view addSubview:_lbl];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(40, CGRectGetMaxY(_lbl.frame) + 40, self.view.frame.size.width - 80, 40);
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setTitle:@"click" forState:(UIControlStateNormal)];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(clickBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    self.lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame) + 40, self.view.frame.size.width, 30)];
    _lbl2.font = [UIFont systemFontOfSize:14];
    _lbl2.textColor = [UIColor blackColor];
    _lbl2.textAlignment = NSTextAlignmentCenter;
    _lbl2.text = @"请选择街道";
    [self.view addSubview:_lbl2];
    
    UIButton *btn2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn2.frame = CGRectMake(40, CGRectGetMaxY(_lbl2.frame) + 40, self.view.frame.size.width - 80, 40);
    [btn2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn2 setTitle:@"click" forState:(UIControlStateNormal)];
    [btn2 setBackgroundColor:[UIColor lightGrayColor]];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn2 addTarget:self action:@selector(clickBtn2Action:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn2];
}
#pragma mark eventResponse 响应事件
// 三级列表点击
- (void)clickBtnAction:(UIButton *)btn {
    LNAreaPickView *selectV = [[LNAreaPickView alloc] initWithLastContent:self.currentProvince ? @[self.currentProvince, self.currentCity, self.currentArea] : nil];
    selectV.confirmSelect = ^(NSArray *address) {
        self.currentProvince = address[0];
        self.currentCity = address[1];
        self.currentArea = address[2];
        self.currentCityId = address[3];
        //给label赋值 回显结果
        self.lbl.text = [NSString stringWithFormat:@"%@ %@ %@ %@", self.currentProvince, self.currentCity, self.currentArea ,self.currentCityId];
        
        //用cityID获取街道列表
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://apis.map.qq.com/ws/district/v1/getchildren?&id=%@&key=%@", self.currentCityId,MapKey]];
        // 发起数据任务
        [[self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"%@---%@",response,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *allArray = [dic objectForKey:@"result"];
            [self.streetArray removeAllObjects];
            for (NSDictionary *dict in [allArray objectAtIndex:0]) {
                LNAddressStreetModel *model = [[LNAddressStreetModel alloc]initWithDictionary:dict];
                [self.streetArray addObject:model];
            }
        }] resume];
    };
    [selectV show];
}
// 街道点击
- (void)clickBtn2Action:(UIButton *)btn {
    if(self.streetArray.count > 0){
        // 初始化pickerView
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,  self.view.bounds.size.height - 200 , self.view.bounds.size.width, 200)];
        [self.view addSubview:self.pickerView];
        //指定数据源和委托
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }else{
        NSLog(@"请先选择地区");
    }
}
#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.streetArray.count;//根据数组的元素个数返回几行数据
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LNAddressStreetModel *model = (LNAddressStreetModel *)self.streetArray[row];
    return model.fullname;
}
// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    LNAddressStreetModel *model = (LNAddressStreetModel *)self.streetArray[row];
    self.lbl2.text = model.fullname;
    [pickerView removeFromSuperview];
}
#pragma mark URLSessionDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    // 判断是否是信任服务器证书
    if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // 告诉服务器，客户端信任证书
        // 创建凭据对象
        NSURLCredential *credntial = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        // 通过completionHandler告诉服务器信任证书
        completionHandler(NSURLSessionAuthChallengeUseCredential,credntial);
    }
    NSLog(@"protectionSpace = %@",challenge.protectionSpace);
}


#pragma mark layzload 懒加载
- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}
- (NSMutableArray *)streetArray{
    if(!_streetArray){
        _streetArray = [NSMutableArray array];
    }
    return _streetArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
