//
//  ProfileEditViewController.h
//  spotted
//
//  Created by BoHuang on 4/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "ViewController.h"
#import "CircleBorderImageView.h"
#import "BorderButton.h"

@interface ProfileEditViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet CircleBorderImageView *imgProfile;
@property (weak, nonatomic) IBOutlet BorderButton *btnCamera;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRetypePassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) UIImage* selectedImage;

@end
