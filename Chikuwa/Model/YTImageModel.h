//
//  YTImageModel.h
//  Chikuwa
//
//  Created by Yukiya Takagi on 2013/02/17.
//  Copyright (c) 2013年 Yukiya Takagi. All rights reserved.
//

typedef void (^ImageListResponseBlock)(NSArray *images);

@interface YTImageModel : NSObject
@property (copy, nonatomic) NSString *imageId;
@property (copy, nonatomic) NSString *ext;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger width;
@property (copy, nonatomic) NSString *sourceUrl;

- (id)initWithDictionary:(NSDictionary *)json;
+ (void)search:(NSString *)query
  onCompletion:(ImageListResponseBlock)completionBlock
       onError:(MKNKResponseErrorBlock)errorBlock;
@end
