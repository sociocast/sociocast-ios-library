//
//  SCRequest.m
//  Sociocast
//
//  Created by Jared Halpern on 2/13.
//  Copyright (c) 2013 Sociocast. All rights reserved.
//

#import "SCRequest.h"

/**
 `SCRequest` objects are used to interact with the Sociocast REST API Endpoints.
 See http://www.sociocast.com/dev-center/ for more information on working with the Sociocast REST API.
 */


@implementation SCRequest

@synthesize requestPath;
@synthesize requestHTTPMethod;
@synthesize requestParameters;
@synthesize requestDelegate;
@synthesize response;


-(SCRequest *)initWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate{
    
    self = [super init];
    if (self){
        
        self.requestPath = path; // endpoint
        self.requestHTTPMethod = HTTPMethod; // GET | POST
        self.requestParameters = parameters;
        self.requestDelegate = delegate;
        
        [[SCAPIClient sharedInstance] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown){
                [[SCAPIClient sharedInstance] setConnectionAvailable:NO];
                
            }else {
                [[SCAPIClient sharedInstance] setConnectionAvailable:YES];
                
                int tempOpCount = [[[SCAPIClient sharedInstance] opQueue] count];
                
                if(tempOpCount > 0){
                    [[SCAPIClient sharedInstance] enqueueBatchOfHTTPRequestOperations:[[SCAPIClient sharedInstance] opQueue] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                        NSLog(@"Enqueing operation.");
                    } completionBlock:^(NSArray *operations) {
                        [[[SCAPIClient sharedInstance] opQueue] removeAllObjects];
                    }];
                }
            }
        }];
    }
    
    return self;
}

-(void)requestGETMethod{
    NSLog(@"requestGETMethod");
    
	NSMutableURLRequest *request = [[SCAPIClient sharedInstance] requestWithMethod:@"GET" path:[self requestPath] parameters:[self parseParameters]];
    
    AFHTTPRequestOperation *operation =
    [[SCAPIClient sharedInstance] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setResponse:responseObject];
        [requestDelegate requestdidFinishLoading:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"requestGETMethod.1 %s\nERROR:\n%@", __PRETTY_FUNCTION__, error);
        [requestDelegate request:self didFailWithErrror:error];
        [[[SCAPIClient sharedInstance]opQueue]addObject:(AFHTTPRequestOperation *)operation];
    }];
    
    if([[SCAPIClient sharedInstance] connectionAvailable]){
        //        NSLog(@"requestGETMethod.2 - connection available: %@", NSStringFromBOOL([[SCAPIClient sharedInstance] connectionAvailable]));
        [[SCAPIClient sharedInstance] enqueueHTTPRequestOperation:operation];
        
    } else{
        //        NSLog(@"requestGETMethod.3 - connection NOT Available! Queueing up operation. "));
        [[[SCAPIClient sharedInstance] opQueue] addObject:(AFHTTPRequestOperation*)operation];
    }
}

-(void)requestPOSTMethod{
    
    NSLog(@"requestPOSTMethod");
    
	NSMutableURLRequest *request = [[SCAPIClient sharedInstance] requestWithMethod:@"POST" path:[self requestPath] parameters:[self requestParameters]];
    
	AFHTTPRequestOperation *operation =
    [[SCAPIClient sharedInstance] HTTPRequestOperationWithRequest:request
                                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                              [self setResponse:responseObject];
                                                              [requestDelegate requestdidFinishLoading:self];
                                                              
                                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {                                                                                                 //NSLog(@"requestPOSTMethod.2 %s\nERROR:\n%@", __PRETTY_FUNCTION__, error);
                                                              [requestDelegate request:self didFailWithErrror:error];
                                                              [[[SCAPIClient sharedInstance] opQueue] addObject:(AFHTTPRequestOperation*)operation];
                                                          }];
    
    if ([[SCAPIClient sharedInstance] connectionAvailable]) {
        [[SCAPIClient sharedInstance] enqueueHTTPRequestOperation:operation];
        
    } else{
        [[[SCAPIClient sharedInstance] opQueue] addObject:(AFHTTPRequestOperation*)operation];
    }
}

-(void)start{
    
    if ([[self requestHTTPMethod] isEqualToString:@"GET"]) {
        
        [self requestGETMethod];
        
    } else if ([[self requestHTTPMethod] isEqualToString:@"POST"]) {
        
        [self requestPOSTMethod];
    } else {
        NSLog(@"SCRequest: HTTPMethod not recognized in %s", __PRETTY_FUNCTION__);
    }
}

// Ensure that parameter data are strings.
-(NSDictionary *)parseParameters{
    
    NSMutableDictionary *pairs = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in requestParameters) {
        
        NSString *value = [requestParameters objectForKey:key];
        
        if (![value isKindOfClass:[NSString class]]) {
            if ([value isKindOfClass:[NSNumber class]]) {
                
                value = [value description];
                
            } else {
                continue;
            }
        }
        [pairs setObject:value forKey:key];
    }
    
    return pairs;
}

@end

