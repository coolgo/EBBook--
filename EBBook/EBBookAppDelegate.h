//
//  EBBookAppDelegate.h
//  EBBook
//
//  Created by Kissshot HeartunderBlade on 12-6-6.
//  Copyright (c) 2012年 Ebupt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "EBBookContactBookViewController.h"
#import "EBBookBlogViewController.h"
@class EBBookAccount;

ABAddressBookRef addressBook;

#define KPHONELABELDICDEFINE		@"KPhoneLabelDicDefine"
#define KPHONENUMBERDICDEFINE	@"KPhoneNumberDicDefine"
#define KPHONENAMEDICDEFINE	@"KPhoneNameDicDefine"

@interface EBBookAppDelegate : UIResponder <UIApplicationDelegate>
{
    EBBookAccount *checkUser;
}

@property (strong, nonatomic) UIWindow *window;
@property (retain) NSMutableArray *localEBContact;
@property (retain) NSMutableArray *localNamePhoneContact;
@property (nonatomic, retain) NSString *globalDeviceToken;
@property (nonatomic, retain) UITabBarItem *forthTabItem;

- (void)reloadLocalContacts;
@end
