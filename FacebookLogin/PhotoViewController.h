//
//  PhotoViewController.h
//  FacebookLogin
//
//  Created by Apple on 18/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <Social/Social.h>

@interface PhotoViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic) NSInteger count;
@property (strong, nonatomic) NSArray *namelist;
@property (strong, nonatomic) NSArray *idList;

- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet iCarousel *SliderView;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end
