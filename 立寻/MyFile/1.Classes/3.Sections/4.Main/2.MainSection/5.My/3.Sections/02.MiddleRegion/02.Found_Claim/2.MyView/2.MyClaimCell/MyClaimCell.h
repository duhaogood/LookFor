//
//  MyClaimCell.h
//  立寻
//
//  Created by mac on 2017/6/3.
//  Copyright © 2017年 杜浩. All rights reserved.
//  认领

#import <UIKit/UIKit.h>

@interface MyClaimCell : UITableViewCell

-(instancetype)initWithDictionary:(NSDictionary *)dictionary andHeight:(float)height andDelegate:(id)delegate andIndexPath:(NSIndexPath *)indexPath;

@end
