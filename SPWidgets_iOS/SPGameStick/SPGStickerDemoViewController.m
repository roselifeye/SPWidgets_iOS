//
//  SPGStickerDemoViewController.m
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-04-16.
//  Copyright © 2016 roselifeye. All rights reserved.
//

#import "SPGStickerDemoViewController.h"
#import "SPGameStickController.h"

@interface SPGStickerDemoViewController () <SPGameStickControllerDelegate>

@end

@implementation SPGStickerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SPGameStickController *stickView = [[SPGameStickController alloc] initWithFrame:CGRectMake(100, 100, 128, 128)];
    stickView.delegate = self;
    [self.view addSubview:stickView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SPGameStickController Delegate
- (void)stickValueDidChanged:(SPGameStickController *)gameStick withChangedCoodinate:(CGPoint)coordinate {
    NSLog(@"%f", coordinate.x);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
