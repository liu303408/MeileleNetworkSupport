//
//  ViewController.m
//  MeileleNetworkSupport Example
//
//  Created by cailu on 14/11/12.
//  Copyright (c) 2014年 Meilele iOS Dev Team. All rights reserved.
//

#import "ViewController.h"
#import "BaseNetworkService.h"
#import "MeileleCustomURLCache.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BaseNetworkService *service = [[BaseNetworkService alloc] init];
    [service GETWithURLString:@"http://www.meilele.com/mll_api/api/hd_img_api?goods_id=20363" hitCache:^(BOOL isHit) {
        if (isHit) {
            NSLog(@"1 is hit cache!");
        } else {
            NSLog(@"1 is not hit cache!");
        }
    } interval:14 parameters:nil success:^(id responseData) {
        NSLog(@"1");
    } failure:nil];
    
    sleep(5);
    
    [service GETWithURLString:@"http://www.meilele.com/mll_api/api/hd_img_api?goods_id=20363" hitCache:^(BOOL isHit) {
        if (isHit) {
            NSLog(@"2 is hit cache!");
        } else {
            NSLog(@"2 is not hit cache!");
        }
    } interval:6 parameters:nil success:^(id responseData) {
        NSLog(@"2");
    } failure:nil];
    
    sleep(5);
    
    [service GETWithURLString:@"http://www.meilele.com/mll_api/api/hd_img_api?goods_id=20363" hitCache:^(BOOL isHit) {
        if (isHit) {
            NSLog(@"3 is hit cache!");
        } else {
            NSLog(@"3 is not hit cache!");
        }
    } interval:3 parameters:nil success:^(id responseData) {
        NSLog(@"3");
    } failure:nil];
    
    sleep(5);
    
    [service GETWithURLString:@"http://www.meilele.com/mll_api/api/hd_img_api?goods_id=20363" hitCache:^(BOOL isHit) {
        if (isHit) {
            NSLog(@"4 is hit cache!");
        } else {
            NSLog(@"4 is not hit cache!");
        }
    } interval:3 parameters:nil success:^(id responseData) {
        NSLog(@"4");
    } failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
