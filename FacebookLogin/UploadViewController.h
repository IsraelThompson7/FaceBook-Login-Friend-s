//
//  UploadViewController.h
//  FacebookLogin
//
//  Created by Apple on 21/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface UploadViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *shareItButton;

- (IBAction)back:(id)sender;
- (IBAction)shareIt:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)SelectPhoto:(id)sender;

@end
