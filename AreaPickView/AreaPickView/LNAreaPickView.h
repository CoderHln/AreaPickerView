//
//  LNAreaPickView.h
//  AreaPickView
//
//  Created by SY8 on 2018/12/28.
//  Copyright © 2018年 SY8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNAreaPickView : UIView
@property (nonatomic, copy) void (^confirmSelect)(NSArray *address);
- (instancetype)initWithLastContent:(NSArray *)lastContent;
- (void)show;
@end
