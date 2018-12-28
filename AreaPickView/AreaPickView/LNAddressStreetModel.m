//
//  LNAddressStreetModel.m
//  AreaPickView
//
//  Created by SY8 on 2018/12/28.
//  Copyright © 2018年 SY8. All rights reserved.
//

#import "LNAddressStreetModel.h"

@implementation LNAddressStreetModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.fullname = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"fullname"]];
        self.areaId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"areaId"]];
    }
    return self;
}
@end
