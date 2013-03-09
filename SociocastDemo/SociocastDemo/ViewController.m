//
//  ViewController.m
//  SociocastDemo
//
//  Created by Jared Halpern on 2/13.
//  Copyright (c) 2013 Sociocast. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize entityObserveButton;
@synthesize entityAttributesButton;
@synthesize entityProfileButton;
@synthesize contentProfileButton;

@synthesize request = request_;
@synthesize response = response_;
@synthesize sociocast;

#pragma mark - SCRequestDelegate

-(void)requestdidFinishLoading:(SCRequest *)request{
    self.response = request.response;
    self.request = nil;
    
    // Take action based on the response in the request object.
//    NSLog(@"%s\n%@\n%@", __PRETTY_FUNCTION__, [self.response valueForKey:@"classification"], [self.response valueForKey:@"attributes"]);
    
    for (id key in self.response) {
        NSLog(@"%s\nResponse- key: %@, value: %@",__PRETTY_FUNCTION__, key, [self.response valueForKey:key]);
    }
}

-(void)request:(SCRequest *)request didFailWithErrror:(NSError *)error{
    NSLog(@"Error - %s: %@", __PRETTY_FUNCTION__, error);
    self.response = nil;
    self.request = nil;
}
#pragma mark - 

-(void)prepareForRequest{
    self.response = nil;
    self.request = nil;
}

#pragma mark - UI Elements

-(IBAction)entityObserveButtonPressed:(id)sender{
    
    [self prepareForRequest];
    
    NSDictionary *obsDict = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.techcrunch.com", @"url", @"technology", @"txt", nil];
    NSString *timeStamp = [NSString stringWithFormat:@"%1.f", [[NSDate date] timeIntervalSince1970]];
    
    // entity/observe - POST
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                SOCIOCAST_CLIENT_ID, @"clid",
                                @"sociocastAPITest_01", @"eid",
                                obsDict, @"obs",
                                timeStamp, @"ets",
                                @"click", @"evt",
                                nil];

    self.request = [sociocast entityObserve:parameters delegate:self];
    [self.request start];
}

-(IBAction)entityAttributesButtonPressed:(id)sender{
    
    [self prepareForRequest];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                SOCIOCAST_CLIENT_ID, @"clid",
                                @"sociocastAPITest_01", @"eid",
                                [NSDictionary dictionaryWithObject:@"18 - 34" forKey:@"age"], @"add",
                                nil];
    
    self.request = [sociocast entityAttributes:parameters delegate:self];
    [self.request start];
}

-(IBAction)entityProfileButtonPressed:(id)sender{
    
    [self prepareForRequest];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSArray arrayWithObjects:@"cls.ctx", nil], @"attributes",
                                SOCIOCAST_CLIENT_ID, @"clid",                                
                                @"sociocastAPITest_01", @"eid",
                                @"TRUE", @"humanread",
                                nil];
    
    self.request = [sociocast entityProfile:parameters delegate:self];
    [self.request start];
}

-(IBAction)contentProfileButtonPressed:(id)sender{
    
    [self prepareForRequest];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.techcrunch.com", @"url", nil];
    
    self.request = [sociocast contentProfile:parameters delegate:self];
    [self.request start];
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sociocast = [[Sociocast alloc] initWithAPIKey:API_KEY andSecret:API_SECRET andClientID:SOCIOCAST_CLIENT_ID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
