//
//  YTCollectionViewCell.m
//  Chikuwa
//
//  Created by Yukiya Takagi on 2013/02/17.
//  Copyright (c) 2013年 Yukiya Takagi. All rights reserved.
//

#import "YTCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface YTCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@end

@implementation YTCollectionViewCell

- (void)awakeFromNib
{
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.layer.shadowOpacity = 0.7f;
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.cornerRadius = 4.f;
    self.imageView.layer.cornerRadius = 4.f;
    self.imageView.layer.masksToBounds = YES;
}

@end
