//
//  PhotoViewController.m
//  FacebookLogin
//
//  Created by Apple on 18/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *share;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSURL *photoURL;

@end

@implementation PhotoViewController

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLayoutSubviews
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure carousel
    self.SliderView.type = iCarouselTypeCoverFlow2;
    self.SliderView.decelerationRate = 0.0f;
    self.SliderView.stopAtItemBoundary = YES;
    self.SliderView.scrollToItemBoundary = YES;
    self.SliderView.scrollSpeed = 0.2f;
    self.items = [NSMutableArray array];
    NSInteger count = self.count;
    for (int i = 0; i < count; i++)
    {
        [_items addObject:@(i)];
    }
    NSLog(@"Count = %li", (long)count);
    
    self.share = [[UIView alloc]initWithFrame:CGRectMake(85, 300, 220, 60)];
    [self.share setBackgroundColor:[UIColor clearColor]];
    [self.SliderView addSubview:self.share];
    self.share.hidden = YES;
    self.share.alpha = 0.0;
    self.detailLabel.alpha = 0.0;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    NSLog(@"returns %lu", (unsigned long)[self.idList count]);
    return [self.idList count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 300.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.layer.cornerRadius = 25.0;
        view.layer.masksToBounds = YES;
        //view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    //label.text = [_items[index] stringValue];
    
    //Shows the id name
    //label.text = [self.idList [index] description];
    
    //For showing images
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [self.idList [index] description]]];
        NSInteger indexCurrent = self.SliderView.currentItemIndex;
         NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [self.idList [indexCurrent] description]]];
        self.photoURL = url1;
    NSData *data = [NSData dataWithContentsOfURL:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        ((UIImageView *)view).image = [[UIImage alloc] initWithData:data];
        self.imageData = data;
        });
    });
    
    //Add Two Buttons
    
    UIButton *IdButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [IdButton setFrame:CGRectMake(0, 0, 100, 65)];
    [IdButton setBackgroundColor:[UIColor clearColor]];
    IdButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [IdButton setTitle:@"get I.d" forState:UIControlStateNormal];
    [IdButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [view addSubview:IdButton];
    [IdButton addTarget:self action:@selector(IdButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *NameButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [NameButton setFrame:CGRectMake(200, 0, 100, 65)];
    [NameButton setBackgroundColor:[UIColor clearColor]];
    NameButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [NameButton setTitle:@"Show Name" forState:UIControlStateNormal];
    [NameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [view addSubview:NameButton];
    [NameButton addTarget:self action:@selector(NameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *share=[UIButton buttonWithType:UIButtonTypeCustom];
    [share setFrame:CGRectMake(0, 250, 75, 50)];
    [share setBackgroundColor:[UIColor clearColor]];
    [share setBackgroundImage:[UIImage imageNamed:@"ios_share.png"] forState:UIControlStateNormal];
    [share setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [view addSubview:share];
    [share addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (void)IdButtonAction:(id)sender
{
    self.detailLabel.alpha = 0.0;
    NSInteger index = [self.SliderView indexOfItemViewOrSubview:sender];
    [UIView animateWithDuration:3.0 animations:^{
        self.detailLabel.alpha = 1.0;
        self.detailLabel.text = [self.idList objectAtIndex:index];
    }];
}

- (void)NameButtonAction:(id)sender
{
    self.detailLabel.alpha = 0.0;
    NSInteger index = [self.SliderView indexOfItemViewOrSubview:sender];
    [UIView animateWithDuration:3.0 animations:^{
        self.detailLabel.alpha = 1.0;
        self.detailLabel.text = [self.namelist objectAtIndex:index];
    }];
}

- (void)shareAction:(id)sender
{
    NSInteger index = [self.SliderView indexOfItemViewOrSubview:sender];
    NSLog(@"%li", (long)index);
    UIButton *faceBook=[UIButton buttonWithType:UIButtonTypeCustom];
    [faceBook setFrame:CGRectMake(05, 05, 90, 50)];
    [faceBook setBackgroundColor:[UIColor clearColor]];
    [faceBook setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [faceBook setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.share addSubview:faceBook];
    [faceBook addTarget:self action:@selector(facebookAction) forControlEvents:UIControlEventTouchUpInside];

    UIButton *twitter=[UIButton buttonWithType:UIButtonTypeCustom];
    [twitter setFrame:CGRectMake(100, 05, 90, 50)];
    [twitter setBackgroundColor:[UIColor clearColor]];
    [twitter setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [twitter setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.share addSubview:twitter];
    [twitter addTarget:self action:@selector(twitterAction) forControlEvents:UIControlEventTouchUpInside];

    if(self.share.hidden == YES)
    {
        self.share.hidden = NO;
        [UIView animateWithDuration:3.0 animations:^{
            self.share.alpha = 1.0;
        }];
    }
    else if (self.share.hidden == NO)
    {
        self.share.hidden = YES;
        [UIView animateWithDuration:3.0 animations:^{
            self.share.alpha = 0.0;
            [self removeImage];
        }];
    }    
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
   if (self.share.hidden == NO)
    {
        self.share.hidden = YES;
        [UIView animateWithDuration:1.0 animations:^{
            self.share.alpha = 0.0;
            [self removeImage];
        }];
    }
    self.detailLabel.text = @" ";
}

- (void)saveImage
{
    //NSInteger index = [self.SliderView indexOfItemViewOrSubview:sender];
    // Get an image from the URL below
    UIImage *image =[[UIImage alloc] initWithData:self.imageData];
    //NSLog(@"%f,%f",image.size.width,image.size.height);
    // Let's save the file into Document folder.
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // If you go to the folder below, you will find those pictures
    //NSLog(@"%@",docDir);
    //NSLog(@"saving png");
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%li.png",docDir,(long)self.count];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data1 writeToFile:pngFilePath atomically:YES];
    NSLog(@"saving image to %@",pngFilePath);
}

- (void)removeImage
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%li.png",docDir, (long)self.count];
    NSError *error = nil;
    if(![fileManager removeItemAtPath: fullPath error:&error])
    {
        NSLog(@"Delete failed:%@", error);
    } else
    {
        NSLog(@"image removed: %@", fullPath);
    }
}

- (void)facebookAction
{
    [self saveImage];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *Facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [Facebook setInitialText:[NSString stringWithFormat: @"uploaded with my sample App"]];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%li.png",docDir,(long)self.count];
        [Facebook addImage:[UIImage imageWithContentsOfFile:pngFilePath]];
        [Facebook addURL:self.photoURL];
        [self presentViewController:Facebook animated:YES completion:Nil];
    }
    else
    {
        UIAlertView *showMessage = [[UIAlertView alloc]initWithTitle:@"INFO" message:@"Not Available" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [showMessage show];
    }
}

- (void)twitterAction
{
    [self saveImage];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *Twitter = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [Twitter setInitialText:[NSString stringWithFormat: @"uploaded with my sample App"]];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%li.png",docDir,(long)self.count];
        [Twitter addImage:[UIImage imageWithContentsOfFile:pngFilePath]];
        [Twitter addURL:self.photoURL];
        [self presentViewController:Twitter animated:YES completion:nil];
    }
    else
    {
        UIAlertView *showMessage = [[UIAlertView alloc]initWithTitle:@"INFO" message:@"Not Available" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [showMessage show];
    }
}

@end
