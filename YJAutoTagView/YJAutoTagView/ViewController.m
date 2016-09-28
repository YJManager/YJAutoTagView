//
//  ViewController.m
//  YJAutoTagView
//
//  Created by YJHou on 2016/9/28.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "ViewController.h"
#import "YJAutoTagView.h"

static int i = 0;

@interface ViewController ()



@property (nonatomic, weak) YJAutoTagView * tagView;

@property (nonatomic, strong) NSArray *titles;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titles = @[@"感冒",@"头疼发热",@"北京融贯电子商务", @"北", @"北飞", @"2333北", @"ffff北", @"ffkfppp", @"00k,,,"];

    
    YJAutoTagView * tagView = [[YJAutoTagView alloc] init];
    
    tagView.backgroundColor = [UIColor whiteColor];
    // 点击标签，就会调用,点击标签，删除标签
    tagView.clickTagBlock = ^(NSString *tag){
        
        NSLog(@"---- = %@", tag);
        
    };

    
    
    
    // 高度可以设置为0，会自动跟随标题计算
    tagView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 0);
    // 设置标签背景色
    tagView.tagBackgroundColor = [UIColor colorWithRed:20 / 255.0 green:160 / 255.0 blue:250 / 255.0 alpha:1];
    // 设置标签颜色
    tagView.tagColor = [UIColor whiteColor];
    [self.view addSubview:tagView];
    
    _tagView = tagView;


}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSString *tagStr = [NSString stringWithFormat:@"%@  (%d)",_titles[arc4random_uniform(3)],i];
    [_tagView addTags:_titles];
    i++;
}

@end
