//
//  NSObject+RYLazyProperty.h
//  LazyProperty
//
//  Created by 若懿 on 16/11/22.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (RYLazyProperty)

+ (void)ry_setLazyPropertyArr:(nullable NSArray<NSString *> *)nonilPropertyArr;

+ (void)ry_CorrespondProperty:(nullable NSDictionary<NSString *,NSString *>  *)correspondDic;

@end
