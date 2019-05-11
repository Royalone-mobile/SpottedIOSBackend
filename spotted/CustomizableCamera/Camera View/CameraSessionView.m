//
//  CACameraSessionDelegate.h
//
//  Created by Christopher Cohen & Gabriel Alvarado on 1/23/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "CameraSessionView.h"
#import "CaptureSessionManager.h"
#import <ImageIO/ImageIO.h>

//Custom UI classes
#import "CameraShutterButton.h"
#import "CameraToggleButton.h"
#import "CameraFlashButton.h"
#import "CameraDismissButton.h"
#import "CameraFocalReticule.h"
#import "Constants.h"
#import "CameraViewController.h"
#import "UserInfo.h"
#import "macros.h"

@interface CameraSessionView () <CaptureSessionManagerDelegate,UIGestureRecognizerDelegate>
{
    //Size of the UI elements variables
    CGSize shutterButtonSize;
    CGSize topBarSize;
    CGSize barButtonItemSize;
    CGSize screenSize;
    
    //HHT
    CGSize bottomBarSize;
    CGSize belowTopBarSize;
    //Variable vith the current camera being used (Rear/Front)
    CameraType cameraBeingUsed;
}

//Primative Properties
@property (readwrite) BOOL animationInProgress;

@property (nonatomic, strong) CameraViewController *camVw;

//Object References
@property (nonatomic, strong) CaptureSessionManager *captureManager;

@property (nonatomic, strong) CameraShutterButton *cameraShutter;
@property (nonatomic, strong) CameraToggleButton *cameraToggle;
@property (nonatomic, strong) CameraFlashButton *cameraFlash;
@property (nonatomic, strong) CameraDismissButton *cameraDismiss;
@property (nonatomic, strong) CameraFocalReticule *focalReticule;
@property (nonatomic, strong) UIView *topBarView;

//HHT
@property (nonatomic, strong) UIView *bottomBarView;
@property (nonatomic, strong) UIView *belowTopBarView;

//Temporary/Diagnostic properties
@property (nonatomic, strong) UILabel *ISOLabel, *apertureLabel, *shutterSpeedLabel;

@property (nonatomic, assign) CGFloat lastScale;
@property (nonatomic, assign) CGFloat currentScale;

@end

@implementation CameraSessionView

-(void)drawRect:(CGRect)rect {
    if (self) {
        _animationInProgress = NO;
        [self setupCaptureManager:RearFacingCamera];
        cameraBeingUsed = RearFacingCamera;
        [self composeInterface];
        
        [[_captureManager captureSession] startRunning];
    }
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

#pragma mark - Setup

-(void)setupCaptureManager:(CameraType)camera {
    
    // remove existing input
    AVCaptureInput* currentCameraInput = [self.captureManager.captureSession.inputs objectAtIndex:0];
    [self.captureManager.captureSession removeInput:currentCameraInput];
    
    _captureManager = nil;
    
    //Create and configure 'CaptureSessionManager' object
    _captureManager = [CaptureSessionManager new];
    
    // indicate that some changes will be made to the session
    [self.captureManager.captureSession beginConfiguration];
    
    if (_captureManager) {
        
        //Configure
        [_captureManager setDelegate:self];
        [_captureManager initiateCaptureSessionForCamera:camera];
        [_captureManager addStillImageOutput];
        [_captureManager addVideoPreviewLayer];
        [self.captureManager.captureSession commitConfiguration];
        
        //Preview Layer setup
        CGRect layerRect = self.layer.bounds;
        [_captureManager.previewLayer setBounds:layerRect];
        [_captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
        
        //Apply animation effect to the camera's preview layer
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.6];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [_captureManager.previewLayer addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
        
        //Add to self.view's layer
        [self.layer addSublayer:_captureManager.previewLayer];
        
        UIPinchGestureRecognizer * pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchToZoomRecognizer:)];
        pinchGR.delegate =self;
        [self addGestureRecognizer:pinchGR];
        //effectiveScale = 1.0;
    }
}

-(void)composeInterface {
    screenSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    /*if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
         screenSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    }else {

    }*/

    //Adding notifier for orientation changes
    //[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    //Define adaptable sizing variables for UI elements to the right device family (iPhone or iPad)
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        //Declare the sizing of the UI elements for iPad
        shutterButtonSize = CGSizeMake(screenSize.width * 0.1, screenSize.width * 0.1);
        topBarSize        = CGSizeMake(screenSize.width, screenSize.height * 0.15);  // 0.06
        barButtonItemSize = CGSizeMake(screenSize.height * 0.04, screenSize.height * 0.04);
        
        //HHT
        bottomBarSize     = CGSizeMake(screenSize.width, screenSize.height * 0.17);
        belowTopBarSize   = CGSizeMake(screenSize.width, screenSize.height * 0.08);
        
    } else
    {
        //Declare the sizing of the UI elements for iPhone
        shutterButtonSize = CGSizeMake(screenSize.width * 0.21, screenSize.width * 0.21);
        topBarSize        = CGSizeMake(screenSize.width, screenSize.height * 0.15); // 0.07
        barButtonItemSize = CGSizeMake(screenSize.height * 0.05, screenSize.height * 0.05);
        
        //HHT
        bottomBarSize     = CGSizeMake(screenSize.width, screenSize.height * 0.18);
        belowTopBarSize   = CGSizeMake(screenSize.width, screenSize.height * 0.08);
    }
    
    //HHT
    _bottomBarView = [UIView new];
    if (_bottomBarView) {
        //Setup visual attribution for bar
        NSLog(@"%f",bottomBarSize.height);
        _bottomBarView.frame  = (CGRect){0,screenSize.height - bottomBarSize.height, bottomBarSize};
        _bottomBarView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.80];
        [self addSubview:_bottomBarView];
    }
    
    //HHT
    _belowTopBarView = [UIView new];
    if (_belowTopBarView) {
        _belowTopBarView.frame  = (CGRect){0,topBarSize.height, belowTopBarSize};
        _belowTopBarView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.40];
        [self addSubview:_belowTopBarView];
    }

    NSString *strTask = @"Spotted: ";
    
    if([UserInfo shared].mCurrentGameModel.mCurrentRound.mTask!=nil)
        strTask = [strTask stringByAppendingString:[UserInfo shared].mCurrentGameModel.mCurrentRound.mTask];
    
    //HHT
    UILabel *lbl2 = [[UILabel alloc] init];
    lbl2.textColor = [UIColor whiteColor];
    [lbl2 sizeToFit];
    [lbl2 setFrame:CGRectMake(0 ,0 , 250, 50)];
    lbl2.center = CGPointMake(_belowTopBarView.center.x, belowTopBarSize.height / 2);
    lbl2.backgroundColor=[UIColor clearColor];
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.userInteractionEnabled=NO;
    
    if([UserInfo shared].mCurrentGameModel != nil && [UserInfo shared].mCurrentGameModel.mCurrentRound != nil && [UserInfo shared].mCurrentGameModel.mCurrentRound.mTask != nil)
        lbl2.text= strTask;
    else
        lbl2.text = @"Something Blue";
    
    [lbl2 setFont:[UIFont italicSystemFontOfSize:20]];
    [_belowTopBarView addSubview:lbl2];
    
    //Create shutter button
    _cameraShutter = [CameraShutterButton new];
    
    if (_captureManager) {
        
        //Button Visual attribution
        _cameraShutter.frame = (CGRect){0,0, shutterButtonSize};
        //_cameraShutter.center = CGPointMake(self.frame.size.width/2, self.frame.size.height*875);
        _cameraShutter.center = CGPointMake(_bottomBarView.frame.size.width/2, _bottomBarView.frame.size.height/2);
        _cameraShutter.tag = ShutterButtonTag;
        _cameraShutter.backgroundColor = [UIColor clearColor];
        
        //HHT change
        
        [_cameraShutter setImage:[UIImage imageNamed:@"camera_button"] forState:UIControlStateNormal];
        //Button target
        [_cameraShutter addTarget:self action:@selector(inputManager:) forControlEvents:UIControlEventTouchUpInside];
        
        //HHT
        [_bottomBarView addSubview:_cameraShutter];
    }
    
    //Create the top bar and add the buttons to it
    _topBarView = [UIView new];
    
    if (_topBarView) {
        
        //Setup visual attribution for bar
        _topBarView.frame  = (CGRect){0,0, topBarSize};
        _topBarView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.80];
        [self addSubview:_topBarView];
        
        //Add the flash button
        _cameraFlash = [CameraFlashButton new];
        if (_cameraFlash) {
            _cameraFlash.frame = (CGRect){10,5, barButtonItemSize};
            
            //HHT change
            
            [_cameraFlash setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
            
            _cameraFlash.center = CGPointMake(20, _topBarView.center.y);
            _cameraFlash.tag = FlashButtonTag;
            if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad ) [_topBarView addSubview:_cameraFlash];
        }
        
        //Add the camera toggle button
        _cameraToggle = [CameraToggleButton new];
        if (_cameraToggle) {
            //HHT change
            _cameraToggle.frame = (CGRect){_topBarView.frame.size.width - 50,5, barButtonItemSize};
            [_cameraToggle setImage:[UIImage imageNamed:@"camera_flip"] forState:UIControlStateNormal];
            _cameraToggle.center = CGPointMake(topBarSize.width - 25, _topBarView.center.y);
            _cameraToggle.tag = ToggleButtonTag;
            [_topBarView addSubview:_cameraToggle];
        }
        
        //Add the camera dismiss button
        _cameraDismiss = [CameraDismissButton new];
        if (_cameraDismiss) {
            _cameraDismiss.frame = (CGRect){0,0, barButtonItemSize};
            _cameraDismiss.center = CGPointMake(20, _topBarView.center.y);
            _cameraDismiss.tag = DismissButtonTag;
            //[_topBarView addSubview:_cameraDismiss];
        }
        
        //Attribute and configure all buttons in the bar's subview
        for (UIButton *button in _topBarView.subviews) {
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(inputManager:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //HHT
    UILabel *lbl1 = [[UILabel alloc] init];
    lbl1.textColor = [UIColor whiteColor];
    [lbl1 setFrame:CGRectMake(0, 0, 200, 50)];
    lbl1.center = _topBarView.center;
    lbl1.backgroundColor=[UIColor clearColor];
    lbl1.userInteractionEnabled=NO;
    lbl1.textAlignment = NSTextAlignmentCenter;
    if([UserInfo shared].mCurrentGameModel != nil && [UserInfo shared].mCurrentGameModel.mGameName != nil)
        lbl1.text= [UserInfo shared].mCurrentGameModel.mGameName;
    else
        lbl1.text = @"Spotted";
    [lbl1 setFont:[UIFont boldSystemFontOfSize:16]];
    [_topBarView addSubview:lbl1];
    
    //Create the focus reticule UIView
    _focalReticule = [CameraFocalReticule new];
    
    if (_focalReticule) {
        _focalReticule.frame = (CGRect){0,0, 60, 60};
        _focalReticule.backgroundColor = [UIColor clearColor];
        _focalReticule.hidden = YES;
        [self addSubview:_focalReticule];
    }
    
    //Create the gesture recognizer for the focus tap
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
    if (singleTapGestureRecognizer) [self addGestureRecognizer:singleTapGestureRecognizer];
    //[self orientationChange];
}

#pragma mark - User Interaction
-(void)inputManager:(id)sender {
    
    //If animation is in progress, ignore input
    if (_animationInProgress) return;
    
    //If sender does not inherit from 'UIButton', return
    if (![sender isKindOfClass:[UIButton class]]) return;
    
    //Input manager switch
    switch ([(UIButton *)sender tag]) {
        case ShutterButtonTag:  [self onTapShutterButton];  return;
        case ToggleButtonTag:   [self onTapToggleButton];   return;
        case FlashButtonTag:    [self onTapFlashButton];    return;
        case DismissButtonTag:  [self onTapDismissButton];  return;
    }
}

- (void)onTapShutterButton {
    
    //Animate shutter release
    [self animateShutterRelease];
    
    //Capture image from camera
    [_captureManager captureStillImage];
}

- (void)onTapFlashButton {
    BOOL enable = !self.captureManager.isTorchEnabled;
    self.captureManager.enableTorch = enable;
}

- (void)onTapToggleButton {
    if (cameraBeingUsed == RearFacingCamera) {
        [self setupCaptureManager:FrontFacingCamera];
        cameraBeingUsed = FrontFacingCamera;
        [self composeInterface];
        [[_captureManager captureSession] startRunning];
        _cameraFlash.hidden = YES;
    } else {
        [self setupCaptureManager:RearFacingCamera];
        cameraBeingUsed = RearFacingCamera;
        [self composeInterface];
        [[_captureManager captureSession] startRunning];
        _cameraFlash.hidden = NO;
    }
}

- (void)onTapDismissButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y*3);
    } completion:^(BOOL finished) {
        [_captureManager stop];
        [self removeFromSuperview];
    }];
}

- (void)focusGesture:(id)sender {
    
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = sender;
        if (tap.state == UIGestureRecognizerStateRecognized) {
            CGPoint location = [sender locationInView:self];
            
            [self focusAtPoint:location completionHandler:^{
                 [self animateFocusReticuleToPoint:location];
             }];
        }
    }
}

#pragma mark - Animation

- (void)animateShutterRelease {
    
    _animationInProgress = YES; //Disables input manager
    
    [UIView animateWithDuration:.1 animations:^{
        _cameraShutter.transform = CGAffineTransformMakeScale(1.25, 1.25);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            _cameraShutter.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
            _animationInProgress = NO; //Enables input manager
        }];
    }];
}

- (void)animateFocusReticuleToPoint:(CGPoint)targetPoint
{
    _animationInProgress = YES; //Disables input manager
    
    [self.focalReticule setCenter:targetPoint];
    self.focalReticule.alpha = 0.0;
    self.focalReticule.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
         self.focalReticule.alpha = 1.0;
     } completion:^(BOOL finished) {
         [UIView animateWithDuration:0.4 animations:^{
              self.focalReticule.alpha = 0.0;
          }completion:^(BOOL finished) {
              
              _animationInProgress = NO; //Enables input manager
          }];
     }];
}

- (void)orientationChange {
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait:
        {
            //Standard device orientation (Portrait)
            [UIView animateWithDuration:0.6 animations:^{
                // CGAffineTransform transform = CGAffineTransformMakeRotation( 0 );
                CGRect layerRect = (CGRect){0,0, CGSizeMake(screenSize.width, screenSize.height)};
                [_captureManager.previewLayer setBounds:layerRect];
                [_captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
                _topBarView.frame  = (CGRect){0,0, topBarSize};
                _belowTopBarView.frame =(CGRect){0,_topBarView.frame.size.height, belowTopBarSize};
                _bottomBarView.frame  = (CGRect){0,screenSize.height - bottomBarSize.height, bottomBarSize};
                //_cameraFlash.transform = transform;
                _cameraFlash.center = CGPointMake(_topBarView.center.x * 0.80, _topBarView.center.y);
                _cameraShutter.center = CGPointMake(_bottomBarView.frame.size.width/2, _bottomBarView.frame.size.height/2);
                // _cameraToggle.transform = transform;
                _cameraToggle.center = CGPointMake(_topBarView.center.x * 1.20, _topBarView.center.y);
                
                _cameraDismiss.center = CGPointMake(20, _topBarView.center.y);
            }];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            //Device orientation changed to landscape left
            [UIView animateWithDuration:0.6 animations:^{
                //CGAffineTransform transform = CGAffineTransformMakeRotation( M_PI_2 );
                _topBarView.frame  = (CGRect){0,0, CGSizeMake(screenSize.height, topBarSize.height)};
                CGRect layerRect = (CGRect){0,0, CGSizeMake(screenSize.height, screenSize.width)};
                [_captureManager.previewLayer setBounds:layerRect];
                [_captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
                _bottomBarView.frame  = (CGRect){screenSize.height - bottomBarSize.height,_topBarView.frame.size.height ,  CGSizeMake(bottomBarSize.height , screenSize.height - _topBarView.frame.size.height)};
                _belowTopBarView.frame = (CGRect){0,_topBarView.frame.size.height, CGSizeMake(screenSize.height- bottomBarSize.height, belowTopBarSize.height)};
                _cameraShutter.center = CGPointMake(_bottomBarView.frame.size.width/2, _bottomBarView.frame.size.height/2);
                //_cameraFlash.transform = transform;
                _cameraFlash.center = CGPointMake(_topBarView.center.x * 1.25, _topBarView.center.y);
                
                //_cameraToggle.transform = transform;
                _cameraToggle.center = CGPointMake(_topBarView.center.x * 1.60, _topBarView.center.y);
                
                _cameraDismiss.center = CGPointMake(_topBarView.center.x * 0.25, _topBarView.center.y);
                //Button target
                [_cameraShutter addTarget:self action:@selector(inputManager:) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            //Device orientation changed to landscape right
            [UIView animateWithDuration:0.6 animations:^{
                //CGAffineTransform transform = CGAffineTransformMakeRotation( - M_PI_2 );
                _topBarView.frame  = (CGRect){0,0, CGSizeMake(screenSize.height, topBarSize.height)};
                CGRect layerRect = (CGRect){0,0, CGSizeMake(screenSize.height, screenSize.width)};
                
                [_captureManager.previewLayer setBounds:layerRect];
                [_captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
                _bottomBarView.frame  = (CGRect){screenSize.height - bottomBarSize.height,_topBarView.frame.size.height ,  CGSizeMake(bottomBarSize.height , screenSize.height - _topBarView.frame.size.height)};
                _belowTopBarView.frame = (CGRect){0,_topBarView.frame.size.height, CGSizeMake(screenSize.height- bottomBarSize.height, belowTopBarSize.height)};
                _cameraShutter.center = CGPointMake(_bottomBarView.frame.size.width/2, _bottomBarView.frame.size.height/2);
                //_cameraFlash.transform = transform;
                _cameraFlash.center = CGPointMake(_topBarView.center.x * 1.25, _topBarView.center.y);
                
                //_cameraToggle.transform = transform;
                _cameraToggle.center = CGPointMake(_topBarView.center.x * 1.60, _topBarView.center.y);
                
                _cameraDismiss.center = CGPointMake(_topBarView.center.x * 0.25, _topBarView.center.y);
                //Button target
                [_cameraShutter addTarget:self action:@selector(inputManager:) forControlEvents:UIControlEventTouchUpInside];
                
            }];
            
        }
            break;
        default:;
    }

}

- (void)orientationChanged:(NSNotification *)notification{
    [self orientationChange];
    //Animate top bar buttons on orientation changes
 }

#pragma mark - Camera Session Manager Delegate Methods

-(void)cameraSessionManagerDidCaptureImage
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(didCaptureImage:)])
            [self.delegate didCaptureImage:[[self captureManager] stillImage]];
        
        if ([self.delegate respondsToSelector:@selector(didCaptureImageWithData:)])
            [self.delegate didCaptureImageWithData:[[self captureManager] stillImageData]];
    }
}

-(void)cameraSessionManagerFailedToCaptureImage {
}

-(void)cameraSessionManagerDidReportAvailability:(BOOL)deviceAvailability forCameraType:(CameraType)cameraType {
}

-(void)cameraSessionManagerDidReportDeviceStatistics:(CameraStatistics)deviceStatistics {
}

#pragma mark  - Zoom Method
-(void) handlePinchToZoomRecognizer:(UIPinchGestureRecognizer*)pinchRecognizer {
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];;
    const CGFloat pinchVelocityDividerFactor = 5.0f;
    
    if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
        NSError *error = nil;
        if ([videoDevice lockForConfiguration:&error]) {
            CGFloat desiredZoomFactor = videoDevice.videoZoomFactor + atan2f(pinchRecognizer.velocity, pinchVelocityDividerFactor);
            // Check if desiredZoomFactor fits required range from 1.0 to activeFormat.videoMaxZoomFactor
            videoDevice.videoZoomFactor = MAX(1.0, MIN(desiredZoomFactor, videoDevice.activeFormat.videoMaxZoomFactor));
            [videoDevice unlockForConfiguration];
        } else {
            NSLog(@"error: %@", error);
        }
    }
}
#pragma mark - Helper Methods

- (void)focusAtPoint:(CGPoint)point completionHandler:(void(^)())completionHandler
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];;
    CGPoint pointOfInterest = CGPointZero;
    CGSize frameSize = self.bounds.size;
    pointOfInterest = CGPointMake(point.y / frameSize.height, 1.f - (point.x / frameSize.width));
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        //Lock camera for configuration if possible
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
                [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
            }
            
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                [device setFocusPointOfInterest:pointOfInterest];
            }
            
            if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [device setExposurePointOfInterest:pointOfInterest];
                [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            [device unlockForConfiguration];
            
            completionHandler();
        }
    }
    else { completionHandler(); }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - API Functions

- (void)setTopBarColor:(UIColor *)topBarColor
{
    _topBarView.backgroundColor = topBarColor;
}

- (void)hideFlashButton
{
    _cameraFlash.hidden = YES;
}

- (void)hideCameraToggleButton
{
    _cameraToggle.hidden = YES;
}

- (void)hideDismissButton
{
    _cameraDismiss.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
