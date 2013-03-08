//
//  SCRequest.h
//  Sociocast
//
//  Created by Jared Halpern on 2/13.
//  Copyright (c) 2013 Sociocast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SCAPIClient.h"

#define TIMEOUT_INTERVAL    180.0
#define NSStringFromBOOL(amIBOOL) amIBOOL? @"YES" : @"NO"

@protocol SCRequestDelegate;

@interface SCRequest : NSObject{
    
    NSString *requestPath;
    NSString *requestHTTPMethod;
    NSDictionary *requestParameters;
    id <SCRequestDelegate> requestDelegate;
    
    NSDictionary *response;

}

-(id)initWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id)delegate;
-(void)start;

-(NSDictionary *)parseParameters;
-(void)requestGETMethod;
-(void)requestPOSTMethod;
//-(void)recursivePOSTNumberOfTimes:(NSUInteger)numTimes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@property (nonatomic, strong) NSString *requestPath;
@property (nonatomic, strong) NSString *requestHTTPMethod;
@property (nonatomic, strong) NSDictionary *requestParameters;
@property (nonatomic, strong) id<SCRequestDelegate> requestDelegate;

@property (nonatomic, copy) NSDictionary *response;

@end

/**
 * The SCRequestDelegate describes a delegate object given the option of responding when the request operation finishes.
 *
 */
@protocol SCRequestDelegate
@optional
-(void)requestDidStartLoading:(SCRequest *)request;
-(void)requestdidFinishLoading:(SCRequest *)request;
-(void)request:(SCRequest *)request didFailWithErrror:(NSError *)error;

@end
