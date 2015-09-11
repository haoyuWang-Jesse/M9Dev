//
//  M9AlertController.h
//  M9Dev
//
//  Created by MingLQ on 2015-09-10.
//  Copyright (c) 2015 MingLQ <minglq.9@gmail.com>.
//  Released under the MIT license.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <M9Dev/M9Dev.h>

typedef NS_ENUM(NSInteger, M9AlertActionStyle) {
    M9AlertActionStyleDefault = 0,
    M9AlertActionStyleCancel,
    M9AlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, M9AlertControllerStyle) {
    M9AlertControllerStyleActionSheet = 0,
    M9AlertControllerStyleAlert
};

#pragma mark -

@protocol M9AlertAction <NSObject>

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) M9AlertActionStyle style;
// @property (nonatomic, getter=isEnabled) BOOL enabled;

@end

#pragma mark -

@protocol M9AlertController <NSObject>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, readonly) M9AlertControllerStyle preferredStyle;

@property (nonatomic, readonly) NSArray *actions;
@property (nonatomic, readonly) NSArray *textFields;

- (void)addActionWithTitle:(NSString *)title style:(M9AlertActionStyle)style handler:(void (^)(id<M9AlertAction> action))handler;
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

- (void)presentFromViewController:(UIViewController *)presentingViewController animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end

#pragma mark -

@interface M9AlertController : NSObject <M9AlertController>

+ (id<M9AlertController>)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(M9AlertControllerStyle)preferredStyle;

@end
