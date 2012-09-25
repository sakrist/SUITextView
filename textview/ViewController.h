//
//  ViewController.h
//  textview
//
//  Created by Volodymyr Boichentsov on 10/22/11.
//  Copyright (c) 2011 www.developers-life.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CUITextViewHighlighting;

@interface ViewController : UIViewController <UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *lbl;


@property (nonatomic, strong) IBOutlet CUITextViewHighlighting* cTextView;

- (IBAction) showtext;
- (IBAction) draw;

@end
