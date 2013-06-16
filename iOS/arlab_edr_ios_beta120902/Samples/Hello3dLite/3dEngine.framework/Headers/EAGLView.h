//
//  EAGLView.h
//  EAD Framework
//
//  Copyright ARLab. All rights reserved.
//
//  Version 0.11
//

#ifndef EDR_ADVANCED
#define EDR_ADVANCED

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "_ARLab_3d.h" 

/**
 * @brief The 3DR Engine Advanced SDK version is a rendering engine that includes the basic functionality to render complex objects and animations.
 * This version is thought for non 3D expert users. It is a powerful API for animation management, objects transformations, video tools,
 *  texture management, camera and lighting control.
 *
 */

/**
 * @brief Structure containing the result after loading EAD:
 * animation loaded status
 * lights loaded status
 * camera loaded status
 * objects loaded status
 * material loaded status
 * textures loaded status
 * bones loaded status
 * helpers loaded status
 */
typedef struct EAD_RESULT
{
    BOOL    IsAnimationLoaded;
    BOOL    IsLightsLoaded;
    BOOL    IsCamerasLoaded;
    BOOL    IsObjectsLoaded;
    BOOL    IsMaterialLoaded;
    BOOL    IsTexturesLoaded;
    BOOL    IsBonesLoaded;
    BOOL    IsHelpersLoaded;
    __unsafe_unretained NSNumber* EADId;
}EAD_RESULT;

/**
 * @brief Camera types:
 * Trackball: rotates around the center.
 * FPS: is fixed and rotates arount itself.
 *
 */
typedef enum  {
    Trackball,
    FPS,
}EAD_CAMERAS;

/**
 *  Optional protocol
 */
@protocol renderProtocol <NSObject>

@required
/**
 *  @brief Called each rendering frame.
 *  Mandatory if the protocol is implemented.
 */
-(void)frameRendered;

@end

@class UIViewController;

__attribute__((__visibility__("default"))) @interface EAGLView : UIView<NSURLConnectionDataDelegate>
{
    UIViewController __unsafe_unretained *pMainViewController;
}


/**
 * @brief View controller where the GL view is going to be displayed.
 */
@property (nonatomic, assign) UIViewController *pMainViewController;

/**
 *  Callback delegate.
 */
@property (weak, nonatomic) id <renderProtocol> renderDelegate;


/*==================================================
 GENERAL METHODS
 ==================================================*/

/**
 * @brief Init EAGLView.
 *
 * @param frame: view frame rectangle.
 * @param appKey: product API key.
 * @param camera: camera type.
 *
 * @return object instance.
 */
- (id)initWithFrame:(CGRect)frame withAppKey:(NSString*)appKey withCamera:(EAD_CAMERAS)camera ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Start rendering.
 *
 */
- (void)start ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Stop rendering.
 *
 */
- (void)stop ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Creates a new object and generates the model id automatically.
 *
 *  @return model id within NSNumber, -1 if the model was not created.
 */
- (NSNumber*)createModel ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Creates a new object.
 *
 *  @param NSNumber custom modelId. If the id is already taken the system will assign another one.
 *
 *  @return model modelId within NSNumber, -1 if the model was not created.
 */
- (NSNumber*)createModel:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Get model modelId.
 *
 *  @param NSString holding the model name. This name can be retrieved also using the getHierarchyNames function.
 *  @param NSNumber EAD id containing the object to search.
 *
 *  @return model modelId within NSNumber, -1 if the model does not exist.
 */
- (NSNumber*)getModel:(NSString*)modelName witheadId:(NSNumber*)eadId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Remove model from the world.
 *
 *  @param NSNumber model modelId.
 *
 *  @return YES if the model has been successfully removed, NO otherwise.
 */
- (BOOL)removeModel:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Loads EAD 3D object.
 *
 *  @param NSString path: File to load from local resources.
 *
 *  @return the EAD_RESULT struct with the resulting information.
 */
- (EAD_RESULT)loadEAD:(NSString*)path ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 *  @brief Loads EAD 3D object.
 *  @discussion not implemented yet.
 *
 *  @param NSString path: File to load from URL.
 *
 *  @return the EAD_RESULT struct with the resulting information.
 */
- (EAD_RESULT)loadEADfromURL:(NSString*)path ARLAB_AVAILABLE(UNKNOWN);

/**
 * @brief Removes EAD resource for the EADs pool.
 *
 *  @param eadId:  EAD unique ID.
 *
 *  @return YES if the EAD has been successfully removed.
 */
- (BOOL)removeEAD:(NSNumber*)eadId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Gives a list with the names of all objects starting from the object with given eadId.
 *
 *  @param NSNumber eadId:  EAD unique id.
 *
 *  @return NSMutableArray:  The list of names as NSString objects.
 */
- (NSMutableArray*)getHierarchyNames:(NSNumber*)eadId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Gives a list with the names of all the meshes from the object with given eadId.
 *
 *  @param NSNumber eadId:  EAD unique id.
 *
 *  @return NSMutableArray:  The list of meshes as NSString objects.
 */
- (NSMutableArray*)getMeshesNames:(NSNumber*)eadId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 *  @brief Check if a specific object is clicked.
 *
 * @param modelId: object modelId.
 * @param xC: X coord of the click on the screen.
 * @param yC: Y coord of the click on the screen.
 *
 * @return YES if object is clicked, NO is object is not clicked.
 */
- (BOOL)isObjectClicked:(NSNumber*)modelId xClick:(NSNumber*)xC yClick:(NSNumber*)yC ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 *  @brief add target/action for click event to modelId object.
 *  You can call this multiple times and you can specify multiple target/actions for a particular click event.
 *
 * @param target: target where you implemented the selector.
 * @param action: action to perform once the event is triggered.
 * @param modelId: object modelId.
 *
 * @return YES the target has been successfully added.
 */
- (BOOL)addTarget:(id)target withAction:(SEL)action withModeId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief remove the target/action for a set of click events.
 *
 * @param target: target where you implemented the selector.
 * @param modelId: object modelId. Pass NULL to remove all the click events associated to the target.
 *
 * @return YES the target has been successfully removed.
 */
- (BOOL)removeTarget:(id)target withModeId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Attach an EAD object.
 *
 *  @param eadId: EAD id.
 *  @param modelId: model unique id.
 *
 *  @return YES if the EAD has been successfully attached.
 */
- (BOOL) attachEAD:(NSNumber*)eadId withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Detach an EAD object.
 *
 *  @param eadId: EAD id.
 *  @param modelId: model unique id.
 *
 *  @return YES if the EAD has been successfully detached.
 */
- (BOOL) detachEAD:(NSNumber*)eadId withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/*==================================================
 TEXTURE METHODS
 ==================================================*/

/**
 * @brief Returns a list of textures from the object with given eadId.
 *
 *  @param modelId: model unique id.
 *
 *  @return NSMutableArray with the list of textures.
 */
- (NSMutableArray*)getTexturesList:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Replaces an existing texture with a new texture.
 *
 *  @param modelId: model unique id.
 *  @param NSString oldTexture: The name of the existing texture.
 *  @param NSString newTexture: Full path to the new texture.
 *
 *  @return YES if the texture has been successfully replaced.
 */
- (BOOL) replaceTexture:(NSNumber*)modelId oldTexture:(NSString*)oldTxt newTexture:(NSString*)newTxt ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 *  @brief Set Model Visibility.
 *
 *  @param modelId: model unique id.
 *  @param BOOL visible: YES to show the model, NO to hide it.
 *  @param BOOL applyToChildren: YES to affect the children.
 *
 *  @return YES if successfully hidden.
 */
- (BOOL) setVisibilityForHierarhchy:(BOOL)visible applyToChildren:(BOOL)applyToChildren withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/*==================================================
 TRANSFORMATIONS METHODS
 ==================================================*/

/**
 * @brief Set Model position.
 *
 *  @param objPosition  (x,y,z) vector.
 *  @param modelId: model unique id.
 *
 *  @return YES if the model position has been successfully set.
 */
- (BOOL)setModelPosition:(NSArray*)objPosition withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Set Model scale.
 *
 *  @param objScale (x,y,z) vector.
 *  @param modelId: model unique id.
 *
 *  @return YES if the model scale has been successfully set.
 */
- (BOOL)setModelScale:(NSArray*)objScale withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Set Model rotation.
 *
 *  @param objRot in degrees  (x,y,z) vector.
 *  @param modelId: model unique id.
 *
 *  @return YES if the model rotation has been successfully set.
 */
- (BOOL)SetModelRotation:(NSArray*)objRot withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Set Model matrix.
 *
 *  @param objRotation 4x4 model matrix.
 *  @param modelId: model unique id.
 *
 *  @return YES if the model matrix has been successfully set.
 */
- (BOOL)setModelMatrix:(NSArray*)objRotation withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Get Model position.
 *
 *  @param modelId: model unique id.
 *
 *  @return (x,y,z) vector.
 */
- (NSArray*)getModelPosition:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 *  Sets the rotation offsets of the scene.
 *
 * @param vRot: the rotation angles.
 * @param modelId: model unique id.
 */
- (BOOL) SetRotationsOffset:(NSArray*)vRot withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/*==================================================
 ANIMATION METHODS
 ==================================================*/

/**
 * @brief Stop model animation.
 *
 * @param applyToChildren: YES to apply to object children, NO otherwise.
 * @param modelId: model unique id.
 *
 *  @return YES if the animation has been successfully stopped.
 */
- (BOOL) stopAnimation:(BOOL)applyToChildren withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Pause model animation.
 *
 * @param applyToChildren: YES to apply to object children, NO otherwise.
 * @param modelId: model unique id.
 *
 *  @return YES if the animation has been successfully paused.
 */
- (BOOL) pauseAnimation:(BOOL)applyToChildren withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Resume model animation.
 *
 * @param applyToChildren: YES to apply to object children, NO otherwise.
 * @param modelId: model unique id.
 *
 *  @return YES if the animation has been successfully resumed.
 */
- (BOOL) resumeAnimation:(BOOL)applyToChildren withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Set animation to an object.
 *
 * @param animName: animation name. Can be retrieved using getAnimationsList function.
 * @param modelId: model unique id.
 *
 * @return YES if the animation has been properly set, NO otherwise.
 */
- (BOOL) setAnimation:(NSString*)animName withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Play model animation.
 *
 * @param applyToChildren: YES to apply to object children, NO otherwise.
 * @param modelId: model unique id.
 *
 *  @return YES if the animation has been successfully started.
 */
- (BOOL) playAnimation:(BOOL)applyToChildren withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Set animation speed.
 *
 *  @param applyToChildren: YES to apply to object children, NO otherwise.
 *  @param speed: 1.0f for normal speed.
 *				   fSpeed > 1.0f makes the animation run faster.
 *				   fSpeed < 1.0f makes the animation run slower.
 *				   fSpeed < 0.0f makes the animation run backwards.
 *  @param modelId: model unique id.
 *
 *  @return YES if the animation speed has been successfully set.
 */
- (BOOL) SetAnimationSpeed:(BOOL)applyToChildren speed:(NSNumber*)speed withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/** @brief Get the float representing the speed.
 *
 *  @param modelId: model unique id.
 *
 *  @return float representation of the speed.
 */
- (NSNumber*)getAnimationSpeed:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Set if animation loops.
 *
 * @param loop YES the animation will enter in loop mode, NO the animation will not loop once completed.
 * By default all animations starts with loop mode on.
 *  @param modelId: model unique id.
 *
 *  @return YES if the animation loop has been successfully.
 */
- (BOOL)setAnimationLoop:(BOOL)loop withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Returns a list of animations the object has.
 *
 *  @param modelId: model unique id.
 *
 *  @return NSMutableArray: A list of NSString objects with the animations names.
 */
- (NSMutableArray*)getAnimationsList:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);

/*==================================================
 VIDEO METHODS
 ==================================================*/

/**
 * @brief Attach a Video object. On this version, we automatically replace the video texture
 *	with the current diffuse textures. Detaching the video will remove all the diffuse textures from the model.
 *  @discussion not implemented yet.
 *
 *  @param eadId: EAD unique id.
 *  @param modelId: model unique id.
 *
 *  @return YES if the video has been successfully attached.
 */
- (BOOL)attachVideo:(NSNumber*)eadId withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(UNKNOWN);

/**
 * @brief Detach the Video object. Detaching the video will remove all the diffuse textures from the model.
 *  @discussion not implemented yet.
 *
 *  @param modelId: model unique id.
 *
 *  @return YES if the video has been successfully detached.
 */
- (BOOL)detachVideo:(NSNumber*)modelId ARLAB_AVAILABLE(UNKNOWN);

/**
 * @brief Play video.
 *  @discussion not implemented yet.
 *
 *  @param modelId: model unique id.
 *
 *  @return YES if the video has been successfully started or resumed.
 */
- (BOOL)playVideo:(NSNumber*)modelId ARLAB_AVAILABLE(UNKNOWN);

/**
 * @brief Pause video.
 *  @discussion not implemented yet.
 *
 *  @param modelId: model unique id.
 *
 *  @return YES if the video has been successfully paused.
 */
- (BOOL)pauseVideo:(NSNumber*)modelId ARLAB_AVAILABLE(UNKNOWN);

/**
 * @brief Stop video.
 *  @discussion not implemented yet.
 *
 *  @param modelId: model unique id.
 *
 *  @return YES if the video has been successfully stopped.
 */
- (BOOL)stopVideo:(NSNumber*)modelIdM ARLAB_AVAILABLE(UNKNOWN);

/**
 * @brief Loads video file.
 *  @discussion not implemented yet.
 *
 *  @param NSString path: File to load from local resources.
 *
 *  @return the videoId if successfully loaded, else returns -1.
 */
- (NSNumber*)loadVideo:(NSString*)path ARLAB_AVAILABLE(UNKNOWN);

/**
 * @brief Loads video file.
 *  @discussion not implemented yet
 *
 *  @param NSString path: File to load from URL
 *
 *  @return the videoId if successfully loaded, else returns -1
 */
- (NSNumber*)loadVideoFromURL:(NSString*)path ARLAB_AVAILABLE(UNKNOWN);

/**
 * @brief Removes Video resource from the videos pool.
 *
 *  @param NSNumber videoId:  video unique ID.
 *
 *  @return YES if the video has been successfully removed, NO otherwise.
 */
- (BOOL)removeVideo:(NSNumber*)videoId ARLAB_AVAILABLE(EDR_ADV_120901);

/*==================================================
 CAMERA METHODS
 ==================================================*/

/**
 * @brief Set world camera position.
 *
 *  @param camPos:  (x,y,z) vector.
 *
 *  @return YES if the camera position is properly set.
 *
 */
- (BOOL) setCameraPosition:(NSArray*)camPos ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Set camera target position.
 *
 *  @param camTarPos:  (x,y,z) vector.
 *
 *  @return YES if the camera target position is properly set.
 *
 */
- (BOOL) setCameraTargetPos:(NSArray*)camTarPos ARLAB_AVAILABLE(EDR_ADV_120901);

/**
 * @brief Set camera rotation.
 *
 *  @param rotMatrix:  4x4 matrix.
 *
 *  @return YES if the camera rotation is properly set.
 *
 */
- (BOOL)setCameraRotation:(NSArray*)rotMatrix ARLAB_AVAILABLE(EDR_ADV_120901);


/*==================================================
 LIGHTS METHODS
 ==================================================*/

/**
 *  Sets whether the object will be affected by lights.
 *
 * @param applyToObject: YES object affected by light.
 * @param applyToChildren: YES to apply to object children, NO otherwise.
 * @param modelId: model unique id.
 *
 * @return YES if the lights value has been successfully applied.
 */
- (BOOL) setAffectedByLights:(BOOL)applyToObject applyToChildren:(BOOL)applyToChildren withModelId:(NSNumber*)modelId ARLAB_AVAILABLE(EDR_ADV_120901);


/*==================================================
 PRIVATE API
 ==================================================*/


@property (nonatomic, assign, getter = getLoadingAnimation) BOOL loadingAnimation;
@property (nonatomic, assign, getter = getUseCache) BOOL useCache;
- (void)setTexture:(NSString*)texture;
- (void)setTextureFromUrl:(NSString*)texture;
- (void)setRecPoints:(float*)points:(float)originalW:(float)originalH;
- (void)setRecAlpha:(float)alpha;
- (void)initRectangle;

@end

#endif