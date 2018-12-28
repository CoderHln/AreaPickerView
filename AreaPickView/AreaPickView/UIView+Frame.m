//
//  UIView+Frame.m
//  AreaPickView
//
//  Created by SY8 on 2018/12/28.
//  Copyright © 2018年 SY8. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (CGFloat)ln_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setln_bottom:(CGFloat)ln_bottom {
    CGRect frame = self.frame;
    frame.origin.y = ln_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)ln_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setln_right:(CGFloat)ln_right {
    CGRect frame = self.frame;
    frame.origin.x = ln_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ln_x {
    return self.frame.origin.x;
}

- (void)setln_x:(CGFloat)ln_x {
    CGRect frame = self.frame;
    frame.origin.x = ln_x;
    self.frame = frame;
}

- (CGFloat)ln_y {
    return self.frame.origin.y;
}

- (void)setln_y:(CGFloat)ln_y {
    CGRect frame = self.frame;
    frame.origin.y = ln_y;
    self.frame = frame;
}

- (CGFloat)ln_centerX {
    return self.center.x;
}

- (void)setln_centerX:(CGFloat)ln_centerX {
    CGPoint center = self.center;
    center.x = ln_centerX;
    self.center = center;
}

- (CGFloat)ln_centerY {
    return self.center.y;
}

- (void)setln_centerY:(CGFloat)ln_centerY {
    CGPoint center = self.center;
    center.y = ln_centerY;
    self.center = center;
}

- (CGFloat)ln_width {
    return self.frame.size.width;
}

- (void)setln_width:(CGFloat)ln_width {
    CGRect frame = self.frame;
    frame.size.width = ln_width;
    self.frame = frame;
}

- (CGFloat)ln_height {
    return self.frame.size.height;
}

- (void)setln_height:(CGFloat)ln_height {
    CGRect frame = self.frame;
    frame.size.height = ln_height;
    self.frame = frame;
}

- (CGSize)ln_size {
    return self.frame.size;
}

- (void)setln_size:(CGSize)ln_size {
    CGRect frame = self.frame;
    frame.size = ln_size;
    self.frame = frame;
}

- (CGPoint)ln_origin {
    return self.frame.origin;
}

- (void)setln_origin:(CGPoint)ln_origin {
    CGRect frame = self.frame;
    frame.origin = ln_origin;
    self.frame = frame;
}
@end
