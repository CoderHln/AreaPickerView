//
//  LNAreaPickView.m
//  AreaPickView
//
//  Created by SY8 on 2018/12/28.
//  Copyright © 2018年 SY8. All rights reserved.
//

#import "LNAreaPickView.h"
#import "LNAddressProvinceModel.h"
#import "LNAddressCityModel.h"
#import "LNAddressCountyModel.h"
#import "UIView+Frame.h"

#define kPickerViewHeight 200
#define kTitleHeight 40
/*** RGB颜色 */
#define HmColorRGB(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]
/*** RGBA颜色 */
#define HmColorRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:(a)]
// 屏幕的width
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕的height
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LNAreaPickView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerV;
@property (nonatomic, strong) NSArray *allDataArr;
@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *areaArr;
@property (nonatomic, strong) NSString *currentSelectProvince;
@property (nonatomic, strong) NSString *currentSelectCity;
@property (nonatomic, strong) LNAddressCountyModel *currentSelectArea;

// 布局控件
@property (nonatomic, strong) UIButton *bgV;

@end
@implementation LNAreaPickView

- (instancetype)initWithLastContent:(NSArray *)lastContent {
    if ([super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        if (lastContent) {
            self.currentSelectProvince = lastContent.firstObject;
            self.currentSelectCity = lastContent[1];
            //            self.currentSelectArea = lastContent.lastObject;
        }
        [self setupView];
        [self HmGetArea];
    }
    return self;
}

- (void)show {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

#pragma mark -- UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArr.count;
    }else if (component == 1) {
        return self.cityArr.count;
    }else {
        return self.areaArr.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArr[row];
    }else if (component == 1) {
        return self.cityArr[row];
    }else {
        return self.areaArr[row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.currentSelectProvince = self.provinceArr[row];
        self.currentSelectCity = nil;
        self.currentSelectArea = nil;
        [self calculationCityAreaArr];
        [pickerView selectRow:[self.cityArr indexOfObject:self.currentSelectCity] inComponent:1 animated:YES];
        [pickerView selectRow:[self.areaArr indexOfObject:self.currentSelectArea] inComponent:2 animated:YES];
    }else if (component == 1) {
        self.currentSelectCity = self.cityArr[row];
        self.currentSelectArea = nil;
        [self calculationCityAreaArr];
        [pickerView selectRow:[self.areaArr indexOfObject:self.currentSelectArea] inComponent:2 animated:YES];
    }else {
        self.currentSelectArea = self.areaArr[row];
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (!view) {
        view = [[UIView alloc] init];
    }
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth - 50) / 3, 30)];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont systemFontOfSize:15];
    lblTitle.textColor = HmColorRGB(51, 51, 51);
    if (component == 0) {
        lblTitle.text = self.provinceArr[row];
    }else if (component == 1) {
        lblTitle.text = self.cityArr[row];
    }else {
        LNAddressCountyModel *model  = (LNAddressCountyModel *)self.areaArr[row];
        lblTitle.text = model.name;
    }
    [view addSubview:lblTitle];
    return view;
}

#pragma mark -- Functions
/// 设置view
- (void)setupView {
    // 背景
    self.bgV = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _bgV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _bgV.backgroundColor = HmColorRGBA(0, 0, 0, 0.4);
    [_bgV setTitle:@"" forState:(UIControlStateNormal)];
    [_bgV addTarget:self action:@selector(cancelAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_bgV];
    // 承载view
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - kPickerViewHeight - 80) , kScreenWidth, kPickerViewHeight + 80)];
    vv.backgroundColor = [UIColor whiteColor];
    [self addSubview:vv];
    // title
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, vv.ln_width-160, kTitleHeight)];
    lblTitle.textColor = HmColorRGB(51, 51, 51);
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = @"选择所在地区";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont systemFontOfSize:14];
    [vv addSubview:lblTitle];
    
    // 取消
    UIButton *btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnCancel.frame = CGRectMake(0, 0, 80,kTitleHeight );
    btnCancel.backgroundColor = [UIColor clearColor];
    [btnCancel setTitle:@"取消" forState:(UIControlStateNormal)];
    [btnCancel setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [btnCancel addTarget:self action:@selector(cancelAction:) forControlEvents:(UIControlEventTouchUpInside)];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [vv addSubview:btnCancel];
    
    // 确定
    UIButton *btnSure = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnSure.frame = CGRectMake(kScreenWidth - 80, 0, 80,kTitleHeight );
    btnSure.backgroundColor = [UIColor clearColor];
    [btnSure setTitle:@"确定" forState:(UIControlStateNormal)];
    [btnSure setTitleColor:HmColorRGB(6, 160, 16) forState:(UIControlStateNormal)];
    [btnSure addTarget:self action:@selector(sureAction:) forControlEvents:(UIControlEventTouchUpInside)];
    btnSure.titleLabel.font = [UIFont systemFontOfSize:15];
    [vv addSubview:btnSure];
    
    // PickerView
    self.pickerV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, lblTitle.ln_bottom, vv.ln_width, kPickerViewHeight)];
    self.pickerV.frame = CGRectMake(0, lblTitle.ln_bottom, vv.ln_width, kPickerViewHeight);
    self.pickerV.delegate = self;
    self.pickerV.dataSource = self;
    self.pickerV.backgroundColor = [UIColor clearColor];
    [vv addSubview:_pickerV];
    
    
    
    
}

/// 取消
- (void)cancelAction:(UIButton *)btn {
    [self removeFromSuperview];
}

/// 确定
- (void)sureAction:(UIButton *)btn {
    if (self.confirmSelect) {
        self.confirmSelect(@[self.currentSelectProvince, self.currentSelectCity, self.currentSelectArea.name, self.currentSelectArea.cityId ,self.currentSelectArea]);
    }
    [self removeFromSuperview];
}

/// 解析地址
- (void)HmGetArea {
    [self removeAllObjectFromArea];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path]; //34个省份
    NSMutableArray *cityArray = [NSMutableArray array];
    for (NSDictionary *cityDict in array) {
        LNAddressProvinceModel *cityModel = [[LNAddressProvinceModel alloc]initWithDictionary:cityDict]; //转换模型
        [cityArray addObject:cityModel];
    }
    self.allDataArr = [NSArray arrayWithArray:cityArray];
    [self calculationCityAreaArr];
    [self.pickerV selectRow:[self.provinceArr indexOfObject:self.currentSelectProvince] inComponent:0 animated:YES];
    [self.pickerV selectRow:[self.cityArr indexOfObject:self.currentSelectCity] inComponent:1 animated:YES];
    [self.pickerV selectRow:[self.areaArr indexOfObject:self.currentSelectArea] inComponent:2 animated:YES];
}
- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}
/// 清空当前数据
- (void)removeAllObjectFromArea {
    [self.provinceArr removeAllObjects];
    [self.cityArr removeAllObjects];
    [self.areaArr removeAllObjects];
}

/// 计算当前市区数组
- (void)calculationCityAreaArr {
    [self.provinceArr removeAllObjects];
    [self.cityArr removeAllObjects];
    [self.areaArr removeAllObjects];
    if (!self.currentSelectProvince) {
        self.currentSelectProvince = ((LNAddressProvinceModel *)self.allDataArr[0]).name;
    }
    for (LNAddressProvinceModel *model in self.allDataArr) {
        [self.provinceArr addObject:model.name];
        if ([self.currentSelectProvince isEqualToString:model.name]) {
            if (!self.currentSelectCity) {
                self.currentSelectCity = ((LNAddressCityModel *)model.city[0]).name;
            }
            for (LNAddressCityModel *mo in model.city) {
                [self.cityArr addObject:mo.name];
                if ([mo.name isEqualToString:self.currentSelectCity]) {
                    if (!self.currentSelectArea) {
                        self.currentSelectArea = mo.area.firstObject;
                    }
                    for (LNAddressCountyModel *aa in mo.area) {
                        [self.areaArr addObject:aa];
                    }
                }
            }
        }
    }
    [self.pickerV reloadAllComponents];
}

#pragma mark -- Getter
- (NSMutableArray *)provinceArr {
    if (!_provinceArr) {
        _provinceArr = [NSMutableArray array];
    }
    return _provinceArr;
}

- (NSMutableArray *)cityArr {
    if (!_cityArr) {
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}

- (NSMutableArray *)areaArr {
    if (!_areaArr) {
        _areaArr = [NSMutableArray array];
    }
    return _areaArr;
}

@end
