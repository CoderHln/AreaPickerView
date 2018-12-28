//
//  LNAddressProvinceModel.h
//  AreaPickView
//
//  Created by SY8 on 2018/12/28.
//  Copyright © 2018年 SY8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNAddressProvinceModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *city;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
