//
//  TableViewCell.m
//  demoa
//
//  Created by kfw on 2019/7/2.
//  Copyright © 2019 kfw. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 圆角
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = UIColor.redColor;
        // 父视图透明
        self.backgroundColor = UIColor.clearColor;
        self.backgroundView.backgroundColor = UIColor.clearColor;
    }
    return self;
}

@end
