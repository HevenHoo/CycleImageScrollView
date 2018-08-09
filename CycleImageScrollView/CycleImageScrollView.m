//
//  CycleImageScrollView.m
//  CycleImageScrollView
//
//  Created by 胡海锋 on 2017/11/25.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "CycleImageScrollView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "Masonry.h"

@implementation CycleImageScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:_singleTapGesture];

    UISwipeGestureRecognizer *swipeGestureUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGestureUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:swipeGestureUp];
    
    UISwipeGestureRecognizer *swipeGestureDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGestureDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:swipeGestureDown];
    
    [self addSubview:self.scrollView];
    
    _leftScrollView = [self createScrollView:1];
    _centerScrollView = [self createScrollView:2];
    _rightScrollView = [self createScrollView:3];
    
    [_scrollView addSubview:_leftScrollView];
    [_scrollView addSubview:_centerScrollView];
    [_scrollView addSubview:_rightScrollView];
    
    [_leftScrollView addSubview:self.leftImageView];
    [_centerScrollView addSubview:self.centerImageView];
    [_rightScrollView addSubview:self.rightImageView];
    
    [self addSubview:self.pageControl];

    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_leftScrollView);
        make.size.mas_equalTo(_leftScrollView);
    }];
    
    [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_centerScrollView);
        make.size.mas_equalTo(_centerScrollView);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_rightScrollView);
        make.size.mas_equalTo(_rightScrollView);
    }];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-5);
    }];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    if (self.closeAction) {
        self.closeAction();
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp || recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
//        if (self.closeAction) {
//            self.closeAction();
//        }
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
    CGFloat zs = _centerScrollView.zoomScale;
    zs = (zs == 1.0) ? 2.0:1.0;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _centerScrollView.zoomScale = zs;
    [UIView commitAnimations];
}

- (void)setupDefaultImage {
    NSInteger imgCount = [self.imgList count];
    if (imgCount >= 2) {
        self.scrollView.scrollEnabled = YES;
        [self.scrollView setContentSize:CGSizeMake(3 * SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        [self.pageControl setNumberOfPages:imgCount];
        
        NSInteger leftImageIndex = imgCount-1;
        _currentIndex = 0;
        NSInteger rightImageIndex = 1;
        
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[_imgList objectAtIndex:_currentIndex]]];
        
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[_imgList objectAtIndex:leftImageIndex]]];
        
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imgList objectAtIndex:rightImageIndex]]];
        
    } else if (imgCount == 1) {
        [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.pageControl setNumberOfPages:0];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:[self.imgList objectAtIndex:0]]];
    }

    self.currentIndex = 0;
    self.pageControl.currentPage = 0;
}

#pragma mark - ScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 0) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scroll...");
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag != 0) {
        return _centerImageView;
    } else {
        return nil;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.tag != 0) {
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
        (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
        (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        _centerImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
    }
}

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.tag == 0 ) {
        //重新加载图片
        [self reloadImage];
        //移动到中间
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        //设置分页
        _pageControl.currentPage=_currentIndex;
    }
}


#pragma mark 重新加载图片
-(void)reloadImage{
    NSInteger leftImageIndex, rightImageIndex;
    CGPoint offset = _scrollView.contentOffset;
    if (offset.x > SCREEN_WIDTH) { //向右滑动
        _currentIndex = (_currentIndex+1) % _imgList.count;
    }else if(offset.x < SCREEN_WIDTH){ //向左滑动
        _currentIndex = (_currentIndex+_imgList.count-1) % _imgList.count;
    }
    
    //重新设置左右图片
    leftImageIndex=(_currentIndex+_imgList.count-1) % _imgList.count;
    rightImageIndex=(_currentIndex+1) % _imgList.count;
    
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[_imgList objectAtIndex:_currentIndex]]];

    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[_imgList objectAtIndex:leftImageIndex]]];

    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imgList objectAtIndex:rightImageIndex]]];
}

- (CGRect)getImageViewRectWithSize:(CGSize)size {
    CGRect rect = self.scrollView.frame;
    CGRect imageViewRect = CGRectZero;
    CGFloat imageWidth = rect.size.width;
    CGFloat imageHeight = imageWidth * size.height / size.width;
    if (imageHeight > rect.size.height) {
        imageHeight = rect.size.height;
        imageWidth = imageHeight * size.width / size.height;
        imageViewRect = CGRectMake((rect.size.width-imageWidth)/2, 0, imageWidth, imageHeight);
    } else {
        imageViewRect = CGRectMake(0, (rect.size.height-imageHeight)/2, imageWidth, imageHeight);
    }
    
    return imageViewRect;
}

- (IBAction)saveImageToAlbum:(id)sender {
    [self saveImageToPhotos:_centerImageView.image];
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSLog(@"error = %@", error);
    
    NSString *msg = nil ;
    if(error){
        msg = @"保存失败";
    }else{
        msg = @"已保存到相册";
    }
    MBProgressHUD *statusHUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    statusHUD.dimBackground = NO;
    statusHUD.customView = [[UIView alloc] init];
    statusHUD.mode = MBProgressHUDModeCustomView;
    statusHUD.labelText = msg;
    [statusHUD hide:YES afterDelay:1.0];
}

- (UIScrollView *)createScrollView:(NSInteger)tag {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake((tag-1)*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.delegate = self;
    scrollView.tag = tag;
    scrollView.maximumZoomScale = 5.0;
    scrollView.minimumZoomScale = 1;
    UITapGestureRecognizer *doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleRecognizer.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleRecognizer];
    [_singleTapGesture requireGestureRecognizerToFail:doubleRecognizer];
    return scrollView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView {
    if(!_centerImageView) {
        _centerImageView = [[UIImageView alloc] init];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _centerImageView;
}

- (UIImageView *)rightImageView {
    if(!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _rightImageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
    }
    return _pageControl;
}

@end
