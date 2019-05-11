//
//  CameraCaptureResultViewController.m
//  spotted
//
//  Created by BoHuang on 4/20/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "CameraCaptureResultViewController.h"
#import "Global.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "AnswerModel.h"

@interface CameraCaptureResultViewController ()

@end

@implementation CameraCaptureResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgPhoto.image = self.imgShare;
    // Do any additional setup after loading the view.
    NSLog(@"Task String = %@", [UserInfo shared].mCurrentGameModel.mCurrentRound.mTask);
    if([UserInfo shared].mCurrentGameModel != nil && [UserInfo shared].mCurrentGameModel.mCurrentRound != nil &&  [UserInfo shared].mCurrentGameModel.mCurrentRound.mTask != nil) {
        self.taskTitle.text = [@"Spotted: " stringByAppendingString: [UserInfo shared].mCurrentGameModel.mCurrentRound.mTask];
    }

    else
        self.taskTitle.text = @"Spotted: ";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backAction:(id)sender {
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    
    // [navigationArray removeAllObjects];    // This is just for remove all view controller from navigation stack.
    if(navigationArray.count >=2){
        [navigationArray removeObjectsInRange:NSMakeRange(navigationArray.count -2, 2) ];  // You can pass your index here
        self.navigationController.viewControllers = navigationArray;
        
    }
}
- (IBAction)retakeAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitAction:(id)sender {
    
    NSString* userId = [UserInfo shared].mAccount.mId;
    GameModel* gameModel = [UserInfo shared].mCurrentGameModel;
    [Global showIndicator:self];
    [[NetworkParser shared] onSubmitAnswer:self.imgShare withUserId:userId withGameId:gameModel.mId withRoundId:gameModel.mCurrentRound.mId withCompletionBlock:^(id responseObject, NSString *error) {
        [Global stopIndicator:self];
        if(error != nil){
            [Global AlertMessage: self Message:error Title:@"Reason"];

            

        }else {
            NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
            
            // [navigationArray removeAllObjects];    // This is just for remove all view controller from navigation stack.
            if(navigationArray.count >=2){
                [navigationArray removeObjectsInRange:NSMakeRange(navigationArray.count -2, 2) ];  // You can pass your index here
                self.navigationController.viewControllers = navigationArray;
                
            }
            AnswerModel* model = [[AnswerModel alloc] init];
            model.mId = @"";
            model.mImageUrl = @"";
            model.mUserId = userId;
            
            [gameModel.mCurrentRound.mAnswers addObject:model];
        }
        
        
    }];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
