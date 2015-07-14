//
//  CycleView.m
//  循环滚动
//
//  Created by wazrx on 15/7/14.
//  Copyright (c) 2015年 肖文. All rights reserved.
//

#import "CycleView.h"
@interface CycleView ()<UICollectionViewDataSource, UICollectionViewDelegate>
/**
 *  图片名数组
 */
@property (strong,nonatomic)NSArray *data;

@end

@implementation CycleView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data{
    self.data = data;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = frame.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"wazrx"];
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

- (void)setData:(NSArray *)data{
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:data];
    [temp addObject:temp[0]];
    _data = temp;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wazrx" forIndexPath:indexPath];
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:_data[indexPath.row]]]];
    view.frame = self.frame;
    cell.backgroundView = view;
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * (_data.count - 1), 0);
    }
    if (scrollView.contentOffset.x > scrollView.frame.size.width * (_data.count - 1)) {
        scrollView.contentOffset = CGPointZero;
    }
}

@end
