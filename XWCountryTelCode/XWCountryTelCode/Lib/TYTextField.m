//
//  TYTextField.m
//  tianyanAR
//
//  Created by Edwin on 16/1/7.
//  Copyright © 2016年 Steven2761. All rights reserved.
//

#import "TYTextField.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation TYTextField

//我们有时需要定制化UITextField对象的风格，可以添加许多不同的重写方法，来改变文本字段的显示行为。这些方法都会返回一个CGRect结构，制定了文本字段每个部件的边界范围，甚至修改placeHolder颜色，字体。

//– textRectForBounds:　　    //重写来重置文字区域
//– drawTextInRect:　　       //改变绘文字属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了.
//– placeholderRectForBounds:　　//重写来重置占位符区域
//– drawPlaceholderInRect:　　//重写改变绘制占位符属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了
//– borderRectForBounds:　　//重写来重置边缘区域
//– editingRectForBounds:　　//重写来重置编辑区域
//– clearButtonRectForBounds:　　//重写来重置clearButton位置,改变size可能导致button的图片失真
//– leftViewRectForBounds:
//– rightViewRectForBounds:

//通过– drawPlaceholderInRect:方法可改变placeHolder颜色、字体，请看代码：
//首先定义一个类CustomTextField让它继承UITextField实现以下方法即可：
//控制清除按钮的位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + bounds.size.width - 15, bounds.origin.y + bounds.size.height/4, 16, 16);
}

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    CGRect inset = CGRectMake(bounds.origin.x+15, bounds.origin.y/2, bounds.size.width -15, bounds.size.height-30);//更好理解些
    return inset;
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    CGRect inset = CGRectMake(bounds.origin.x+15, bounds.origin.y, bounds.size.width -15, bounds.size.height);//更好理解些
    
    return inset;
    
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    
    CGRect inset = CGRectMake(bounds.origin.x +15, bounds.origin.y, bounds.size.width -15, bounds.size.height);
    return inset;
}
//控制左视图位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x +15, bounds.origin.y, bounds.size.width-350, bounds.size.height);
    return inset;
}

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    [[UIColor lightGrayColor] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:ScreenHeight*48/2/1104]];
}


@end
