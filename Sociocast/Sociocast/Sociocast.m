//
//  Sociocast.m
//  Sociocast
//
//  Endpoint Logic
//
//  Created by Jared Halpern on 2/13.
//  Copyright (c) 2013 Sociocast. All rights reserved.
//

#import "Sociocast.h"

@implementation Sociocast

@synthesize apiKey, apiSecret, clientID;

#pragma mark - Initialization 

-(id)init{
    return [self initWithAPIKey:nil andSecret:nil andClientID:nil];
}

/** 
 * Initialize a Sociocast object with an APIKey, APISecret and ClientID. This needs to only be
 * initialized one time in your application. APIKey, APISecret and ClientID are
 * provided to you by your Sociocast Client Support Manager. 
 * Email support@sociocast.com and see http://www.sociocast.com/dev-center/ for more information.
 * @param key Known token to be passed as part of the request query string.
 * @param secret A secure alphanumeric string used to calculate the request signature.
 * @param cID Your Sociocast client ID is provided to you by your Sociocast Client Support Manager
 * @return An initialized Sociocast object containing details necessary to authenticate each API request.
 */
-(id)initWithAPIKey:(NSString *)key andSecret:(NSString *)secret andClientID:(NSString *)cID{
    
    self = [super init];
    if (self) {
        [self setApiKey:key];
        [self setApiSecret:secret];
        [self setClientID:cID];
    }
    return self;
}

#pragma mark - Endpoints

/**
 * Triggers an Entity Event to be tracked by Sociocast.
 * Corresponds with the entity/observe API endpoint.
 * @param parameters An NSDictionary containing parameters specific to the REST API Endpoint. See http://www.sociocast.com/dev-center/entityobserve/ for more information on specific endpoint requirements.
 * @param delegate Implements the SCRequestDelegate protocol and optionally handles the JSON Response.
 * @return An initialized SCRequest object containing the path to the entity/observe Endpoint and other details required for the POST operation.
 */
-(SCRequest *)entityObserve:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate{
    return [self requestWithPath:@"entity/observe" HTTPMethod:@"POST" parameters:parameters delegate:delegate];
}

/**
 * Used to pass Entity Attributes to Sociocast (i.e. Attributes specific to an Entity as opposed to an event)
 * @param parameters An NSDictionary containing parameters specific to the REST API Endpoint. See http://www.sociocast.com/dev-center/entityobserve/ for more information on specific endpoint requirements.
 * @param delegate Implements the SCRequestDelegate protocol and optionally handles the JSON Response.
 * @return An initialized SCRequest object containing the path to the entity/attributes Endpoint and other details required for the POST operation.
 */
-(SCRequest *)entityAttributes:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate{
    
    return [self requestWithPath:@"entity/attributes" HTTPMethod:@"POST" parameters:parameters delegate:delegate];
}

/**
 * Used to pass 
 * @param parameters An NSDictionary containing parameters specific to the REST API Endpoint. See http://www.sociocast.com/dev-center/entityobserve/ for more information on specific endpoint requirements.
 * @param delegate Implements the SCRequestDelegate protocol and optionally handles the JSON Response.
 * @return An initialized SCRequest object containing the path to the entity/profile Endpoint and other details required for the POST operation.
 */
-(SCRequest *)entityProfile:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate{
    return [self requestWithPath:@"entity/profile" HTTPMethod:@"POST" parameters:parameters delegate:delegate];
}

/**
 * Used to pass 
 * @param parameters An NSDictionary containing parameters specific to the REST API Endpoint. See http://www.sociocast.com/dev-center/entityobserve/ for more information on specific endpoint requirements.
 * @param delegate Implements the SCRequestDelegate protocol and optionally handles the JSON Response.
 * @return An initialized SCRequest object containing the path to the content/profile Endpoint and other details required for the GET operation.
 */
-(SCRequest *)contentProfile:(NSDictionary *)parameters delegate:(id<SCRequestDelegate>)delegate{
    return [self requestWithPath:@"content/profile" HTTPMethod:@"GET" parameters:parameters delegate:delegate];
}

#pragma mark -

/**
 * Create a Sociocast Request object. Used in lieu of a specific Endpoint function.
 * @param path A Sociocast REST API Endpoint
 * @param HTTPMethod The HTTP request-response methods: GET or POST
 * @param parameters Parameters specific to the Sociocast REST Endpoint, including reserved JSON Keys and Optional keys. See http://www.sociocast.com/dev-center/ for details on specific Endpoint requirements.
 * @param delegate A delegate object that complies with the [SCRequestDelegate](SCRequestDelegate) protocol. Will be called asynchronously upon completion or failure of the SCRequest.
 * @return An initialized SCRequest object containing the path to a REST API Endpoint and other details required for a GET/POST operation.
 */
-(SCRequest *)requestWithPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod parameters:(NSDictionary *)parameters delegate:(id <SCRequestDelegate>)delegate{

    NSString *timeStamp = [NSString stringWithFormat:@"%1.f", [[NSDate date] timeIntervalSince1970]];
    NSString *signatureResult = [self generateSHA256Signature:apiKey APISecret:apiSecret timeStamp:timeStamp];
        
    // finalize parameters
    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    if ([HTTPMethod isEqualToString:@"GET"]) {
        
        // Append everything to final parameters. These will be appended to path later on.
        [finalParameters setObject:signatureResult forKey:@"sig"];
        [finalParameters setObject:apiKey forKey:@"apikey"];
        [finalParameters setObject:timeStamp forKey:@"ts"];
        
    } else if ([HTTPMethod isEqualToString:@"POST"]){
        
        // Append key/sig/ts to path now.
        path = [NSString stringWithFormat:@"%@?apikey=%@&sig=%@&ts=%@", path, apiKey, signatureResult, timeStamp];
    }

/*    NSLog(@"%s requestWithPath - parameters:", __PRETTY_FUNCTION__);
    for(id param in finalParameters){
        NSLog(@"key=%@, value=%@", param, [finalParameters valueForKey:param]);
    }*/

    return [[SCRequest alloc] initWithPath:path HTTPMethod:HTTPMethod parameters:finalParameters delegate:delegate];
}

/**
 * Compute a signature used to [sign](http://www.sociocast.com/dev-center/authenticating-your-api-access-3/) every API request.
 * Signature consists of a SHA256 Digest based on the following key/value string, sorted in *alphabetical* order: APIKey, APISecret and Unix Timestamp.
 * Note that a +/-5 minutes wiggle period is permitted on the Sociocast server on either side of the current timestamp to allow for reasonable 
 * clock drift and other delays.
 * @param key Sociocast granted APIKey
 * @param secret Sociocast granted APISecret
 * @param timeStamp Reflects the number of seconds since the Unix Epoch (January 1 1970 00:00:00 GMT) at the time a request was made.
 */
-(NSString *)generateSHA256Signature:(NSString *)key APISecret:(NSString *)secret timeStamp:(NSString *)timeStamp{
    
    NSString *signatureString = nil;
    
    @try {
        
        if(IsEmpty(key) || IsEmpty(secret) || IsEmpty(timeStamp)) {
            NSLog(@"WARNING: Empty APIKey / APISecret / Timestamp being used to generate SHA-256 signature.\nDid you remember to initialize a Sociocast object with your APIKey and APISecret?");
        }
        
        NSString *keyString = [NSString stringWithFormat:@"apikey=%@&apisecret=%@&ts=%@", key, secret, timeStamp];
        unsigned char hashedChars[CC_SHA256_DIGEST_LENGTH];
        NSData *dataIn = [keyString dataUsingEncoding:NSUTF8StringEncoding];
        CC_SHA256([dataIn bytes], [dataIn length], hashedChars);
        // sloppy but works. refactor.
        NSData *signatureData = [NSData dataWithBytes:hashedChars length:CC_SHA256_DIGEST_LENGTH];
        signatureString = [NSString stringWithFormat:@"%@", signatureData];
        signatureString = [signatureString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"< >"]];
        signatureString = [signatureString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in Sociocast.m, %s: %@", __PRETTY_FUNCTION__, [exception description]);
    }
    
    return signatureString;
}

@end




