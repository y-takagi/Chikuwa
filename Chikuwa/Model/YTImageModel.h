//
//  YTImageModel.h
//  Chikuwa
//
//  Created by Yukiya Takagi on 2013/02/17.
//  Copyright (c) 2013年 Yukiya Takagi. All rights reserved.
//

typedef void (^ImageListResponseBlock)(NSArray *images);

@interface YTImageModel : NSObject

@property (copy, nonatomic)   NSString *imageId;
@property (copy, nonatomic)   NSString *ext;
@property (copy, nonatomic)   NSString *sourceUrl;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) CGFloat customHeight;

+ (void)search:(NSString *)query
  onCompletion:(ImageListResponseBlock)completionBlock
       onError:(MKNKResponseErrorBlock)errorBlock;

+ (void)newest:(ImageListResponseBlock)completionBlock
       onError:(MKNKResponseErrorBlock)errorBlock;

- (id)initWithDictionary:(NSDictionary *)json;

- (NSURL *)thumbnailUrl;

@end
