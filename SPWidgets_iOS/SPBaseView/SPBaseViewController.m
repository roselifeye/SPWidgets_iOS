//
//  SPBaseViewController.m
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-04-23.
//  Copyright © 2016 roselifeye. All rights reserved.
//
//  Import MBProcessHUD for displaying process messsage. From https://github.com/jdg/MBProgressHUD


#import "SPBaseViewController.h"
#import "MBProgressHUD.h"
#import "UINavigationItem+CustomItem.h"

#define RGBA(r,g,b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface SPBaseViewController ()

@end

@implementation SPBaseViewController

- (void)addNavBarItem:(NSString *)title
              leftBtn:(BAR_BTN_TYPE)leftBtnType
             rightBtn:(BAR_BTN_TYPE)rightBtnType {
    [self.navigationItem setItemWithTitle:title textColor:RGBA(78, 78, 78, 1) fontSize:23 itemType:center];
    
    if (leftBtnType == BAR_BTN_MENU) {
        CustomBarItem *leftItem = [self.navigationItem setItemWithImage:@"homeBtn" size:CGSizeMake(30, 30) itemType:left];
        [leftItem addTarget:self selector:@selector(menuShow) event:(UIControlEventTouchUpInside)];
    }
    
    if (leftBtnType == BAR_BTN_BACK || leftBtnType == BAR_BTN_BACKALERT || leftBtnType == BAR_BTN_BACKCUSTOM) {
        CustomBarItem *leftItem = [self.navigationItem setItemWithImage:@"backBtn" size:CGSizeMake(30, 30) itemType:left];
        if (leftBtnType == BAR_BTN_BACK)
            [leftItem addTarget:self selector:@selector(goBack) event:(UIControlEventTouchUpInside)];
        else if (leftBtnType == BAR_BTN_BACKALERT)
            [leftItem addTarget:self selector:@selector(goBackWithAlert) event:(UIControlEventTouchUpInside)];
        else
            [leftItem addTarget:self selector:@selector(goBackWithCustom) event:(UIControlEventTouchUpInside)];
        }
    
    if (rightBtnType == BAR_BTN_RIGHT) {
        CustomBarItem *rightItem = [self.navigationItem setItemWithImage:@"addBtn" size:CGSizeMake(30, 30) itemType:right];
        [rightItem setOffset:10];//设置item偏移量(正值向左偏，负值向右偏)
        [rightItem addTarget:self selector:@selector(rightBtnAction) event:(UIControlEventTouchUpInside)];
    }
    
    if (rightBtnType == BAR_BTN_SEND) {
        CustomBarItem *rightItem = [self.navigationItem setItemWithImage:@"SendButton" size:CGSizeMake(30, 30) itemType:right];
        [rightItem setOffset:10];//设置item偏移量(正值向左偏，负值向右偏)
        [rightItem addTarget:self selector:@selector(rightBtnAction) event:(UIControlEventTouchUpInside)];
    }
}

- (void)menuShow {
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBackWithAlert {
    [self showAlertWithMessage:@"Do you want to go back?"];
}

- (void)goBackWithCustom {
}

- (void)rightBtnAction {
    // ReWrite in Child ViewController
}

//  Alert
- (void)showAlertWithMessage:(NSString *)message {
    NSString *title = NSLocalizedString(@"Warning", nil);
    NSString *content = NSLocalizedString(message, nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAnimationLabelWithMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    hud.detailsLabel.font = [UIFont systemFontOfSize:13.0f];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:3.f];
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
