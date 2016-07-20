//
//  SunCarousels.h
//  SunCarousel
//
//  Created by 孙兆楠 on 16/7/18.
//  Copyright © 2016年 孙兆楠. All rights reserved.
//

#import <UIKit/UIKit.h>
//获取屏幕 宽度、高度
#define SJ_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SJ_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@protocol SZPersonalPageHeadViewDelegate<NSObject>
// 轮播点击图片方法
- (void)tapButton:(UIButton *)tap;

@end

@interface SunCarousels : UIView

- (void)awakeScrollViewFromHeight:(CGFloat)height data:(NSMutableArray *)arr;


@end
