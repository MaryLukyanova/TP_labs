//
//  ViewController.h
//  lab08_1
//
//  Created by Admin on 13.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *cityFrom;
@property (strong, nonatomic) IBOutlet UITextField *cityTo;
//@property (strong, nonatomic) IBOutlet MKMapView *map;

- (IBAction)showFlights:(id)sender;


@end

