//
//  MeileleCustomURLCache.h
//  MeileleMallHD
//
//  Created by chester on 8/4/14.
//  Copyright (c) 2014 Meilele iOS Dev Team. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CustomURLCacheExpirationInterval 216000         //缓存持续时间，秒为单位
#define MemoryCapacity 10                               //缓存 用于内存的容量限制，M为单位
#define DiskCapacity 2000                               //缓存 用于磁盘的容量限制，M为单位

@interface MeileleCustomURLCache : NSURLCache

+ (instancetype)shareMeileleURLCache;

/**
 *  是否命中缓存
 *
 *  @param request
 *
 *  @return 
 */
- (BOOL)isHit:(NSURLRequest *)request;
@end
