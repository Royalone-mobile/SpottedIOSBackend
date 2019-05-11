//
//  SelectWinnerViewController.h
//  spotted
//
//  Created by BoHuang on 4/13/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface SelectWinnerViewController : UIViewController<iCarouselDataSource, iCarouselDelegate>


@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnAlert;
@property (weak, nonatomic) IBOutlet UILabel *txtTask;
@property (weak, nonatomic) IBOutlet iCarousel *selectWinnerCarouse;
@property (nonatomic, assign) BOOL wrap;



@property (strong, nonatomic) NSMutableArray* items;

@property (assign, nonatomic) NSInteger selectedRow;
@property (assign, nonatomic) NSInteger selectedSection;
@end
