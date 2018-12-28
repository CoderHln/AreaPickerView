//
//  LNAddressCountyModel.m
//  AreaPickView
//
//  Created by SY8 on 2018/12/28.
//  Copyright © 2018年 SY8. All rights reserved.
//

#import "LNAddressCountyModel.h"

@implementation LNAddressCountyModel
- (instancetype)initWithString:(NSString *)string{
    self = [super init];
    if (self) {
        //  140107杏花岭区
        //前6位为 id
        self.cityId = [string substringToIndex:6];
        //其余为name
        self.name = [string substringFromIndex:6];
    }
    return self;
}
@end
