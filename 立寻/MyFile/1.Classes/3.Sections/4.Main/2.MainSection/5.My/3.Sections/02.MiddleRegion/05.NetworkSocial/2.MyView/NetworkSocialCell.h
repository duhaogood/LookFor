//
//  NetworkSocialCell.h
//  立寻
//
//  Created by Mac on 17/6/17.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkSocialCell : UITableViewCell
-(instancetype)initWithDictionary:(NSDictionary *)dictionary andHeight:(float)height andDelegate:(id)delegate andIndexPath:(NSIndexPath *)indexPath;
@end
