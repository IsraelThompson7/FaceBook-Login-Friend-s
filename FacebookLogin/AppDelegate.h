//
//  AppDelegate.h
//  FacebookLogin
//
//  Created by Apple on 15/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#define FaceBookLoginApp  ((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *session;

@end
