//
//  M9NetworkingViewController.m
//  M9Dev
//
//  Created by iwill on 2014-07-05.
//  Copyright (c) 2014年 iwill. All rights reserved.
//

#import "M9NetworkingViewController.h"

#import "EXTScope.h"
#import "M9Utilities.h"
#import "M9Networking.h"
#import "M9Networking+.h"

#import "DEPRECATEDRequestInfo.h"

@interface M9NetworkingViewController ()

@end

@implementation M9NetworkingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(- 1, 0, 320 + 2, 44);
    
    frame.origin.y += CGRectGetMaxY(frame) + 20;
    [self.view addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = frame;
        [button setTitle:@"request" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.5;
        button;
    })];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buttonDidTapped:(UIButton *)button {
    if (button.selected) {
        button.selected = NO; // confirm result
        return;
    }
    else {
        button.enabled = NO; // start loading
    }
    
    /*
    M9RequestInfo *requestInfo = [M9RequestInfo new];
    // requestInfo.URLString = @"http://10.2.10.187:3000/static/index.html";
    requestInfo.URLString = @"http://10.2.10.187:3000/route/path/file.json?a=1&b=2";
    requestInfo.parameters = @{ @"x": @1, @"y": @2 };
    requestInfo.sender = self;
    
    weakify(button);
    requestInfo.success = ^(id<M9ResponseRef> responseRef, id responseObject) {
        NSLog(@"success: %@", responseObject);
        strongify(button);
        button.enabled = YES; // stop loading
        button.selected = YES; // alert result
        [button setTitle:@"success" forState:UIControlStateSelected];
    };
    requestInfo.failure = ^(id<M9ResponseRef> responseRef, NSError *error) {
        NSLog(@"failure: %@", error);
        strongify(button);
        button.enabled = YES; // stop loading
        button.selected = YES; // alert result
        [button setTitle:@"failure" forState:UIControlStateSelected];
    }; */
    
    DEPRECATEDRequestInfo *requestInfo = [DEPRECATEDRequestInfo new];
    requestInfo.URLString = @"http://10.2.10.187:3000/route/path/file.json?a=1&b=2";
    requestInfo.parameters = @{ @"x": @1, @"y": @2 };
    [requestInfo setDelegate:self successSelector:@selector(successWithResponseRef:responseObject:) failureSelector:@selector(failureWithResponseRef:error:)];
    requestInfo.userInfo = button;
    
    [M9NETWORKING GET:requestInfo];
}

- (void)successWithResponseRef:(id<M9ResponseRef>)responseRef responseObject:(id)responseObject {
    NSLog(@"success: %@", responseObject);
    UIButton *button = responseRef.requestRef.userInfo;
    button.enabled = YES; // stop loading
    button.selected = YES; // alert result
    [button setTitle:@"success" forState:UIControlStateSelected];
}

- (void)failureWithResponseRef:(id<M9ResponseRef>)responseRef error:(NSError *)error {
    NSLog(@"failure: %@", error);
    UIButton *button = responseRef.requestRef.userInfo;
    button.enabled = YES; // stop loading
    button.selected = YES; // alert result
    [button setTitle:@"failure" forState:UIControlStateSelected];
}

@end
