//
//  UploadViewController.m
//  FacebookLogin
//
//  Created by Apple on 21/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@property (strong, nonatomic) UIAlertView *sharingAlert;

@end

@implementation UploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.imageView.image = [UIImage imageNamed:@"select.png"];
    self.imageView.layer.cornerRadius = 20.0;
    self.imageView.layer.masksToBounds = YES;
    self.shareItButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Selecting Images
- (IBAction)takePhoto:(id)sender
{
    [self removeImage];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *notAvailable = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Could not perform operation" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [notAvailable show];
    }
}

- (IBAction)SelectPhoto:(id)sender
{
    [self removeImage];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *notAvailable = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Could not perform operation" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [notAvailable show];
    }
}

#pragma mark - Sharing Images
- (IBAction)shareIt:(id)sender
{
    self.sharingAlert = [[UIAlertView alloc]initWithTitle:@"Choose the platform" message:@"you like to share this picture" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"FaceBook",@"Twitter", nil];
    [self.sharingAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.sharingAlert)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"Sharing Canceled by user");
        }
        if (buttonIndex == 1)
        {
            [self facebookAction];
        }
        if (buttonIndex == 2)
        {
            [self twitterAction];
        }
    }
}

- (void)facebookAction
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *Facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [Facebook setInitialText:[NSString stringWithFormat: @"uploaded with my sample App"]];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
        [Facebook addImage:[UIImage imageWithContentsOfFile:pngFilePath]];
        [self presentViewController:Facebook animated:YES completion:Nil];
    }
    else
    {
        UIAlertView *notAvailable = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Could not perform operation" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [notAvailable show];
    }
}

- (void)twitterAction
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *Twitter = [SLComposeViewController
                                            composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [Twitter setInitialText:[NSString stringWithFormat: @"uploaded with my sample App"]];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
        [Twitter addImage:[UIImage imageWithContentsOfFile:pngFilePath]];
        [self presentViewController:Twitter animated:YES completion:nil];
    }
    else
    {
        UIAlertView *notAvailable = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Could not perform operation" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [notAvailable show];
    }
}

#pragma mark - Saving and Removing Images
- (void)saveImage
{
    //NSInteger index = [self.SliderView indexOfItemViewOrSubview:sender];
    // Get an image from the URL below
    UIImage *image =self.imageView.image;
    //NSLog(@"%f,%f",image.size.width,image.size.height);
    // Let's save the file into Document folder.
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // If you go to the folder below, you will find those pictures
    //NSLog(@"%@",docDir);
    //NSLog(@"saving png");
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data1 writeToFile:pngFilePath atomically:YES];
    NSLog(@"saving image to %@",pngFilePath);
}

- (void)removeImage
{
    self.imageView.image = [UIImage imageNamed:@"select.png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [NSString stringWithFormat:@"%@/UploadingImage.png.png",docDir];
    NSError *error = nil;
    if(![fileManager removeItemAtPath: fullPath error:&error])
    {
        NSLog(@"Delete failed:%@", error);
    }
    else
    {
        NSLog(@"image removed: %@", fullPath);
    }
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image =selectedImage;
    self.shareItButton.hidden = NO;
    [self saveImage];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

@end
