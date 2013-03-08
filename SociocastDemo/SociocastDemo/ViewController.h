//
//  ViewController.h
//  SociocastDemo
//
//  Created by Jared Halpern on 2/13.
//  Copyright (c) 2013 Sociocast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sociocast.h"

#define SOCIOCAST_CLIENT_ID @"C2"
#define API_KEY @"atlantishome"
#define API_SECRET @"atlantishome"

@interface ViewController : UIViewController <SCRequestDelegate>{
    
    IBOutlet UIButton *entityObserveButton;
    IBOutlet UIButton *entityAttributesButton;
    IBOutlet UIButton *entityProfileButton;
    IBOutlet UIButton *contentProfileButton;
    
    SCRequest *request_;
    Sociocast *sociocast;
    
    NSDictionary *response_;
}

-(IBAction)entityObserveButtonPressed:(id)sender;
-(IBAction)entityAttributesButtonPressed:(id)sender;
-(IBAction)entityProfileButtonPressed:(id)sender;
-(IBAction)contentProfileButtonPressed:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton *entityObserveButton;
@property (nonatomic, strong) IBOutlet UIButton *entityAttributesButton;
@property (nonatomic, strong) IBOutlet UIButton *entityProfileButton;
@property (nonatomic, strong) IBOutlet UIButton *contentProfileButton;

@property (nonatomic, strong) SCRequest *request;
@property (nonatomic, strong) Sociocast *sociocast;

@property (nonatomic, copy) NSDictionary *response;

@end
