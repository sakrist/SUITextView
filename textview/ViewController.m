//
//  ViewController.m
//  textview
//
//  Created by Volodymyr Boichentsov on 10/22/11.
//  Copyright (c) 2011 www.injoit.com. All rights reserved.
//

#import "ViewController.h"
#import "CUITextView.h"

@implementation ViewController

@synthesize cTextView=_cTextView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction) setColor {
    if ([_cTextView.textColor isEqual:[UIColor blackColor]])
    {
        [_cTextView setTextColor:[UIColor clearColor]];
    } else {
        [_cTextView setTextColor:[UIColor blackColor]];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
//    [textView setText:textView.text];
//    [textView setNeedsDisplay];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
        [(CUITextView*)textView resetAttributedText];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
}

- (void) scrollViewDidScroll: (UIScrollView*) scrollView {
    // 
    NSLog(@"scrollViewDidScroll The scroll offset is ---%f",scrollView.contentOffset.y); 
    [scrollView setNeedsDisplay];
    
}















#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", [UIFont familyNames]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
