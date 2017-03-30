//
//  SPTipsMenu.m
//  图标拖动
//
//  Created by Song on 17/3/21.
//  Copyright © 2017年 TracyMcSong. All rights reserved.
//

#import "SPTipsMenu.h"

@interface SPTipsMenu ()<UIScrollViewDelegate>
{
    float _paddingTB;  // 上下间距
    
    float _paddingLR;  // 左右间距
    
    NSInteger _colNumber;    // 每行按钮数量
    
    float _colHeight;  // 子项每行高度
    
    NSMutableArray *_menus;   // 切换按钮数据
    
    NSMutableArray *_subArr;  // 子按钮数组
    
    NSInteger _menuIndex;    //menu组号
}

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) NSArray *menuArray;


@end

@implementation SPTipsMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // 设置左边距和右边距
        _paddingLR = 10;
        // 设置上下边距
        _paddingTB = 10;
        // 设置每行的按钮个数
        _colNumber = 4;
        // 设置每行的按钮高度
        _colHeight = 80;
        // 设置默认组号
        _menuIndex = 0;
        
        [self setUpView];
    }
    
    return self;
}

- (void)setUpView
{
    self.layer.borderWidth = 2;
    
    self.layer.borderColor = kBlueColor.CGColor;
    
    CGRect rect1 = kcr(_paddingLR, _paddingTB, self.width - _paddingLR * 2, self.height - 50 - _paddingTB * 2);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:rect1];
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.delegate = self;
    
    _scrollView.backgroundColor = kColorFromRGB(0xf7f7f7);
    
    [self addSubview:_scrollView];
    
    // 配置按钮
    
    _menus = [NSMutableArray array];
    
    _subArr = [NSMutableArray array];
    
    [self.menuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dict = obj;
        
        [self btn:[dict objectForKey:@"name"] mainIndex:idx];
        
        NSArray *subArr = [dict objectForKey:@"sub"];
        
        for (int i =  0; i <subArr.count; i++) {
            
            NSDictionary *subDict = subArr[i];
            
            UIButton *btn = [self btn:subDict subIndex:i mainIndex:idx];
            
            [_scrollView addSubview:btn];
        }
        
    }];
    
    // 设置ContentSize
    [_scrollView setContentSize:CGSizeMake(_scrollView.width * self.menuArray.count, _scrollView.height)];
}
/// 设置子按钮
- (UIButton *)btn:(NSDictionary *)dict subIndex:(NSInteger)subIndex mainIndex:(NSInteger)mainIndex
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.userInfo = dict;
    
    float width = (self.width - _paddingLR * 2) / _colNumber;
    
    float x = (subIndex % _colNumber) * width + _scrollView.width * mainIndex;
    
    float y = (subIndex / _colNumber) * _colHeight;
    
    button.frame = kcr(x, y, width, _colHeight);
    
    button.tag = subIndex + 1000;
    
    [button setTitle:[dict objectForKey:@"name"] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    
    NSString *imageName = [NSString stringWithFormat:@"image_%ld",subIndex + 1];
    
    NSString *imageNmmeH = [NSString stringWithFormat:@"image_%ld_h",subIndex + 1];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:imageNmmeH] forState:UIControlStateSelected];
    
    [button setImage:[UIImage imageNamed:imageNmmeH] forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[UIImage imageWithColor:kColorFromRGB(0xf7f7f7)] forState:UIControlStateDisabled];
    
    [button setBackgroundImage:[UIImage imageWithColor:kBlueColor] forState:UIControlStateSelected];
    
    [button setBackgroundImage:[UIImage imageWithColor:kBlueColor] forState:UIControlStateHighlighted];
    button.enabled = [[dict objectForKey:@"enable"] intValue];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(subMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 给每个按钮增加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [button addGestureRecognizer:longPress];
    
    [button verticalAlignWithSpace:6 topSpacing:0];
    
    [_subArr addObject:button];
    
    return button;
}
/// 设置menu按钮
- (void)btn:(NSString *)name mainIndex:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    float width = (self.width - _paddingLR * 2) / self.menuArray.count;
    
    button.frame = kcr(_paddingLR + width * index, _scrollView.maxY, width, 50);
    
    button.tag = index + 1000;
    
    if (index == 0) {
        
        button.selected = YES;
    }
    
    [button setTitle:name forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageWithColor:kColorFromRGB(0xf7f7f7)] forState:UIControlStateSelected];
    
    [button setBackgroundImage:[UIImage imageWithColor:kColorFromRGB(0xf7f7f7)] forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_menus addObject:button];
    
    [self addSubview:button];
}

- (void)menuClicked:(UIButton *)btn
{
    if (btn.selected) {return;}
    
    btn.selected = YES;
    
    for (UIButton *menuBtn in _menus)
    {
        if (menuBtn != btn)
        {
            menuBtn.selected = NO;
        }
    }
    
    _menuIndex = btn.tag - 1000;
    // 设置偏移
    CGPoint point = CGPointMake((btn.tag - 1000) * _scrollView.width, 0);
    
    [_scrollView setContentOffset:point animated:YES];
}

- (void)subMenuClicked:(UIButton *)btn
{
    if (btn.selected) {return;}
    
    btn.selected = YES;
    
    for (UIButton *subBtn in _subArr) {
        
        if (subBtn != btn)
        {
            subBtn.selected = NO;
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPressGesture
{
    UIButton *orignBtn = (UIButton *)longPressGesture.view;
    
    UIButton *copyBtn = [self btn:orignBtn.userInfo subIndex:orignBtn.tag - 1000 mainIndex:_menuIndex];
    
    copyBtn.layer.cornerRadius = 15;
    
    copyBtn.layer.masksToBounds = YES;
    
    copyBtn.alpha = .5;
    
    copyBtn.backgroundColor = [UIColor whiteColor];
    
    self.hidden = YES;
    
    CGPoint point = [longPressGesture locationInView:orignBtn.superview];
    // 这里涉及到在ViewController的View中移动按钮的问题，如果当前menu组数不是第一组，则需要把坐标point转换成相对于第一组的坐标
    if (_menuIndex > 0)
    {
        point = CGPointMake(point.x - _menuIndex * _scrollView.width, point.y);
    }
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(startMoveMenuButton:point:bgView:)]) {
            
            [self.delegate startMoveMenuButton:copyBtn point:point bgView:self];
        }
    }
    else if (longPressGesture.state == UIGestureRecognizerStateChanged)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(moveMenuButton:point:bgView:)]) {
            
            [self.delegate moveMenuButton:copyBtn point:point bgView:self];
        }

    }
    else if (longPressGesture.state == UIGestureRecognizerStateEnded)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(endMoveMenuButton:point:bgView:)]) {
            
            [self.delegate endMoveMenuButton:copyBtn point:point bgView:self];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageCount = scrollView.contentOffset.x / scrollView.width;
    
    for (UIButton *btn in _menus)
    {
        if (pageCount == btn.tag - 1000)
        {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
}
/// 数组格式化 最外层name为menu菜单按钮的名称  内存name为分部按钮的名称，img为分布按钮的图片，enable为分布按钮是否可以点击
- (NSArray *)menuArray
{
    if (!_menuArray) {
        
        _menuArray = @[@{@"name":@"标题1",@"sub":@[
                                 @{@"name":@"子标题1",@"img":@"image_1",@"enable":@YES},
                                 @{@"name":@"子标题2",@"img":@"image_2",@"enable":@YES},
                                 @{@"name":@"子标题3",@"img":@"image_3",@"enable":@YES},
                                 @{@"name":@"子标题4",@"img":@"image_4",@"enable":@YES},
                                 @{@"name":@"子标题5",@"img":@"image_5",@"enable":@YES},
                                 @{@"name":@"子标题6",@"img":@"image_6",@"enable":@YES},
                                 @{@"name":@"子标题7",@"img":@"image_7",@"enable":@YES},
                                 @{@"name":@"子标题8",@"img":@"image_8",@"enable":@YES},
                                 @{@"name":@"子标题9",@"img":@"image_9",@"enable":@YES},
                                 @{@"name":@"子标题10",@"img":@"image_10",@"enable":@YES}
                                 ]
                         },
                       @{@"name":@"标题2",@"sub":@[
                                 @{@"name":@"子标题1",@"img":@"image_1",@"enable":@YES},
                                 @{@"name":@"子标题2",@"img":@"image_2",@"enable":@YES},
                                 @{@"name":@"子标题3",@"img":@"image_3",@"enable":@YES},
                                 @{@"name":@"子标题4",@"img":@"image_4",@"enable":@YES},
                                 @{@"name":@"子标题5",@"img":@"image_5",@"enable":@YES},
                                 @{@"name":@"子标题6",@"img":@"image_6",@"enable":@YES},
                                 @{@"name":@"子标题7",@"img":@"image_7",@"enable":@YES},
                                 @{@"name":@"子标题8",@"img":@"image_8",@"enable":@YES},
                                 @{@"name":@"子标题9",@"img":@"image_9",@"enable":@YES},
                                 @{@"name":@"子标题10",@"img":@"image_10",@"enable":@YES}
                                 ]
                         },
                       @{@"name":@"标题3",@"sub":@[
                                 @{@"name":@"子标题1",@"img":@"image_1",@"enable":@YES},
                                 @{@"name":@"子标题2",@"img":@"image_2",@"enable":@YES},
                                 @{@"name":@"子标题3",@"img":@"image_3",@"enable":@YES},
                                 @{@"name":@"子标题4",@"img":@"image_4",@"enable":@YES},
                                 @{@"name":@"子标题5",@"img":@"image_5",@"enable":@YES},
                                 @{@"name":@"子标题6",@"img":@"image_6",@"enable":@YES},
                                 @{@"name":@"子标题7",@"img":@"image_7",@"enable":@YES},
                                 @{@"name":@"子标题8",@"img":@"image_8",@"enable":@YES},
                                 @{@"name":@"子标题9",@"img":@"image_9",@"enable":@YES},
                                 @{@"name":@"子标题10",@"img":@"image_10",@"enable":@YES}
                                 ]
                         },
                       @{@"name":@"标题4",@"sub":@[
                                 @{@"name":@"子标题1",@"img":@"image_1",@"enable":@YES},
                                 @{@"name":@"子标题2",@"img":@"image_2",@"enable":@YES},
                                 @{@"name":@"子标题3",@"img":@"image_3",@"enable":@YES},
                                 @{@"name":@"子标题4",@"img":@"image_4",@"enable":@YES},
                                 @{@"name":@"子标题5",@"img":@"image_5",@"enable":@YES},
                                 @{@"name":@"子标题6",@"img":@"image_6",@"enable":@YES},
                                 @{@"name":@"子标题7",@"img":@"image_7",@"enable":@YES},
                                 @{@"name":@"子标题8",@"img":@"image_8",@"enable":@YES},
                                 @{@"name":@"子标题9",@"img":@"image_9",@"enable":@YES},
                                 @{@"name":@"子标题10",@"img":@"image_10",@"enable":@YES}
                                 ]
                         },
                       @{@"name":@"标题5",@"sub":@[
                                 @{@"name":@"子标题1",@"img":@"image_1",@"enable":@YES},
                                 @{@"name":@"子标题2",@"img":@"image_2",@"enable":@YES},
                                 @{@"name":@"子标题3",@"img":@"image_3",@"enable":@YES},
                                 @{@"name":@"子标题4",@"img":@"image_4",@"enable":@YES},
                                 @{@"name":@"子标题5",@"img":@"image_5",@"enable":@YES},
                                 @{@"name":@"子标题6",@"img":@"image_6",@"enable":@YES},
                                 @{@"name":@"子标题7",@"img":@"image_7",@"enable":@YES},
                                 @{@"name":@"子标题8",@"img":@"image_8",@"enable":@YES},
                                 @{@"name":@"子标题9",@"img":@"image_9",@"enable":@YES},
                                 @{@"name":@"子标题10",@"img":@"image_10",@"enable":@YES}
                                 ]}
                       ];
    }
    
    return _menuArray;
}

@end
