//
//  SPBaseViewController.h
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-04-23.
//  Copyright © 2016 roselifeye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BAR_BTN_TYPE){
    BAR_BTN_BACK,       // Back Button
    BAR_BTN_BACKALERT,  // Back Button with Alert
    BAR_BTN_BACKCUSTOM, // Back Button with Customize Back Function
    BAR_BTN_MENU,       // Menu Button
    BAR_BTN_NONE,       // No Button
    BAR_BTN_RIGHT,      // Right Button
    BAR_BTN_SEND        // Send Button
};

@interface SPBaseViewController : UIViewController {

}

/**
 *  This function is the custome define of UINavigationItem.
 *
 *  @param title        NavigationBar Title
 *  @param leftBtnType  LeftBtn Type
 *  @param rightBtnType LeftBtn Type
 */
- (void)addNavBarItem:(NSString *)title leftBtn:(BAR_BTN_TYPE)leftBtnType rightBtn:(BAR_BTN_TYPE)rightBtnType;

// This uses to show UIAlertMessage and includes button 'OK'.
- (void)showAlertWithMessage:(NSString *)message;

// This uses to show Alert Lable and will disappear in 3 seconds.
- (void)showAnimationLabelWithMessage:(NSString *)message;


@end
