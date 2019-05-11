//
//  CameraViewController.m
//  CameraWithAVFoundation
//

#import "CameraViewController.h"
#import "CameraSessionView.h"
#import "CameraCaptureResultViewController.h"
#import "PreviewVC.h"
#import "UserInfo.h"

@interface CameraViewController () <CACameraSessionDelegate>

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self launchCamera];
    
}

-(void)launchCamera{
    //Set white status bar
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Instantiate the camera view & assign its frame
    _cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    
    //Set the camera view's delegate and add it as a subview
    _cameraView.delegate = self;
    
    //Apply animation effect to present the camera view
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.6];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[_cameraView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    
    [self.view addSubview:_cameraView];
    
    //____________________________Example Customization____________________________
    //[_cameraView setTopBarColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha: 0.64]];
    //[_cameraView hideFlashButton]; //On iPad flash is not present, hence it wont appear.
    //[_cameraView hideCameraToggleButton];
    //[_cameraView hideDismissButton];
}

-(void)didCaptureImage:(UIImage *)image {
    CameraCaptureResultViewController *prevw = [self.storyboard instantiateViewControllerWithIdentifier:@"CameraCaptureResultViewController"];
    UIImage *rotatedImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0f orientation:UIImageOrientationDown];
    prevw.imgShare = image;
    prevw.modalPresentationCapturesStatusBarAppearance = NO;
    [self.navigationController pushViewController:prevw animated:YES];
}

-(void)didCaptureImageWithData:(NSData *)imageData {
    NSLog(@"CAPTURED IMAGE DATA");
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Show error alert if image could not be saved
    if (error) [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
