//
//  YTViewController.m
//  Chikuwa
//
//  Created by Yukiya Takagi on 2013/02/16.
//  Copyright (c) 2013年 Yukiya Takagi. All rights reserved.
//

#import "YTViewController.h"
#import "YTImageModel.h"

@interface YTViewController ()

@end

@implementation YTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [YTImageModel search:@"hoge"
            onCompletion:^(NSArray *images) {
                for (YTImageModel *image in images) {
                    NSLog(@"%@", image.imageId);
                }
            } onError:^(MKNetworkOperation *completedOperation, NSError *error) {

            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
