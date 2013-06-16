//
//  ViewController.h
//  HelloImageMatching
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CVSDK/ImageMatcher.h>
#import "LineView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController<matcherProtocol, matcherQRProtocol>
{
    ImageMatcher* _cvView;
    NSMutableArray *IdsImages;
    NSMutableArray *ArrayTitlesImages;
    NSTimer *timerTitle;
    IBOutlet UILabel *titleLabel;
    int IDImage;
    UIAlertView *alert;
}

/**
 *
 *Add images into the library (in background).
 *
 */
-(void)addImagesInLibrary;

/**
 *
 *Add an image (which is into the project) into the library.
 *
 *@param [NSString]img Image name.
 *
 *@param [NSString]titleImage Title that the image has got associated.
 *
 */
-(void)addImageToPool:(NSString*)img withTitle:(NSString*)titleImage;

/**
 *
 *Add an image (from an URL) into the library.
 *
 *@param [NSString]img Image url.
 *
 *@param [NSString]titleImage Title that the image has got associated.
 *
 */
-(void)addImageToPoolWithURL:(NSString*)imgPath withTitle:(NSString*)titleImage;

/**
 *
 *Add an image (which is into the project) into the library.
 *
 *@param [NSString]img Image name.
 *
 *@param [NSNumber]uId Image Id.
 *
 *@param [NSString]titleImage Title that the image has got associated.
 *
 */
-(void)addImageToPool:(NSString*)img withUniqueID:(NSNumber*)uId withTitle:(NSString*)titleImage;

/**
 *
 *Create ROIs and add them into the library. Also, draw the regions of the ROIs.
 *
 */
-(void)createROIs;

/**
 *
 *Create a rectangle where the library will detect. Also, draw the rectangle.
 *
 *@param [CGRect]sizeRect Size of the rectangle.
 *
 */
-(void)createImageMatcherCropRect:(CGRect)sizeRect;

/**
 *
 *Draw the rectangle.
 *
 *@param [CGRect]sizeRect Size of the rectangle.
 *
 */
-(void)Createview:(CGRect)sizeRect;

@end
