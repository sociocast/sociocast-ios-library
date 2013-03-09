//
//  SCAPIClient.h
//  Sociocast
//
//  Created by Jared Halpern on 2/13.
//  Copyright (c) 2013 Sociocast. All rights reserved.
//

#import "AFNetworking.h"

//---------------------------------------------------------------------------------
// To update from Testing Environment to Production, edit SOCIOCAST_BASEURL below.
//---------------------------------------------------------------------------------

#define SOCIOCAST_BASEURL @"http://api-sandbox.sociocast.com/"
#define SOCIOCAST_VERSION @"1.0"


@interface SCAPIClient : AFHTTPClient{

    NSMutableArray *opQueue;
    BOOL connectionAvailable;
}

@property (nonatomic, strong) NSMutableArray *opQueue;
@property (nonatomic, assign) BOOL connectionAvailable;

+(id)sharedInstance;

@end
