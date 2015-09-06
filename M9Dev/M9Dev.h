//
//  M9Dev.h
//  M9Dev
//
//  Created by MingLQ on 2015-08-20.
//  Copyright (c) 2015 MingLQ <minglq.9@gmail.com>.
//  Released under the MIT license.
//

#ifndef M9Dev
#define M9Dev

/* Error: Include of non-modular header inside framework module
 *  @see http://stackoverflow.com/a/28552525/456536
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "M9Utilities.h"

/* third part */
#import "NSObject+AssociatedObjects.h"
#import "NSString+CompareToVersion.h"
#import "EXTScope+M9.h"
#import "metamacros+M9.h"
#import "JRSwizzle.h"

/* Foundation */
#import "NSArray+M9.h"
#import "NSDictionary+M9.h"
#import "NSInvocation+M9.h"
#import "NSObject+AssociatedValues.h"

/* UIKit */
#import "UIImage+M9.h"
// view
#import "UIControl+M9EventCallback.h"
#import "UIView+M9.h"
// view controller
#import "M9ScrollViewController.h"
#import "M9TableViewController.h"
#import "M9PagingViewController.h"
#import "UINavigationController+M9.h"
#import "UIViewController+M9.h"

#endif