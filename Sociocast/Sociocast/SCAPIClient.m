//
//  SCAPIClient.m
//  Sociocast
//
//  Created by Jared Halpern on 2/13.
//  Copyright (c) 2013 Sociocast. All rights reserved.
//

#import "SCAPIClient.h"

@implementation SCAPIClient

@synthesize opQueue;
@synthesize connectionAvailable;

+(id)sharedInstance{
    
    NSString *baseURL = [SOCIOCAST_BASEURL stringByAppendingString:SOCIOCAST_VERSION];
    
    static SCAPIClient *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[SCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });
    
    return __sharedInstance;
}

-(id)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if(self){

        [self registerHTTPOperationClass:[AFJSONRequestOperation class]]; // Return JSON
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setParameterEncoding:AFJSONParameterEncoding];
        
        int cacheSizeMemory = 4*1024*1024; // 4MB
        int cacheSizeDisk = 16*1024*1024; // 16 MB
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
        [NSURLCache setSharedURLCache:sharedCache];
        
        self.opQueue = [[NSMutableArray alloc] init];
        self.connectionAvailable = NO;
    }
    
    return self;
}


@end
