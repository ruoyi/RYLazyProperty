//
//  NSObject+RYLazyProperty.m
//  LazyProperty
//
//  Created by 若懿 on 16/11/22.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "NSObject+RYLazyProperty.h"
#import <objc/runtime.h>

@implementation NSObject (RYLazyProperty)
+ (void)ry_setLazyPropertyArr:(NSArray<NSString *> *)lazyPropertyArr {
    for (NSString *nonilStr in lazyPropertyArr) {
        [self _ry_checkPropertyViable:nonilStr];
        objc_property_t property =  class_getProperty([self class], [nonilStr UTF8String]);
        NSString *propertyAtt = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        NSAssert([propertyAtt containsString:@"@\""], @"%@ must be Subclass of NSObject",nonilStr);
        NSString *getMethod = [@"G_" stringByAppendingString:nonilStr];
        NSAssert(![propertyAtt containsString:getMethod], @"%@ of %@ has rewritten the get method",nonilStr,[self class]);
        IMP replaceMedth = [self methodForSelector:@selector(_ry_method)];
        class_replaceMethod([self class], NSSelectorFromString(nonilStr), replaceMedth, NULL);
    }
}

+ (void)_ry_checkPropertyViable:(NSString *)propertyName {
    NSAssert([propertyName isKindOfClass:[NSString class]], @"%@ must be type of NSString",propertyName);
    NSString *propertyMethod = [@"_" stringByAppendingString:propertyName];
    Ivar ivar = class_getInstanceVariable([self class], [propertyMethod UTF8String]);
    NSAssert(ivar, @"%@ is not of %@ property",propertyName,[self class]);
}

- (id)_ry_method {
    NSString *method = [@"_" stringByAppendingString:NSStringFromSelector(_cmd)];
    Ivar ivar = class_getInstanceVariable([self class], [method UTF8String]);
    id value = object_getIvar(self, ivar);
    if (value) {
        return value;
    }
    objc_property_t property =  class_getProperty([self class], [NSStringFromSelector(_cmd) UTF8String]);
    NSString *propertyAtt = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSRange rangeBegin = [propertyAtt rangeOfString:@"@\""];
    NSRange rangeEnd = [propertyAtt rangeOfString:@"\","];
    
    NSString *className = [propertyAtt substringWithRange:NSMakeRange(rangeBegin.location + rangeBegin.location + 1, rangeEnd.location - 3)];
    value = [[NSClassFromString(className) alloc] init];
    // if override set method
    NSString *setMethod = [@"set" stringByAppendingString:[NSStringFromSelector(_cmd) capitalizedString]];
    if ([propertyAtt containsString:[@"S_" stringByAppendingString:setMethod]]) {
        SEL setSEL = NSSelectorFromString([setMethod stringByAppendingString:@":"]);
        NSMethodSignature *medthdsign = [[self class] instanceMethodSignatureForSelector:setSEL];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:medthdsign];
        [invocation setArgument:&value atIndex:0];
        invocation.selector = setSEL;
        [invocation invokeWithTarget:self];
    }else {
        [self willChangeValueForKey:NSStringFromSelector(_cmd) ];
        object_setIvar(self, ivar, value);
        [self didChangeValueForKey:NSStringFromSelector(_cmd)];
    }
    return value;
}



@end
