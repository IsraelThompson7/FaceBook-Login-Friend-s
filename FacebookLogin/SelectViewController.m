//
//  SelectViewController.m
//  FacebookLogin
//
//  Created by Apple on 15/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "SelectViewController.h"
#import "AppDelegate.h"
#import "ListViewController.h"

@interface SelectViewController ()

@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) NSArray *idArray;

@end

@implementation SelectViewController

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
    self.userState.text = @"Log in to know More";
    self.loginWithFacebook.titleLabel.text = [NSString stringWithFormat:@"LogIn"];
    self.proceed.hidden = YES;
    [self updateView];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithFaceBook:(id)sender
{
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen)
    {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
    }
    else
    {
        if (appDelegate.session.state != FBSessionStateCreated)
        {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             // and here we make sure to update our UX according to the new session state
             [self updateView];
         }];
    }
}

- (void)updateView
{
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen)
    {
        // valid account UI is shown whenever the session is open
        self.userState.text = @"Proceed to know More";
        [self.loginWithFacebook setTitle: @"LogOut" forState: UIControlStateNormal];
        self.proceed.hidden = NO;
        [self parseValues];
    }
    else
    {
        // login-needed account UI is shown whenever the session is closed
        self.userState.text = @"Log in to know More";
        [self.loginWithFacebook setTitle: @"LogIn" forState: UIControlStateNormal];
        self.proceed.hidden = YES;
    }
}

- (void)parseValues
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", appDelegate.session.accessTokenData.accessToken];
    NSLog(@"%@ ::::", urlString);
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request1 setHTTPMethod: @"GET"];
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest: request1 returningResponse: &response error: nil];
    NSError *error = [[NSError alloc] init];
    NSLog(@"Response code: %ld", (long)[response statusCode]);
        
    if ([response statusCode] >=200 && [response statusCode] <300)
    {
        NSString *jsonString = [NSString stringWithContentsOfURL:url1 encoding:NSASCIIStringEncoding error:&error];
        NSData *jsonData = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
        
        if (jsonData == nil)
        {
            NSLog(@"Error in fetching data");
        }
        else
        {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            //NSLog(@"jsonDictionary = %@", jsonDictionary);
            self.nameArray = [[jsonDictionary valueForKey:@"data"] valueForKey:@"name"];
            self.idArray = [[jsonDictionary valueForKey:@"data"] valueForKey:@"id"];
        }
    }
}

- (IBAction)nameList:(id)sender
{
    NSLog(@"friend's list");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ListViewController *listViewController = [segue destinationViewController];
    listViewController.namelist = self.nameArray;
    listViewController.idList = self.idArray;
}

@end
