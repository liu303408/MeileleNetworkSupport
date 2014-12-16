//
//  BaseNetworkService.h
//  MLLNetWorkService
//
//  Created by chester on 7/31/14.
//  Copyright (c) 2014 Meilele iOS Dev Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "MeileleHttpRequestSerializer.h"
#import "MeileleJSONResponseSerializer.h"

// default open cache
#define Open_Request_Cache 1

/**
 *  Base networking frame work
 */
@interface BaseNetworkService : NSObject

@property (nonatomic,readonly) AFHTTPRequestOperationManager *operationManager;

/**
 *  Get Method--with cache
 *
 *  @param urlString  url request string
 *  @param parameters parameters with dictionary type
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)GETWithURLString:(NSString *)urlString
              parameters:(NSDictionary *)parameters
                 success:(void (^)(id responseData))success
                 failure:(void (^)(NSString *errorString))failure;

- (void)GETWithURLString:(NSString *)urlString
              parameters:(NSDictionary *)parameters
                hitCache:(void (^)(BOOL isHit))hitCache
                 success:(void (^)(id responseData))success
                 failure:(void (^)(NSString *errorString))failure;
/**
 *  Get Method -can close cache
 *
 *  @param urlString  url request string
 *  @param useCache   cache flag
 *  @param parameters parameters with dictionary type
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)GETWithURLString:(NSString *)urlString
               withCache:(BOOL)useCache
              parameters:(NSDictionary *)parameters
                 success:(void (^)(id responseData))success
                 failure:(void (^)(NSString *errorString))failure;


/**
 *  Get Method -can refresh cache
 *
 *  @param urlString      url request string
 *  @param beRefreshCache refresh cache
    if yes, the old cache will be cleaned and the new response will be cached
    if no, the old cache will be reserved and the request will be the one time request
           and it'll not replace the old cache
 *  @param parameters     parameters with dictionary type
 *  @param success        success block
 *  @param failure        failure block
 */
- (void)GETWithURLString:(NSString *)urlString
        withRefreshCache:(BOOL)beRefreshCache
              parameters:(NSDictionary *)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSString *))failure;

/**
 *  Post Method
 *
 *  @param urlString  url request string
 *  @param parameters parameters with dictionary type
 *  @param success    success block
 *  @param failure    failure block
 */
- (void)POSTWithURLString:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseData))success
                  failure:(void (^)(NSString *errorString))failure;

/**
 *  cancel network requests
 */
- (void)cancelRequests;
@end
