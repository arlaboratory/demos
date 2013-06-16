//
//  ViewController.h
//  HelloImageMatching
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CVSDK/ImageTracker.h>
#import <3dEngine/EAGLView.h>
#import <QuartzCore/QuartzCore.h>


@interface ViewController : UIViewController<trackerProtocol>
{
    ImageTracker* _imageTracker;
    UIAlertView *alert;

}

@property (nonatomic, assign) BOOL memoryWarning;

/**
 *
 *Add images into the library (in background).
 *
 */
-(void)addImagesInLibrary;




@end
