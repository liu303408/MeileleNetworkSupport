//
//  MeileleJSONResponseSerializer.m
//  MLLNetWorkService
//
//  Created by chester on 7/31/14.
//  Copyright (c) 2014 Meilele iOS Dev Team. All rights reserved.
//

#import "MeileleJSONResponseSerializer.h"

@implementation MeileleJSONResponseSerializer

- (id)init {
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
@end
