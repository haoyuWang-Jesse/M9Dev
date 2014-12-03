//
//  M9Promise.m
//  M9Dev
//
//  Created by MingLQ on 2014-11-10.
//  Copyright (c) 2014年 iwill. All rights reserved.
//

#import "M9Promise.h"

#import "EXTScope.h"

#import "M9Utilities.h"

@class M9Deferred;

typedef NS_ENUM(NSInteger, M9PromiseState) {
    M9PromiseStatePending = 0,
    M9PromiseStateFulfilled,
    M9PromiseStateRejected
};

#pragma mark -

@interface M9Promise ()

@property(nonatomic) M9PromiseState state;
@property(nonatomic, strong) id value;

@property(nonatomic, copy, readonly) void (^handle)(M9Deferred *deferred);
@property(nonatomic, copy, readonly) void (^finale)();

@property(nonatomic, weak, readonly) M9PromiseCallback fulfill, reject;

@property(nonatomic, strong) NSMutableArray *deferreds;

@end

@interface M9Deferred : NSObject

@property(nonatomic, copy) M9ThenableCallback fulfillCallback, rejectCallback;
@property(nonatomic, strong) M9Promise *nextPromise;

+ (instancetype)deferred:(M9ThenableCallback)fulfillCallback :(M9ThenableCallback)rejectCallback;

@end

#pragma mark -

@implementation M9Promise

+ (instancetype)promise:(M9PromiseBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (instancetype)init {
    return [self initWithBlock:nil];
}

- (instancetype)initWithBlock:(M9PromiseBlock)block {
    self = [super init];
    if (self) {
        weakify(self);
        
        _handle = ^void (M9Deferred *deferred) {
            strongify(self);
            if (self.state == M9PromiseStatePending) {
                [self.deferreds addObject:deferred];
                return;
            }
            dispatch_async_main_queue(^() {
                M9ThenableCallback callback = nil;
                M9PromiseCallback callNext = nil;
                if (self.state == M9PromiseStateFulfilled) {
                    callback = deferred.fulfillCallback;
                    callNext = deferred.nextPromise.fulfill;
                }
                else if (self.state == M9PromiseStateRejected) {
                    callback = deferred.rejectCallback;
                    callNext = deferred.nextPromise.reject;
                }
                if (callback) {
                    id value = callback(self.value);
                    if (deferred.nextPromise.fulfill) deferred.nextPromise.fulfill(value);
                }
                else {
                    if (callNext) callNext(self.value);
                }
            });
        };
        
        _finale = ^void () {
            strongify(self);
            for (M9Deferred *deferred in self.deferreds) {
                self.handle(deferred);
            }
            self.deferreds = nil;
        };
        
        _then = ^M9Promise *(M9ThenableCallback fulfillCallback, M9ThenableCallback rejectCallback) {
            M9Deferred *deferred = [M9Deferred deferred:fulfillCallback :rejectCallback];
            weakify(deferred);
            M9Promise *nextPromise = [M9Promise promise:^(M9PromiseCallback nextFulfill, M9PromiseCallback nextReject) {
                strongify(self, deferred);
                // ???: deferred will be nil
                deferred.nextPromise = nextPromise;
                self.handle(deferred);
            }];
            return nextPromise;
        };
        
        _done = ^M9Promise *(M9ThenableCallback fulfillCallback) {
            strongify(self);
            return self.then(fulfillCallback, nil);
        };
        
        _catch = ^M9Promise *(M9ThenableCallback rejectCallback) {
            strongify(self);
            return self.then(nil, rejectCallback);
        };
        
        _finally = ^M9Promise *(M9ThenableCallback callback) {
            strongify(self);
            return self.then(callback, callback);
        };
        
        M9PromiseCallback fulfill = ^void (id value) {
            if (self.state != M9PromiseStatePending) {
                return;
            }
            if (value == self) {
                self.reject([NSError errorWithDomain:M9PromiseError code:M9PromiseErrorCode_TypeError userInfo:nil]);
                return;
            }
            if ([value conformsToProtocol:@protocol(M9Thenable)]) {
                id<M9Thenable> thanable = (id<M9Thenable>)value;
                thanable.then(^id (id value) {
                    self.fulfill(value);
                    return nil;
                }, ^id (id value) {
                    self.reject(value);
                    return nil;
                });
                return;
            }
            self.state = M9PromiseStateFulfilled;
            self.value = value;
            self.finale();
        };
        
        M9PromiseCallback reject = ^void (id value) {
            if (self.state != M9PromiseStatePending) {
                return;
            }
            if (value == self) {
                self.reject([NSError errorWithDomain:M9PromiseError code:M9PromiseErrorCode_TypeError userInfo:nil]);
            }
            self.state = M9PromiseStateRejected;
            self.value = value;
            self.finale();
        };
        
        _fulfill = fulfill;
        _reject = reject;
        
        block(fulfill, reject);
    }
    return self;
}

+ (M9Promise *)some:(NSInteger)howMany of:(va_list)arg_list {
    M9Promise *promise = [self new];
    NSMutableDictionary *values = [NSMutableDictionary new];
    __block NSInteger count = 0, fulfilled = 0, rejected = 0;
    
    M9PromiseBlock block;
    while ((block = va_arg(arg_list, M9PromiseBlock))) {
        [M9Promise promise:block].then(^id (id value) {
            [values setObject:value forKey:@(count)];
            fulfilled++;
            if ((fulfilled >= howMany || fulfilled >= count)
                && rejected == 0) {
                promise.fulfill(values);
            }
            return nil;
        }, ^id (id value) {
            if (howMany <= 0 || howMany >= count || rejected >= count - howMany) {
                promise.reject(value);
            }
            rejected++;
            return nil;
        });
        count++;
    }
    
    return promise;
}

+ (instancetype)all:(M9PromiseBlock)first, ... {
    va_make(arg_list, first, {
        return [self some:0 of:arg_list];
    });
}

+ (instancetype)any:(M9PromiseBlock)first, ... {
    va_make(arg_list, first, {
        return [self some:1 of:arg_list];
    });
}

+ (instancetype)some:(NSInteger)howMany :(M9PromiseBlock)first, ... {
    va_make(arg_list, first, {
        return [self some:howMany of:arg_list];
    });
}

@end

@implementation M9Deferred

+ (instancetype)deferred:(M9ThenableCallback)fulfillCallback
                        :(M9ThenableCallback)rejectCallback {
    M9Deferred *deferred = [self new];
    deferred.fulfillCallback = fulfillCallback;
    deferred.rejectCallback = rejectCallback;
    return deferred;
}

@end