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

static const CGFloat kThumbnailMargin = 14.f;
static const CGFloat kItemWidth = kThumbnailWidth + kThumbnailMargin;

@interface YTViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateWaterfallLayout, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *imageSearchBar;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSMutableDictionary *cacheImage;
@end

@implementation YTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup UICollectionViewWaterfallLayout
	UICollectionViewWaterfallLayout *layout = (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
	layout.columnCount = 2;
	layout.itemWidth = kItemWidth;
    layout.sectionInset = UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
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

- (NSMutableDictionary *)cacheImage
{
    if (!_cacheImage) {
        _cacheImage = [NSMutableDictionary dictionary];
    }
    return _cacheImage;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YTCollectionViewCell" forIndexPath:indexPath];
    YTImageModel *imageModel = self.images[indexPath.row];

    if ([self.cacheImage objectForKey:imageModel.imageId]) {
        [cell.imageView setImage:[self.cacheImage objectForKey:imageModel.imageId]];
    } else {
        cell.indicator.center = CGPointMake(kItemWidth/2, (imageModel.thumbnailSize.height + kThumbnailMargin)/2);
        [cell.indicator startAnimating];
        DECLARE_WEAK(cell);
        [cell.imageView setImageWithURL:[self.images[indexPath.row] thumbnailUrl]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                options:SDWebImageCacheMemoryOnly
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                  [w_cell.indicator stopAnimating];
                                  [self.cacheImage setObject:image forKey:imageModel.imageId];
                              }
         ];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YTImageModel *image = self.images[indexPath.row];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setValue:image.originalUrl forPasteboardType:@"public.url"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud setDetailsLabelText:@"選択した画像のURLをコピーしました。"];
    [hud hide:YES afterDelay:1.f];
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
    [self.cacheImage removeAllObjects];
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
