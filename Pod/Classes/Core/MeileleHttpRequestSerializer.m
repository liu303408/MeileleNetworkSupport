//
//  MeileleHttpRequestSerializer.m
//  MLLNetWorkService
//
//  Created by chester on 7/31/14.
//  Copyright (c) 2014 Meilele iOS Dev Team. All rights reserved.
//

#import "MeileleHttpRequestSerializer.h"

@implementation MeileleHttpRequestSerializer

- (id)init {
    self = [super init];
    
    if (self) {
        self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        [self setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    }
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error {
    if (!URLString) {
        NSLog(@"=========MLL ERROR IN Build Request!===== in %s",__FUNCTION__);
        return nil;
    }
    
    NSMutableURLRequest *req = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    [req setCachePolicy:self.cachePolicy];

    return req;
}

@end
