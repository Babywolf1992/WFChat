//
//  WFLoginViewController.m
//  WFChat
//
//  Created by babywolf on 17/8/16.
//  Copyright © 2017年 babywolf. All rights reserved.
//

#import "WFLoginViewController.h"
#import "WFXMPPManager.h"
#import "AppDelegate.h"
#import "FriendsListViewController.h"

@interface WFLoginViewController ()

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *hostField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation WFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:@"DIDLogIn" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    headerView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [self.view addSubview:headerView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2.0, 27, 100, 30)];
    label.text = @"登录";
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    
    _usernameField = [[UITextField alloc] initWithFrame:CGRectMake(30, 64+20, self.view.frame.size.width-60, 35)];
    _usernameField.backgroundColor = [UIColor lightGrayColor];
    _usernameField.placeholder = @"用户名";
    _usernameField.layer.cornerRadius = 5;
    [self.view addSubview:_usernameField];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_usernameField.frame)+20, CGRectGetWidth(_usernameField.frame), CGRectGetHeight(_usernameField.frame))];
    _passwordField.backgroundColor = [UIColor lightGrayColor];
    _passwordField.placeholder = @"密码";
    _passwordField.secureTextEntry = YES;
    _passwordField.layer.cornerRadius = 5;
    [self.view addSubview:_passwordField];
    
    _hostField = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_passwordField.frame)+20, CGRectGetWidth(_passwordField.frame), CGRectGetHeight(_passwordField.frame))];
    _hostField.backgroundColor = [UIColor lightGrayColor];
    _hostField.placeholder = @"服务器地址";
    _hostField.layer.cornerRadius = 5;
//    [self.view addSubview:_hostField];
    
    _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-80)/2.0-80, CGRectGetMaxY(_hostField.frame)+30, 80, 40)];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn setTitle:@"注册" forState:UIControlStateHighlighted];
    [_registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-80)/2.0+80, CGRectGetMaxY(_hostField.frame)+30, 80, 40)];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitle:@"登录" forState:UIControlStateHighlighted];
    [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _hostField.text = @"192.168.51.121";
    _usernameField.text = @"abc";
    _passwordField.text = @"123";
}

- (void)loginAction:(UIButton *)sender {
    [WFXMPPManager sharedInstance].isRegister = NO;
    [[WFXMPPManager sharedInstance] loginWithName:_usernameField.text andPassword:_passwordField.text];
}

- (void)registerAction:(UIButton *)sender {
    [WFXMPPManager sharedInstance].isRegister = YES;
    [[WFXMPPManager sharedInstance] loginWithName:_usernameField.text andPassword:_passwordField.text];
}

- (void)didLogin:(NSNotification *)sender {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    FriendsListViewController *listVC = [[FriendsListViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listVC];
    delegate.window.rootViewController = nav;
    [delegate.window makeKeyAndVisible];
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
