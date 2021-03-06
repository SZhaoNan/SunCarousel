//
//  ViewController.m
//  SunCarousel
//
//  Created by 孙兆楠 on 16/7/18.
//  Copyright © 2016年 孙兆楠. All rights reserved.
//

#import "ViewController.h"
#import "SunCarousels.h"
#import "SunTableViewCell.h"

@interface ViewController ()
@property (nonatomic, strong) SunCarousels *SunCarousels;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray arrayWithObjects:@"http://cdn.zmqnw-images.zmqnw.com.cn/broadcast/2016/07/17/8764154704410a1147.jpg?width=1280&height=720", @"http://cdn.zmqnw-images.zmqnw.com.cn/broadcast/2016/07/17/2464155818442a1147.jpg?width=1280&height=720", @"http://cdn.zmqnw-images.zmqnw.com.cn/broadcast/2016/07/17/3064156771499a1147.jpg?width=1280&height=720", @"http://cdn.zmqnw-images.zmqnw.com.cn/broadcast/2016/07/17/5964157767480a1147.jpg?width=1280&height=720", nil];
//    _dataArr = [NSMutableArray arrayWithObjects:@"index0.png", @"index1.png", @"index2.png", nil];
    _SunCarousels = [[NSBundle mainBundle] loadNibNamed:@"SunCarousels" owner:self options:nil].lastObject;
    [_SunCarousels awakeScrollViewFromHeight:210 data:_dataArr];
    UINib *nib1 = [UINib nibWithNibName:@"SunTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"SunTableViewCell"];
    self.tableView.tableHeaderView = _SunCarousels;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SunTableViewCell"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SJ_SCREEN_HEIGHT-1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
