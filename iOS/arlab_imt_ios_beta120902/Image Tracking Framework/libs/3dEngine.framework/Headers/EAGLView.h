//
//  EAGLView.h
//  EAD Framework
//
//  Copyright ARLab. All rights reserved.
//
//  Version 0.11
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EAGLView.h"
#import "_ARLab_3d.h"

/**
 * @brief This class lets you create a 3D plain and apply over it a texture
 * User will be able to set its rotation, translation and scale or only the polygon 4 corners.
 *
 * This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
 * The view content is basically an EAGL _sace you render your OpenGL scene into.
 * Note that setting the view non-opaque will only work if the EAGL _sace has an alpha channel.
 */

/**
 * @brief result after loading EAD displaying:
 * Trackball: rotates around the center.
 * FPS: is fixed and rotates arount itself
 * lights loaded status
 */
typedef enum  {
    Trackball,
    FPS,
}EAD_CAMERAS;

@class UIViewController;

@interface EAGLView : UIView<NSURLConnectionDataDelegate, NSURLConnectionDownloadDelegate, NSURLConnectionDelegate>
{    
    UIViewController __unsafe_unretained *pMainViewController;
}

/**
 * @brief View controller where the GL view is going to be displayed
 */
@property (nonatomic, assign) UIViewController *pMainViewController;

/**
 * @brief loading animation is played always when the texture is set from URL,
 * but when loading from resources the user can decide wheter or not to display it.
 * Recommended when setting as texture big images.
 */
@property (nonatomic, assign, getter = getLoadingAnimation) BOOL loadingAnimation;

/**
 * @brief when loading an image as a texture we can decide wheter to
 * save it in cache so next time loading will be faster or not.
 *
 * @discussion to update the texture associated to a target mantaining the same 
 * name, this option must be set to YES, so even with the same name the texture
 * will be loaded a again.
 */
@property (nonatomic, assign, getter = getUseCache) BOOL useCache;

/**
 * @brief Init 3DR Lite library
 *
 * @param appKey: Api Key
 * @param camera: Camera Type
 */
- (id)initWithFrame:(CGRect)frame withAppKey:(NSString*)appKey withCamera:(EAD_CAMERAS)camera ARLAB_AVAILABLE(EDR_LITE_120901);

/**
 * @brief Set polygon texture from local resources.
 *
 * @param texture: texture path.
 */
- (void)setTexture:(NSString*)texture ARLAB_AVAILABLE(EDR_LITE_120901);

/**
 * @brief Set polygon texture from url.
 *
 * @param texture: texture path.
 */
- (void)setTextureFromUrl:(NSString*)texture ARLAB_AVAILABLE(EDR_LITE_120901);

/**
 * @brief Set polygon four corners.
 *
 * @param points: array with the 8 values of the 4 points
 * @param originalW: device screen width
 * @param originalH: device screen height
 */
- (void)setRecPoints:(float*)points:(float)originalW:(float)originalH ARLAB_AVAILABLE(EDR_LITE_120901);

/**
 * @brief Start rendering.
 *
 */
- (void)start ARLAB_AVAILABLE(EDR_LITE_120901);

/**
 * @brief Stop rendering.
 *
 */
- (void)stop ARLAB_AVAILABLE(EDR_LITE_120901);

/**
 * @brief Set alpha for the rectangle
 *
 * @param alpha
 */
- (void)setRecAlpha:(float)alpha ARLAB_AVAILABLE(EDR_LITE_120901);

/**
 * @brief Init plain to place texture
 *
 */
- (void)initRectangle ARLAB_AVAILABLE(EDR_LITE_120901);

@end