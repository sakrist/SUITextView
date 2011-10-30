//
//  CUITextView.m
//  textview
//
//  Created by Volodymyr Boichentsov on 10/22/11.
//  Copyright (c) 2011 www.injoit.com. All rights reserved.
//

#import "CUITextView.h"
#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

#import "NSAttributedString+Attributes.h"

/////////////////////////////////////////////////////////////////////////////
// MARK: Private Utility methods

CGPoint CGPointFlipped(CGPoint point, CGRect bounds);
CGRect CGRectFlipped(CGRect rect, CGRect bounds);
NSRange NSRangeFromCFRange(CFRange range);
CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin);
CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin);
BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range);
BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range);

/////////////////////////////////////////////////////////////////////////////
// MARK: -
/////////////////////////////////////////////////////////////////////////////


//CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment) {
//	switch (alignment) {
//		case UITextAlignmentLeft: return kCTLeftTextAlignment;
//		case UITextAlignmentCenter: return kCTCenterTextAlignment;
//		case UITextAlignmentRight: return kCTRightTextAlignment;
//		case UITextAlignmentJustify: return kCTJustifiedTextAlignment; /* special OOB value if we decide to use it even if it's not really standard... */
//		default: return kCTNaturalTextAlignment;
//	}
//}
//
//CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode) {
//	switch (lineBreakMode) {
//		case UILineBreakModeWordWrap: return kCTLineBreakByWordWrapping;
//		case UILineBreakModeCharacterWrap: return kCTLineBreakByCharWrapping;
//		case UILineBreakModeClip: return kCTLineBreakByClipping;
//		case UILineBreakModeHeadTruncation: return kCTLineBreakByTruncatingHead;
//		case UILineBreakModeTailTruncation: return kCTLineBreakByTruncatingTail;
//		case UILineBreakModeMiddleTruncation: return kCTLineBreakByTruncatingMiddle;
//		default: return 0;
//	}
//}

// Don't use this method for origins. Origins always depend on the height of the rect.
CGPoint CGPointFlipped(CGPoint point, CGRect bounds) {
	return CGPointMake(point.x, CGRectGetMaxY(bounds)-point.y);
}

CGRect CGRectFlipped(CGRect rect, CGRect bounds) {
	return CGRectMake(CGRectGetMinX(rect),
					  CGRectGetMaxY(bounds)-CGRectGetMaxY(rect),
					  CGRectGetWidth(rect),
					  CGRectGetHeight(rect));
}

NSRange NSRangeFromCFRange(CFRange range) {
	return NSMakeRange(range.location, range.length);
}

// Font Metrics: http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/FontHandling/Tasks/GettingFontMetrics.html
CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin) {
	CGFloat ascent = 0;
	CGFloat descent = 0;
	CGFloat leading = 0;
	CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	CGFloat height = ascent + descent /* + leading */;
	
	return CGRectMake(lineOrigin.x,
					  lineOrigin.y - descent,
					  width,
					  height);
}

CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin) {
	CGFloat ascent = 0;
	CGFloat descent = 0;
	CGFloat leading = 0;
	CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
	CGFloat height = ascent + descent /* + leading */;
	
	CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
	
	return CGRectMake(lineOrigin.x + xOffset,
					  lineOrigin.y - descent,
					  width,
					  height);
}

BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range) {
	NSRange lineRange = NSRangeFromCFRange(CTLineGetStringRange(line));
	NSRange intersectedRange = NSIntersectionRange(lineRange, range);
	return (intersectedRange.length > 0);
}

BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range) {
	NSRange runRange = NSRangeFromCFRange(CTRunGetStringRange(run));
	NSRange intersectedRange = NSIntersectionRange(runRange, range);
	return (intersectedRange.length > 0);
}


@implementation CUITextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}





- (void) awakeFromNib {
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setText:self.text];
    [self setTextColor:[UIColor clearColor]];
    [self setFont:[UIFont fontWithName:@"Menlo" size:12]];
}

- (void)setText:(NSString *)text {
    text = [text stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];
    
	[super setText:text]; // will call setNeedsDisplay too
	[self resetAttributedText];
}

- (void) resetAttributedText {
    

    NSMutableAttributedString* mutAttrStr = [NSMutableAttributedString attributedStringWithString:self.text];

	[mutAttrStr setTextColor:[UIColor blackColor]];
    [mutAttrStr setFont:[UIFont fontWithName:@"Menlo" size:12]];
   
    
    
    NSUInteger count = 0, length = [self.text length];
    NSRange range = NSMakeRange(0, length); 
    while(range.location != NSNotFound)
    {
        range = [self.text rangeOfString:@"code" options:0 range:range];
        if(range.location != NSNotFound)
        {
            [mutAttrStr setTextColor:[UIColor blueColor] range:NSMakeRange(range.location, 4) ];
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
            
        }
    }
    
    NSArray *array = [NSArray arrayWithObjects:@"void", @"self", @"while", @"if", @"else", @"for", nil];
    
    
    UIColor *opColor = [UIColor colorWithRed:193.f/255.f green:63.f/255.f blue:178.f/255.f alpha:1];
    
    for (NSString *op in array) {
        count = 0, length = [self.text length];
        range = NSMakeRange(0, length); 
        while(range.location != NSNotFound)
        {
            range = [self.text rangeOfString:op options:0 range:range];
            if(range.location != NSNotFound) {
                [mutAttrStr setTextColor:opColor range:NSMakeRange(range.location, [op length])];
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count++; 
            }
        }
    }
    self.attributedText = mutAttrStr;
}

- (NSAttributedString *) attributedText {
	if (!_attributedText) {
		[self resetAttributedText];
	}
	return [[_attributedText copy] autorelease]; // immutable autoreleased copy
}
- (void) setAttributedText:(NSAttributedString*)attributedText {
	[_attributedText release];
	_attributedText = [attributedText mutableCopy];
	[self setNeedsDisplay];
}


- (void) resetTextFrame {
	if (textFrame) {
		CFRelease(textFrame);
		textFrame = NULL;
	}
}

- (void) setNeedsDisplay {
	[self resetTextFrame];
	[super setNeedsDisplay];
}


- (void)drawRect:(CGRect)aRect
{
    
 //   NSLog(@"%@ %@", NSStringFromCGRect(aRect), NSStringFromCGRect(self.bounds));
    
    CGRect r = self.bounds;
    r.origin.y = self.contentOffset.y;
    r.size.height = self.contentSize.height;
    [[UIColor clearColor] setFill];
	if (_attributedText) {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		
		// flipping the context to draw core text
		// no need to flip our typographical bounds from now on
		CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(8, r.size.height+8), 1.f, -1.f));

        
        NSMutableAttributedString* attrStrWithLinks = [self.attributedText mutableCopy];
        
		if (textFrame == NULL) {
			CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStrWithLinks);

			drawingRect = CGRectMake(0, 0, self.bounds.size.width-16, r.size.height);
            
            
			CGMutablePathRef path = CGPathCreateMutable();
			CGPathAddRect(path, NULL, drawingRect);
//            drawingRect.size.height += 1;
			textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
            
			CGPathRelease(path);
			CFRelease(framesetter);
		}
		
		
		CTFrameDraw(textFrame, ctx);
        
		CGContextRestoreGState(ctx);
    }
    [super drawRect:aRect];
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
