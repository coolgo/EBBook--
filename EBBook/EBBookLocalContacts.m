//
//  EBBookLocalContacts.m
//  EBBook
//
//  Created by Kissshot HeartunderBlade on 12-6-27.
//  Copyright (c) 2012年 Ebupt. All rights reserved.
//

#import "EBBookLocalContacts.h"
#import "EBBookContact.h"
#import <AddressBook/AddressBook.h>

@implementation EBBookLocalContacts

+ (void)addAllContactsToDevice:(NSArray *)contactsToAdd
{
    for(int i = 0; i < [contactsToAdd count]; i++)
    {
        [[self class] addContactToDevice:[contactsToAdd objectAtIndex:i]];
    }
}

+ (NSString *)get_filename:(NSString *)name
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:name];
}

+ (BOOL)is_file_exist:(NSString *)name
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[[self class] get_filename:name]];
}

+ (UIImage *)getPhotoForContact:(NSString *)uid
{
    NSString *fileName = [uid stringByAppendingString:@".jpg"];
    if([[self class] is_file_exist:fileName])
    {
        return [UIImage imageWithContentsOfFile:[[self class] get_filename:fileName]];
    }
    else {
        UIImage *image = [UIImage imageNamed:fileName];
        if(image.size.height > 0.0000001)
        {
            return image;
        }
        else
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"adressbook_default@2x" ofType:@"png"];
            return [UIImage imageWithContentsOfFile:path];
        }
    }
}

+ (void)addContactToDevice:(EBBookContact *)eBerToAdd
{
    CFErrorRef error = NULL;
    
    ABRecordRef personRef = ABPersonCreate();
    ABRecordSetValue(personRef, kABPersonLastNameProperty,(CFStringRef)eBerToAdd.name ,&error);
    //ABRecordSetValue(personRef, kABPersonFirstNameProperty, CFSTR("二狗"), &error);
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi, (CFStringRef)eBerToAdd.mobile, kABPersonPhoneMobileLabel,NULL);
    if (eBerToAdd.tel.length >= 4) {
        ABMultiValueAddValueAndLabel(multi, (CFStringRef)eBerToAdd.tel, kABWorkLabel, NULL);
    }
    
    ABRecordSetValue(personRef, kABPersonPhoneProperty, multi, &error);
    
    CFRelease(multi);
    multi = nil;
    multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi, (CFStringRef)eBerToAdd.mail, nil, NULL);
    ABRecordSetValue(personRef, kABPersonEmailProperty, multi, &error);
    //ABRecordSetValue(personRef, kABPersonEmailProperty, (CFStringRef)_eBer.mail, &error);
    
    ABRecordSetValue(personRef, kABPersonOrganizationProperty, (CFStringRef)eBerToAdd.center, &error);
    ABRecordSetValue(personRef, kABPersonDepartmentProperty, (CFStringRef)eBerToAdd.department, &error);
    ABRecordSetValue(personRef, kABPersonJobTitleProperty, (CFStringRef)eBerToAdd.title, &error);
    
    CFRelease(multi);
    multi = nil;
    multi = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:eBerToAdd.office forKey:(NSString* ) kABPersonAddressCityKey];
    //[addressDictionary setObject:_eBer.seat forKey:(NSString*) kABPersonAddressStateKey];
    ABMultiValueAddValueAndLabel(multi, addressDictionary, kABWorkLabel, NULL);
    ABRecordSetValue(personRef, kABPersonAddressProperty, multi, &error);
    [addressDictionary release];
    CFRelease(multi);

    //无年份 不加
    /*
     NSDateFormatter *inputFormat = [[NSDateFormatter alloc] init];
     [inputFormat setDateFormat:@"MM-DD"];
     NSDate *date = [inputFormat dateFromString:_eBer.birthdate];
     ABRecordSetValue(personRef, kABPersonBirthdayProperty, (CFStringRef)date, &error);
     */
    NSData *data = UIImageJPEGRepresentation([[self class] getPhotoForContact:eBerToAdd.uid], 0.0);
    ABPersonSetImageData(personRef, (CFDataRef)data, &error);
    
    ABAddressBookRef addressbookref = ABAddressBookCreate();
    ABAddressBookAddRecord(addressbookref, personRef, &error);
    ABAddressBookSave(addressbookref, &error);
    
    CFRelease(personRef);
    CFRelease(addressbookref);
}

+ (UIAlertView *)alertSaving:(NSString *)alertContent
{
    UIAlertView *warningView = [[UIAlertView alloc] initWithTitle:alertContent  message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [warningView setTag:0]; 
    [warningView show];
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //activeView.center = CGPointMake(warningView.bounds.size.width/2.0f+140.0f, warningView.bounds.size.height+75.0f);
    activeView.center = CGPointMake(warningView.bounds.size.width/2.0f, warningView.bounds.size.height-40.0f);
    [activeView startAnimating];
    [warningView addSubview:activeView];
    [activeView release];
    [warningView release];
    return warningView;
}

+ (void)finishSaving:(UIAlertView *)warningView
{
    [warningView dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存成功"  message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

@end
