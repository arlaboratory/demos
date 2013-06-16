//
//  ViewController.m
//  HelloImageMatching
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize memoryWarning;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Set frame
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    // Init
    _imageTracker = [[ImageTracker alloc] initWithAppKey:@"UWr+GthwLByFBG9ebct5PBXgYQB3aUMJnRl1uTnF7og=" useDefaultCamera:TRUE with3DappKey:@"UWr+GthwLByFBG9ebct5PBXgYQB3aUMJnRl1uTnF7og="];
    
    // Register delegate
    [_imageTracker setTrackingDelegate:self];
    
    // Set filter
    [_imageTracker setEnableMedianFilter:YES];
    
    // Set image minimum rating required to enter in the pool
    [_imageTracker setImagePoolMinimumRating:0];
    
        
     
    // Start
    [_imageTracker start];
    
    [self.view addSubview:_imageTracker.view];
    
    [self addImages];
        
    
}
-(void)addImages{
    //Add images into the library
    alert = [[UIAlertView alloc] initWithTitle:@"Loading..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(142,70);
    [spinner startAnimating];
    [alert addSubview:spinner];
    [alert show];
    [self performSelectorInBackground:@selector(addImagesInLibrary) withObject:nil];
    
}
-(void)addImagesInLibrary{
    [self addImageToPoolFromData:@"ARLab@25_Compass500jpgdetector_data" withTitle:@"Compass" andAddImageOnTop:@"Compass500Overlay.png"];
    [self addImageToPoolFromData:@"ARLab@26_PC500jpgdetector_data" withTitle:@"PC" andAddImageOnTop:@"PC500Overlay.png"];
    [self addImageToPoolFromData:@"ARLab@28_Vikingo500jpgdetector_data" withTitle:@"Vikingo" andAddImageOnTop:@"Vikingo500Overlay.png"];
    [self addImageToPoolFromData:@"ARLab@29_Wheel500jpgdetector_data" withTitle:@"Wheel" andAddImageOnTop:@"Wheel500Overlay.png"];
    
    [self performSelectorOnMainThread:@selector(removeAlertWithSpinner) withObject:nil waitUntilDone:YES];
}

-(void)removeAlertWithSpinner{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)addImageToPoolFromData:(NSString*)img withTitle:(NSString*)titleImage andAddImageOnTop:(NSString*)trackImageName{
    
    //If there is a memory warning, don't add the image to the pool
    if(memoryWarning) return;
    NSNumber* res = [_imageTracker addImageFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:img ofType:@"dat"]]];
    if(trackImageName!=nil)
        [_imageTracker setTrackedImageOverlay:trackImageName forImageId:res];
    NSLog(@"*** Image named %@, with id %d %@ ***", img, [res intValue], [res intValue] != -1 ? @"ADDED":@"NOT ADDED");
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark cv sdk delegates


-(void)imageCornersChanged:(CGPoint)x :(CGPoint)y :(CGPoint)z :(CGPoint)w
{
    NSLog(@"************* CORNERS ******************");
    NSLog(@"x0: %f, x1: %f, x2: %f, x3: %f, x4: %f, x5: %f, x6: %f, x7: %f", x.x, x.y, y.x, y.y, z.x, z.y, w.x, w.y);
    NSLog(@"************* CORNERS ******************");
    
}


-(void)trackedImageTouched:(NSNumber *)uId{
    if([uId intValue]!= -1){
        NSLog(@"***MATCH - Image id:*** %d", [uId intValue]);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    UIAlertView *alertMem = [[UIAlertView alloc]
                             initWithTitle:@"Warning"
                             message:@"Your device is low on memory..."
                             delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alertMem show];
    memoryWarning = YES;
}

@end
