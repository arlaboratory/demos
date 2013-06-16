//
//  ImageTracker.h
//  CVSDK IMT
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//
//  Version 0.11
//

#import "ImageMatcher.h"

@protocol trackerProtocol <NSObject>

@optional

/**
 *  Optional callback: Called when an Image is tracked to new corners.
 *  @param x: point in the polygon representing the images position
 *  @param y: point in the polygon representing the images position
 *  @param z: point in the polygon representing the images position
 *  @param w: point in the polygon representing the images position
 */
-(void)imageCornersChanged:(CGPoint)x :(CGPoint)y :(CGPoint)z :(CGPoint)w ARLAB_AVAILABLE(IMT_120901);

/**
 *  Optional callback: Called when an Image is tracked.
 *  @param matrix: An array of NSNumbers. Size 16.
 *
 *  @discussion NOT IMPLEMENTED
 */
-(void)projectionMatrixChanged:(NSArray*)matrix ARLAB_NOT_AVAILABLE_UNTIL(IMT_120902);

/**
 *  Optional callback: Called when an User touches the tracked image.
 *  @param uId: id of the touched image.
 */
-(void)trackedImageTouched:(NSNumber*)uId ARLAB_AVAILABLE(IMT_120901);

@end

__attribute__((__visibility__("default"))) @interface ImageTracker : ImageMatcher


/**
 *  setTrackedImage: 
 *  Set the image to put ontop of the tracked image
 *  @param image: image to put ontop of the tracked image
 */
- (void) setTrackedImageOverlay:(NSString*)img forImageId:(NSNumber*)uId ARLAB_AVAILABLE(IMT_120901);

/**
 *  setTrackedImageFromURL: 
 *  Set the image from url to put ontop of the tracked image
 *  @param url: url of image to put ontop of the tracked image
 */
- (void) setTrackedImageOverlayFromURL:(NSString *)imgUrl forImageId:(NSNumber*)uId ARLAB_AVAILABLE(IMT_120901);


/**
 *  setTrackedVideo: 
 *  Set the video to put ontop of the tracked image
 *  @param video: image to put ontop of the tracked image
 */
- (void) setTrackedVideo:(NSString*)videoPath forImageId:(NSNumber*)uId withPosterOverlay:(NSString*)posterOverlay ARLAB_AVAILABLE(IMT_120901);

/**
 *  setTrackedVideoFromURL: 
 *  Set the video from url to put ontop of the tracked image
 *  @param url: url of video to put ontop of the tracked image
 */
- (void) setTrackedVideoFromURL:(NSURL *)videoUrl forImageId:(NSNumber*)uId withPosterOverlay:(NSString*)posterOverlay ARLAB_AVAILABLE(IMT_120901);

/**
 *  Callback delegate.
 */
@property (weak, nonatomic) id <trackerProtocol> trackingDelegate;

/**
 *  Use loading for functions:
 *  - setTrackedImageOverlay
 *  - setTrackedVideo
 *  - setTrackedVideoFromURL
 *
 * @discussion loading is displayed always for function:
 * - setTrackedImageOverlayFromURL
 */
@property (nonatomic, assign) BOOL useLoading;

/**
 *  If YES, textures with same name will only be loaded once.
 *  If NO, all the textures will be reloaded.
 */
@property (nonatomic, assign) BOOL useTextureCache;

@end