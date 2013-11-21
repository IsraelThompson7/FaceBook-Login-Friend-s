//
//  ViewController.h
//  FacebookLogin
//
//  Created by Apple on 15/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *namelist;
@property (strong, nonatomic) NSArray *idList;
@property (nonatomic) NSInteger count;

- (IBAction)back:(id)sender;

@end
