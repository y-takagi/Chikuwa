//
//  YTImageModel.m
//  Chikuwa
//
//  Created by Yukiya Takagi on 2013/02/17.
//  Copyright (c) 2013年 Yukiya Takagi. All rights reserved.
//

#import "YTImageModel.h"
#import "YTApiEngine.h"

static NSString * const kProtocol = @"http";
static NSString * const kImageHost = @"img.tiqav.com";
#define kThumbnailFormat @"http://img.tiqav.com/%@.th.jpg"

static const CGFloat kImageWidth = 145.f;

@implementation YTImageModel

+ (void)search:(NSString *)query
  onCompletion:(ImageListResponseBlock)completionBlock
       onError:(MKNKResponseErrorBlock)errorBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:query forKey:@"q"];
    [[YTApiEngine sharedInstance] runWithMethod:@"GET"
                                        apiPath:@"search.json"
                                         params:params
                                   onCompletion:^(MKNetworkOperation *completedOperation) {
                                       completionBlock([YTImageModel parseResponse:completedOperation]);
                                   } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                                       errorBlock(completedOperation, error);
                                   }];
}

+ (void)newest:(ImageListResponseBlock)completionBlock
       onError:(MKNKResponseErrorBlock)errorBlock
{
    [[YTApiEngine sharedInstance] runWithMethod:@"GET"
                                        apiPath:@"search/newest.json"
                                         params:nil
                                   onCompletion:^(MKNetworkOperation *completedOperation) {
                                       completionBlock([YTImageModel parseResponse:completedOperation]);
                                   } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
                                   }];
}

+ (NSArray *)parseResponse:(MKNetworkOperation *)completedOperation
{
    NSData *responseData = [completedOperation responseData];
    NSError *error;
    NSArray *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
    NSMutableArray *images = [NSMutableArray array];
    for (NSDictionary *imageDict in result) {
        [images addObject:[[YTImageModel alloc] initWithDictionary:imageDict]];
    }
    return images;
}

- (id)initWithDictionary:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.imageId = [json objectForKey:@"id"];
        self.ext = [json objectForKey:@"ext"];
        self.height = [[json objectForKey:@"height"] intValue];
        self.width = [[json objectForKey:@"width"] intValue];
        self.sourceUrl = [json objectForKey:@"source_url"];
        self.customHeight = self.height * kImageWidth/self.width;
    }
    return self;
}

- (NSURL *)thumbnailUrl
{
    NSString *urlString = [NSString stringWithFormat:kThumbnailFormat, self.imageId];
    return [NSURL URLWithString:urlString];
}

@end
