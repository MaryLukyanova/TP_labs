//
//  ViewController.h
//  lab07_1
//
//  Created by Admin on 07.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIActionSheetDelegate>{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}

@property (strong, nonatomic) IBOutlet UIButton *pencilPressed;
@property (strong, nonatomic) IBOutlet UIButton *save;

@property (strong, nonatomic) IBOutlet UIButton *settings;
@property (strong, nonatomic) IBOutlet UIButton *reset;
@property (strong, nonatomic) IBOutlet UISlider *brushControl;
@property (strong, nonatomic) IBOutlet UILabel *brushValueLabel;
@property (strong, nonatomic) IBOutlet UIImageView *brushPreview;

@end

