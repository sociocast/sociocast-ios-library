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

#define HASH_VALUE_STORAGE_SIZE 32

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

typedef enum {
    ENTITYATTRIBUTE_ADD,
    ENTITYATTRIBUTE_SET,
    ENTITYATTRIBUTE_DEL
} SCEntityAttributeActionType;

@interface Sociocast : NSObject{

    NSString *apiKey;
    NSString *apiSecret;
    NSString *clientID;
}

-(id)initWithAPIKey:(NSString *)APIKey andSecret:(NSString *)APISecret andClientID:(NSString *)cID;
-(SCRequest *)requestWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id <SCRequestDelegate>)delegate;

-(NSString *)generateSHA256Signature:(NSString *)key APISecret:(NSString *)secret timeStamp:(NSString *)timeStamp;

-(SCRequest *)entityObserve:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate;
-(SCRequest *)entityAttributes:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate;
-(SCRequest *)entityProfile:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate;
-(SCRequest *)contentProfile:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate;


@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *apiSecret;
@property (nonatomic, strong) NSString *clientID;

@end
