//
//  CUITextView.h
//  textview
//
//  Created by Volodymyr Boichentsov on 10/22/11.
//  Copyright (c) 2011 www.developers-life.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


@interface CUITextView : UITextView  {
	NSMutableAttributedString* _attributedText; //!< Internally mutable, but externally immutable copy 
    CTFrameRef textFrame;
    
	CGRect drawingRect;
}



@property (nonatomic, copy) NSAttributedString* attributedText; 
@property (nonatomic) BOOL draw;

@property short int fontSize;

- (void) resetAttributedText;

- (NSMutableAttributedString*) setColor:(UIColor*)color words:(NSArray*)words inText:(NSMutableAttributedString*)mutableAttributedString;

- (void) highlightingText: (NSMutableAttributedString*) mutableAttributedString;


@end
