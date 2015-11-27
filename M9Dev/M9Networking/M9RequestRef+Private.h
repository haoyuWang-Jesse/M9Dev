//
//  M9RequestRef+Private.h
//  M9Dev
//
//  Created by MingLQ on 2014-07-06.
//  Copyright (c) 2014 MingLQ <minglq.9@gmail.com>.
//  Released under the MIT license.
//

#import <Foundation/Foundation.h>

#import "M9RequestRef.h"

@interface M9RequestRef ()

@property(nonatomic, readwrite) NSOperation *currentRequestOperation;

@property(nonatomic, readwrite) NSInteger retriedTimes;
@property(nonatomic, readwrite) BOOL usedCachedData;
// @property(nonatomic, readwrite) NSTimeInterval loadingDuration;
@property(nonatomic, readwrite, setter = setCancelled:) BOOL isCancelled;

- (instancetype)initWithOwner:(id)owner;
+ (instancetype)requestRefWithOwner:(id)owner;

- (void)cancel;

@end

#pragma mark -

@interface NSObject (M9RequestOwner) /* <M9RequestOwner> */

- (NSMutableArray *)allRequestRef;

- (void)addRequestRef:(M9RequestRef *)requestRef;
- (void)removeRequestRef:(M9RequestRef *)requestRef;
- (void)removeAllRequestRef;

@end
