//
//  ViewController.h
//  Woof
//
//  Created by Mattia Campana on 25/01/13.
//  Copyright (c) 2013 nikotia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *loginViewContainer;
@property (weak, nonatomic) IBOutlet UIView *formContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *backgroundTaskIndicator;
@property (weak, nonatomic) IBOutlet UILabel *labelTask;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;


- (IBAction)loginButtonClick:(id)sender;
@end
