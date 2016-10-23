//
//  NotificationTableViewCell.m
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    _check = false;
    [super awakeFromNib];
    self.lblNotification.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblNotification.numberOfLines = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickBtnCheck:(id)sender {
    _check = true;
}
@end
