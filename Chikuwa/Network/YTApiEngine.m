//
//  YTApiEngine.m
//  Chikuwa
//
//  Created by Yukiya Takagi on 2013/02/16.
//  Copyright (c) 2013年 Yukiya Takagi. All rights reserved.
//

#import "YTApiEngine.h"

#define kHostName @"api.tiqav.com"

@implementation YTApiEngine

+ (YTApiEngine *)sharedInstance
{
    static dispatch_once_t s_singletonPredicate;
    static YTApiEngine *s_singleton = nil;
    dispatch_once(&s_singletonPredicate, ^{
        s_singleton = [[YTApiEngine alloc] initWithHostName:kHostName];
    });
    return s_singleton;
}

- (MKNetworkOperation *)runWithMethod:(NSString *)method
                              apiPath:(NSString *)path
                               params:(NSDictionary *)params
                         onCompletion:(MKNKResponseBlock)completionBlock
                              onError:(MKNKResponseErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:params
                                          httpMethod:method];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        completionBlock(completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(completedOperation, error);
    }];
    [self enqueueOperation:op];
    return op;
}

@end
