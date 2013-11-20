//
//  ListViewController.h
//  FacebookLogin
//
//  Created by Apple on 15/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController
@property (strong, nonatomic) NSArray *namelist;
@property (strong, nonatomic) NSArray *idList;

- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
