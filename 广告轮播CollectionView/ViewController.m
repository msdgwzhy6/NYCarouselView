//
//  ViewController.m
//  广告轮播CollectionView
//
//  Created by IOS on 15/12/26.
//  Copyright © 2015年 com.itcat.com. All rights reserved.
//

#import "ViewController.h"
#define NYScreenWidth [UIScreen mainScreen].bounds.size.width
#import "NYCarouselView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray *ma = [NSMutableArray array];
    for (int i = 1; i<5; i++) {
        NSString *imageName = [NSString stringWithFormat:@"banner%d",i];
        [ma addObject:imageName];
        
    }

    NYCarouselView *carouselView = [[NYCarouselView alloc]initWithFrame:CGRectMake(0, 0, NYScreenWidth, 190)imageNames:ma];
//    [carouselView startTimer];//开启时钟自动轮播
    [self.view addSubview:carouselView];
    
    //给轮播图增加点击事件
    carouselView.cellDidSelectItemAtIndexPath = ^(UICollectionView *collection,NSIndexPath *indexPath) {
        NSLog(@"indexPath === %ld", indexPath.row);
    };

}



@end