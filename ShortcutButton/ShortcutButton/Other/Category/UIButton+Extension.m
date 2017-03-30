//
//  UIButton+Extension.m
//  BaseLib
//
//  Copyright (c) 2015年 navinfo. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

- (void)horizontalAlgin:(int)spacing
{
    CGFloat insetAmount = spacing / 2.0;
 
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
}

- (void)horizontalConverseAlgin:(int)spacing
{
    CGFloat insetAmount = spacing / 2.0;
    
    CGSize imageSize = self.imageView.image.size;
    
    CGSize titleSize;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        titleSize = [[self titleForState:self.state] sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    }
    else
    {
        titleSize = self.titleLabel.frame.size;
    }
    
    if (CGSizeEqualToSize(titleSize, CGSizeZero)) return;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width - insetAmount,
                                            0, imageSize.width + insetAmount);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + insetAmount,
                                            0, -titleSize.width - insetAmount);
}

- (void)verticalAlignWithSpace:(int)spacing topSpacing:(int)topSpacing
{
    CGSize imageSize = self.imageView.image.size;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(topSpacing,
                                            - imageSize.width,
                                            - (imageSize.height + spacing + topSpacing),
                                            0.0);
    
    CGSize titleSize;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
        titleSize = [[self titleForState:self.state] sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    }
    else
    {
        titleSize = self.titleLabel.frame.size;
    }
    
    if (CGSizeEqualToSize(titleSize, CGSizeZero)) return;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(topSpacing - (titleSize.height + spacing),
                                            0.0,
                                            -topSpacing,
                                            - titleSize.width);
}

@end
