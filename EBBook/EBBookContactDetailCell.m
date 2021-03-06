//
//  EBBookContactDetailCell.m
//  EBBook
//
//  Created by 延晋 张 on 12-6-20.
//  Copyright (c) 2012年 Ebupt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBBookContactDetailCell.h"

@interface EBBookContactDetailCell ()
{
    UILabel *titleLabel;
    UILabel *detailLabel;
    
    UIButton *messageButton;
}
@end


@implementation EBBookContactDetailCell
@synthesize delegate;
@synthesize title;
@synthesize detail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier flag:(BOOL) hidden
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self = self.delegate;
        [self setContentMode:UIViewContentModeScaleToFill];
        UILabel	*_labelTetle = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 71, 15)];
		_labelTetle.textAlignment = UITextAlignmentRight;
		_labelTetle.textColor = [UIColor colorWithRed:82.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
        _labelTetle.highlightedTextColor = [UIColor whiteColor];
        [_labelTetle setFont:[UIFont  fontWithName:@"Helvetica-Bold"  size:12]];
		_labelTetle.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_labelTetle];
		titleLabel = _labelTetle;
		[_labelTetle release];
 
  /*      
        UILabel	*_labelDetail = [[UILabel alloc] initWithFrame:CGRectMake(83, 12, 200, 19)];
        [_labelDetail setFont:[UIFont  fontWithName:@"Helvetica-Bold"  size:15]];
        _labelDetail.textColor = [UIColor blackColor];
        _labelDetail.highlightedTextColor = [UIColor whiteColor];
        _labelDetail.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_labelDetail];
		detailLabel = _labelDetail;
		[_labelDetail release];
   */
        
        UILabel	*_labelDetail = [[UILabel alloc] initWithFrame:CGRectMake(83, 12, 200, 19)];
        _labelDetail.numberOfLines = 0;
        _labelDetail.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        _labelDetail.textColor = [UIColor blackColor];
        _labelDetail.highlightedTextColor = [UIColor whiteColor];
        _labelDetail.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_labelDetail];
		detailLabel = _labelDetail;
		[_labelDetail release];
        
        
        UIImage *image = [UIImage imageNamed:@"message"];
        //UIImage *image_open = [UIImage imageNamed:@"Message Open.png"];
        UIButton *_messageButton = [[UIButton alloc] initWithFrame:CGRectMake(245,12,28,20)];
        [_messageButton setBackgroundImage:image forState:UIControlStateNormal];
        [_messageButton setShowsTouchWhenHighlighted:YES];
        //[_messageButton setBackgroundImage:image_open forState:UIControlStateHighlighted];
        [_messageButton addTarget:self action:@selector(messageButtonPressed: event:) forControlEvents:UIControlEventTouchUpInside];
        _messageButton.hidden = hidden;
        _messageButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_messageButton];
        /*
        UIImage *image = [UIImage imageNamed:@""];
        UIButton *_messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(253,0,37,37);
        _messageButton.frame = frame;
        [_messageButton setBackgroundImage:image forState:UIControlStateNormal];
         self.accessoryView = _messageButton;
         */
        [_messageButton release];
    }
    return self;
}
- (void) dealloc
{
    //[titleLabel release];
    [super dealloc];
}

- (void) changeLines
{
    CGSize size = CGSizeMake(205, 38);
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    CGSize labelsize = [[detailLabel text] sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    detailLabel.frame = CGRectMake(83, 12, labelsize.width, labelsize.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)t {
    if (![t isEqualToString:title]) {
        title = [[NSString alloc] initWithString:t];
        titleLabel.text = title;
        [title release];
    }
}

- (void)setDetail:(NSString *)d{
    if (![d isEqualToString:detail]) {
        detail = d.copy;
        detailLabel.text = detail;
    }
}

- (void)messageButtonPressed:(id)sender event:(id) event
{
    [self.delegate cellSendMessage];
}
 
/*
- (void)messageButtonPressed:(id)sender event:(id) event {
    NSString *mobString = [[NSString alloc] initWithFormat:@"sms:%@",detailLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobString]];
    [mobString release];
}
 */        
@end
