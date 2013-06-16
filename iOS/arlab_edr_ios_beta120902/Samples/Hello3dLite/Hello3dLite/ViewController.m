//
//  ViewController.m
//  HelloLib
//
//  Copyright ARLab. All rights reserved.
//

#import "ViewController.h"
// Util math library
#import <3dEngine/CC3GLMatrix.h>

#define HEAD_STEP_ROTATION 360.0/200
#define HEAD_MAX_ROTATION 360.0/10

#define FBOX(x) [NSNumber numberWithFloat:x]
#define IBOX(x) [NSNumber numberWithInt:x]
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ViewController (){
    
    //Objects
    NSNumber* animationObjId;
    NSNumber* modelrootObjId;
    NSNumber* skyDomeOjbId;
    NSNumber* buttonsRootObjId;
    NSNumber* leftButton;
    NSNumber* midButton;
    NSNumber* rightButton;
    
    //Test
    NSNumber* hairId;
    NSNumber* rightLegId;
    NSNumber* leftLegId;
    NSNumber* swordId;
    
    //EADs
    EAD_RESULT girlEADRes;
    EAD_RESULT skyEADRes;
    EAD_RESULT buttonsEADRes;
    
    //Animations
    EAD_RESULT anim1;
    EAD_RESULT anim2;
    EAD_RESULT anim3;
    
    //Lights
    EAD_RESULT lights1;
    
    CMMotionManager *motionManager;
    
    float head_rotation_angle;
    BOOL head_rotation_b;
    
}

@end

@implementation ViewController

@synthesize glView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create our OpenGL view
    glView = [[EAGLView alloc] initWithFrame:self.view.bounds withAppKey:@"O5lYMpcwFWxc/lKNa36Jpjae8gn37mvFxkDHFDeTbYs=" withCamera:FPS];
    glView.pMainViewController = self;
    glView.backgroundColor = [UIColor colorWithRed:0.5f green:1.0f blue:1.0f alpha:0.0f];
    
    // Add it as a subView to the View Controller's view
    [self.view addSubview: glView];
    
    // Bring OpenGL view to front
    [self.view bringSubviewToFront: glView];
    
    // Register delegate
    [glView setRenderDelegate:self];
    
    // Set up
    [self loadEAD];
    
    // Start rendering
    [glView start];
    
    motionManager = [[CMMotionManager alloc] init]; // motionManager is an instance variable
    motionManager.accelerometerUpdateInterval = 0.01; // 100Hz
    [motionManager startDeviceMotionUpdates];
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXMagneticNorthZVertical];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [motionManager stopAccelerometerUpdates];
}

-(void) loadEAD
{
    
    // ModelRoot object
    modelrootObjId = [glView createModel:IBOX(0)];
    
    if( [modelrootObjId isEqualToNumber:IBOX(-1)] )
    {
        // Error: Model was not created
        return;
    }
    
    girlEADRes = [glView loadEAD:@"data/Models/girlscene/girl_model.EAD"];
    
    // Load 3D Model
    if ( [girlEADRes.EADId intValue] > -1 )
	{
        
		if(! [glView attachEAD:girlEADRes.EADId withModelId:modelrootObjId] )
		{
            // Error: Failed to attach the 3D object.
			return;
		}
        
        // Offset
        NSArray * offset = [NSArray arrayWithObjects:
                            FBOX(90.0f),
                            FBOX(0.0f),
                            FBOX(0.0f), nil];
        if(![glView SetRotationsOffset:offset withModelId:modelrootObjId])
            NSLog(@"Error applying rotation offset");
        
        // Animation object
        animationObjId = [glView getModel:@"ctl_girl_root" witheadId:girlEADRes.EADId];
        
        // Some other girl bones
        rightLegId = [glView getModel:@"ctl_leg_R" witheadId:girlEADRes.EADId];
        leftLegId  = [glView getModel:@"ctl_leg_L" witheadId:girlEADRes.EADId];
        swordId    = [glView getModel:@"ctl_sword" witheadId:girlEADRes.EADId];
        
        //Mesh object
        hairId    = [glView getModel:@"m_girl_hair" witheadId:girlEADRes.EADId];
        
        
        anim1 = [glView loadEAD:@"data/Models/girlscene/girl_animation_01.EAD"];
        anim2 = [glView loadEAD:@"data/Models/girlscene/girl_animation_02.EAD"];
        anim3 = [glView loadEAD:@"data/Models/girlscene/girl_animation_03.EAD"];
        
        // Those files only contain the animation so will not load object
        if ( anim1.IsAnimationLoaded )
        {
            NSLog(@"Animation loaded girl_animation_01.EAD");
        }
        
        if ( anim2.IsAnimationLoaded )
        {
            NSLog(@"Animation loaded girl_animation_02.EAD");
        }
        
        if ( anim3.IsAnimationLoaded )
        {
            NSLog(@"Animation loaded girl_animation_03.EAD");
        }
        
        if ([animationObjId intValue] > 0) {
            if([glView setAnimation:@"girl_animation_01" withModelId:animationObjId])
                if([glView playAnimation:YES withModelId:animationObjId])
                    NSLog(@"Animation Playing");
        }
        
	}
    else
    {
        NSLog(@"Error: IsAnimationLoaded %@, IsBonesLoaded %@, IsCamerasLoaded %@, IsHelpersLoaded %@, IsLightsLoaded %@, IsMaterialLoaded %@, IsObjectsLoaded %@, IsTexturesLoaded %@",
              [self printBoolean:girlEADRes.IsAnimationLoaded], [self printBoolean:girlEADRes.IsBonesLoaded],
              [self printBoolean:girlEADRes.IsCamerasLoaded],   [self printBoolean:girlEADRes.IsHelpersLoaded],
              [self printBoolean:girlEADRes.IsLightsLoaded],    [self printBoolean:girlEADRes.IsMaterialLoaded],
              [self printBoolean:girlEADRes.IsObjectsLoaded],   [self printBoolean:girlEADRes.IsTexturesLoaded] );
    }
    
    skyEADRes = [glView loadEAD:@"data/Models/girlscene/skydome.EAD"];
    
    if ( [skyEADRes.EADId intValue] > -1 )
    {
        // Skydome object
        skyDomeOjbId = [glView createModel];
        
        if ([skyDomeOjbId intValue] > -1)
        {
            if(![glView attachEAD:skyEADRes.EADId withModelId:skyDomeOjbId] )
                return; // Error: Failed to attach the 3D object.
        }
        
        // We do not want the skyDome object be affected by light, unlike the main object
        if(![glView setAffectedByLights:FALSE applyToChildren:TRUE withModelId:skyDomeOjbId])
            NSLog(@"Error - setAffectedByLights");
    }
    
    buttonsEADRes = [glView loadEAD:@"data/Models/girlscene/buttons.EAD"];
    
    if ( [buttonsEADRes.EADId intValue] > -1 )
    {
        // Buttons root object
        buttonsRootObjId = [glView createModel];
        
        if ([buttonsRootObjId intValue] > -1)
        {
            if(![glView attachEAD:buttonsEADRes.EADId withModelId:buttonsRootObjId] )
                return; // Error: Failed to attach the 3D object.
        }
        

        // We do not want the buttons be affected by light, unlike the main object
        if(![glView setAffectedByLights:FALSE applyToChildren:TRUE withModelId:buttonsRootObjId])
            NSLog(@"Error - setAffectedByLights");
        
    }
    
    lights1 = [glView loadEAD:@"data/Models/girlscene/girl_lights.EAD"];
    
    if ( [lights1.EADId intValue] < 0 )
    {
        NSLog(@"Error loading girl_lights.EAD");
    }
    
    leftButton  = [glView getModel:@"button01" witheadId:buttonsEADRes.EADId];
    midButton   = [glView getModel:@"button02" witheadId:buttonsEADRes.EADId];
    rightButton = [glView getModel:@"button03" witheadId:buttonsEADRes.EADId];
    
    [glView addTarget:self withAction:@selector(handleClick:) withModeId:leftButton];
    [glView addTarget:self withAction:@selector(handleClick:) withModeId:midButton];
    [glView addTarget:self withAction:@selector(handleClick:) withModeId:rightButton];
    
    // Set camera position, camera target position and model scale
    NSArray * camPos = [NSArray arrayWithObjects:
                        FBOX(0.0f),
                        FBOX(30.0f),
                        FBOX(175.0f), nil];
    
    NSArray * camTargetPos = [NSArray arrayWithObjects:
                              FBOX(0.0f),
                              FBOX(5.0f),
                              FBOX(0.0f), nil];
    
    NSArray * modelScale = [NSArray arrayWithObjects:
                            FBOX(10.0f),
                            FBOX(10.0f),
                            FBOX(10.0f), nil];
    
    
    if(![glView setCameraPosition:camPos])
        NSLog(@"Error setting camera position");
    
    if(![glView setCameraTargetPos:camTargetPos])
        NSLog(@"Error setting camera target position");
    
    if(![glView setModelScale:modelScale withModelId:skyDomeOjbId])
        NSLog(@"Error setting model scale");

}

- (void)handleClick :(NSNotification*)notif
{
    NSNumber *modelId=notif.object;
    // Each button triggers one animation.
    // We first detect if any of the buttons has been clicked.
    // If so, we do play the animation.
    
    if ( [modelId isEqualToNumber:leftButton] )
    {
        if([glView setAnimation:@"girl_animation_01" withModelId:animationObjId])
        {
            if([glView playAnimation:YES withModelId:animationObjId])
            {
                NSLog(@"Playing animation girl_animation_01");
            }
        }
    }else     if ( [modelId isEqualToNumber:midButton] )
    {
        if([glView setAnimation:@"girl_animation_02" withModelId:animationObjId])
        {
            if([glView playAnimation:YES withModelId:animationObjId])
            {
                NSLog(@"Playing animation girl_animation_02");
            }
        }
    }else     if ( [modelId isEqualToNumber:rightButton] )
    {
        if([glView setAnimation:@"girl_animation_03" withModelId:animationObjId])
        {
            if([glView playAnimation:YES withModelId:animationObjId])
            {
                NSLog(@"Playing animation girl_animation_03");
            }
        }
    }
}

#pragma mark -
#pragma mark 3dEngine sdk delegates

-(void)frameRendered
{
    // This callback is called each rendering frame.
    // We apply some basic transformations so the scene will look more real.
     
    
    //Applies the sky rotation
	static float fAngleSky = 0.0f;
    
	if (fAngleSky > 36000.0f)
		fAngleSky = 0.0f;
    
	fAngleSky += 0.75f;
    
    NSArray * skyRot = [NSArray arrayWithObjects:FBOX(0.0f),
                        FBOX(-fAngleSky/10.0f),
                        FBOX(0.0f),
                        nil];
    [glView SetModelRotation:skyRot withModelId:skyDomeOjbId];
    
    
    //Applies the model movement around its position (floating effect)
    static float fAngle = 0.0f; 
    
	if (fAngle > 360.0f)
		fAngle = 0.0f;
    
	fAngle += 0.75f;
    float s = sin(fAngle/8),
    c = cos(fAngle/8);
    
    NSArray * rootPos = [NSArray arrayWithObjects:FBOX(c+s + 10),
                         FBOX(s + c -5),
                         FBOX(s+c + 10),
                         nil];
    [glView setModelPosition:rootPos withModelId:modelrootObjId];
    
    
    // Applies the model orientation depending on device position//
    CMAttitude *currentAttitude = motionManager.deviceMotion.attitude;
    
    // Quaternion
    CC3Vector4 v4;
    v4.x = currentAttitude.quaternion.x;
    v4.y = currentAttitude.quaternion.y;
    v4.z = currentAttitude.quaternion.z;
    v4.w = currentAttitude.quaternion.w;
    
    // TRANSLATION VECTOR
    CC3Vector v;
    v.x = 0.0;
    v.y = 0.0;
    v.z = 0.0;
    
    // SCALE VECTOR
    CC3Vector v2;
    v2.x = 1.0;
    v2.y = 1.0;
    v2.z = 1.0;
    
    CC3GLMatrix *modelMatrix = [CC3GLMatrix matrix];
    [modelMatrix populateFromTranslation:v];
    [modelMatrix populateFromScale:v2];
    
    [modelMatrix rotateByQuaternion:v4];
    
    
    // QUATERNION
    NSArray * m = [NSArray arrayWithObjects:
                   FBOX(modelMatrix.glMatrix[0]), FBOX(modelMatrix.glMatrix[1]), FBOX(modelMatrix.glMatrix[2]), FBOX(modelMatrix.glMatrix[3]),
                   FBOX(modelMatrix.glMatrix[4]), FBOX(modelMatrix.glMatrix[5]), FBOX(modelMatrix.glMatrix[6]), FBOX(modelMatrix.glMatrix[7]),
                   FBOX(modelMatrix.glMatrix[8]), FBOX(modelMatrix.glMatrix[9]), FBOX(modelMatrix.glMatrix[10]), FBOX(modelMatrix.glMatrix[11]),
                   FBOX(modelMatrix.glMatrix[12]), FBOX(modelMatrix.glMatrix[13]), FBOX(modelMatrix.glMatrix[14]), FBOX(modelMatrix.glMatrix[15]),
                   nil];
    
   
    [glView setModelMatrix:m withModelId:modelrootObjId];
    
}

#pragma mark -
#pragma Util Functions

- (NSString*)printBoolean:(BOOL)res
{
    return res ? @"YES" : @"NO";
}

#pragma mark -
#pragma Touch Events


@end
