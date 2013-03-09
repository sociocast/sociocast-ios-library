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

@property (nonatomic, strong) NSString *requestPath;
@property (nonatomic, strong) NSString *requestHTTPMethod;
@property (nonatomic, strong) NSDictionary *requestParameters;
@property (nonatomic, strong) id<SCRequestDelegate> requestDelegate;

@property (nonatomic, copy) NSDictionary *response;

@end

/**
 * The `SCRequestDelegate` protocol describes a delegate object given the option of taking action when the `SCRequest` operation finishes. The `SCRequest` object returned will contain a `JSON` response from the API.
 */
@protocol SCRequestDelegate
@optional

///----------------------------------------------------
/// @name Delegate Functions
///----------------------------------------------------

/**
 * Called when the `SCRequest` has finished loading.
 */
-(void)requestdidFinishLoading:(SCRequest *)request;

/**
 * Called when the `SCRequest` fails with an `NSError`.
 */
-(void)request:(SCRequest *)request didFailWithErrror:(NSError *)error;

@end
