//
//  SPCircleMenuViewController.m
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-04-21.
//  Copyright © 2016 roselifeye. All rights reserved.
//

#import "SPCircleMenuViewController.h"
#import "SPCircleMenu.h"

@interface SPCircleMenuViewController () <SPCircleMenuDelegate> {
    SPCircleMenu *circleMenu;
    NSArray *circleMenusArr;
}

@end

@implementation SPCircleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCircleMenu];
}

- (void)initCircleMenusArray {
    UIImage *circleItemImage = [UIImage imageNamed:@"round_center"];
    SPCircleMenuItem *circleItem1 = [[SPCircleMenuItem alloc] initWithImage:circleItemImage
                                                          highlightedImage:circleItemImage
                                                              ContentImage:nil
                                                   highlightedContentImage:nil];
    SPCircleMenuItem *circleItem2 = [[SPCircleMenuItem alloc] initWithImage:circleItemImage
                                                           highlightedImage:circleItemImage
                                                               ContentImage:nil
                                                    highlightedContentImage:nil];
    SPCircleMenuItem *circleItem3 = [[SPCircleMenuItem alloc] initWithImage:circleItemImage
                                                           highlightedImage:circleItemImage
                                                               ContentImage:nil
                                                    highlightedContentImage:nil];
    
    circleMenusArr = [[NSArray alloc] initWithObjects:circleItem1, circleItem2, circleItem3, nil];
}

- (void)initCircleMenu {
    [self initCircleMenusArray];
    SPCircleMenuItem *cmStartItem = [[SPCircleMenuItem alloc] initWithImage:[UIImage imageNamed:@"round_center"]
                                                             highlightedImage:[UIImage imageNamed:@"round_center"]
                                                                 ContentImage:nil
                                                      highlightedContentImage:nil];
    
    circleMenu = [[SPCircleMenu alloc] initWithFrame:self.view.frame startItem:cmStartItem optionMenus:circleMenusArr];
    circleMenu.startPoint = CGPointMake(50, self.view.bounds.size.height - 80);
    circleMenu.rotateAngle = 0;
    circleMenu.endRadius = 10+[circleMenusArr count]*20;
    circleMenu.farRadius = 10+[circleMenusArr count]*20;
    circleMenu.nearRadius = ([circleMenusArr count]-1)*20;
    circleMenu.menuWholeAngle = M_PI/2;
    circleMenu.delegate = self;
    circleMenu.tag = 0;
    [self.view addSubview:circleMenu];
}

#pragma mark -
#pragma SPCircleMenuDelegate

- (void)SPCircleMenu:(SPCircleMenu *)menu didSelectIndex:(NSInteger)idx {
    NSLog(@"Index: %ld item clicked", (long)idx);
}

- (void)SPCircleMenuDidFinishAnimationClose:(SPCircleMenu *)menu {
    NSLog(@"Circle Menu was closed");
}

- (void)SPCircleMenuDidFinishAnimationOpen:(SPCircleMenu *)menu {
    NSLog(@"Circle Menu was open");
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

@end
