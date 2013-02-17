//
//  YTImageModel.h
//  Chikuwa
//
//  Created by Yukiya Takagi on 2013/02/17.
//  Copyright (c) 2013年 Yukiya Takagi. All rights reserved.
//

typedef void (^ImageListResponseBlock)(NSArray *images);

static const CGFloat kThumbnailWidth = 142.f;

@interface YTImageModel : NSObject

@property (copy, nonatomic)     NSString *imageId;
@property (copy, nonatomic)     NSString *ext;
@property (copy, nonatomic)     NSString *sourceUrl;
@property (assign, nonatomic)   NSInteger height;
@property (assign, nonatomic)   NSInteger width;
@property (readonly, nonatomic) CGSize thumbnailSize;
@property (readonly, nonatomic) NSURL *thumbnailUrl;

+ (void)search:(NSString *)query
  onCompletion:(ImageListResponseBlock)completionBlock
       onError:(MKNKResponseErrorBlock)errorBlock;

+ (void)newest:(ImageListResponseBlock)completionBlock
       onError:(MKNKResponseErrorBlock)errorBlock;

- (id)initWithDictionary:(NSDictionary *)json;

@end
