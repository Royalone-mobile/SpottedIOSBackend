//
//  JudgeImageViewController.m
//  spotted
//
//  Created by BoHuang on 4/20/17.
//  Copyright © 2017 ITLove. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>

#import "JudgeImageViewController.h"
#import "AnswerModel.h"
#import "Global.h"
#import "GameModel.h"
#import "UserInfo.h"
#import "MyImageView.h"

@interface JudgeImageViewController ()

@end

@implementation JudgeImageViewController

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
    GameModel* gameModel = [UserInfo shared].mCurrentGameModel;
    
    if(gameModel == nil)
        return;
    NSString *strTask = @"Spotted: ";
    
    if(gameModel.mCurrentRound.mTask!=nil) {
        NSLog(@"Task String = %@", gameModel.mCurrentRound.mTask);
        strTask = [strTask stringByAppendingString:gameModel.mCurrentRound.mTask];
        self.labTask.text =  strTask;
    }
    
    self.images = gameModel.mCurrentRound.mAnswers;
    self.labGameName.text = gameModel.mGameName;
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
     NSString* layoutString = @"H:|";
    for(i=0; i<self.images.count; i++){
        NSString* imageName = [NSString stringWithFormat:@"image%i", i];
        layoutString = [[[layoutString stringByAppendingString:@"["]stringByAppendingString:imageName]stringByAppendingString:@"]"];
    }
    layoutString = [layoutString stringByAppendingString:@"|"];
    [self.imagesContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:layoutString  options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    
    i=0;
    for (AnswerModel* model in self.images) {

        NSString* imageName = [NSString stringWithFormat:@"image%i", i];
        MyImageView* imageView =  views[imageName];
        
        NSLayoutConstraint *constraintCentreHeight= [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imagesContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imagesContainer attribute:NSLayoutAttributeHeight multiplier:1.f constant:0];
        NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
        [_imagesContainer addConstraints:[NSArray arrayWithObjects:constraintCentreHeight, constraintHeight, nil]];
        [self.view addConstraints:[NSArray arrayWithObjects: constraintWidth, nil]];

        i++;
        
        
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
    if(page ==  _images.count-1){
        [self.viewjudge setHidden:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // execute when you drag the scrollView
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
}

#pragma mark -Action
- (void) judgeAction:(id)sender{
 
    [Global switchScreen:self withControllerName:@"SelectWinnerViewController"];
}
- (IBAction)backAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareAction:(id)sender {
    
    [Global shareApp:self withButtonView:sender];
}
@end
