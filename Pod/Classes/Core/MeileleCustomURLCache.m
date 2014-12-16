//
//  MeileleCustomURLCache.m
//  MeileleMallHD
//
//  Created by chester on 8/4/14.
//  Copyright (c) 2014 Meilele iOS Dev Team. All rights reserved.
//

#import "MeileleCustomURLCache.h"

#define kCustomURLCacheExpiration @"CustomURLCacheExpiration"

@implementation MeileleCustomURLCache

+ (instancetype)shareMeileleURLCache
{
    static MeileleCustomURLCache *_standardURLCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardURLCache = [[MeileleCustomURLCache alloc]
                             initWithMemoryCapacity:(MemoryCapacity * 1024 * 1024)
                             diskCapacity:(DiskCapacity * 1024 * 1024)
                             diskPath:nil];
    });
    return _standardURLCache;
}

- (BOOL)isHit:(NSURLRequest *)request {
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    if (cachedResponse) {
        NSDate *cacheData = cachedResponse.userInfo[kCustomURLCacheExpiration];
        if ([MeileleCustomURLCache isOverdue:cacheData]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

#pragma mark - overwrite
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    if (cachedResponse) {
        NSDate *cacheData = cachedResponse.userInfo[kCustomURLCacheExpiration];
        if ([MeileleCustomURLCache isOverdue:cacheData]) {
            return nil;
        }
    }
    return cachedResponse;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:cachedResponse.userInfo];
    userInfo[kCustomURLCacheExpiration] = [NSDate date];
    
    NSCachedURLResponse *modifiedCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:userInfo storagePolicy:cachedResponse.storagePolicy];
    
    [super storeCachedResponse:modifiedCachedResponse forRequest:request];
}

#pragma mark - private method
+ (BOOL)isOverdue:(NSDate *)data
{
    NSDate *overdueData = [data dateByAddingTimeInterval:CustomURLCacheExpirationInterval];
    return [overdueData compare:[NSDate date]] == NSOrderedAscending;
}
@end
