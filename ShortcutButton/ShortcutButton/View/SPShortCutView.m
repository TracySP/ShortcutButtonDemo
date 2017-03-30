//
//  SPShortCutView.m
//  图标拖动
//
//  Created by Song on 17/3/23.
//  Copyright © 2017年 TracyMcSong. All rights reserved.
//

#import "SPShortCutView.h"

@implementation SPShortCutView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.cornerRadius = 15;
        
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        _highlight = NO;
        
    }
    
    return self;
}

- (void)setHighlight:(BOOL)highlight
{
    _highlight = highlight;
    
    [self setNeedsDisplay];
}

- (void)setExistButton:(BOOL)existButton
{
    _existButton = existButton;
    
    if (existButton)
    {
        self.hidden = NO;
    }
    else
    {
        self.hidden = YES;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:kcr(0, 0, self.width, self.height) cornerRadius:15];
    // 普通模式下是蓝色边框透明
    
    path.lineWidth = 3;
    
    if (_highlight)
    {
        // 按钮进入范围后是红色边框
        [[UIColor redColor] setStroke];
    }
    else
    {
        [kBlueColor setStroke];
    }
    
    [path stroke];
}

@end
