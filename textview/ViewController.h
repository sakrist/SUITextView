//
//  ViewController.h
//  textview
//
//  Created by Volodymyr Boichentsov on 10/22/11.
//  Copyright (c) 2011 www.injoit.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CUITextView;

@interface ViewController : UIViewController <UITextViewDelegate, UIScrollViewDelegate>


@property (nonatomic, strong) IBOutlet CUITextView* cTextView;

- (IBAction) setColor;

@end
