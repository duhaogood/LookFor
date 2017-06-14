//
//  NetShowHelpUpView.m
//  立寻
//
//  Created by Mac on 17/6/14.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import "NetShowHelpUpView.h"
#import "NetShowHelpVC.h"
@implementation NetShowHelpUpView

-(instancetype)initWithFrame:(CGRect)frame andUserUrl:(NSString *)url andTypeTitle:(NSString *)typeTitle andTypeArray:(NSArray *)typeArray andDelegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        //[MYTOOL getHeightWithIphone_six:323]
        float left = 0;
        float top = [MYTOOL getHeightWithIphone_six:14];
        //头像
        float user_width = [MYTOOL getHeightWithIphone_six:35];
        {
            UIImageView * icon = [UIImageView new];
            icon.frame = CGRectMake(10, top, user_width, user_width);
            icon.layer.masksToBounds = true;
            icon.layer.cornerRadius = user_width/2.0;
            [self addSubview:icon];
            [icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
            left = 10 + user_width + 10;
        }
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
                label.frame = CGRectMake(WIDTH - 10 - size.width, top + user_width/2.0-size.height/2, size.width, size.height);
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
                tf.frame = CGRectMake(left, top + user_width/2.0-size.height/2, right-left, size.height);
                top += user_width/2.0 + size.height/2.0 + 5;
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
            tv.placeholderLabel.text = @"  尽量详细的描述您的要求";
            tv.placeholderLabel.font = [UIFont systemFontOfSize:10];
            tv.placeholderLabel.textColor = [MYTOOL RGBWithRed:180 green:180 blue:180 alpha:1];
            tv.font = [UIFont systemFontOfSize:12];
            [self addSubview:tv];
            [delegate setContentTV:tv];
            tv.layer.masksToBounds = true;
            tv.layer.borderWidth = 1;
            tv.delegate = delegate;
            tv.layer.borderColor = [MYCOLOR_181_181_181 CGColor];
            top += height + 5;
        }
        //详细信息字数
        {
            UILabel * label = [UILabel new];
            label.text = @"  0/500";
            label.textColor = [MYTOOL RGBWithRed:168 green:168 blue:168 alpha:1];
            label.font = [UIFont systemFontOfSize:10];
            [self addSubview:label];
            [delegate setContentNumberLabel:label];
            CGSize size = [MYTOOL getSizeWithLabel:label];
            label.frame = CGRectMake(WIDTH - 10 - size.width, top , size.width, size.height);
            top += size.height;
        }
        //下面4行文字
        float label_height = 0;
        {
            UILabel * llabel = [UILabel new];
            llabel.font = [UIFont systemFontOfSize:12];
            llabel.text = @"目标";
            CGSize size = [MYTOOL getSizeWithLabel:llabel];
            label_height = size.height;
        }
        float label_space = (frame.size.height - top - 10 - 2 * label_height)/3;
        //目标类型
        {
            top += label_space;
            left = 0;
            //左侧提示
            {
                UILabel * label = [UILabel new];
                label.text = @"目标类型:";
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(10, top, size.width, size.height);
                [self addSubview:label];
                left += 20 + size.width;
            }
            //右侧
            {
                UITextField * typeTF = [UITextField new];
                typeTF.text = typeArray[0][@"CategoryTitle"];
                typeTF.textAlignment = NSTextAlignmentCenter;
                typeTF.frame = CGRectMake(left, top -5, 100, label_height + 10);
                typeTF.font = [UIFont systemFontOfSize:(label_height + 10)*0.6];
                typeTF.tag = 100;
                typeTF.delegate = delegate;
                typeTF.layer.masksToBounds = true;
                typeTF.layer.borderWidth = 1;
                typeTF.layer.borderColor = [MYCOLOR_181_181_181 CGColor];
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
                label.text = @"所在城市:";
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = MYCOLOR_48_48_48;
                CGSize size = [MYTOOL getSizeWithLabel:label];
                label.frame = CGRectMake(10, top, size.width, size.height);
                [self addSubview:label];
                left = 10 + size.width + 10;
            }
            //右侧
            {
                UITextField * cityTF = [UITextField new];
                cityTF.placeholder = @"  请选择城市";
                cityTF.frame = CGRectMake(left, top -5, WIDTH/2.0, label_height + 10);
                cityTF.font = [UIFont systemFontOfSize:(label_height + 10)*0.6];
                cityTF.tag = 300;
                cityTF.delegate = delegate;
                cityTF.layer.masksToBounds = true;
                cityTF.layer.borderWidth = 1;
                cityTF.layer.borderColor = [MYCOLOR_181_181_181 CGColor];
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
