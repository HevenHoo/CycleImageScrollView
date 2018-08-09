//
//  ViewController.m
//  CycleImageScrollView
//
//  Created by 胡海锋 on 2017/11/25.
//  Copyright © 2017年 feng. All rights reserved.
//

#import "ViewController.h"
#import "BrowseImageViewController.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)browseImage:(id)sender {
    BrowseImageViewController *browse = [[BrowseImageViewController alloc] init];
    [self presentViewController:browse animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
