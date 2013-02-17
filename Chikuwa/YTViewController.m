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
#import "MBProgressHUD.h"

static const CGFloat kThumbnailMargin = 10.f;
static const CGFloat kItemWidth = kThumbnailWidth + kThumbnailMargin;

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
	layout.itemWidth = kItemWidth;
    layout.sectionInset = UIEdgeInsetsMake(6.f, 6.f, 6.f, 6.f);
	layout.delegate = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YTImageModel newest:^(NSArray *images) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    YTImageModel *image = self.images[indexPath.row];
    cell.indicator.center = CGPointMake(kItemWidth/2, (image.thumbnailSize.height + kThumbnailMargin)/2);
    [cell.indicator startAnimating];
    DECLARE_WEAK(cell);
    [cell.imageView setImageWithURL:[self.images[indexPath.row] thumbnailUrl]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                            options:SDWebImageCacheMemoryOnly
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              [w_cell.indicator stopAnimating];
                          }];
    return cell;
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return ((YTImageModel *)self.images[indexPath.row]).thumbnailSize.height + kThumbnailMargin;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YTImageModel search:searchBar.text
            onCompletion:^(NSArray *images) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.imageSearchBar.prompt = @"検索結果";
                self.images = images;
                [self.collectionView reloadData];
                [self.collectionView setContentOffset:CGPointMake(0.f, 0.f) animated:NO];
            } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
            }];
}

@end
