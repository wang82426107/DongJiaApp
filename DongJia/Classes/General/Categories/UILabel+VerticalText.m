//
//  UILabel+VerticalText.m
//  SDRunLine
//
//  Created by bnqc on 2018/11/14.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "UILabel+VerticalText.h"
#import "objc/Runtime.h"

@implementation UILabel (VerticalText)

- (NSString *)verticalText{
    // 利用runtime添加属性
    return objc_getAssociatedObject(self, @selector(verticalText));
}

- (void)setVerticalText:(NSString *)verticalText{
    objc_setAssociatedObject(self, &verticalText, verticalText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableString *str = [[NSMutableString alloc] initWithString:verticalText];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2-1];
    }
    self.text = str;
    self.numberOfLines = 0;
    self.textAlignment = NSTextAlignmentCenter;
}

@end
