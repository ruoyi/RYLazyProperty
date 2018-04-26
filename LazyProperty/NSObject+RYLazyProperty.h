//
//  NSObject+RYLazyProperty.h
//  LazyProperty
//
//  Created by 若懿 on 16/11/22.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (RYLazyProperty)
// 设置不为 nil 的实例变量
+ (void)ry_setLazyPropertyArr:(nullable NSArray<NSString *> *)nonilPropertyArr;

@end
