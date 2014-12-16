//
//  BaseNetworkService.m
//  MLLNetWorkService
//
//  Created by chester on 7/31/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "BaseNetworkService.h"
#import "MeileleCustomURLCache.h"

@interface BaseNetworkService ()

@property (nonatomic) AFHTTPRequestOperationManager *operationManager;
@property (nonatomic) AFHTTPSessionManager *sessoinManager;
@end

@implementation BaseNetworkService


-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
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
- (void)GETWithURLString:(NSString *)urlString
              parameters:(NSDictionary *)parameters
                 success:(void (^)(id responseData))success
                 failure:(void (^)(NSString *errorString))failure
{
#if Open_Request_Cache
    _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
#endif
    [self GET:urlString parameters:parameters hitCache:nil success:success failure:failure];
}

- (void)GETWithURLString:(NSString *)urlString
              parameters:(NSDictionary *)parameters
                hitCache:(void (^)(BOOL isHit))hitCache
                 success:(void (^)(id responseData))success
                 failure:(void (^)(NSString *errorString))failure
{
    {
#if Open_Request_Cache
        _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
#endif
        [self GET:urlString parameters:parameters hitCache:hitCache success:success failure:failure];
    }
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
- (void)GETWithURLString:(NSString *)urlString
               withCache:(BOOL)useCache
              parameters:(NSDictionary *)parameters
                 success:(void (^)(id responseData))success
                 failure:(void (^)(NSString *errorString))failure
{
    if (useCache) {
        _operationManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    } else {
        _operationManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    [self GET:urlString parameters:parameters hitCache:nil success:success failure:failure];
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
-(void)GETWithURLString:(NSString *)urlString
       withRefreshCache:(BOOL)beRefreshCache
             parameters:(NSDictionary *)parameters
                success:(void (^)(id))success
                failure:(void (^)(NSString *))failure
{
    if (!beRefreshCache) {
        //如果不refresh，这里就是一次性请求的，且不会冲cache
        [self GETWithURLString:urlString withCache:NO parameters:parameters success:success failure:failure];
    } else {
        // refresh，清理之前的cache，然后做请求，并缓存到cache中
        [self clearCache:urlString parameters:parameters];
        // request
        [self GETWithURLString:urlString parameters:parameters success:success failure:failure];
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
- (void)GET:(NSString *)urlString
 parameters:(NSDictionary *)parameters
   hitCache:(void (^)(BOOL isHit))hitCache
    success:(void (^)(id responseData))success
    failure:(void (^)(NSString *errorString))failure
{
    BOOL __block responseFromCache = YES;
    void (^successWrapper)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef DebugHttpLog
        if (responseFromCache) {
            NSLog(@"RESPONSE FROM CACHE: %@", operation.request.URL.absoluteString);
        } else {
            NSLog(@"RESPONSE: %@", operation.request.URL.absoluteString);
        }
#endif
        success(responseObject);
    };
    
    void (^requestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        if ([error.userInfo objectForKey:NSLocalizedDescriptionKey]) {
            failure([error.userInfo objectForKey:NSLocalizedDescriptionKey]);
        }else if([error.userInfo objectForKey:@"NSDebugDescription"]){
            failure([error.userInfo objectForKey:@"NSDebugDescription"]);
        }
    };
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:parameters
                                                     error:nil];
    if (hitCache) {
        hitCache([[MeileleCustomURLCache shareMeileleURLCache] isHit:request]);
    }
    AFHTTPRequestOperation *operation = [_operationManager HTTPRequestOperationWithRequest:request success:successWrapper failure:requestFailureBlock];
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        responseFromCache = NO;
        return cachedResponse;
    }];
    [_operationManager.operationQueue addOperation:operation];
}

#pragma mark - Post Method
/**
 *  Post Method
 */
- (void)POSTWithURLString:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseData))success
                  failure:(void (^)(NSString *errorString))failure
{
    [_operationManager POST:urlString
                 parameters:parameters
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if (responseObject)
                        {
                            if (success)
                            {
#ifdef DebugHttpLog
                                NSLog(@"Post %@",[NSHTTPCookie requestHeaderFieldsWithCookies:
                                                  [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies]);
                                
                                NSURLRequest *request = operation.request;
                                NSDictionary *requestHeader = [request allHTTPHeaderFields];
                                NSLog(@"**** request header start ****");
                                NSLog(@"%@",requestHeader);
                                NSLog(@"**** request header end ****");
                                
                                NSHTTPURLResponse *response = operation.response;
                                NSDictionary *responseHeader = [response allHeaderFields];
                                NSLog(@"**** response header start ****");
                                NSLog(@"%@",responseHeader);
                                NSLog(@"**** response header end ****");
#endif
                                success(responseObject);
                                
                            }
                        }
                        else
                        {
                            if (failure)
                            {
                                failure(ResponseDataErrorString);
                            }
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [BaseNetworkService DebugHttpLog:operation];
                        if (failure && error)
                        {
                            if ([error.userInfo objectForKey:NSLocalizedDescriptionKey]) {
                                failure([error.userInfo objectForKey:NSLocalizedDescriptionKey]);
                            }else if([error.userInfo objectForKey:@"NSDebugDescription"]){
                                failure([error.userInfo objectForKey:@"NSDebugDescription"]);
                            }
                        }
                    }];
}

/**
 *  cancel requests
 */
- (void)cancelRequests
{
    [_operationManager.operationQueue cancelAllOperations];
}

#pragma mark - private method
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error
{
    return [_operationManager.requestSerializer requestWithMethod:method
                                                        URLString:[[NSURL URLWithString:URLString
                                                                          relativeToURL:_operationManager.baseURL] absoluteString]
                                                       parameters:parameters
                                                            error:error];
}

- (void)clearCache:(NSString *)urlString parameters:(NSDictionary *)parameters
{
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                 URLString:urlString
                                                parameters:parameters
                                                     error:nil];
    [[MeileleCustomURLCache shareMeileleURLCache] removeCachedResponseForRequest:request];
}

#pragma mark - Debug Log
+ (void)DebugHttpLog:(AFHTTPRequestOperation *)operation
{
#ifdef DebugHttpLog
    NSHTTPURLResponse *response = operation.response;
    NSDictionary *responseHeader = [response allHeaderFields];
    NSLog(@"**** response header start ****");
    NSLog(@"%@",responseHeader);
    NSLog(@"**** response header end ****");
#endif
}
@end
