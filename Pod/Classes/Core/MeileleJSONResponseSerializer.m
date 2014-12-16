//
//  MeileleJSONResponseSerializer.m
//  MLLNetWorkService
//
//  Created by chester on 7/31/14.
//  Copyright (c) 2014 chesterlee. All rights reserved.
//

#import "MeileleJSONResponseSerializer.h"

@implementation MeileleJSONResponseSerializer

- (id)init
{
    self = [super init];
    
    if (self) {
        NSMutableSet *customContentTypes = [self.acceptableContentTypes mutableCopy];
        [customContentTypes addObject:@"text/html"];
        [customContentTypes addObject:@"text/plain"];
        [customContentTypes addObject:@"text/json"];
        [customContentTypes addObject:@"application/json"];
        self.acceptableContentTypes = [customContentTypes copy];
    }

    return self;
}

//- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
//{
//    
//    /* ==== web页面接口，暂时保留
//   
//     //如果网络请求为加载商品详情页，则直接返回nsdata数据
//     if ([response.URL.absoluteString rangeOfString:@"/goods-"].location != NSNotFound) {     return data;}
//    ====*/
//    //NSString *string  = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    //NSLog(@"%@",string);
//    
//    NSLog(@"url:%@",response.URL.absoluteString);
//    return [super responseObjectForResponse:response data:data error:error];
//}

@end
