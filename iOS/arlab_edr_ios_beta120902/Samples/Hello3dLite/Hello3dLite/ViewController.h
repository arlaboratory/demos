//
//  ViewController.h
//  HelloLib
//
//  Copyright ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <3dEngine/EAGLView.h>

@class EAGLView;

@interface ViewController : UIViewController<renderProtocol>{
    
    EAGLView*			glView;
    
}

@property (nonatomic, strong) IBOutlet EAGLView *glView;

@end
