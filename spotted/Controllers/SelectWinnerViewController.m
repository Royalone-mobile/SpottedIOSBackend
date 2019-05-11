//
//  SelectWinnerViewController.m
//  spotted
//
//  Created by BoHuang on 4/13/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "SelectWinnerViewController.h"
#import "AnswerModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Global.h"
#import "GameModel.h"
#import "UserInfo.h"
#import "NetworkParser.h"
#import "MyImageView.h"
@interface SelectWinnerViewController ()
@property (assign, nonatomic) NSUInteger animationsCount;
@property (assign, nonatomic) CGFloat imageWidth;
@property (assign, nonatomic) CGFloat imageHeight;
@end

@implementation SelectWinnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectWinnerCarouse.type = iCarouselTypeCoverFlow2;
    self.selectWinnerCarouse.dataSource  = self;
    self.selectWinnerCarouse.delegate = self;
    self.imageWidth = self.view.frame.size.width /2;
    self.imageHeight = self.imageWidth * 4 /3;

    [self loadAnswers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadAnswers {
    
    GameModel* gameModel = [UserInfo shared].mCurrentGameModel;
    if(self.items == nil){
        self.items = [[NSMutableArray alloc] init];
    }else{
        [self.items removeAllObjects];
    }
    self.items = gameModel.mCurrentRound.mAnswers;
    [self.selectWinnerCarouse reloadData];
    
    NSString *strTask = @"Spotted: ";
    
    if(gameModel.mCurrentRound.mTask!=nil) {
        NSLog(@"Task String = %@", gameModel.mCurrentRound.mTask);
        strTask = [strTask stringByAppendingString:gameModel.mCurrentRound.mTask];
        self.txtTask.text =  strTask;
    }

    /*if(self.items == nil){
        self.items = [[NSMutableArray alloc] init];
    }else{
        [self.items removeAllObjects];
    }
    
    for(int i=0; i<2; i++){
        AnswerModel* answer = [[AnswerModel alloc] init];
        answer.mImageUrl =@"https://image.issuu.com/160528163920-2b0fff95b8b379e2258cdf03e2d3672c/jpg/page_1.jpg";
        answer.mId = @"0";
        answer.mUserId = @"0";
        [self.items addObject:answer];
    }
      [self.selectWinnerCarouse reloadData];*/
}


#pragma mark -Action
- (IBAction)selectWinnerAction:(id)sender {

    AnswerModel* currentSelected = [self.items objectAtIndex:self.selectWinnerCarouse.currentItemIndex];
    
    GameModel* gameModel = [UserInfo shared].mCurrentGameModel;
    
    [[UserInfo shared] setViewRoundResult:gameModel.mId  withRoundIndex:gameModel.mCurrentRound.mId];
    [[NetworkParser shared] onSubmitJudge:[UserInfo shared].mAccount.mId withGameId:gameModel.mId withRoundId:gameModel.mCurrentRound.mId withAnswerId:currentSelected.mId withCompletionBlock:^(id responseObject, NSString *error) {
            NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
            if(error == nil){
            // [navigationArray removeAllObjects];    // This is just for remove all view controller from navigation stack.
                if(navigationArray.count >=2){
                    [navigationArray removeObjectsInRange:NSMakeRange(navigationArray.count -2, 2) ];  //   You can pass your index here
                    self.navigationController.viewControllers = navigationArray;
            
                }
            }else {
                [Global AlertMessage:self Message:error Title:@"Reason"];
            }
    }];

        

}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.items count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
  
    //create new view if no view is available for recycling
    if (view == nil)
    {

        view = [[MyImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageWidth, self.imageHeight)];
        AnswerModel* model = [self.items objectAtIndex:index];
        /*[((UIImageView *)view) sd_setImageWithURL:[NSURL URLWithString:model.mImageUrl] placeholderImage:[UIImage imageNamed:@"splash_back.png"]];*/
        ((MyImageView*) view).clipsToBounds = NO;
        
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.mImageUrl]];
        ((MyImageView*) view).image = [UIImage imageWithData:imageData];
    }
    else
    {
        AnswerModel* model = [self.items objectAtIndex:index];
        /*[((UIImageView *)view) sd_setImageWithURL:[NSURL URLWithString:model.mImageUrl] placeholderImage:[UIImage imageNamed:@"splash_back.png"]];*/
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.mImageUrl]];
        ((MyImageView*) view).image = [UIImage imageWithData:imageData];
        //get a reference to the label in the recycled view
     //   label = (UILabel *)[view viewWithTag:1];
    }
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {

        view = [[MyImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageWidth, self.imageHeight)];
        ((MyImageView*) view).clipsToBounds = NO;
        ((MyImageView *)view).image = [UIImage imageNamed:@"splash_back.png"];
        view.contentMode = UIViewContentModeCenter;
        
    }
    else
    {
        ((MyImageView *)view).image = [UIImage imageNamed:@"splash_back.png"];
        view.contentMode = UIViewContentModeCenter;
    }
    

    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 20.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.selectWinnerCarouse.itemWidth/5);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return self.wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.1;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.selectWinnerCarouse.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSNumber *item = (self.items)[(NSUInteger)index];
    NSLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.selectWinnerCarouse.currentItemIndex));
}


@end
