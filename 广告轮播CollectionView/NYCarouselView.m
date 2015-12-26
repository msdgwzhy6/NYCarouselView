//
//  NYCarouselView.m
//  广告轮播CollectionView
//
//  Created by IOS on 15/12/26.
//  Copyright © 2015年 com.itcat.com. All rights reserved.
//

#import "NYCarouselView.h"

@interface NYCarouselView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UIPageControl *carouselPageControl;

@property (nonatomic, strong) NSTimer *timer;

@end
@implementation NYCarouselView

static NSString * const carouselID = @"NYCarouselView";


-(instancetype)initWithFrame:(CGRect)frame
{
    
    
    UICollectionViewFlowLayout *carouseLayout = [[UICollectionViewFlowLayout alloc]init];
    
    carouseLayout.itemSize = frame.size;// 设置cell的尺寸
   
    carouseLayout.minimumLineSpacing = 0;// 清空行距
    
    carouseLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;// 设置滚动的方向

    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:carouselID];

    self.dataSource = self;
    self.delegate = self;
    

    [self startTimer];
    
    return [super initWithFrame:frame collectionViewLayout:carouseLayout];
    
}

-(instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames
{
    
    self.imageNames = imageNames;
    [self scrollViewDidScroll:self];
    return [self initWithFrame:frame];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bounces = NO;//去掉弹簧效果
    self.showsHorizontalScrollIndicator = NO;//去掉水平显示的拖拽线
    self.pagingEnabled = YES;//分页效果
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageNames.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:carouselID forIndexPath:indexPath];

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.imageNames[indexPath.row]]];
    cell.backgroundView = imageView;
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellDidSelectItemAtIndexPath(collectionView,indexPath);
}


#pragma mark - 分页
//分页控件的监听方法
-(void)pageChanged:(UIPageControl *)page
{
    [self.timer invalidate];
    //根据页数，调整滚动视图中得图片位置contentOffset
    CGFloat x = page.currentPage * self.bounds.size.width;
    [self setContentOffset:CGPointMake(x, 0) animated:YES];
    [self startTimer];
}

#pragma mark - 时钟
/**启动时钟*/
-(void)startTimer
{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    //添加运行循环
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

-(void)updateTimer
{
    //页号发生变化
    //（当前页数 + 1） % 总页数
    NSUInteger count = self.imageNames.count;
    if (count == 0) {
        NSLog(@"图片个数是0");
        return;
    }
    int page = (self.carouselPageControl.currentPage+1) % (int)count;
    self.carouselPageControl.currentPage = page;
    //调用监听方法。让滚动视图滚动
    [self pageChanged:self.carouselPageControl];
}

/**
 抓住图片时，停止时钟，松手后，开启时钟
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止时钟，停止后就不能在使用，如果要启用时钟，需要重新实例化
    [self.timer invalidate];
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    //启动时钟
    [self startTimer];
    
}

#pragma mark - UIScrollView代理
// 只要一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(scrollView.);
    // 获取当前的偏移量，计算当前第几页
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    // 设置页数
    self.carouselPageControl.currentPage = page;
    
}


#pragma mark - 懒加载
-(UIPageControl *)carouselPageControl
{
    if (_carouselPageControl == nil) {
        
        UIPageControl * carouselPageControl = [[UIPageControl alloc]init];
        
        //总页数
        carouselPageControl.numberOfPages = self.imageNames.count;
        //控件尺寸
        CGSize size = [_carouselPageControl sizeForNumberOfPages:self.imageNames.count];
        
        carouselPageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        //pageControl的位置
        carouselPageControl.center = CGPointMake(self.center.x, self.bounds.size.height * 0.85);
        
        //设置颜色
        carouselPageControl.pageIndicatorTintColor = [UIColor redColor];
        
        carouselPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        
        //添加监听方法
        [carouselPageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        [self.window addSubview:carouselPageControl];
        _carouselPageControl = carouselPageControl;
    }
    return _carouselPageControl;
}
-(NSArray *)imageNames{
    if (_imageNames == nil) {
        _imageNames = [NSArray array];
    }
    return _imageNames;
}


@end
