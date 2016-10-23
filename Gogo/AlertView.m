//
//  AlertView.m
//  Gogo
//
//  Created by Thuong on 10/9/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "AlertView.h"
#import "Object.h"
#import "Category.h"
#import "AFNetworking.h"
#import "Utils.h"

@implementation AlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self getData];
    _btnCategory.layer.borderWidth = 1;
    _btnCategory.layer.borderColor = [[UIColor clearColor] CGColor];
    _btnCategory.layer.cornerRadius = 5;
    
    self.btnPost.layer.borderWidth = 1;
    self.btnPost.layer.borderColor = [[UIColor clearColor] CGColor];
    self.btnPost.layer.cornerRadius = 5;
//    self.contentView.layer.cornerRadius = 3;
    self.arrayCategory = [[NSMutableArray alloc] init];
    self.arrayIdCategory = [[NSMutableArray alloc]init];
    self.txtLocation.delegate = self;
    // bind yourTextField to DownPicker
    [self.txtLocation addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_txtLocation setFont: [_txtLocation.font fontWithSize:[Utils fontSizeBig]]];
    [_btnCategory.titleLabel setFont: [_btnCategory.titleLabel.font fontWithSize:[Utils fontSizeBig]]];
}
-(void)getData{
    NSURL *URL = [NSURL URLWithString:@"http:210.245.95.50:6996/api/categories"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        Object *object = [[Object alloc]init];
        object.code = [[responseObject objectForKey:@"code"] integerValue];
        object.result =  [responseObject objectForKey:@"result"];
        NSLog(@"%@" , [responseObject objectForKey:@"code"]);
        NSLog(@"%@" , [responseObject objectForKey:@"result"]);
        if(object.code == 1){
            NSArray *array = [[NSArray alloc]init];
            array = [MTLJSONAdapter modelsOfClass:[Category class] fromJSONArray:object.result error:nil];
            for(Category *category in array){
                [self.arrayCategory addObject:category.name];
                NSLog(@"%@" , category.category_Id);
                [self.arrayIdCategory addObject:category.category_Id];
            }
            NSLog(@"%@" , self.arrayCategory);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    [[NSUserDefaults standardUserDefaults] setObject:theTextField.text forKey:@"location"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)clickBtnCategory:(id)sender {

    if(dropDown == nil) {
        CGFloat f = self.arrayCategory.count * 40;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.arrayCategory :nil :@"down"];
        dropDown.delegate = self;
        
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    NSLog(@"%@", _btnCategory.titleLabel.text);

}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}
-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
- (IBAction)clickBtnPost:(id)sender {
    for(int i = 0 ; i < self.arrayCategory.count;i++){
        if(self.arrayCategory[i] == _btnCategory.titleLabel.text){
            self.idCategory = self.arrayIdCategory[i];
        }
    }
    NSLog(@"%@" , self.idCategory);
    if ([self.delegate respondsToSelector:@selector(clickBtnPost:location:)]) {
        [self.delegate clickBtnPost:self.idCategory location:self.txtLocation.text];
    }
}
@end
