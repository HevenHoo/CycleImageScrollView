//
//  CycleImageScrollView.h
//  CycleImageScrollView
//
//  Created by 胡海锋 on 2017/11/25.
//  Copyright © 2017年 feng. All rights reserved.
//

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#import <UIKit/UIKit.h>

typedef void(^CloseAction)(void);

@interface CycleImageScrollView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *singleTapGesture;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) UIScrollView *leftScrollView;
@property (strong, nonatomic) UIScrollView *centerScrollView;
@property (strong, nonatomic) UIScrollView *rightScrollView;

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *rightImageView;

@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableArray *imgList;

@property (copy, nonatomic) CloseAction closeAction;

- (void)setupDefaultImage;

@end
