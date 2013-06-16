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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IdsImages = [[NSMutableArray alloc] init];
	ArrayTitlesImages = [[NSMutableArray alloc] init];
    
    // Set frame
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    // Init
    _cvView = [[ImageMatcher alloc] initWithAppKey:@"v8EwEmq6omqeHD5YL1oppXaQEJqONbUjXmKNGzuYKQ==" useDefaultCamera:TRUE];
    
    // Register delegate
    _cvView.matcherDelegate = self;
    _cvView.matcherQRDelegate = self;
    
    // Start
    [_cvView start];
    
    // Set filter
    [_cvView setEnableMedianFilter:YES];
    
    // Set image minimum rating required to enter in the pool
    [_cvView setImagePoolMinimumRating:0];
    
    // Set match mode
    [_cvView setMatchMode:matcher_mode_All];
    
    [self.view insertSubview:_cvView.view belowSubview:self.view];
    [self.view bringSubviewToFront:titleLabel];
    
    //Add images into the library
    alert = [[UIAlertView alloc] initWithTitle:@"Loading" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(142,70);
    [spinner startAnimating];
    [alert addSubview:spinner];
    [alert show];
    [self performSelectorInBackground:@selector(addImagesInLibrary) withObject:nil];
    
    // Set crop rect if you want, the framework will onlt process whats inside it.
    //[self createImageMatcherCropRect:CGRectMake(50, 200, 150, 200)];
    
    //[self createROIs];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Some test functions to check out if the images have been successfully added to the pool //////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)addImagesInLibrary{
    // Add images to the pool
    //[self addImageToPool:@"pic2.jpeg" withUniqueID:[NSNumber numberWithInt:112] withTitle:@"pic2"];
    [self addImageToPoolFromData:@"ARLab@pic2jpegdetector_data" withTitle:@"pic2"];
    
    // You can also use your own ids
    [self addImageToPool:@"pic3.jpeg"  withTitle:@"pic3"];
    
    //    // Or from an internet URL
    [self addImageToPoolWithURL:@"http://mw2.google.com/mw-panoramio/photos/medium/65201277.jpg"  withTitle:@"grey_house"];
    [self addImageToPoolWithURL:@"http://vipdictionary.com/img/blue_sky_1920.jpg"  withTitle:@"blue_sky"];
    
    //
    //    // Add more images to the pool
    //[self addImageToPool:@"pic4.jpeg" withTitle:@"pic4"];
    [self addImageToPoolFromData:@"ARLab@43_pic8jpeg" withTitle:@"pic8"];
    [self addImageToPoolFromData:@"ARLab@pic9jpeg" withTitle:@"pic9"];
    [self addImageToPoolFromData:@"ARLab@pic16jpeg" withTitle:@"pic16"];
    //[self addImageToPool:@"pic5.jpeg" withTitle:@"pic5"];
    [self addImageToPoolFromData:@"ARLab@pic5jpegdetector_data" withTitle:@"pic5"];
    [self addImageToPool:@"pic6.jpeg" withTitle:@"pic6"];
    [self addImageToPool:@"pic7.jpeg" withTitle:@"pic7"];
    [self addImageToPool:@"pic8.jpeg" withTitle:@"pic8"];
    //    [self addImageToPool:@"pic9.jpeg" withTitle:@"pic9"];
    //    [self addImageToPool:@"pic10.jpeg" withTitle:@"pic10"];
    //    [self addImageToPool:@"pic11.jpeg" withTitle:@"pic11"];
    //    [self addImageToPool:@"pic12.jpeg" withTitle:@"pic12"];
    //    [self addImageToPool:@"pic13.jpeg" withTitle:@"pic13"];
    //    [self addImageToPool:@"pic14.jpeg" withTitle:@"pic14"];
    //    [self addImageToPool:@"pic15.jpeg" withTitle:@"pic15"];
    //    [self addImageToPool:@"pic16.jpeg" withTitle:@"pic16"];
    //    [self addImageToPool:@"pic17.jpeg" withTitle:@"pic17"];
    //    [self addImageToPool:@"pic18.jpeg" withTitle:@"pic18"];
    //    [self addImageToPool:@"pic19.jpeg" withTitle:@"pic19"];
    //    [self addImageToPool:@"pic20.jpeg" withTitle:@"pic20"];
    //    [self addImageToPool:@"pic21.jpeg" withTitle:@"pic21"];
    //    [self addImageToPool:@"pic22.jpeg" withTitle:@"pic22"];
    //    [self addImageToPool:@"pic23.jpeg" withTitle:@"pic23"];
    //    [self addImageToPool:@"pic24.jpeg" withTitle:@"pic24"];
    //    [self addImageToPool:@"pic25.jpeg" withTitle:@"pic25"];
    //    [self addImageToPool:@"pic26.jpeg" withTitle:@"pic26"];
    //    [self addImageToPool:@"pic27.jpeg" withTitle:@"pic27"];
    //    [self addImageToPool:@"pic28.jpeg" withTitle:@"pic28"];
    //    [self addImageToPool:@"pic29.jpeg" withTitle:@"pic29"];
    //    [self addImageToPool:@"pic30.jpeg" withTitle:@"pic30"];
    //    [self addImageToPool:@"pic31.jpeg" withTitle:@"pic31"];
    //    [self addImageToPool:@"pic33.jpeg" withTitle:@"pic33"];
    //    [self addImageToPool:@"pic34.jpeg" withTitle:@"pic34"];
    //    [self addImageToPool:@"pic35.jpeg" withTitle:@"pic35"];
    //    [self addImageToPool:@"pic36.jpeg" withTitle:@"pic36"];
    //    [self addImageToPool:@"pic37.jpeg" withTitle:@"pic37"];
    //    [self addImageToPool:@"pic38.jpeg" withTitle:@"pic38"];
    
    [self performSelectorOnMainThread:@selector(removeAlertWithSpinner) withObject:nil waitUntilDone:YES];
}

-(void)removeAlertWithSpinner{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)addImageToPool:(NSString*)img withTitle:(NSString*)titleImage{
    
    NSNumber* res = [_cvView addImage:[UIImage imageNamed:img]];
    NSLog(@"*** Image named %@, with id %d %@ ***", img, [res intValue], [res intValue] != -1 ? @"ADDED":@"NOT ADDED");
    [IdsImages addObject:res];
    [ArrayTitlesImages addObject:titleImage];
}

-(void)addImageToPoolFromData:(NSString*)img withTitle:(NSString*)titleImage{
    
    NSNumber* res = [_cvView addImageFromData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:img ofType:@"dat"]]];
    NSLog(@"*** Image named %@, with id %d %@ ***", img, [res intValue], [res intValue] != -1 ? @"ADDED":@"NOT ADDED");
    [IdsImages addObject:res];
    [ArrayTitlesImages addObject:titleImage];
}

-(void)addImageToPoolWithURL:(NSString*)imgPath withTitle:(NSString*)titleImage{
    
    NSNumber* res = [_cvView addImageFromUrl:[NSURL URLWithString:imgPath]];
    NSLog(@"*** Image named %@, with id %d %@ ***", imgPath, [res intValue], [res intValue] != -1 ? @"ADDED":@"NOT ADDED");
    [IdsImages addObject:res];
    [ArrayTitlesImages addObject:titleImage];
}

-(void)addImageToPool:(NSString*)img withUniqueID:(NSNumber*)uId withTitle:(NSString*)titleImage{
    
    BOOL res = [_cvView addImage:[UIImage imageNamed:img] withUniqeID:uId];
    NSLog(@"*** %@ ***", res ? @"ADDED" : @"NOT ADDED");
    [IdsImages addObject:uId];
    [ArrayTitlesImages addObject:titleImage];
    
}

-(void)createROIs{
    // Add ROIs to match several QR codes a time
    Roi *r1 = [[Roi alloc] initWithRect:CGRectMake(0, 0, 160, 240)];
    Roi *r2 = [[Roi alloc] initWithRect:CGRectMake(0, 240, 160, 240)];
    Roi *r3 = [[Roi alloc] initWithRect:CGRectMake(160, 0, 160, 240)];
    Roi *r4 = [[Roi alloc] initWithRect:CGRectMake(160, 240, 160, 240)];
    
    //Draw the regions of the ROIs
    [self Createview:CGRectMake(0, 0, 160, 240)];
    [self Createview:CGRectMake(0, 240, 160, 240)];
    [self Createview:CGRectMake(160, 0, 160, 240)];
    [self Createview:CGRectMake(160, 240, 160, 240)];
    
    [_cvView addQrRoi:r1];
    [_cvView addQrRoi:r2];
    [_cvView addQrRoi:r3];
    [_cvView addQrRoi:r4];
}

-(void)createImageMatcherCropRect:(CGRect)sizeRect{
    // Set crop rect if you want, the framework will onlt process whats inside it.
    [_cvView setImageCropRect:sizeRect];
    [self Createview:sizeRect];
}

-(void)Createview:(CGRect)sizeRect{
    LineView *myview = [[LineView alloc] init];
    myview.frameRect = sizeRect;
    myview.frame = [UIScreen mainScreen].bounds;
    myview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myview];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark cv sdk delegates

-(void)imageRecognitionResult:(int)uId
{
    if(uId != -1){
        NSLog(@"***MATCH - Image id:*** %d", uId);
        IDImage = uId;
        [self performSelectorOnMainThread:@selector(addTitle) withObject:nil waitUntilDone:YES];
    }
}

-(void)singleQRrecognitionResult:(NSString *)code
{
    NSLog(@"***QR Info:*** %@",code);
}

-(void)multipleQRrecognitionResult:(NSArray*)codes
{
    NSString *code = @"";
    for (int i = 0; i < [codes count]; i++) {
        Roi *roi = [codes objectAtIndex:i];
        code = [code stringByAppendingString:roi.qrString];
        NSLog(@"*** QR multiple info *** %@ \n", [codes objectAtIndex:i]);
    }
}

-(void)addTitle{
    [timerTitle invalidate];
    timerTitle = nil;
    timerTitle = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeTitle) userInfo:nil repeats:NO];
    NSString *titleString;
    for(int i=0; i<[IdsImages count]; i++){
        if(IDImage == [[IdsImages objectAtIndex:i]intValue]){
            titleString = [ArrayTitlesImages objectAtIndex:i];
            break;
        }
    }
    if(titleString != nil)
        [titleLabel setText:titleString];
}

-(void)addCode:(NSString*)code{
    [timerTitle invalidate];
    timerTitle = nil;
    timerTitle = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeTitle) userInfo:nil repeats:NO];
    [titleLabel setText:code];
}

-(void)removeTitle{
    [titleLabel setText:@""];
    timerTitle = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
