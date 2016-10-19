//
//  YJAutoTagView.m
//  YJAutoTagView
//
//  Created by YJHou on 2016/9/28.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "YJAutoTagView.h"

static CGFloat const imgViewH = 20;

@interface YJAutoTagView ()

@property (nonatomic, strong) NSMutableArray      * tagDatasource; // tag的数据源
@property (nonatomic, strong) NSMutableDictionary * tags;
@property (nonatomic, strong) NSMutableArray      * tagBtns;

@end

@implementation YJAutoTagView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUpAutoTagMainView];
    }
    return self;
}

- (void)_setUpAutoTagMainView{
    
    self.tagMargin = 10;
    self.tagColor = [UIColor redColor];
    self.tagBtnMargin = 5;
    self.tagCornerRadius = 0.0;
    self.borderColor = [UIColor clearColor];
    self.borderWidth = 0.0f;
    _tagListCols = 4;
    _scaleTagInSort = 1;
    _isFitTagListH = YES;
    _tagFont = [UIFont systemFontOfSize:13];
    self.clipsToBounds = YES;
}

- (void)setScaleTagInSort:(CGFloat)scaleTagInSort{
    if (_scaleTagInSort < 1) {
        @throw [NSException exceptionWithName:@"YJError" reason:@"(scaleTagInSort)缩放比例必须大于1" userInfo:nil];
    }
    _scaleTagInSort = scaleTagInSort;
}

- (CGFloat)tagListH{
    if (self.tagBtns.count <= 0) return 0;
    return CGRectGetMaxY([self.tagBtns.lastObject frame]) + _tagMargin;
}

#pragma mark - 操作标签方法
// 添加多个标签
- (void)addTags:(NSArray *)tagStrs{
    if (self.frame.size.width == 0) {
        @throw [NSException exceptionWithName:@"YJError" reason:@"先设置标签列表的frame" userInfo:nil];
    }
    
    for (NSString *tagStr in tagStrs) {
        [self addTag:tagStr];
    }
}
// 添加标签
- (void)addTag:(NSString *)tagStr{
    Class tagClass = [UIButton class];
    
    // 创建标签按钮
    UIButton *tagButton = [tagClass buttonWithType:UIButtonTypeCustom];
    tagButton.layer.cornerRadius = _tagCornerRadius;
    tagButton.layer.borderWidth = _borderWidth;
    tagButton.layer.borderColor = _borderColor.CGColor;
    tagButton.clipsToBounds = YES;
    tagButton.tag = self.tagBtns.count;
    [tagButton setTitle:tagStr forState:UIControlStateNormal];
    [tagButton setTitleColor:_tagColor forState:UIControlStateNormal];
    [tagButton setBackgroundColor:_tagBackgroundColor];
    tagButton.titleLabel.font = _tagFont;
    [tagButton addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tagButton];
    
    // 保存到数组
    [self.tagBtns addObject:tagButton];
    
    // 保存到字典
    [self.tags setObject:tagButton forKey:tagStr];
    [self.tagDatasource addObject:tagStr];
    
    // 设置按钮的位置
    [self updateTagButtonFrame:tagButton.tag extreMargin:YES];
    
    // 更新自己的高度
    if (_isFitTagListH) {
        CGRect frame = self.frame;
        frame.size.height = self.tagListH;
        [UIView animateWithDuration:0.1 animations:^{
            self.frame = frame;
        }];
    }
}

// 点击标签
- (void)clickTag:(UIButton *)button{
    
    if (self.clickTagBlock) {
        self.clickTagBlock(button.currentTitle);
    }
}

// 看下当前按钮中心点在哪个按钮上
- (UIButton *)buttonCenterInButtons:(UIButton *)curButton{
    for (UIButton *button in self.tagBtns) {
        if (curButton == button) continue;
        if (CGRectContainsPoint(button.frame, curButton.center)) {
            return button;
        }
    }
    return nil;
}

// 更新标签
- (void)updateTag{
    NSInteger count = self.tagBtns.count;
    for (int i = 0; i < count; i++) {
        UIButton *tagButton = self.tagBtns[i];
        tagButton.tag = i;
    }
}

// 更新之前按钮
- (void)updateBeforeTagButtonFrame:(NSInteger)beforeI{
    for (int i = 0; i < beforeI; i++) {
        // 更新按钮
        [self updateTagButtonFrame:i extreMargin:NO];
    }
}

// 更新以后按钮
- (void)updateLaterTagButtonFrame:(NSInteger)laterI{
    NSInteger count = self.tagBtns.count;
    
    for (NSInteger i = laterI; i < count; i++) {
        // 更新按钮
        [self updateTagButtonFrame:i extreMargin:NO];
    }
}

- (void)updateTagButtonFrame:(NSInteger)i extreMargin:(BOOL)extreMargin{
    // 获取上一个按钮
    NSInteger preI = i - 1;
    
    // 定义上一个按钮
    UIButton *preButton;
    
    // 过滤上一个角标
    if (preI >= 0) {
        preButton = self.tagBtns[preI];
    }
    
    // 获取当前按钮
    UIButton *tagButton = self.tagBtns[i];
    // 自适应标签尺寸
    // 设置标签按钮frame（自适应）
    [self setupTagButtonCustomFrame:tagButton preButton:preButton extreMargin:extreMargin];

}

// 设置标签按钮frame（自适应）
- (void)setupTagButtonCustomFrame:(UIButton *)tagButton preButton:(UIButton *)preButton extreMargin:(BOOL)extreMargin{
    // 等于上一个按钮的最大X + 间距
    CGFloat btnX = CGRectGetMaxX(preButton.frame) + _tagMargin;
    
    // 等于上一个按钮的Y值,如果没有就是标签间距
    CGFloat btnY = preButton? preButton.frame.origin.y : _tagMargin;
    
    // 获取按钮宽度
    CGFloat titleW = [tagButton.titleLabel.text sizeWithFont:_tagFont].width;
    CGFloat titleH = [tagButton.titleLabel.text sizeWithFont:_tagFont].height;
    CGFloat btnW = extreMargin?titleW + 2 * _tagBtnMargin : tagButton.bounds.size.width ;
    // 获取按钮高度
    CGFloat btnH = extreMargin? titleH + 2 * _tagBtnMargin:tagButton.bounds.size.height;
    // 判断当前按钮是否足够显示
    CGFloat rightWidth = self.bounds.size.width - btnX;
    
    if (rightWidth < btnW) {
        // 不够显示，显示到下一行
        btnX = _tagMargin;
        btnY = CGRectGetMaxY(preButton.frame) + _tagMargin;
    }
    
    tagButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
}

#pragma mark - Lazy (Private)
- (NSMutableArray *)tagDatasource{
    if (_tagDatasource == nil) {
        _tagDatasource = [NSMutableArray array];
    }
    return _tagDatasource;
}

- (NSMutableArray *)tagBtns{
    if (_tagBtns == nil) {
        _tagBtns = [NSMutableArray array];
    }
    return _tagBtns;
}

- (NSMutableDictionary *)tags{
    if (_tags == nil) {
        _tags = [NSMutableDictionary dictionary];
    }
    return _tags;
}

@end
