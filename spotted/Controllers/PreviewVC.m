//
//  PreviewVC.m
//  CameraView
//

#import "PreviewVC.h"
#import "Global.h"

@interface PreviewVC ()

@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIView *belowTopBarview;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;

@end

@implementation PreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _imgPreview.image = _imgShare;
    
    _topBarView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.80];
    _belowTopBarview.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.40];
    
    [_lbl2 setFont:[UIFont italicSystemFontOfSize:20]];
    [_lbl1 setFont:[UIFont boldSystemFontOfSize:16]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnRetakeClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSumbitClick:(id)sender {
    
    [Global switchScreen:self withControllerName:@"JudgeImageViewController"];
}

@end
