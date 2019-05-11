//
//  JudgeImageViewController.m
//  spotted
//
//  Created by BoHuang on 4/20/17.
//  Copyright © 2017 ITLove. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>

#import "ImageShowViewController.h"
#import "AnswerModel.h"
#import "Global.h"
#import "GameModel.h"
#import "UserInfo.h"
#import "MyImageView.h"
#import "CircleBorderImageView.h"

@interface ImageShowViewController ()
@property (strong, nonatomic) UserModel* mWinner;

@end

@implementation ImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.judgeImageScrollView.delegate =self;
    [self loadImages];
    [self initView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Helper
- (void) loadImages{
    if(self.images  == nil){
        self.images = [[NSMutableArray alloc]init];
    }
    
    [self.images removeAllObjects];
    self.mGameModel = [UserInfo shared].mCurrentGameModel;
    if(self.mGameModel == nil)
        return;
    if(self.mRoundModel == nil)
        return;
    
    
    NSString *strTask = @"Spotted: ";
    
    if(self.mRoundModel.mTask !=nil) {
        NSLog(@"Task String = %@", self.mRoundModel.mTask);
        strTask = [strTask stringByAppendingString:self.mRoundModel.mTask];
        self.labTask.text =  strTask;
    }
    
    self.images = self.mRoundModel.mAnswers;

    self.labGameName.text = self.mGameModel.mGameName;
    [self setTitles:0];
}

- (void) initView{
    [self.btnJudge addTarget:self action:@selector(judgeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewjudge setHidden:YES];
    NSMutableDictionary* views = [[NSMutableDictionary alloc] init];
    
    views[@"container"] = self.imagesContainer;
    int i=0;
    if(self.images.count == 0)
        return;
    for (AnswerModel* model in self.images) {
        MyImageView* imageView = [[MyImageView alloc]init];
        //[imageView setImage:[UIImage imageNamed:@"splash_back.png"]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.imagesContainer addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.mImageUrl]
                     placeholderImage:[UIImage imageNamed:@"splash_back.png"]];
        
        NSString* imageName = [NSString stringWithFormat:@"image%i", i];
        views[imageName] = imageView;
        
        i++;
        
    }
    
    NSString* imageName = [NSString stringWithFormat:@"image%i", i];
    UIView* winnerView =  [[UIView alloc] init];
    winnerView.backgroundColor = [UIColor colorWithRed:32/255 green:32/255 blue:32/255 alpha:1];
   
    

    winnerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imagesContainer addSubview:winnerView];

    views[imageName] = winnerView;
    
    NSString* layoutString = @"H:|";
    for(i=0; i<self.images.count+1; i++){
        NSString* imageName = [NSString stringWithFormat:@"image%i", i];
        layoutString = [[[layoutString stringByAppendingString:@"["]stringByAppendingString:imageName]stringByAppendingString:@"]"];
    }
    layoutString = [layoutString stringByAppendingString:@"|"];
    [self.imagesContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:layoutString  options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    
    i=0;
    UserModel* winner = nil;
    for (AnswerModel* model in self.images) {
        NSString* imageName = [NSString stringWithFormat:@"image%i", i];
        MyImageView* imageView =  views[imageName];
        
        NSLayoutConstraint *constraintCentreHeight= [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imagesContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imagesContainer attribute:NSLayoutAttributeHeight multiplier:1.f constant:0];
        NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
        [_imagesContainer addConstraints:[NSArray arrayWithObjects:constraintCentreHeight, constraintHeight, nil]];
        [self.view addConstraints:[NSArray arrayWithObjects: constraintWidth, nil]];
        
        i++;
        UserModel* userModel = [model getAnswerOwner];
        if(self.mRoundModel.mRoundWinner != nil && [self.mRoundModel.mRoundWinner isEqualToString: userModel.mId]) {
            winner = userModel;
        }
    }
    self.mWinner = winner;
    //Add User Image
    imageName = [NSString stringWithFormat:@"image%i", i];
    UIView* userImageBack = views[imageName];
    NSLayoutConstraint *constraintCentreHeight= [NSLayoutConstraint constraintWithItem:userImageBack attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imagesContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:userImageBack attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imagesContainer attribute:NSLayoutAttributeHeight multiplier:1.f constant:0];
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:userImageBack attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
    [_imagesContainer addConstraints:[NSArray arrayWithObjects:constraintCentreHeight, constraintHeight, nil]];
    [self.view addConstraints:[NSArray arrayWithObjects: constraintWidth, nil]];
    
    if(winner != nil) {
    
        CircleBorderImageView* imageView = [[CircleBorderImageView alloc]init];
        imageView.borderWidth = 5;
        imageView.borderColor = [UIColor whiteColor];
        
        //[imageView setImage:[UIImage imageNamed:@"splash_back.png"]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:winner.mPhoto]
                     placeholderImage:[UIImage imageNamed:@"splash_back.png"]];
        [userImageBack addSubview:imageView];
        NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:userImageBack attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [userImageBack addConstraint:xCenterConstraint];
        
        NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:userImageBack attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [userImageBack addConstraint:yCenterConstraint];
        [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute: NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:350]];
        
        // Height constraint
        [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute: NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:350]];
    }
    
}


- (IBAction)swipeInstructionAction:(id)sender {
    self.judgeInstruction.hidden = true;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender{
    //executes when you scroll the scrollView
    CGFloat width = sender.frame.size.width;
    NSInteger page = (sender.contentOffset.x + (0.5f * width)) / width;

    if(page < _images.count)
        [self setTitles:page];
    
    if(page == _images.count){
         [self.viewjudge setHidden:NO];
          [self showWinnerView:YES];
        self.playerName.text = self.mWinner.mUserName;
    }
    
    
}

- (void) setTitles:(long) page {
    AnswerModel* answer = [self.images objectAtIndex:page];
    UserModel* userModel = [answer getAnswerOwner];
    if(userModel != nil){
        self.playerName.text = userModel.mUserName;
        
        if(self.mRoundModel.mRoundWinner != nil && [self.mRoundModel.mRoundWinner isEqualToString: userModel.mId]) {
            [self showWinnerView:YES];
        }else {
            [self showWinnerView:NO];
        }
    }else {
        
        [self showWinnerView:NO];
        
    }
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // execute when you drag the scrollView
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
}

#pragma mark -Action
- (void) judgeAction:(id)sender{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OpenGame"
     object:self.mGameModel];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showWinnerView :(BOOL) visible {
    NSLayoutConstraint *heightConstraint;
    for (NSLayoutConstraint *constraint in self.roundWinnerView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }
    
    if(visible){
        heightConstraint.constant = 40;
        self.roundWinnerView.hidden = false;
    }else {
        heightConstraint.constant = 0;
        self.roundWinnerView.hidden = true;
    }
}

@end
