//
//  NotificationModel.m
//  Gogo
//
//  Created by Thuong on 9/25/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"content": @"content",
             @"post_id": @"post_id",
             @"image": @"image",
             @"created": @"created",
             @"iD":@"id",
             @"status":@"status",
             @"comment_id":@"comment_id"
             };
}
@end
