//
//  ExtensionCell.h
//  立寻
//
//  Created by mac on 2017/6/3.
//  Copyright © 2017年 杜浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtensionCell : UITableViewCell
-(instancetype)initWithDictionary:(NSDictionary *)dictionary andHeight:(float)height andDelegate:(id)delegate andIndexPath:(NSIndexPath *)indexPath;
@end
