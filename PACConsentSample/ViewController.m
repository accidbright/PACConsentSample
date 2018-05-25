//
//  ViewController.m
//  PACConsentSample
//
//  Created by Accid Bright on 25.05.2018.
//  Copyright © 2018 Digitalchemy. All rights reserved.
//

#import "ViewController.h"

#import <PersonalizedAdConsent/PACPersonalizedAdConsent.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self detectMemberEEA:^(BOOL isEEAMember) {
        NSLog(@"Detection completed");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)detectMemberEEA:(void (^)(BOOL))completionHandler {
    NSString * publisherId = @"pub-0123456789012345";
    [PACConsentInformation.sharedInstance requestConsentInfoUpdateForPublisherIdentifiers:@[publisherId]
                                                                        completionHandler:^(NSError * _Nullable error) {
                                                                            BOOL isEEA = PACConsentInformation.sharedInstance.requestLocationInEEAOrUnknown;
                                                                            if (error) {
                                                                                NSLog(@"Detecting EEA member error: %@", error);
                                                                                if (error.code == NSPropertyListReadCorruptError) {
                                                                                    // NSPropertyListReadCorruptError = 3840 - error occured during parsing response JSON
                                                                                    // Occured only when running on device and device is in EEA
                                                                                    // Fired issue https://github.com/googleads/googleads-consent-sdk-ios/issues/13
                                                                                    // This workaround is until issue won't fixed
                                                                                    isEEA = YES;
                                                                                }
                                                                            }
                                                                            NSLog(@"Is%@EEA member", isEEA ? @" " : @" not ");
                                                                            completionHandler(isEEA);
                                                                        }];
}


@end
