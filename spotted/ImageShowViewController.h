//
//  ImageShowViewController.h
//  spotted
//
//  Created by BoHuang on 7/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GameModel.h"
#import "RoundModel.h"
@interface ImageShowViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *judgeInstruction;
@property (weak, nonatomic) IBOutlet UIScrollView *judgeImageScrollView;
@property (strong, nonatomic) NSMutableArray* images;
@property (weak, nonatomic) IBOutlet UIView *imagesContainer;
@property (assign, nonatomic) int startPage;
@property (weak, nonatomic) IBOutlet UIButton *btnJudge;
@property (weak, nonatomic) IBOutlet UIView *viewjudge;
@property (weak, nonatomic) IBOutlet UILabel *labGameName;
@property (weak, nonatomic) IBOutlet UILabel *labTask;
@property (strong, nonatomic) GameModel* mGameModel;
@property (strong, nonatomic) RoundModel* mRoundModel;
@property (weak, nonatomic) IBOutlet UIView *roundWinnerView;
@property (weak, nonatomic) IBOutlet UILabel *playerName;


@end
