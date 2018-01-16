//
//  MaTableViewCell.h
//  Cell嵌套WkWebView
//
//  Created by Admin on 2018/1/12.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableview;

//浏览器高度
@property(nonatomic,assign)CGFloat webHeight;
//内容
@property(nonatomic,copy)NSString *contentHtml;
@end
