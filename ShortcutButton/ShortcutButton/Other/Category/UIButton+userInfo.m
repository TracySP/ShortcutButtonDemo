//
//  UIButton+userInfo.m
//  图标拖动
//
//  Copyright © 2015年 TracyMcSong. All rights reserved.
//

#import "UIButton+userInfo.h"
#import <objc/runtime.h>

@implementation UIButton (userInfo)
// 动态获取userInfo属性
- (id)userInfo
{
    return objc_getAssociatedObject(self, @selector(userInfo));
}
// 动态添加userInfo属性
- (void)setUserInfo:(id)userInfo
{
    objc_setAssociatedObject(self, @selector(userInfo), userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
