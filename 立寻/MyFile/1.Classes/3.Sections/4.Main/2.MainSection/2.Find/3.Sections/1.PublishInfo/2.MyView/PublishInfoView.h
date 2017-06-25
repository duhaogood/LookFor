//
//  PublishInfoView.h
//  立寻
//
//  Created by mac on 2017/6/25.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishInfoVC.h"
@interface PublishInfoView : UIView

-(instancetype)initWithFrame:(CGRect)frame andPublishDictionary:(NSDictionary*)publishDictionary andDelegate:(PublishInfoVC*)delegate;

@end
