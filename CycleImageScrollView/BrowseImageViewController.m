//
//  BrowseImageViewController.m
//  CycleImageScrollView
//
//  Created by 胡海锋 on 2017/11/25.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "BrowseImageViewController.h"
#import "CycleImageScrollView.h"
#import "Masonry.h"

@interface BrowseImageViewController ()

@property (strong, nonatomic) CycleImageScrollView *imageScrollView;

@end

@implementation BrowseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    NSArray *imgsArray =
  @[@"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472343610.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472356646.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472360269.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472416256.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472451825.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472484937.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472473956.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472441979.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472456963.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472455850.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472486364.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472461894.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472557952.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472557011.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472572199.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472551613.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472514304.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472570460.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472598593.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472585861.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472523970.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472643863.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472619156.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472683536.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472682920.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472697238.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472648801.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472668736.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472674904.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472676114.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472734142.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510472771263.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510473253000.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510473271394.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510473292538.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510473243804.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510473285787.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510473235567.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510473215865.jpg",
    @"https://stoneread.fengimg.com/uploadimg/news/2017/11/25/2017112510473278037.jpg"];
    
    [self setupSubviews];
    
//    NSMutableArray *imgs = [NSMutableArray array];
//    for (int i = 0; i < 11; i++) {
//        [imgs addObject:[NSString stringWithFormat:@"IMG_%d.jpg", i+1]];
//    }
    
    _imageScrollView.imgList = [NSMutableArray arrayWithArray:imgsArray];
    
    [_imageScrollView setupDefaultImage];
    
    __weak typeof(self)weakSelf = self;
    _imageScrollView.closeAction = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupSubviews {
    [self.view addSubview:self.imageScrollView];
    
    [_imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CycleImageScrollView *)imageScrollView {
    if (!_imageScrollView) {
        _imageScrollView = [[CycleImageScrollView alloc] init];
    }
    
    return _imageScrollView;
}

@end
