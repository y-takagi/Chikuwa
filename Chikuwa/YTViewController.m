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

@interface YTViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateWaterfallLayout, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *imageSearchBar;
@property (strong, nonatomic) NSArray *images;
@end

@implementation YTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup UICollectionViewWaterfallLayout
	UICollectionViewWaterfallLayout *layout = (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
	layout.columnCount = 2;
	layout.itemWidth = self.view.bounds.size.width / 2 - 15;
    layout.sectionInset = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
	layout.delegate = self;

    [YTImageModel newest:^(NSArray *images) {
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

    [cell.imageView setImageWithURL:[self.images[indexPath.row] thumbnailUrl]
                   placeholderImage:nil
                            options:SDWebImageCacheMemoryOnly
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                          }];
    return cell;
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return ((YTImageModel *)self.images[indexPath.row]).customHeight;
}

#pragma mark - UISerarchBar methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.imageSearchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.imageSearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.imageSearchBar resignFirstResponder];
    [self.imageSearchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.imageSearchBar resignFirstResponder];
    [YTImageModel search:searchBar.text
            onCompletion:^(NSArray *images) {
                self.images = images;
                [self.collectionView reloadData];
            } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
            }];
}

@end
