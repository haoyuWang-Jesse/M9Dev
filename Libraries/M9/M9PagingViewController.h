//
//  M9PagingViewController.h
//  M9Dev
//
//  Created by MingLQ on 2015-05-07.
//  Copyright (c) 2015 MingLQ <minglq.9@gmail.com>. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "M9Utilities.h"
#import "NSArray+M9.h"
#import "M9ScrollViewController.h"
#import "UIViewController+M9.h"

// TODO: UIPageViewController
// TODO: placeholderViewController
@interface M9PagingViewController : M9ScrollViewController

@property(nonatomic, readonly) NSInteger numberOfPages;
@property(nonatomic, readonly) NSInteger currentPage;

/**
 *  call setupWithNumberOfPages: when viewDidLoad
 */
- (void)setupWithNumberOfPages:(NSInteger)numberOfPages;
- (UIViewController *)viewControllerOfPage:(NSInteger)page;

// subclasses MUST override
- (UIViewController *)generateViewControllerOfPage:(NSInteger)page;
// default: UIEdgeInsetsMake(0, 0, 0, 0)
- (UIEdgeInsets)viewInsetOfPage:(NSInteger)page;

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

// TODO: scroll progress - 1, 1.1, 1.2 ..., 2
- (void)willScrollToPage:(NSInteger)page animated:(BOOL)animated;
- (void)didScrollToPage:(NSInteger)page animated:(BOOL)animated;

@end