//
//  Sociocast.h
//  Sociocast
//
//  Created by Jared Halpern on 2/13.
//  Copyright (c) 2013 Sociocast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SCRequest.h"

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

@interface Sociocast : NSObject{

    NSString *apiKey;
    NSString *apiSecret;
    NSString *clientID;
}

///----------------------------------------------------
/// @name Properly Initializing a Sociocast Object
///----------------------------------------------------

-(id)initWithAPIKey:(NSString *)APIKey andSecret:(NSString *)APISecret andClientID:(NSString *)cID;

///----------------------------------------------------
/// @name Sociocast REST API Endpoints
///----------------------------------------------------

-(SCRequest *)entityObserve:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate;
-(SCRequest *)entityAttributes:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate;
-(SCRequest *)entityProfile:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate;
-(SCRequest *)contentProfile:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate;

///----------------------------------------------------
/// @name Sociocast Object Functionality
///----------------------------------------------------

-(SCRequest *)requestWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id <SCRequestDelegate>)delegate;
-(NSString *)generateSHA256Signature:(NSString *)key APISecret:(NSString *)secret timeStamp:(NSString *)timeStamp;

///----------------------------------------------------
/// @name Properties
///----------------------------------------------------

/**
 The Sociocast REST API requires a known token to be passed as part of the request query string. The token is called an apikey. The value of the token is an alphanumeric string assigned to you by your Sociocast Client Support Manager and/or upon registration.
 */
@property (nonatomic, strong) NSString *apiKey;

/**
 An apisecret is a secure alphanumeric string and will be used to calculate the SHA-256 signature, which is in turn used to sign and authenticate all Sociocast REST API requests.
 */
@property (nonatomic, strong) NSString *apiSecret;

/**
 The Client ID is required by certain Sociocast REST API Endpoints. Your Sociocast Client Support Manager will give this to you.
 */
@property (nonatomic, strong) NSString *clientID;

@end
