//
//  ViewController.m
//  FacebookLogin
//
//  Created by Apple on 15/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "CustomCell.h"
#import "PhotoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

// main helper method to update the UI to reflect the current state of the session.
- (void)updateView
{
    /*// get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen)
    {
        // valid account UI is shown whenever the session is open
        [self.loginButton setTitle:@"Log out" forState:UIControlStateNormal];
        [self.textForUser setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", appDelegate.session.accessTokenData.accessToken]];
        //[self.textForUser setText:@"fetching data's"];
        [self parseValues];
    }
    else
    {
        // login-needed account UI is shown whenever the session is closed
        [self.loginButton setTitle:@"Log in" forState:UIControlStateNormal];
        [self.textForUser setText:@"Login to create a link to fetch your friend's name list"];
    }*/
}

- (void)parseValues
{
    /*AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen)
    {
       NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", appDelegate.session.accessTokenData.accessToken];
        NSLog(@"%@ ::::", urlString);
        NSURL *url1 = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        [request1 setHTTPMethod: @"GET"];
        NSHTTPURLResponse *response = nil;
        [NSURLConnection sendSynchronousRequest: request1 returningResponse: &response error: nil];
        NSError *error = [[NSError alloc] init];
        NSLog(@"Response code: %d", [response statusCode]);
    
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
                NSLog(@"jsonDictionary = %@", jsonDictionary);
                NSArray *dataArray = [[jsonDictionary valueForKey:@"data"] valueForKey:@"name"];
                NSLog(@"names ::::: %@", dataArray);
                self.textForUser.text = [NSString stringWithFormat:@"%@",dataArray];
            }
        }
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (IBAction)loginButton:(id)sender
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
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.namelist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    cell.friendsName.text = [NSString stringWithFormat:@"%@",[self.namelist objectAtIndex:indexPath.row]];
    return cell;
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PhotoViewController *photoViewController = [segue destinationViewController];
    photoViewController.namelist = self.namelist;
    photoViewController.idList = self.idList;
    photoViewController.count = self.count;
}

@end
