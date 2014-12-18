//
//  BaseNetworkServiceTest.m
//  MeileleNetworkSupport Example
//
//  Created by cailu on 14/12/18.
//  Copyright (c) 2014年 Meilele iOS Dev Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BaseNetworkService.h"

@interface BaseNetworkServiceTest : XCTestCase
@property (nonatomic, strong) BaseNetworkService *service;
@end

@implementation BaseNetworkServiceTest

- (void)setUp {
    [super setUp];
    self.service = [[BaseNetworkService alloc] init];
}

- (void)tearDown {
    [self.service cancelRequests];
    [super tearDown];
}

- (void)testGETWithURLString {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGETWithURLString"];
    [self.service GETWithURLString:@"http://www.meilele.com/mll_api/api/hd_img_api?goods_id=20363"
                        parameters:nil
                           success:^(id responseData) {
                               [expectation fulfill];
                           } failure:^(NSString *errorString) {
                               NSLog(@"%@",errorString);
                           }];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        // ...
    }];
}

- (void)testInterval {
    [self.service GETWithURLString:@"http://www.meilele.com/mll_api/api/hd_img_api?goods_id=20363" hitCache:^(BOOL isHit) {
        if (isHit) {
            NSLog(@"1 is hit cache!");
        } else {
            NSLog(@"1 is not hit cache!");
        }
    } interval:14 parameters:nil success:^(id responseData) {
        NSLog(@"1");
    } failure:nil];
    
    sleep(5);
    
    [self.service GETWithURLString:@"http://www.meilele.com/mll_api/api/hd_img_api?goods_id=20363" hitCache:^(BOOL isHit) {
        if (isHit) {
            NSLog(@"2 is hit cache!");
        } else {
            NSLog(@"2 is not hit cache!");
        }
    } interval:6 parameters:nil success:^(id responseData) {
        NSLog(@"2");
    } failure:nil];
    
    sleep(5);
    
    [self.service GETWithURLString:@"http://www.meilele.com/mll_api/api/hd_img_api?goods_id=20363" hitCache:^(BOOL isHit) {
        if (isHit) {
            NSLog(@"3 is hit cache!");
        } else {
            NSLog(@"3 is not hit cache!");
        }
    } interval:3 parameters:nil success:^(id responseData) {
        NSLog(@"3");
    } failure:nil];
    
    sleep(5);
    
    [self.service GETWithURLString:@"http://www.meilele.com/mll_api/api/hd_img_api?goods_id=20363" hitCache:^(BOOL isHit) {
        if (isHit) {
            NSLog(@"4 is hit cache!");
        } else {
            NSLog(@"4 is not hit cache!");
        }
    } interval:3 parameters:nil success:^(id responseData) {
        NSLog(@"4");
    } failure:nil];
}

//- (void)testRequestCall {
//    XCTestExpectation *expectation1 = [self expectationWithDescription:@"1"];
//    NSString *url = @"http://www.meilele.com/mll_api/api/new_goodsTariff?goods_id=21177";
//    [self.service GETWithURLString:url
//                         withCache:NO
//                        parameters:nil
//                           success:^(id responseData) {
//                               NSLog(@"success:1");
//                           } failure:^(NSString *errorString){
//                               [expectation1 fulfill];
//                           }];
//    
//    XCTestExpectation *expectation2 = [self expectationWithDescription:@"2"];
//    [self.service GETWithURLString:url
//                         withCache:NO
//                        parameters:nil
//                           success:^(id responseData) {
//                               NSLog(@"success:2");
//                           } failure:^(NSString *errorString){
//                               [expectation2 fulfill];
//                           }];
//    XCTestExpectation *expectation3 = [self expectationWithDescription:@"3"];
//    [self.service GETWithURLString:url
//                         withCache:NO
//                        parameters:nil
//                           success:^(id responseData) {
//                               NSLog(@"success:3");
//                           } failure:^(NSString *errorString){
//                               [expectation3 fulfill];
//                           }];
//    
//    XCTestExpectation *expectation4 = [self expectationWithDescription:@"4"];
//    [self.service GETWithURLString:url
//                         withCache:NO
//                        parameters:nil
//                           success:^(id responseData) {
//                               NSLog(@"success:4");
//                           } failure:^(NSString *errorString){
//                               [expectation4 fulfill];
//                           }];
//    [self.service cancelRequests];
//    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
//        // ...
//    }];
//}
@end
