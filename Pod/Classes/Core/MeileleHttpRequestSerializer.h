//
//  MeileleHttpRequestSerializer.h
//  MLLNetWorkService
//
//  Created by chester on 7/31/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//
#import "AFURLRequestSerialization.h"

/**
 *  Request Serializer for meilele
 */
@interface MeileleHttpRequestSerializer : AFHTTPRequestSerializer

@property (nonatomic) NSURLRequestCachePolicy cachePolicy;

@end
