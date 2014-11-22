//
//  M9Utilities.m
//  M9Dev
//
//  Created by iwill on 2013-06-26.
//  Copyright (c) 2013年 M9. All rights reserved.
//

#import "M9Utilities.h"


@implementation NSObject (ReturnSelf)

- (id)if:(BOOL)condition {
    return condition ? self : nil;
}

- (instancetype)as:(Class)class {
    return [self if:[self isKindOfClass:class]];
}

- (id)asArray {
    return [self as:[NSArray class]];
}

- (id)asDictionary {
    return [self as:[NSDictionary class]];
}

- (id)asMemberOfClass:(Class)class {
    return [self if:[self isMemberOfClass:class]];
}

- (id)asProtocol:(Protocol *)protocol {
    return [self if:[self conformsToProtocol:protocol]];
}

- (id)ifRespondsToSelector:(SEL)selector {
    return [self if:[self respondsToSelector:selector]];
}

- (id)performIfRespondsToSelector:(SEL)selector {
    SuppressPerformSelectorLeakWarning({
        return [[self ifRespondsToSelector:selector] performSelector:selector];
    });
}

- (id)performIfRespondsToSelector:(SEL)selector withObject:(id)object {
    SuppressPerformSelectorLeakWarning({
        return [[self ifRespondsToSelector:selector] performSelector:selector withObject:object];
    });
}

- (id)performIfRespondsToSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2 {
    SuppressPerformSelectorLeakWarning({
        return [[self ifRespondsToSelector:selector] performSelector:selector withObject:object1 withObject:object2];
    });
}

@end

