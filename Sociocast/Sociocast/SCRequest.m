//
//  SCRequest.m
//  Sociocast
//
//  Created by Jared Halpern on 2/13.
//  Copyright (c) 2013 Sociocast. All rights reserved.
//

#import "SCRequest.h"

@implementation SCRequest

@synthesize requestPath;
@synthesize requestHTTPMethod;
@synthesize requestParameters;
@synthesize requestDelegate;
@synthesize response;


-(id)initWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id)delegate{
    
    self = [super init];
    if (self){
        
        self.requestPath = path; // endpoint
        self.requestHTTPMethod = HTTPMethod; // GET | POST
        self.requestParameters = parameters;
        self.requestDelegate = delegate;
        
        [[SCAPIClient sharedInstance] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown){
                NSLog(@"AFNetworkReachabilityStatusNotReachable!!!!!! Changing setting.");
                [[SCAPIClient sharedInstance] setConnectionAvailable:NO];
                
            }else {
                NSLog(@"Connection available. Changing setting.");
                [[SCAPIClient sharedInstance] setConnectionAvailable:YES];
                
                int tempOpCount = [[[SCAPIClient sharedInstance] opQueue] count];
                NSLog(@"Operations Queue count is: %i", tempOpCount);
                
                if(tempOpCount > 0){
                    [[SCAPIClient sharedInstance] enqueueBatchOfHTTPRequestOperations:[[SCAPIClient sharedInstance] opQueue] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                        NSLog(@"Enqueing operation.");
                    } completionBlock:^(NSArray *operations) {
                        NSLog(@"Done queuing up missed operations. Emptying queue.");
                        [[[SCAPIClient sharedInstance] opQueue] removeAllObjects];
                    }];
                }
            }
        }];
    }
    
    return self;
}

/** 
 * Creates HTTP GET and initiates it asynchronously.
 */
-(void)requestGETMethod{
    NSLog(@"requestGETMethod");
    
	NSMutableURLRequest *request = [[SCAPIClient sharedInstance] requestWithMethod:@"GET" path:[self requestPath] parameters:[self parseParameters]];
    
    AFHTTPRequestOperation *operation =    
    [[SCAPIClient sharedInstance] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setResponse:responseObject];
        [requestDelegate requestdidFinishLoading:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"requestGETMethod.1 %s\nERROR:\n%@", __PRETTY_FUNCTION__, error);
        [[[SCAPIClient sharedInstance]opQueue]addObject:(AFHTTPRequestOperation *)operation];
    }];
    
    if([[SCAPIClient sharedInstance] connectionAvailable]){
        NSLog(@"requestGETMethod.2 - connection available: %@", NSStringFromBOOL([[SCAPIClient sharedInstance] connectionAvailable]));
        [[SCAPIClient sharedInstance] enqueueHTTPRequestOperation:operation];
        
    } else{
        NSLog(@"requestGETMethod.3 - connection NOT Available!!!! queueing up operation. connection: %@", NSStringFromBOOL([[SCAPIClient sharedInstance] connectionAvailable]));
        [[[SCAPIClient sharedInstance] opQueue] addObject:(AFHTTPRequestOperation*)operation];
    }
    
    
    /* original
    [[SCAPIClient sharedInstance] getPath:[self requestPath]
                               parameters:[self parseParameters]
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
                                      [self setResponse:responseObject];
                                      [requestDelegate requestdidFinishLoading:self];
                                      
                                  }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"SCRequest %s, error: %@", __PRETTY_FUNCTION__, error);
                                  }];*/
}

/**
 * Creates HTTP POST and initiates it asynchronously.
 */
-(void)requestPOSTMethod{
    
    NSLog(@"requestPOSTMethod");
    
	NSMutableURLRequest *request = [[SCAPIClient sharedInstance] requestWithMethod:@"POST" path:[self requestPath] parameters:[self requestParameters]];
    //    AFJSONRequestOperation *operation = // SHOULD WE BE USING THIS INSTEAD PERHAPS.
	AFHTTPRequestOperation *operation =
    [[SCAPIClient sharedInstance] HTTPRequestOperationWithRequest:request
                                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                              NSLog(@"requestPOSTMethod -> got success in POST");
                                                              [self setResponse:responseObject];
                                                              [requestDelegate requestdidFinishLoading:self];
                                                              
                                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {                                                                                                 NSLog(@"requestPOSTMethod.2 %s\nERROR:\n%@", __PRETTY_FUNCTION__, error);
                                                              [[[SCAPIClient sharedInstance] opQueue] addObject:(AFHTTPRequestOperation*)operation];
                                                          }];
    
    if ([[SCAPIClient sharedInstance] connectionAvailable]) {
        NSLog(@"requestPOSTMethod.2 - connection available: %@", NSStringFromBOOL([[SCAPIClient sharedInstance] connectionAvailable]));
        [[SCAPIClient sharedInstance] enqueueHTTPRequestOperation:operation];

    } else{
        NSLog(@"requestPOSTMethod - connection NOT Available!!!! queueing up operation. connection: %@", NSStringFromBOOL([[SCAPIClient sharedInstance] connectionAvailable]));
        [[[SCAPIClient sharedInstance] opQueue] addObject:(AFHTTPRequestOperation*)operation];
    }
}

/**
 * Initialize an SCRequest object.
 */
-(void)start{
//        NSLog(@"start------->");
    if ([[self requestHTTPMethod] isEqualToString:@"GET"]) {
        
        [self requestGETMethod];
        
    } else if ([[self requestHTTPMethod] isEqualToString:@"POST"]) {

        [self requestPOSTMethod];
        /*
         [self recursivePOSTNumberOfTimes:3 success:^(id responseObject) {
         NSLog(@"start -> got success in tryPOSTNumberOfTimes"); // NEVER CALLED
         //            [self setResponse:responseObject];
         //            [requestDelegate requestdidFinishLoading:self];
         
         } failure:^(NSError *error) {
         NSLog(@"start --> %s WITH ERROR--\nERROR: %@", __PRETTY_FUNCTION__, error);
         }];
         */
    } else {
        NSLog(@"HTTPMethod not recognized in %s", __PRETTY_FUNCTION__);
    }
}


// Creates HTTP POST and initiates it asynchronously.



// ensure parameter data are strings.
// do additional processing here to make sure no params are nil/malformed
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
    
    /*for(id key in pairs){
     NSLog(@"parseParameters ---> parseParameters: %@=%@", key, [pairs objectForKey:key]);
     }*/
    
    return pairs;
}

@end

