//
//  LNAddressCityModel.m
//  AreaPickView
//
//  Created by SY8 on 2018/12/28.
//  Copyright © 2018年 SY8. All rights reserved.
//

#import "LNAddressCityModel.h"
#import "LNAddressCountyModel.h"

@implementation LNAddressCityModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        //取到dict
        /**
         "140100太原市" =         (
         "140105小店区",
         "140106迎泽区",
         "140107杏花岭区",
         "140108尖草坪区",
         "140109万柏林区",
         "140110晋源区",
         "140121清徐县",
         "140122阳曲县",
         "140123娄烦县",
         "140181古交市"
         );
         */
        
        //name 为key
        NSArray *arr = [dictionary allKeys];//其实只有一个
        self.name = [arr[0] substringFromIndex:6];
        //city 为value
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *str in [dictionary objectForKey:arr[0]]) { //封装为 区 模型
            LNAddressCountyModel *model = [[LNAddressCountyModel alloc]initWithString:str];
            [array addObject:model];
        }
        self.area = array;
    }
    return self;
}
@end
