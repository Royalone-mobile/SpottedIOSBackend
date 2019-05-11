//
//  CameraCaptureResultViewController.h
//  spotted
//
//  Created by BoHuang on 4/20/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraCaptureResultViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnRetake;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;

@property (nonatomic,strong) UIImage *imgShare;
@end
