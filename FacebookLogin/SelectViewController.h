//
//  SelectViewController.h
//  FacebookLogin
//
//  Created by Apple on 15/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PHOTO_ID @"id"

@interface SelectViewController : UIViewController

- (IBAction)loginWithFaceBook:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginWithFacebook;
@property (strong, nonatomic) IBOutlet UILabel *userState;
@property (strong, nonatomic) IBOutlet UIButton *proceed;

@end
