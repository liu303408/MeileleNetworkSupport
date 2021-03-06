//
//  BaseNetworkService.m
//  MLLNetWorkService
//
//  Created by chester on 7/31/14.
//  Copyright (c) 2014 Meilele iOS Dev Team. All rights reserved.
//

#import "BaseNetworkService.h"
#import "MeileleCustomURLCache.h"

@interface BaseNetworkService ()

@property (nonatomic) AFHTTPRequestOperationManager *operationManager;
@property (nonatomic) AFHTTPSessionManager *sessoinManager;
@end

@implementation BaseNetworkService

- (instancetype)init {
    self = [super init];
    
    if (self) {
        MeileleJSONResponseSerializer *jsonResponseSerializer = [MeileleJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        MeileleHttpRequestSerializer *httpRequestSerializer = [MeileleHttpRequestSerializer serializer];
        
        _operationManager = [AFHTTPRequestOperationManager manager];
        [_operationManager setRequestSerializer:httpRequestSerializer];
        [_operationManager setResponseSerializer:jsonResponseSerializer];
    }
    return self;
}

#pragma mark - Get Method
/**
 *  Get Method with cache by default
 */
- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure {
#if Open_Request_Cache
    _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
#endif
    return [self GET:urlString
          parameters:parameters
            hitCache:nil
            interval:CustomURLCacheExpirationInterval
             success:success
             failure:failure];
}

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                          hitCache:(void (^)(BOOL isHit))hitCache
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure {
    return [self GETWithURLString:urlString
                         hitCache:hitCache
                         interval:CustomURLCacheExpirationInterval
                       parameters:parameters
                          success:success
                          failure:failure];
}

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                          hitCache:(void (^)(BOOL isHit))hitCache
                          interval:(NSTimeInterval)expirationInterval
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure {
#if Open_Request_Cache
    _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
#endif
    return [self GET:urlString
          parameters:parameters
            hitCache:hitCache
            interval:expirationInterval
             success:success
             failure:failure];
}

/**
 *  Get Method -can close cache
 *
 *  @param urlString  url request string
 *  @param useCache   cache flag
 *  @param parameters parameters with dictionary type
 *  @param success    success block
 *  @param failure    failure block
 */
- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                         withCache:(BOOL)useCache
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure {
    return [self GETWithURLString:urlString
                        withCache:useCache
                         interval:CustomURLCacheExpirationInterval
                       parameters:parameters
                          success:success
                          failure:failure];
}

- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                         withCache:(BOOL)useCache
                          interval:(NSTimeInterval)expirationInterval
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString *errorString))failure {
    if (useCache) {
        _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    } else {
        _operationManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    
    return [self GET:urlString
          parameters:parameters
            hitCache:nil
            interval:expirationInterval
             success:success
             failure:failure];
}

/**
 *  Get Method -can refresh cache
 *
 *  @param urlString      url request string
 *  @param beRefreshCache refresh cache
 *  @param parameters     parameters with dictionary type
 *  @param success        success block
 *  @param failure        failure block
 */
- (NSURLRequest *)GETWithURLString:(NSString *)urlString
                  withRefreshCache:(BOOL)beRefreshCache
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id))success
                           failure:(void (^)(NSString *))failure {
    if (!beRefreshCache) {
        //如果不refresh，这里就是一次性请求的，且不会冲cache
        return [self GETWithURLString:urlString withCache:NO parameters:parameters success:success failure:failure];
    } else {
        // refresh，清理之前的cache，然后做请求，并缓存到cache中
        [self clearCache:urlString parameters:parameters];
        // request
        return [self GETWithURLString:urlString parameters:parameters success:success failure:failure];
    }
}

/**
 *  重写GET方法，处理304返回
 *
 *  @param urlString
 *  @param parameters
 *  @param success
 *  @param failure
 */
- (NSURLRequest *)GET:(NSString *)urlString
           parameters:(NSDictionary *)parameters
             hitCache:(void (^)(BOOL isHit))hitCache
             interval:(NSTimeInterval)expirationInterval
              success:(void (^)(id responseData))success
              failure:(void (^)(NSString *errorString))failure {
    BOOL __block responseFromCache = YES;
    void (^successWrapper)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    };
    
    void (^requestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        if (failure) {
            if ([error.userInfo objectForKey:NSLocalizedDescriptionKey]) {
                failure([error.userInfo objectForKey:NSLocalizedDescriptionKey]);
            } else if ([error.userInfo objectForKey:@"NSDebugDescription"]) {
                failure([error.userInfo objectForKey:@"NSDebugDescription"]);
            }
        }
    };
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:parameters
                                                     error:nil];
    [MeileleCustomURLCache setExpirationInterval:request interval:expirationInterval];
    
    if (hitCache) {
        hitCache([[MeileleCustomURLCache shareMeileleURLCache] isHit:request]);
    }
    AFHTTPRequestOperation *operation = [_operationManager HTTPRequestOperationWithRequest:request success:successWrapper failure:requestFailureBlock];
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        responseFromCache = NO;
        return cachedResponse;
    }];
    [_operationManager.operationQueue addOperation:operation];
    return operation.request;
}

#pragma mark - Post Method
/**
 *  Post Method
 */
- (void)POSTWithURLString:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseData))success
                  failure:(void (^)(NSString *errorString))failure {
    [_operationManager POST:urlString
                 parameters:parameters
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        success(responseObject);
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        if (failure && error) {
                            if ([error.userInfo objectForKey:NSLocalizedDescriptionKey]) {
                                failure([error.userInfo objectForKey:NSLocalizedDescriptionKey]);
                            } else if([error.userInfo objectForKey:@"NSDebugDescription"]){
                                failure([error.userInfo objectForKey:@"NSDebugDescription"]);
                            }
                        }
                    }];
}

/**
 *  cancel requests
 */
- (void)cancelRequests {
    [_operationManager.operationQueue cancelAllOperations];
}

#pragma mark - private method
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error {
    return [_operationManager.requestSerializer requestWithMethod:method
                                                        URLString:[[NSURL URLWithString:URLString
                                                                          relativeToURL:_operationManager.baseURL] absoluteString]
                                                       parameters:parameters
                                                            error:error];
}

- (void)clearCache:(NSString *)urlString parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:parameters
                                                     error:nil];
    [[MeileleCustomURLCache shareMeileleURLCache] removeCachedResponseForRequest:request];
}
@end
