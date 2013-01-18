//
//  EBViewController.h
//  EB_ADBook
//
//  Created by 延晋 张 on 12-6-15.
//  Copyright (c) 2012年 Ebupt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import "EBBookDatabase.h"
#import "EBBookDetailTableView.h"
#import "EBBookContactBookViewController.h"
#import "SuperLink.h"
#import "MOSNewMessageViewController.h"

@class EBBookContact;

@interface EBADBookDetailViewController : UIViewController
        <UIActionSheetDelegate,EBBookDetailTableViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,CLLocationManagerDelegate,SuperLinkDelegate>

@property (assign, nonatomic) BOOL freeJump;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UILabel *NameLabel;
@property (retain, nonatomic) IBOutlet UILabel *UIDLabel;
@property (retain, nonatomic) IBOutlet UINavigationItem *topBarItem;
@property (retain) UIAlertView *progressView;
@property (retain) CLLocationManager *locManager;
@property (retain, nonatomic) EBBookContactBookViewController *callbackViewController;
- (IBAction)back:(id)sender;

- (id) initWithEBContact:(EBBookContact* ) Contacter;
@end
