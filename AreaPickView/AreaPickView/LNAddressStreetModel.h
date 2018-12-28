//
//  LNAddressStreetModel.h
//  AreaPickView
//
//  Created by SY8 on 2018/12/28.
//  Copyright © 2018年 SY8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNAddressStreetModel : NSObject
/**街道全名*/
@property (nonatomic, copy) NSString *fullname;
/**街道ID*/
@property (nonatomic, copy) NSString *areaId;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
