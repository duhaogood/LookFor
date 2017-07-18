//
//  LookForCircleUpView.m
//  立寻
//
//  Created by Mac on 17/6/14.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "LookForCircleUpView.h"
#import "LookForCircleVC.h"
@implementation LookForCircleUpView



-(instancetype)initWithFrame:(CGRect)frame andUserUrl:(NSString *)url andTypeTitle:(NSString *)typeTitle andTypeArray:(NSArray *)typeArray andDelegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        //[MYTOOL getHeightWithIphone_six:323]
        float left = 10;
        float top = [MYTOOL getHeightWithIphone_six:20];
        //标题文本框
        {
            float right = 0;
            //右侧数字提示
            {
                UILabel * label = [UILabel new];
                label.text = @"   0/20";
                label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
                [delegate setTitleNumberLabel:label];
                label.font = [UIFont systemFontOfSize:10];
                [self addSubview:label];
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(WIDTH - 10 - size.width, top-size.height/2, size.width, size.height);
                right = WIDTH - 10 - size.width - 10;
            }
            //中间文本框
            {
                UITextField * tf = [UITextField new];
                tf.placeholder = @"请填写信息标题";
                tf.font = [UIFont systemFontOfSize:15];
                tf.textColor = [MYTOOL RGBWithRed:144 green:144 blue:144 alpha:1];
                tf.delegate = delegate;
                [delegate setTitleTF:tf];
                tf.tag = 50;
                [self addSubview:tf];
                CGSize size = [MYTOOL getSizeWithLabel:(UILabel *)tf];
                tf.frame = CGRectMake(left, top - size.height/2-10, right-left, size.height+10);
                top += size.height/2.0 + 5;
                //                tf.backgroundColor = [UIColor greenColor];
                
            }
            //下侧分割线
            {
                UIView * space = [UIView new];
                space.backgroundColor = MYCOLOR_240_240_240;
                space.frame = CGRectMake(left, top, WIDTH - 10 - left, 1);
                [self addSubview:space];
            }
        }
        top += 10;
        //文本框
        {
            float height = [MYTOOL getHeightWithIphone_six:75];
            MyTextView * tv = [[MyTextView alloc] initWithFrame:CGRectMake(10, top, WIDTH - 20, height)];
            tv.textColor = MYCOLOR_48_48_48;
            tv.placeholderLabel.text = @"  有啥好玩的，好笑的，好吃的，高营养鸡汤…给大家分享下吧";
            tv.placeholderLabel.font = [UIFont systemFontOfSize:10];
            tv.placeholderLabel.textColor = [MYTOOL RGBWithRed:180 green:180 blue:180 alpha:1];
            tv.font = [UIFont systemFontOfSize:13];
            [self addSubview:tv];
            [delegate setContentTV:tv];
            tv.layer.masksToBounds = true;
            tv.layer.borderWidth = 1;
            tv.delegate = delegate;
            tv.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
            top += height + 5;
        }
        //详细信息字数
        {
            UILabel * label = [UILabel new];
            label.text = @"123456/5000";
            label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
            label.font = [UIFont systemFontOfSize:10];
            [self addSubview:label];
            [delegate setContentNumberLabel:label];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.text = @"0/5000";
            label.frame = CGRectMake(WIDTH - 10 - size.width, top , size.width, size.height);
            top += size.height;
        }
        //下面2行文字
        float label_height = 0;
        {
            UILabel * llabel = [UILabel new];
            llabel.font = [UIFont systemFontOfSize:12];
            llabel.text = @"目标";
            CGSize size = [MYTOOL getSizeWithLabel:llabel];
            label_height = size.height;
        }
        float label_space = (frame.size.height - top - 10 - 2 * label_height)/3;
        float height_tf = [MYTOOL getHeightWithIphone_six:35];
        float middle_right = 0;
        //目标类型
        {
            top += label_space;
            left = 0;
            //左侧提示
            {
                UILabel * label = [UILabel new];
                label.text = @"目标类型:";
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(10, top, size.width, size.height);
                middle_right = top + size.height/2;
                [self addSubview:label];
                left += 20 + size.width;
            }
            //右侧
            {
                UITextField * typeTF = [UITextField new];
                typeTF.text = typeArray[0][@"CategoryTitle"];
                typeTF.textAlignment = NSTextAlignmentCenter;
                typeTF.frame = CGRectMake(left, middle_right - height_tf/2.0, 100, height_tf);
                typeTF.font = [UIFont systemFontOfSize:13];
                typeTF.tag = 100;
                typeTF.delegate = delegate;
                typeTF.layer.masksToBounds = true;
                typeTF.layer.borderWidth = 1;
                typeTF.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
                [delegate setTypeTF:typeTF];
                [self addSubview:typeTF];
                //输入
                {
                    UIPickerView * pick = [UIPickerView new];
                    [delegate setTypePicker:pick];
                    pick.tag = 200;
                    UIView * v = [UIView new];
                    typeTF.inputView = v;
                    v.frame = CGRectMake(0, 500, WIDTH, 271);
                    pick.frame = CGRectMake(0, 44, WIDTH, 271-44);
                    pick.dataSource = delegate;
                    pick.delegate = delegate;
                    [v addSubview:pick];
                    [delegate setPicker:pick];
                    //toolbar
                    UIToolbar * bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
                    [v addSubview:bar];
                    [bar setBarStyle:UIBarStyleDefault];
                    NSMutableArray *buttons = [[NSMutableArray alloc] init];
                    
                    UIBarButtonItem *myDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                                  target: delegate action: @selector(clickOkOfPickerView:)];
                    myDoneButton.tag = 200;
                    myDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:delegate action:@selector(clickOkOfPickerView:)];
                    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                    
                    [buttons addObject:flexibleSpace];
                    [buttons addObject: myDoneButton];
                    
                    
                    [bar setItems:buttons animated:TRUE];
                    
                    //toolbar加个label
                    UILabel * label = [UILabel new];
                    label.text = [NSString stringWithFormat:@"请选择相应的类型"];
                    label.frame = CGRectMake(WIDTH/2-70, 12, 140, 20);
                    label.textAlignment = NSTextAlignmentCenter;
                    [v addSubview:label];
                }
            }
            top += label_height;
        }
        //选择城市
        {
            top += label_space;
            left = 0;
            //左侧提示
            {
                UILabel * label = [UILabel new];
                label.text = @"选择城市:";
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(10, top+5, size.width, size.height);
                middle_right = top + size.height/2;
                [self addSubview:label];
                left = 10 + size.width + 10;
            }
            //右侧
            {
                UITextField * cityTF = [UITextField new];
                cityTF.placeholder = @"  请选择城市";
                cityTF.frame = CGRectMake(left, middle_right - height_tf/2.0+5, WIDTH/2.0, height_tf);
                cityTF.font = [UIFont systemFontOfSize:13];
                cityTF.tag = 300;
                cityTF.delegate = delegate;
                cityTF.layer.masksToBounds = true;
                cityTF.layer.borderWidth = 1;
                cityTF.layer.borderColor = [MYCOLOR_240_240_240 CGColor];
                [delegate setCityTF:cityTF];
                [self addSubview:cityTF];
                //输入
                {
                    UIPickerView * pick = [UIPickerView new];
                    pick.tag = 100;
                    UIView * v = [UIView new];
                    cityTF.inputView = v;
                    v.frame = CGRectMake(0, 500, WIDTH, 271);
                    pick.frame = CGRectMake(0, 44, WIDTH, 271-44);
                    pick.dataSource = delegate;
                    pick.delegate = delegate;
                    [v addSubview:pick];
                    [delegate setPicker:pick];
                    //toolbar
                    UIToolbar * bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
                    [v addSubview:bar];
                    [bar setBarStyle:UIBarStyleDefault];
                    NSMutableArray *buttons = [[NSMutableArray alloc] init];
                    
                    UIBarButtonItem *myDoneButton = [[ UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                                   target: delegate action: @selector(clickOkOfPickerView:)];
                    myDoneButton.tag = 100;
                    myDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:delegate action:@selector(clickOkOfPickerView:)];
                    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                    
                    [buttons addObject:flexibleSpace];
                    [buttons addObject: myDoneButton];
                    
                    
                    [bar setItems:buttons animated:TRUE];
                    
                    //toolbar加个label
                    UILabel * label = [UILabel new];
                    label.text = [NSString stringWithFormat:@"请选择省、市"];
                    label.frame = CGRectMake(WIDTH/2-70, 12, 140, 20);
                    label.textAlignment = NSTextAlignmentCenter;
                    [v addSubview:label];
                }
            }
            top += label_height;
        }
        
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [MYTOOL hideKeyboard];
}



@end
