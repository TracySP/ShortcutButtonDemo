//
//  SPTipsMenu.h
//  图标拖动
//
//  Created by Song on 17/3/21.
//  Copyright © 2017年 TracyMcSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPTipsMenuDelegate <NSObject>

- (void)startMoveMenuButton:(UIButton *)moveBtn point:(CGPoint)point bgView:(UIView *)bgView;

- (void)moveMenuButton:(UIButton *)moveBtn point:(CGPoint)point bgView:(UIView *)bgView;

- (void)endMoveMenuButton:(UIButton *)moveBtn point:(CGPoint)point bgView:(UIView *)bgView;

@end

@interface SPTipsMenu : UIView

@property (nonatomic,weak) id <SPTipsMenuDelegate>delegate;

@end

