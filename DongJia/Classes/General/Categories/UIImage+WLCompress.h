//
//  UIImage+WLCompress.h
// ChildLangTeacher
//
//  Created by bnqc on 2019/1/2.
//  Copyright © 2019年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WLCompress)

// 压缩图片到指定大小
-(NSData *)compressWithMaxLength:(NSUInteger)maxLength;

@end
