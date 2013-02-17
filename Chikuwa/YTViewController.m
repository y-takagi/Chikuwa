//
//  YTViewController.m
//  Chikuwa
//
//  Created by Yukiya Takagi on 2013/02/16.
//  Copyright (c) 2013年 Yukiya Takagi. All rights reserved.
//

#import "YTViewController.h"
#import "YTImageModel.h"
#import "YTCollectionViewCell.h"
#import "UICollectionViewWaterfallLayout.h"

@interface YTViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateWaterfallLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *images;
@end

@implementation YTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup UICollectionViewWaterfallLayout
	UICollectionViewWaterfallLayout *layout = (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
	layout.columnCount = 2;
	layout.itemWidth = self.view.bounds.size.width / 2;
	layout.delegate = self;
    
    [YTImageModel search:@"面倒"
            onCompletion:^(NSArray *images) {
                self.images = images;
                [self.collectionView reloadData];
            } onError:^(MKNetworkOperation *completedOperation, NSError *error) {                
            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter and Getter

- (NSArray *)images
{
    if (!_images) {
        _images = [NSArray array];
    }
    return _images;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YTCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView setImageWithURL:[[self.images objectAtIndex:indexPath.row] imageUrl]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                          }];
    return cell;
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

@end
