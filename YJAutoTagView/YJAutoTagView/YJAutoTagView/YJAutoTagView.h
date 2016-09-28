//
//  YJAutoTagView.h
//  YJAutoTagView
//
//  Created by YJHou on 2016/9/28.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJAutoTagView : UIScrollView

/** 标签间距,和距离左，上间距,默认10 */
@property (nonatomic, assign) CGFloat   tagMargin;
@property (nonatomic, strong) UIColor * tagColor; /**< 标签颜色，默认红色 */
@property (nonatomic, assign) CGFloat tagBtnMargin; /**< 标签按钮内容间距，标签内容距离左上下右间距，默认5 */
@property (nonatomic, assign) CGFloat tagCornerRadius; /**< 标签圆角半径,默认为5 */
@property (nonatomic, assign) CGFloat borderWidth;  /**< 边框宽度 */
@property (nonatomic, strong) UIColor *borderColor; /**< 边框颜色 */
/**
 *  标签间距会自动计算
 */
@property (nonatomic, assign) NSInteger tagListCols;
/**
 *  在排序的时候，放大标签的比例，必须大于1
 */
@property (nonatomic, assign) CGFloat scaleTagInSort;
/**
 *  是否需要自定义tagList高度，默认为Yes
 */
@property (nonatomic, assign) BOOL isFitTagListH;
/**
 *  标签字体，默认13
 */
@property (nonatomic, assign) UIFont *tagFont;
/**
 *  标签背景颜色
 */
@property (nonatomic, strong) UIColor *tagBackgroundColor;


@property (nonatomic, strong) void(^clickTagBlock)(NSString *tag);


- (void)addTag:(NSString *)tagStr;

- (void)addTags:(NSArray *)tagStrs;

@end
