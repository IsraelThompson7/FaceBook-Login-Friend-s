//
//  ListViewController.m
//  FacebookLogin
//
//  Created by Apple on 15/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "ListViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface ListViewController ()

@property (strong, nonatomic) NSString *firstNameUser;
@property (strong, nonatomic) NSString *lastNameUser;
@property (strong, nonatomic) NSString *mainLocation;
@property (strong, nonatomic) NSString *urlImageUser;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *accessToken;

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self test];
    [self.indicator startAnimating];
    self.userImage.layer.cornerRadius = 20.0;
    self.userImage.layer.masksToBounds = YES;
    self.shareButton.hidden = YES;
    self.nameListButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showName"])
    {
        ViewController *viewController = [segue destinationViewController];
        viewController.namelist = self.namelist;
        viewController.idList = self.idList;
        NSUInteger count = [self.idList count];
        NSLog(@":::%lu:::", (unsigned long)count);
        viewController.count = count;
    }
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)test
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [FBSession setActiveSession:appDelegate.session];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
    ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        self.firstNameUser = user.name;
        self.lastNameUser = user.last_name;
        self.mainLocation = user.location.name;
        self.urlImageUser = user.link;
        self.userId = user.id;
        self.accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
        
        NSLog(@"%@:%@:%@:%@:%@:%@", self.firstNameUser, self.lastNameUser, self.mainLocation, self.urlImageUser, self.userId, self.accessToken);
        self.userName.text = [NSString stringWithFormat:@"Welcome %@%@",self.firstNameUser,self.lastNameUser];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", self.userId]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.userImage.image = [[UIImage alloc] initWithData:data];
        [self.indicator stopAnimating];
        self.shareButton.hidden = NO;
        self.nameListButton.hidden = NO;
    }];
}

@end
