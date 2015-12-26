//
//  NYCarouselView.h
//  广告轮播CollectionView
//
//  Created by IOS on 15/12/26.
//  Copyright © 2015年 com.itcat.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYCarouselView : UICollectionView
/**
 *  启动时钟
 */
-(void)startTimer;
/**
 *  停止时钟
 */
-(void)updateTimer;

-(instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames;


@property (nonatomic, strong) NSArray *imageNames;

/**
 *  每个轮播图片的点击事件
 */
@property (nonatomic, copy) void(^cellDidSelectItemAtIndexPath)(UICollectionView *collection,NSIndexPath *indexPath);

@end
