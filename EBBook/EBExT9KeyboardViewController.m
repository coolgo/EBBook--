//
//  EBExT9KeyboardViewController.m
//  Experiment
//
//  Created by Kissshot HeartUnderBlade on 12-7-5.
//  Copyright (c) 2012年 Ebupt. All rights reserved.
//

#import "EBExT9KeyboardViewController.h"
#import "EBBookContact.h"
#import "EBBookDatabase.h"
#import "EBBookLocalContacts.h"
#import "EBBookContactBookCustomCell.h"
#import "EBADBookDetailViewController.h"
#import "EBBookAccount.h"
#import "EBBookAppDelegate.h"
#import "EBBookLocalDetailViewController.h"
#import "ContactData.h"
#import "pinyin.h"

@interface EBExT9KeyboardViewController ()
{
    UIButton *popupT9KeyBoardBtn;
    NSTimer *timerToDeleteAll;
    NSMutableArray *filteredArray;
    NSMutableArray *filteredIndexArray;
    NSMutableArray *finalResultArray;
    NSMutableArray *localFilteredArray;
    NSMutableArray *localFilteredIndexArray;
    NSMutableArray *localFinalResultArray;
    NSArray *searchRange;
    NSArray *localSearchRange;
}

@end

@implementation EBExT9KeyboardViewController
@synthesize searchResultKeyboard;
@synthesize keyboardMonitor;
@synthesize keyboardUIView;
@synthesize contactNameArray;
@synthesize localContactNameArray;
@synthesize searchKeyword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)makeTabBarHidden:(BOOL)hide
{
    if ( [self.tabBarController.view.subviews count] < 2 )
    {
        return;
    }
    UIView *contentView;
    
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
    {
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    }
    else
    {
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    }
    //[UIView beginAnimati*****:@"TabbarHide" context:nil];
    if ( hide )
    {
        contentView.frame = self.tabBarController.view.bounds;        
    }
    else
    {
        contentView.frame = CGRectMake(self.tabBarController.view.bounds.origin.x,
                                       self.tabBarController.view.bounds.origin.y,
                                       self.tabBarController.view.bounds.size.width,
                                       self.tabBarController.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    }
    self.tabBarController.tabBar.clipsToBounds = YES;
    self.tabBarController.tabBar.hidden = hide;
    //    [UIView commitAnimati*****];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    filteredArray = [[NSMutableArray alloc] init];
    filteredIndexArray = [[NSMutableArray alloc] init];
    finalResultArray = [[NSMutableArray alloc] init];
    localFilteredArray = [[NSMutableArray alloc] init];
    localFilteredIndexArray = [[NSMutableArray alloc] init];
    localFinalResultArray = [[NSMutableArray alloc] init];

    searchKeyword = [[NSMutableString alloc] initWithString:@""];
    [self initDataForKey:nil withValue:@"全体员工"];
    [self makeTabBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    searchResultKeyboard.backgroundColor = [UIColor clearColor];
    popupT9KeyBoardBtn = [[UIButton alloc] initWithFrame:CGRectMake(128, 460 - 44, 64, 44)];
    [popupT9KeyBoardBtn addTarget:self action:@selector(keyboardPopup) forControlEvents:UIControlEventTouchUpInside];
    searchRange = contactNameArray;
    localSearchRange = localContactNameArray;
}

- (void)viewDidAppear:(BOOL)animated
{
    if(keyboardUIView.frame.origin.y > 459)
    {
        [self keyboardPopup];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [popupT9KeyBoardBtn removeFromSuperview];
}

- (void)initDataForKey:(NSString *)key withValue:(NSString *)value
{
    EBBookDatabase *myDatabase = [[EBBookDatabase alloc] init];
    [myDatabase openDB];
    contactNameArray = nil;
    self.contactNameArray = [myDatabase queryFromTableForKey:nil withValue:nil];
    self.localContactNameArray = [NSArray arrayWithArray:[((EBBookAppDelegate *)[UIApplication sharedApplication].delegate) localNamePhoneContact]] ;
    [contactNameArray retain];
    [myDatabase closeDB];
    [myDatabase release];
}

- (void)viewDidUnload
{
    [self setKeyboardMonitor:nil];
    [self setKeyboardUIView:nil];
    [self setSearchResultKeyboard:nil];
    [self setLocalContactNameArray:nil];
    [self setContactNameArray:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pressToDial:(UIButton *)sender {
    if ([[UIDevice currentDevice].model isEqualToString:@"iPod touch"] ||
        [[UIDevice currentDevice].model isEqualToString:@"iPad"]  ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，您的设备不支持电话功能"  message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        
        return;
    }
    
    if(keyboardMonitor.text.length < 1)
    {
        return;
    }
    NSDictionary *userInfo = [EBBookAccount loadDefaultAccount];
    BOOL dialFlag;
    if([[userInfo objectForKey:@"dialConfirm"] isEqualToString:@"YES"])
        dialFlag = YES;
    else {
        dialFlag = NO;
    }

    NSString *mobString;

    if (dialFlag) {
        mobString = [[NSString alloc] initWithFormat:@"telprompt:%@",keyboardMonitor.text];
    }
    else {
        mobString = [[NSString alloc] initWithFormat:@"tel:%@",keyboardMonitor.text];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobString]];
    [mobString release];
}

- (IBAction)keyboardType:(UIButton *)sender {
    NSString *userType = [NSString stringWithFormat:@"%d", (sender.tag - 910)];
    keyboardMonitor.text = [keyboardMonitor.text stringByAppendingString:userType];
    switch (userType.integerValue) {
        case 0:
            [searchKeyword appendString:@"0"];

            break;
        case 1:
            [searchKeyword appendString:@"1"];
            break;
        case 2:
            if(searchKeyword.length < 1)
                [searchKeyword appendString:@"^[a-c].*"];
            else {
                [searchKeyword appendString:@"[a-c].*"];
            }
            break;
        case 3:
            if(searchKeyword.length < 1)
                [searchKeyword appendString:@"^[d-f].*"];
            else {
                [searchKeyword appendString:@"[d-f].*"];
            }            
            break;
        case 4:
            if(searchKeyword.length < 1)
                [searchKeyword appendString:@"^[g-h].*"];
            else {
                [searchKeyword appendString:@"[g-i].*"];
            }
            break;
        case 5:
            if(searchKeyword.length < 1)
                [searchKeyword appendString:@"^[j-l].*"];
            else {
                [searchKeyword appendString:@"[j-l].*"];
            }
            break;
        case 6:
            if(searchKeyword.length < 1)
                [searchKeyword appendString:@"^[m-o].*"];
            else {
                [searchKeyword appendString:@"[m-o].*"];
            }
            break;
        case 7:
            if(searchKeyword.length < 1)
                [searchKeyword appendString:@"^[p-s].*"];
            else {
                [searchKeyword appendString:@"[p-s].*"];
            }
            break;
        case 8:
            if(searchKeyword.length < 1)
                [searchKeyword appendString:@"^[t].*"];
            else {
                [searchKeyword appendString:@"[t-v].*"];
            }
            break;
        case 9:
            if(searchKeyword.length < 1)
                [searchKeyword appendString:@"^[w-z].*"];
            else {
                [searchKeyword appendString:@"[w-z].*"];
            }
            break;
        default:
            break;
    }
    [self filterContentForSearchTextEx:searchKeyword];
    //[self filterContentForSearchTextEx:keyboardMonitor.text];
}

- (void)filterContentForSearchTextEx:(NSString *)regularExpression
{
    [filteredIndexArray removeAllObjects];
    [filteredArray removeAllObjects];
    
    [localFilteredArray removeAllObjects];
    [localFilteredIndexArray removeAllObjects];
    NSLog(@"%@",regularExpression);
    if(regularExpression.length < 1)
        return;
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression options:NSRegularExpressionCaseInsensitive error:&error];
    for(EBBookContact *toSearchContact in searchRange)
    {
        NSString *toSearchContactUid = toSearchContact.uid;
        NSTextCheckingResult *match = [regex firstMatchInString:toSearchContactUid options:0 range:NSMakeRange(0, [toSearchContactUid length])];
        if(match)
        {
            NSString *toSearchContactName = toSearchContact.name;
            NSMutableString *nameIndex = [[NSMutableString alloc] initWithString:@""];
            [nameIndex appendFormat:@"%c", [toSearchContactUid characterAtIndex:0]];
            int characterCount = toSearchContactName.length;
            for(int i = 1; i < characterCount; i++)
            {
                [nameIndex appendFormat:@"%c", pinyinFirstLetter([toSearchContactName characterAtIndex:i])];
            }
            NSMutableString *indexRegularExpression = [[NSMutableString alloc] initWithString:@""];
            [indexRegularExpression appendString: [regularExpression stringByReplacingOccurrencesOfString:@".*" withString:@""]];
            [indexRegularExpression appendString:@"$"];
            NSRegularExpression *indexRegex = [NSRegularExpression regularExpressionWithPattern:indexRegularExpression options:NSRegularExpressionCaseInsensitive error:&error];
            [indexRegularExpression release];
            NSTextCheckingResult *equalIndex = [indexRegex firstMatchInString:nameIndex options:0 range:NSMakeRange(0, [nameIndex length])];
            [nameIndex release];
            if(equalIndex)
                [filteredIndexArray addObject:toSearchContact];
            else {
                [filteredArray addObject:toSearchContact];
            }
        }
    }
    for(NSDictionary *localContact in localSearchRange)
    {
        NSString *toSearchContactUid = [localContact objectForKey:@"pinyin"];
        NSTextCheckingResult *match = [regex firstMatchInString:toSearchContactUid options:0 range:NSMakeRange(0, [toSearchContactUid length])];
        if(match)
        {
            NSString *toSearchContactName = [localContact objectForKey:@"name"];
            NSMutableString *nameIndex = [[NSMutableString alloc] initWithString:@""];
            [nameIndex appendFormat:@"%c", [toSearchContactUid characterAtIndex:0]];
            int characterCount = toSearchContactName.length;
            for(int i = 1; i < characterCount; i++)
            {
                [nameIndex appendFormat:@"%c", pinyinFirstLetter([toSearchContactName characterAtIndex:i])];
            }
            NSMutableString *indexRegularExpression = [[NSMutableString alloc] initWithString:@""];
            [indexRegularExpression appendString: [regularExpression stringByReplacingOccurrencesOfString:@".*" withString:@""]];
            [indexRegularExpression appendString:@"$"];
            NSRegularExpression *indexRegex = [NSRegularExpression regularExpressionWithPattern:indexRegularExpression options:NSRegularExpressionCaseInsensitive error:&error];
            [indexRegularExpression release];
            NSTextCheckingResult *equalIndex = [indexRegex firstMatchInString:nameIndex options:0 range:NSMakeRange(0, [nameIndex length])];
            [nameIndex release];
            if(equalIndex)
                [localFilteredIndexArray addObject:localContact];
            else {
                [localFilteredArray addObject:localContact];
            }
        }
    }
    [finalResultArray removeAllObjects];
    [finalResultArray addObjectsFromArray:filteredIndexArray];
    [finalResultArray addObjectsFromArray:filteredArray];

    [localFinalResultArray removeAllObjects];
    [localFinalResultArray addObjectsFromArray:localFilteredIndexArray];
    [localFinalResultArray addObjectsFromArray:localFilteredArray];
    
    [searchResultKeyboard reloadData];
    searchRange = finalResultArray;
    localSearchRange = localFinalResultArray;
}

- (IBAction)keyboardBackspace:(UIButton *)sender {
    int stringLength = keyboardMonitor.text.length;
    int keywordLength = searchKeyword.length;
    if(stringLength > 1)
    {
        keyboardMonitor.text = [keyboardMonitor.text substringToIndex:(stringLength - 1)];
        if([searchKeyword characterAtIndex:keywordLength-1] == '*')
            [searchKeyword deleteCharactersInRange:NSMakeRange((keywordLength - 7), 7)];
        else {
            [searchKeyword deleteCharactersInRange:NSMakeRange((keywordLength - 1), 1)];
        }
        searchRange = contactNameArray;
        [self filterContentForSearchTextEx:searchKeyword];
        [finalResultArray removeAllObjects];
        [finalResultArray addObjectsFromArray:filteredIndexArray];
        [finalResultArray addObjectsFromArray:filteredArray];
        
        [localFinalResultArray removeAllObjects];
        [localFinalResultArray addObjectsFromArray:localFilteredIndexArray];
        [localFinalResultArray addObjectsFromArray:localFilteredArray];
    }
    else if (stringLength == 1){
        keyboardMonitor.text = [keyboardMonitor.text substringToIndex:(stringLength - 1)];
        [searchKeyword deleteCharactersInRange:NSMakeRange(0, keywordLength)];
        [filteredIndexArray removeAllObjects];
        [filteredArray removeAllObjects];
        [finalResultArray removeAllObjects];
        
        [localFilteredIndexArray removeAllObjects];
        [localFilteredArray removeAllObjects];
        [localFinalResultArray removeAllObjects];
        
        searchRange = contactNameArray;
    }
    [searchResultKeyboard reloadData];
}

- (void)keyboardPopup
{
    [popupT9KeyBoardBtn removeFromSuperview];
    [self makeTabBarHidden:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:keyboardUIView cache:NO];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterPopup)];
    [keyboardUIView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [UIView commitAnimations];
}

- (IBAction)keyboardClose:(UIButton *)sender {
    searchResultKeyboard.frame = CGRectMake(0, 0, 320, 460);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:keyboardUIView cache:NO];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(afterClose)];
    [keyboardUIView setTransform:CGAffineTransformMakeTranslation(0, 249)];
    [UIView commitAnimations];
    
    [self.view bringSubviewToFront:searchResultKeyboard];
    [self.view bringSubviewToFront:keyboardUIView];
}

- (void)afterPopup
{
    [searchResultKeyboard setFrame:CGRectMake(0, 0, 320, 211)];
}

- (void)afterClose
{
    [self makeTabBarHidden:NO];
    [self.view.window addSubview: popupT9KeyBoardBtn];
}

#define CONTACTBOOKIMAGEVIEW ((UIImageView *)[cell viewWithTag:601])
#define TITLELABEL ((UILabel *)[cell viewWithTag:602])
#define DETAILLABEL ((UILabel *)[cell viewWithTag:603])

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"contactBookCustomCell";
    
    EBBookContactBookCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if(cell == nil)
    {
        //UINib *nib = [UINib nibWithNibName:@"EBBookContactBookCustomCell" bundle:nil];  
        //[tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EBBookContactBookCustomCell" owner:self options:nil] lastObject];
    }
    NSString *titleLabel;
    NSString *detailStr;

    if (indexPath.section == 0) {
        EBBookContact *toShowContact = (EBBookContact *)[finalResultArray objectAtIndex:indexPath.row];
        if([[EBBookAccount currentDateToString] isEqualToString:toShowContact.birthdate])
        {
            titleLabel = [[toShowContact name] stringByAppendingString:@"  🎂"];
            NSLog(@"%@", toShowContact.uid);
        }
        else {
            titleLabel = [toShowContact name];
        }
        TITLELABEL.text = titleLabel;

        if([[toShowContact tel] isEqualToString:@"0"])
            detailStr = [NSString stringWithFormat:@"%@", [toShowContact mobile]];
        else {
            detailStr = [NSString stringWithFormat:@"%@  分机:%@", [toShowContact mobile], [toShowContact tel]];
        }
        DETAILLABEL.text = detailStr;

        UIImage *headPortraitPhoto = [EBBookLocalContacts getPhotoForContact:[toShowContact uid]];
        if (headPortraitPhoto.size.height > 0.0000001) {
            // [cell.imageView setImage:headPortraitPhoto];
            [CONTACTBOOKIMAGEVIEW setImage:headPortraitPhoto];
        }
        else {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"adressbook_default@2x" ofType:@"png"];
            
            [CONTACTBOOKIMAGEVIEW setImage:[UIImage imageWithContentsOfFile:path]];
        }
    }
    else{
        NSDictionary *dic = [localFinalResultArray objectAtIndex:indexPath.row];
        ABContact *contact = [dic objectForKey:@"contact"];
        TITLELABEL.text = [dic objectForKey:@"name"];
        NSArray *phoneNumberArry = [dic objectForKey:@"mobile"];
        NSString *mobileNumber = nil;

        if ([phoneNumberArry count] > 0) {
            mobileNumber = [phoneNumberArry objectAtIndex:0];
            NSMutableString *phone = [[NSMutableString alloc] initWithString:mobileNumber];
            if ([phoneNumberArry count] > 1) {
                [phone appendFormat:@"  (%d个号)",[phoneNumberArry count]];
            }
            NSString *detailString = [[phone stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            [phone release];
            DETAILLABEL.text = detailString;
        }
        else
        {
            DETAILLABEL.text = @"";
        }
        
        if (contact.image) {
            [CONTACTBOOKIMAGEVIEW setImage:contact.image];
        }
        else {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"adressbook_default@2x" ofType:@"png"];
            [CONTACTBOOKIMAGEVIEW setImage:[UIImage imageWithContentsOfFile:path]];
            
        }
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        EBBookContact* selectedContact = [finalResultArray objectAtIndex:indexPath.row];
        
        EBADBookDetailViewController *detailViewController = [[EBADBookDetailViewController alloc] initWithEBContact: selectedContact];
        detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        [navController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        [self presentModalViewController:navController animated:YES];
        detailViewController.freeJump = NO;
        [detailViewController release];
        [navController release];
    }
    else{
        NSDictionary *dic = [localFinalResultArray objectAtIndex:indexPath.row];
        NSString *contactName = @"";
        contactName = [dic objectForKey:@"name"];
        ABContact *contact = [dic objectForKey:@"contact"];
        
        EBBookLocalDetailViewController *pvc = [[[EBBookLocalDetailViewController alloc] initWithNibTitle:contactName] autorelease];
        
        [pvc.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        pvc.displayedPerson = contact.record;
        pvc.allowsEditing = YES;
        //pvc.allowsActions = YES;
        pvc.personViewDelegate = self;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:pvc];
        navi.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:navi animated:YES];
        [navi release];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"集团通讯录搜索结果";
    }
    else{
        return @"本地通讯录搜索结果";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        if ([finalResultArray count] > 0) {
            return 20;
        }
        else{
            return 0;
        }
    }
    if (section == 1) {
        if ([localFinalResultArray count] > 0) {
            return 20;
        }
        else{
            return 0;
        }
    }
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [finalResultArray count];
    }
    else{
        return [localFinalResultArray count];
    }
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self keyboardClose:nil];
//    searchResultKeyboard.frame = CGRectMake(0, 0, 320, 460-44);
//}

- (void)dealloc {
    [popupT9KeyBoardBtn release];
    [filteredArray release];
    [filteredIndexArray release];
    [finalResultArray release];
    [localFilteredIndexArray release];
    [localFinalResultArray release];
    [localFilteredArray release];
    [searchKeyword release];
    [keyboardMonitor release];
    [keyboardUIView release];
    [searchResultKeyboard release];
    [contactNameArray release];
    [localContactNameArray release];
    [super dealloc];
}

#pragma mark - ABPersonViewControllerDelegate
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier;
{
    ABContact *contact = [ABContact contactWithRecord:person];
    
    NSArray *array = [ABContact arrayForProperty:property inRecord:contact.record];
    if (kABPersonPhoneProperty == property) {
        /*
         NSString *stringNumber = [array objectAtIndex:identifier];
         NSString *phoneString = [[NSString alloc] initWithFormat:@"telprompt:%@",stringNumber];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
         [phoneString release];
         */
        NSString *stringNumber = [array objectAtIndex:identifier];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择" message:stringNumber delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"电话",@"短信", nil ];
        alert.tag = 401;
        [alert show];
        [alert release];
        return NO;
    }
    else if (kABPersonEmailProperty == property) {
        NSString *mailAddress = [array objectAtIndex:identifier];
        NSString *mailString = [[NSString alloc] initWithFormat:@"mailto:%@",mailAddress];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
        [mailString release];
        return NO;
        
    }
    
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 401) {
        if (buttonIndex == 1) {
            NSString *phoneString = [[NSString alloc] initWithFormat:@"tel:%@",alertView.message];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
            [phoneString release];
        }
        else if (buttonIndex == 2){
            NSString *phoneString = [[NSString alloc] initWithFormat:@"sms:%@",alertView.message];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
            [phoneString release];
        }
    }
}

@end
