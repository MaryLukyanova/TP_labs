//
//  ViewController.m
//  lab07_1
//
//  Created by Admin on 07.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *Canvas;
@property CGPoint lastPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.Canvas.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.Canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.Canvas setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.Canvas.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.Canvas.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (IBAction)pencilPressed:(id)sender {
    
    UIButton * PressedButton = (UIButton*)sender;
    
    switch(PressedButton.tag)
    {
        case 0:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 1:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 255.0/255.0;
            break;
        case 2:
            red = 160.0/255.0;
            green = 82.0/255.0;
            blue = 45.0/255.0;
            break;
        case 3:
            red = 102.0/255.0;
            green = 204.0/255.0;
            blue = 0.0/255.0;
            break;
        case 4:
            red = 255.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 5:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
        case 6:
            red = 255.0/255.0;
            green = 102.0/255.0;
            blue = 0.0/255.0;
            break;
        case 7:
            red = 105.0/255.0;
            green = 105.0/255.0;
            blue = 105.0/255.0;
            break;
        case 8:
            red = 51.0/255.0;
            green = 204.0/255.0;
            blue = 255.0/255.0;
            break;
        case 9:
            red = 102.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
    }
}

- (IBAction)reset:(id)sender {
    
    self.Canvas.image = nil;
    
}

- (IBAction)sliderChanged:(id)sender {
  
        
        brush = self.brushControl.value;
        self.brushValueLabel.text = [NSString stringWithFormat:@"%.1f", brush];
    
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (IBAction)save:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Save to Camera Roll", @"Cancel", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIGraphicsBeginImageContextWithOptions(_Canvas.bounds.size, NO,0.0);
        [_Canvas.image drawInRect:CGRectMake(0, 0, _Canvas.frame.size.width, _Canvas.frame.size.height)];
        UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photoalbum"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}



@end
