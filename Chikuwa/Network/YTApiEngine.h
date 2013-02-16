//
//  YTApiEngine.h
//  Chikuwa
//
//  Created by Yukiya Takagi on 2013/02/16.
//  Copyright (c) 2013年 Yukiya Takagi. All rights reserved.
//

@interface YTApiEngine : MKNetworkEngine

+ (YTApiEngine *)sharedInstance;

- (MKNetworkOperation *)runWithMethod:(NSString *)method
                              apiPath:(NSString *)path
                               params:(NSDictionary *)params
                         onCompletion:(MKNKResponseBlock)completionBlock
                              onError:(MKNKResponseErrorBlock)errorBlock;
@end
