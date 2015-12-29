//
//  ViewController.m
//  XWCountryCodeTelePhone
//
//  Created by Edwin on 15/12/28.
//  Copyright © 2015年 EdwinXiang. All rights reserved.
//

#import "ViewController.h"
#import "TYCoutryModel.h"
#import "TYCountryViewController.h"
//屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

//屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//颜色
#define COLOR(_R,_G,_B,_A) [UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:_A]
@interface ViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
/**
 *  输入电话注册
 */
@property (strong, nonatomic) UITextField *teleTextField;

/**
 *  输入密码
 */
@property (strong, nonatomic) UITextField *passwordTextField;

/**
 *  确定按钮
 */
@property (nonatomic,strong) UIButton *OKBtn;

/**
 *  国家地区
 */
@property (nonatomic,strong) UILabel *countryDisLabel;

@property (nonatomic,strong) UILabel *countryNameLabel;

@property (nonatomic,strong)UIView *topBgView;

@property (nonatomic,strong) UITapGestureRecognizer *tap;

@property (nonatomic,strong) UITextField *teleIdField;

@property (nonatomic,copy)NSString *countryName;

@property (nonatomic,strong)NSMutableArray *modelCountryArr;
@end

@implementation ViewController

-(NSMutableArray *)modelCountryArr{
    
    if (_modelCountryArr == nil) {
        _modelCountryArr = [NSMutableArray array];
    }
    return _modelCountryArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = COLOR(239, 239, 239, 1.0);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeRecived:) name:@"country" object:nil];
    
    [self creatUI];
    [self acquireCountryNumID];
}

#pragma mark --读取plist文件--
-(void)acquireCountryNumID{
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"CountyCode" ofType:@"plist"];
    //读取plist文件
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    
    for (NSString *str in dataDic) {
        TYCoutryModel *model = [[TYCoutryModel alloc]init];
        model.countryName = str;
        model.countryTelNum = [dataDic objectForKey:str];
        [self.modelCountryArr addObject:model];
    }
}


#pragma mark -- 通知传值的方法--
-(void)noticeRecived:(NSNotification *)notice{
    
    self.countryName= notice.object[@"countryName"];
    self.countryNameLabel.text = self.countryName;
    self.countryNameLabel.textColor = COLOR(44, 138, 250, 1.0);
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"CountyCode" ofType:@"plist"];
    //读取plist文件
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *number = [dataDic objectForKey:self.countryName];
    NSString *subNum = [NSString stringWithFormat:@"%@",number];
    self.teleIdField.text = subNum;
}

#pragma mark --创建UI界面--
-(void)creatUI{
    
    int _size = ScreenHeight*48/2/1104;
    
    _topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight*162/2/1104)];
    _topBgView.backgroundColor = COLOR(239, 239, 239, 1.0);
    _topBgView.userInteractionEnabled = YES; //开启用户相应
    [self.view addSubview:_topBgView];
    
    //给顶部背景添加点击手势
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    _tap.delegate = self;
    [self.topBgView addGestureRecognizer:_tap];
    
    //国家区号
    _countryDisLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth*60/2/621, 0, ScreenWidth/4, CGRectGetHeight(_topBgView.frame))];
    _countryDisLabel.text = @"国家区号";
    _countryDisLabel.backgroundColor = [UIColor clearColor];
    _countryDisLabel.textColor = COLOR(51, 51, 51, 1.0);
    _countryDisLabel.font = [UIFont systemFontOfSize:_size];
    _countryDisLabel.textAlignment = NSTextAlignmentLeft;
    [self.topBgView addSubview:_countryDisLabel];
    
    //国家名称
    _countryNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-(ScreenWidth*60/2/621)-ScreenWidth/3, 0, ScreenWidth/3, CGRectGetHeight(_topBgView.frame))];
    _countryNameLabel.text = @"中国";
    _countryNameLabel.textAlignment = NSTextAlignmentRight;
    _countryNameLabel.textColor = COLOR(44, 138, 250, 1.0);
    _countryNameLabel.font = [UIFont systemFontOfSize:_size];
    [self.topBgView addSubview:_countryNameLabel];
    
    //国家号码编号
    _teleIdField = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topBgView.frame),ScreenWidth/6 , ScreenHeight*162/2/1104)];
    _teleIdField.backgroundColor = [UIColor whiteColor];
    _teleIdField.borderStyle = UITextBorderStyleNone;
    _teleIdField.textAlignment = NSTextAlignmentLeft;
    _teleIdField.text = @"86";
    _teleIdField.tintColor = [UIColor greenColor];//设置光标颜色
    _teleIdField.font = [UIFont systemFontOfSize:_size];
    _teleIdField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _teleIdField.returnKeyType = UIReturnKeyNext;
    _teleIdField.adjustsFontSizeToFitWidth = YES;
    _teleIdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//设置对齐方式
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth*60/2/1104, CGRectGetHeight(_teleIdField.frame))];
    label.text = @"+";
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:_size];
    self.teleIdField.leftView = label;
    self.teleIdField.leftViewMode = UITextFieldViewModeAlways;
    //给国家号码编码添加监听事件
    [_teleIdField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_teleIdField];
    //输入电话号码
    _teleTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_teleIdField.frame)+1, CGRectGetMaxY(_topBgView.frame),ScreenWidth-ScreenWidth/6, ScreenHeight*162/2/1104)];
    _teleTextField.borderStyle = UITextBorderStyleNone;
    _teleTextField.backgroundColor = [UIColor whiteColor];
    _teleTextField.textAlignment = NSTextAlignmentLeft;
    _teleTextField.placeholder = @"请输入你的手机号";
    _teleTextField.tintColor = [UIColor greenColor];
    _teleTextField.font = [UIFont systemFontOfSize:_size];
    _teleTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _teleTextField.returnKeyType = UIReturnKeyNext;
    _teleTextField.clearsOnBeginEditing = YES;
    _teleTextField.adjustsFontSizeToFitWidth = YES;
    _teleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//设置对齐方式
    _teleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;//一键删除按钮
    
    [self.view addSubview:_teleTextField];
    
    //密码
    _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_teleTextField.frame),ScreenWidth , ScreenHeight*162/2/1104)];
    _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.placeholder = @"请输入新密码";
    _passwordTextField.tintColor = [UIColor greenColor];
    _passwordTextField.font = [UIFont systemFontOfSize:_size];
    _passwordTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _passwordTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.clearsOnBeginEditing = YES;
    _passwordTextField.adjustsFontSizeToFitWidth = YES;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//设置对齐方式
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;//一键删除按钮
    [self.view addSubview:_passwordTextField];
    
    
    //注册按钮
    _OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _OKBtn.frame = CGRectMake(ScreenWidth*60/2/621, CGRectGetMaxY(_passwordTextField.frame)+ScreenHeight*62/2/1104, ScreenWidth - ScreenWidth*60/2/621*2, ScreenHeight*160/2/1104);
    _OKBtn.backgroundColor = [UIColor greenColor];
    _OKBtn.layer.masksToBounds = YES;
    _OKBtn.layer.cornerRadius = 5;
    [_OKBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_OKBtn addTarget:self action:@selector(OKBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _OKBtn.titleLabel.font = [UIFont systemFontOfSize:ScreenHeight*58/2/1104];
    [self.view addSubview:_OKBtn];
    
    //代理方法
    _teleTextField.delegate  = self;
    _teleIdField.delegate = self;
    _passwordTextField.delegate = self;
    
}
#pragma mark --注册--
-(void)OKBtnClick:(UIButton *)btn{
    
    [_passwordTextField resignFirstResponder];
}

#pragma mark --点击手势的方法--
-(void)tapClick{
    TYCountryViewController *countryVc = [[TYCountryViewController alloc]init];
    [self.navigationController pushViewController:countryVc animated:YES];
}

#pragma mark --textField代理方法--
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

//textfield监听事件
-(void)textFieldDidChanged:(UITextField *)textfield{
    
    if (textfield.text.length>0) {
        for (int i = 0; i<self.modelCountryArr.count; i++) {
            TYCoutryModel *model = self.modelCountryArr[i];
            if ([textfield.text isEqualToString:model.countryTelNum]) {
                
                self.countryNameLabel.text = model.countryName;
                self.countryNameLabel.textColor = COLOR(44, 138, 250, 1.0);
                return;
            }else{
                self.countryNameLabel.text = @"国家代码无效";
                self.countryNameLabel.textColor = [UIColor redColor];
            }
        }
    }else {
        NSLog(@"请输入国家编号");
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField ==_teleIdField) {
        //return自动收起键盘
        [self.teleIdField resignFirstResponder];
        [self.teleTextField becomeFirstResponder];
    }else if(textField == _teleTextField){
        
        [self.teleTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }else{
        [self.passwordTextField resignFirstResponder];
    }
    
    return YES;
}
//一键删除按钮的方法
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField.text) {
        //一键删除无效
        return YES;
    }
    //一键删除有效
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
