//
//  ViewController.m
//  HNBouncyPlaceholderTextField
//
//  Created by 许浩男 on 16/4/11.
//  Copyright © 2016年 Zakariyya. All rights reserved.
//

#import "ViewController.h"
#import "HNBouncyPlaceholderTextField.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet HNBouncyPlaceholderTextField *nameTextField;
@property (weak, nonatomic) IBOutlet HNBouncyPlaceholderTextField *ageTextField;
@property (weak, nonatomic) IBOutlet HNBouncyPlaceholderTextField *addressTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ageTextField.rightPlaceholder = @"岁";
    self.addressTextField.rightPlaceholder = @"省";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
