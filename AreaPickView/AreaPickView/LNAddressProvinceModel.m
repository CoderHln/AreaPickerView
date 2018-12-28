//
//  LNAddressProvinceModel.m
//  AreaPickView
//
//  Created by SY8 on 2018/12/28.
//  Copyright © 2018年 SY8. All rights reserved.
//

#import "LNAddressProvinceModel.h"
#import "LNAddressCityModel.h"

@implementation LNAddressProvinceModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        //取到dict
        /**
         "130000河北省" = {
         "130100石家庄市" =   ();
         "130200唐山市" =   ();
         ...
         }
         */
        
        //name 为key
        NSArray *arr = [dictionary allKeys];//其实只有一个
        self.name = [arr[0] substringFromIndex:6];
        //city 为value
        NSMutableArray *array = [NSMutableArray array];
        /* 此时字典为：
         "130100石家庄市" =   ("140105小店区","140106迎泽区","140107杏花岭区",);
         "130200唐山市" =   ("140105小店区","140106迎泽区","140107杏花岭区",);
         ...
         */
        NSDictionary *provinceDict = [dictionary objectForKey:arr[0]];
        NSArray *provinceArr = [provinceDict allKeys];
        for (NSInteger i = 0; i < provinceArr.count; i++) {
            NSMutableDictionary *city = [NSMutableDictionary dictionary];
            [city setValue:[provinceDict objectForKey:provinceArr[i]] forKey:provinceArr[i]];
            /* 此时字典为：
             "130100石家庄市" =   ("140105小店区","140106迎泽区","140107杏花岭区",);
             */
            LNAddressCityModel *model = [[LNAddressCityModel alloc]initWithDictionary:city];
            [array addObject:model];
        }
        self.city = array;
    }
    return self;
}
@end
