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

/**
 Initialize a `SCRequest` object with an Endpoint path. Specify the HTTP Method (GET/POST supported), the parameters specific to that Endpoint, and a callback delegate that conforms to the `SCRequestDelegate` protocol.
 @param path An Endpoint from the Sociocast REST API
 @param HTTPMethod GET or POST
 @param parameters An `NSDictionary` containing parameters specific to the REST API Endpoint. See http://www.sociocast.com/dev-center/ for more information on specific endpoint requirements.
 @param delegate A delegate which implements the optional `SCRequestDelegate` functions.
 @return An initialized `SCRequest` object.
 */
-(SCRequest *)initWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate;

/**
 * Begin the `HTTP` Operation on the `SCRequest` object.
 */
-(void)start;

-(NSDictionary *)parseParameters;

/**
 * Create a HTTP GET and initiate it asynchronously. It is advised to interact with the Sociocast REST API through the Sociocast objects and not call this function directly.
 */
-(void)requestGETMethod;

/**
 * Create a HTTP POST and initiate it asynchronously. It is advised to interact with the Sociocast REST API through the Sociocast objects and not call this function directly.
 */
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
/// @name Delegate Functions (Optional)
///----------------------------------------------------

/**
 * Called when the `SCRequest` has finished loading. The `SCRequest` variable contains the `JSON` response from the Sociocast Endpoint call.
 */
-(void)requestdidFinishLoading:(SCRequest *)request;

/**
 * Called when the `SCRequest` fails with an `NSError`.
 */
-(void)request:(SCRequest *)request didFailWithErrror:(NSError *)error;

@end
