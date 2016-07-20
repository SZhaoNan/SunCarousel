//
//  SunCarousels.m
//  SunCarousel
//
//  Created by 孙兆楠 on 16/7/18.
//  Copyright © 2016年 孙兆楠. All rights reserved.
//

#import "SunCarousels.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface SunCarousels()<UIScrollViewDelegate>
@property (nonatomic, strong)id<SZPersonalPageHeadViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollView_H;      // scrollView所在View的高度
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSTimer *timer;           // 给滚动视图设置个定时器
@property (nonatomic, assign) int timeCount;            // 给定时器记录到哪页
// 标记轮播高度
@property (nonatomic, assign) int isHeight;

@end

@implementation SunCarousels

- (void)awakeScrollViewFromHeight:(CGFloat)height data:(NSMutableArray *)arr{
    if (SJ_SCREEN_WIDTH == 320) {
        self.isHeight = height/375.0*320.0;
        _scrollView_H.constant = self.isHeight;
    }else if (SJ_SCREEN_WIDTH == 375){
        self.isHeight = height;
        _scrollView_H.constant = self.isHeight;
    }else if (SJ_SCREEN_WIDTH == 414){
        self.isHeight = height/375.0*414.0;
        _scrollView_H.constant = self.isHeight;
    }

    _dataArr = [NSMutableArray array];
//    _dataArr = arr;
    if (arr.count == 1) {
        for (int i = 0; i < arr.count; i ++) {
            [self.dataArr addObject:arr[i]];
        }
        self.pageLabel.text = [NSString stringWithFormat:@"%@/%@",@"1",@"1"];
    }else if (arr.count > 1){
        [self.dataArr addObject:arr[arr.count-1]];
        for (int i = 0; i < arr.count; i ++) {
            [self.dataArr addObject:arr[i]];
        }
        [self.dataArr addObject:arr[0]];
        self.pageLabel.text = [NSString stringWithFormat:@"%@/%d",@"1",(int)self.dataArr.count-2];
    }
    if (self.dataArr.count != 0) {
        self.topImage.hidden = YES;
        _pageLabel.hidden = NO;
        [self makeUI];
        if (self.dataArr.count > 1) {
            [self createTimer];
        }
    }else{
        self.topImage.hidden = NO;
        _pageControl.numberOfPages = 0;
        _pageLabel.hidden = YES;
        [self.topImage setImage:[UIImage imageNamed:@"index0.png"]];
    }
}

- (void)makeUI
{
    self.scrollView.contentSize = CGSizeMake(SJ_SCREEN_WIDTH*self.dataArr.count, _isHeight);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    _pageControl.numberOfPages = self.dataArr.count - 2;
    _pageControl.currentPage = 0;
    if (self.dataArr.count != 0) {
        for (int i = 0 ; i < self.dataArr.count; i ++) {
            UIImageView *oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*SJ_SCREEN_WIDTH, 0, SJ_SCREEN_WIDTH, _isHeight)];
            oneImageView.userInteractionEnabled = YES;
            self.scrollView.userInteractionEnabled = YES;
            // 请求网络图片时
            // 自IOS9后 需支持https
            // 1.在Info.plist中添加NSAppTransportSecurity类型Dictionary
            // 2.在NSAppTransportSecurity下添加NSAllowsArbitraryLoads类型Boolean,值设为YES
            [oneImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[i]] placeholderImage:[UIImage imageNamed:@"placeImage.gif"]];
            // 使用本地图片时
//            oneImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.dataArr[i]]];
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.tag = i;
            but.frame = CGRectMake(i*SJ_SCREEN_WIDTH, 0, SJ_SCREEN_WIDTH, _isHeight);
            [but addTarget:self.delegate action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:oneImageView];
            [self.scrollView addSubview:but];
        }
    }
}

#define make UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ((int)scrollView.contentOffset.x%(int)SJ_SCREEN_WIDTH == 0) {
        int page = (int)scrollView.contentOffset.x/(int)SJ_SCREEN_WIDTH;
        //        _pageControl.currentPage = page;
        if (page == 0) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - 2*(int)SJ_SCREEN_WIDTH, 0)];
        }
        if (page == self.dataArr.count-1) {
            [scrollView setContentOffset:CGPointMake((int)SJ_SCREEN_WIDTH, 0)];
        }
        if (page < self.dataArr.count - 2) {
            if (self.dataArr.count == 1 || self.dataArr.count == 0) {
                self.pageLabel.text = [NSString stringWithFormat:@"%@/%@",@"1",@"1"];
                _pageControl.currentPage = 0;
            }else{
                self.pageLabel.text = [NSString stringWithFormat:@"%d/%d",page+1,(int)self.dataArr.count-2];
                _pageControl.currentPage = page;
            }
        }else if (self.dataArr.count > 2){
            if (page == self.dataArr.count-2) {
                self.pageLabel.text = [NSString stringWithFormat:@"%@/%d",@"1",(int)self.dataArr.count-2];
                _pageControl.currentPage = 0;
            }else{
                self.pageLabel.text = [NSString stringWithFormat:@"%@/%d",@"2",(int)self.dataArr.count-2];
                _pageControl.currentPage = 1;
            }
        }else{
            self.pageLabel.text = [NSString stringWithFormat:@"%@/%@",@"1",@"1"];
            _pageControl.currentPage = 0;
        }
        _timeCount = page;
    }
}

// 创建定时器
- (void)createTimer
{
    _timeCount = 0;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
}
- (void)refresh
{
    _timeCount ++;
    
    if (_timeCount == self.dataArr.count -2 + 1) {
        
        _timeCount = 1;
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
        
    }
    
    [self.scrollView scrollRectToVisible:CGRectMake(_timeCount*(int)SJ_SCREEN_WIDTH, 0, SJ_SCREEN_WIDTH, self.isHeight) animated:YES];
    if (_timeCount < self.dataArr.count - 2) {
        self.pageLabel.text = [NSString stringWithFormat:@"%d/%d",_timeCount+1,(int)self.dataArr.count-2];
        _pageControl.currentPage = _timeCount;
    }else if (self.dataArr.count > 2){
        self.pageLabel.text = [NSString stringWithFormat:@"%@/%d",@"1",(int)self.dataArr.count-2];
        _pageControl.currentPage = 0;
    }else{
        self.pageLabel.text = [NSString stringWithFormat:@"%@/%@",@"1",@"1"];
        _pageControl.currentPage = 0;
    }
}
@end
