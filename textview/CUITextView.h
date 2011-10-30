//
//  CUITextView.h
//  textview
//
//  Created by Volodymyr Boichentsov on 10/22/11.
//  Copyright (c) 2011 www.injoit.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


@interface CUITextView : UITextView  {
	NSMutableAttributedString* _attributedText; //!< Internally mutable, but externally immutable copy 
    CTFrameRef textFrame;
	CGRect drawingRect;

}

@property(nonatomic, copy) NSAttributedString* attributedText; //!< Use this instead of the "text" property inherited from UILabel to set and get text


- (void) resetAttributedText;


@end
