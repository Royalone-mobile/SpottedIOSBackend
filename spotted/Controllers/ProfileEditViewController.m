//
//  ProfileEditViewController.m
//  spotted
//
//  Created by BoHuang on 4/14/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "UserInfo.h"
#import "UserModel.h"
#import "UIImage+ImageCompress.h"
#import "NetworkParser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Global.h"

@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(![[UserInfo shared].mCurrentScreenProfile isEqualToString:@"ProfileEditViewController"]){
       [self initView];
    }
    [UserInfo shared].mCurrentScreenProfile =@"ProfileEditViewController";
}
//#progma mark -action

- (IBAction)cameraAction:(id)sender {
    NSString * first = @"Take Photo";
    NSString * second= @"Choose from library";
    NSString * third= @"Cancel";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Menu"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:first style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        //picture
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.allowsEditing = false;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            picker.delegate = self;
            [self presentViewController:picker animated:true completion:nil];
        }else{
            [Global AlertMessage:self Message:@"There is no camera." Title:nil];
        }
        
        
        
    }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:second style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        //picture
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.allowsEditing = false;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [self presentViewController:picker animated:true completion:nil];
        }else{
            [Global AlertMessage:self Message:@"There is no photo library." Title:nil];
        }
        
    }]; // 3
    UIAlertAction *thirdaction = [UIAlertAction actionWithTitle:third style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        
    }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    [alert addAction:thirdaction]; // 5
    
    
    if([alert popoverPresentationController] != nil){
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        [alert popoverPresentationController].sourceView = self.btnCamera;
        [alert popoverPresentationController].sourceRect =  self.btnCamera.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil]; // 6
}
- (IBAction)cancelAction:(id)sender {
    [self sendProfileNotification];
}


- (IBAction)saveAction:(id)sender {
    NSString* userId = [UserInfo shared].mAccount.mId;
    if(userId == nil)
        return;
    if([self validateData]){
        if(self.selectedImage != nil){
            [[NetworkParser shared] onUpdateProfile:userId withImage:self.selectedImage withUsername:self.txtName.text withEmail:self.txtEmail.text withPassword:self.txtPassword.text withCompletionBlock:^(id responseObject, NSString *error) {
                if(error == nil){
                    [self sendProfileNotification];
                }else {
                    [Global AlertMessage:self Message:error Title:@"Reason"];
                }
            }];
        }else  {
            [[NetworkParser shared] onUpdateProfileWithNoImage:userId  withUsername:self.txtName.text withEmail:self.txtEmail.text withPassword:self.txtPassword.text withCompletionBlock:^(id responseObject, NSString *error) {
                if(error == nil){
                    [self sendProfileNotification];
                }else {
                    [Global AlertMessage:self Message:error Title:@"Reason"];
                }
            }];
        }
        
    }
}

- (void) sendProfileNotification{
    
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OpenProfile"
     object:nil];
    
}

- (void) initView{
    UserModel* account = [UserInfo shared].mAccount;
    self.txtName.text = account.mUserName;
    self.txtEmail.text = account.mEmail;
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:account.mPhoto ]
                       placeholderImage:[UIImage imageNamed:@"splash_back.png"]];
}

// MARK: - image picker delegate

-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
    UIImage* image  = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *compressedImage = [UIImage compressImage:image
                                        compressRatio:0.9f];
    self.selectedImage = compressedImage;
    [self.imgProfile setImage:compressedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    /*      */
    // upload current image
    // [Global showIndicator:self];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}


//MARK: - helper

- (bool) validateData {
    if([self.txtName.text isEqualToString:@""] ) {
        [Global AlertMessage:self Message:@"Please enter nickname." Title:@"Alert"];
        return false;
    } else if(![Global NSStringIsValidEmail:self.txtEmail.text] ){
        [Global AlertMessage:self Message:@"Please enter email." Title:@"Alert"];
        return false;
    }else if((![self.txtRetypePassword.text isEqualToString:@""] || ![self.txtPassword.text isEqualToString:@""] ) && ![self.txtPassword.text isEqualToString:self.txtRetypePassword.text]){
        [Global AlertMessage:self Message:@"Password and RetypePassword is not the same." Title:@"Alert"];
        return false;
    }
    return true;

}
@end
