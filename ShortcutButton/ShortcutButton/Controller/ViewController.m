//
//  ViewController.m
//  图标拖动
//
//  Created by Song on 17/3/21.
//  Copyright © 2017年 TracyMcSong. All rights reserved.
//
#import "ViewController.h"
#import "SPTipsMenu.h"
#import "SPShortCutView.h"

@interface ViewController ()<SPTipsMenuDelegate>

@property (nonatomic,strong) SPTipsMenu *tipsMenu;
/// 移动的按钮
@property (nonatomic,strong) UIButton *moveBtn;

@property (nonatomic,strong) UIVisualEffectView *visualView;
/// 存着6个快捷框
@property (nonatomic,strong) NSMutableArray *shortCutArray;
/// 桌面上显示的按钮
@property (nonatomic,strong) NSMutableArray *showButtonArr;

@property (nonatomic,strong) UIImageView *imageView;


@end

@implementation ViewController

- (IBAction)tanchu:(id)sender
{
    if (self.tipsMenu.hidden) {
        
        self.tipsMenu.hidden = NO;
    }
}

- (NSMutableArray *)showButtonArr
{
    if (!_showButtonArr) {
        
        _showButtonArr = [NSMutableArray array];
    }
    
    return _showButtonArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    self.imageView = imageView;
    
    imageView.image = [UIImage imageNamed:@"backgroud.jpg"];
    
    [self.view addSubview:imageView];
    
    [self.view sendSubviewToBack:imageView];
    
    CGRect rect = kcr(0, 0, 350, 280);
    
    self.tipsMenu = [[SPTipsMenu alloc] initWithFrame:rect];
    
    self.tipsMenu.delegate = self;
    
    [self.view addSubview:self.tipsMenu];
    
    self.tipsMenu.centerX = self.view.centerX;
    
    self.tipsMenu.y = self.view.height - 280 - 30;
    
    self.tipsMenu.hidden = YES;
    
    [self setUpShortCutBtn];
}
/// 布局左右各三个按钮框
- (void)setUpShortCutBtn
{
    self.shortCutArray = [NSMutableArray array];
    
    float width = 70;
    
    for (int i =  0; i < 3; i++)
    {
        CGRect rect = kcr(15, 130 + i * (width + 10), width, width);
        
        SPShortCutView *shortCutView = [[SPShortCutView alloc] initWithFrame:rect];
        
        shortCutView.tag = i + 1000;
        
        shortCutView.hidden = YES;
        
        [self.view addSubview:shortCutView];
        
        [self.shortCutArray addObject:shortCutView];
    }
    
    for (int i =  0; i < 3; i++)
    {
        CGRect rect = kcr(self.view.width - 15 - width,130 + i * (width + 10), width, width);
        
        SPShortCutView *shortCutView = [[SPShortCutView alloc] initWithFrame:rect];
        
        shortCutView.tag = i + 1000 + 3;
        
        shortCutView.hidden = YES;
        
        [self.view addSubview:shortCutView];
        
        [self.shortCutArray addObject:shortCutView];
    }
}

- (UIButton *)creatButton:(id)userInfo
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.layer.cornerRadius = 15;
    
    button.layer.masksToBounds = YES;
    
    button.userInfo = userInfo;
    
    [button setTitle:[userInfo objectForKey:@"name"] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    
    NSString *imageName = [userInfo objectForKey:@"img"];
    
    NSString *imageNmmeH = [NSString stringWithFormat:@"%@_h",imageName];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:imageNmmeH] forState:UIControlStateSelected];
    
    [button setImage:[UIImage imageNamed:imageNmmeH] forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[UIImage imageWithColor:kColorFromRGB(0xf7f7f7)] forState:UIControlStateDisabled];
    
    [button setBackgroundImage:[UIImage imageWithColor:kBlueColor] forState:UIControlStateSelected];
    
    [button setBackgroundImage:[UIImage imageWithColor:kBlueColor] forState:UIControlStateHighlighted];
    button.enabled = [[userInfo objectForKey:@"enable"] intValue];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 给每个按钮增加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [button addGestureRecognizer:longPress];
    
    [button verticalAlignWithSpace:6 topSpacing:0];
    
    return button;
}

- (void)buttonClicked:(UIButton *)btn
{
    
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressGesture
{
    CGPoint point = [longPressGesture locationInView:self.view];
    
    UIButton *moveBtn = (UIButton *)longPressGesture.view;
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        [self startMoveMenuButton:moveBtn point:point bgView:self.view];
    }
    else if (longPressGesture.state == UIGestureRecognizerStateChanged)
    {
        [self moveMenuButton:moveBtn point:point bgView:self.view];
    }
    else if (longPressGesture.state == UIGestureRecognizerStateEnded)
    {
        [self endMoveMenuButton:moveBtn point:point bgView:self.view];
    }
}

@end

@implementation ViewController(movePoint)

- (void)startMoveMenuButton:(UIButton *)moveBtn point:(CGPoint)point bgView:(UIView *)bgView
{
    // 背景高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    self.visualView = [[UIVisualEffectView alloc] initWithFrame:self.view.bounds];
    
    self.visualView.effect = effect;
    
    [self.view addSubview:moveBtn];
    
    [self.view insertSubview:self.visualView aboveSubview:self.imageView];
    
    self.moveBtn = moveBtn;
    
    // 坐标转换
    point = [self.view convertPoint:point fromView:bgView];
    
    self.moveBtn.center = point;
    
    // 让6个框显示
    [self.shortCutArray makeObjectsPerformSelector:@selector(setHidden:) withObject:NO];
}

- (void)moveMenuButton:(UIButton *)moveBtn point:(CGPoint)point bgView:(UIView *)bgView
{
    // 坐标转换 让按钮跟随手势移动
    point = [self.view convertPoint:point fromView:bgView];
    
    self.moveBtn.center = point;
    // 移动过程中判断是否移动到6个按钮框范围内
    for (SPShortCutView *view in self.shortCutArray) {
        
        [view setHighlight:CGRectContainsPoint(view.frame, point)];
    }
}

- (void)endMoveMenuButton:(UIButton *)moveBtn point:(CGPoint)point bgView:(UIView *)bgView
{
    // 坐标转换 让按钮跟随手势移动
    point = [self.view convertPoint:point fromView:bgView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!self.tipsMenu.hidden) {
        
        self.tipsMenu.hidden = YES;
    }
    
    BOOL isDesk = NO;
    
    [self.showButtonArr removeObject:self.moveBtn];

    for (SPShortCutView *view in self.shortCutArray) {
        // 移动点在6个框内时
        if (CGRectContainsPoint(view.frame, point))
        {
            // 创建一个新按钮放在框内 移动的按钮移除
            UIButton *newBtn = [self creatButton:self.moveBtn.userInfo];
            
            [self.moveBtn removeFromSuperview];
            
            self.moveBtn = nil;
            
            newBtn.tag = view.tag;
            
            newBtn.frame = CGRectInset(view.frame, 2, 2);
            
            [self.view addSubview:newBtn];
            
            [self.view bringSubviewToFront:newBtn];
            
            [self.showButtonArr addObject:newBtn];
            
            [view setHighlight:NO];
            
            isDesk = YES;
        }
    }
    
    if (!isDesk)
    {
        [self.moveBtn removeFromSuperview];
        
        self.moveBtn = nil;
    }
    
    // 根据界面显示的按钮控制外框是否显示
    
    [self.shortCutArray makeObjectsPerformSelector:@selector(setExistButton:) withObject:NO];
    
    for (UIButton *shortCutBtn in self.showButtonArr)
    {
        if (shortCutBtn.tag - 1000 < self.shortCutArray.count)
        {
            SPShortCutView *cutView = self.shortCutArray[shortCutBtn.tag - 1000];
            
            cutView.existButton = YES;
        }
    }
    
    // 移除高斯模糊背景
    [self.visualView removeFromSuperview];
    
    self.visualView = nil;
}

@end
