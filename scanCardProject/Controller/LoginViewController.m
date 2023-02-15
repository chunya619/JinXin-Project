//
//  LoginViewController.m
//  scanCardProject
//
//  Created by 胡淨淳 on 2021/10/21.
//  Copyright © 2021 JXInfo. All rights reserved.
//

#import "LoginViewController.h"
#import "SQLClient.h"

@interface LoginViewController ()

@property (strong, nonatomic) UIActivityIndicatorView* spinner;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _loginButton.backgroundColor = [[UIColor alloc]initWithRed:0.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1.0];
    _loginButton.tintColor = [[UIColor alloc]initWithRed:248.0/255.0 green:248.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    //keyboard controlling
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


#pragma  mark - Login and connect to server

- (IBAction)loginButton:(id)sender {
    NSLog(@"login button pressed.");
    
    NSString *account = _accountTextField.text;
    NSLog(@"account: %@", account);
    NSString *password = _passwordTextField.text;
    NSLog(@"password: %@", password);
    
}


@end
