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


@implementation CUITextView

@synthesize draw=_draw;

@synthesize fontSize=_fontSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
        
    self.fontSize = 14;
    
    _draw = YES;
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setTextColor:[UIColor clearColor]];
    [self setFont:[UIFont fontWithName:@"Menlo" size:_fontSize]];
    [self setText:self.text];
    [self setDataDetectorTypes:0];

}


- (void)setText:(NSString *)text {
    
    text = [text stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];
    
	[super setText:text]; // will call setNeedsDisplay too
	[self resetAttributedText];
}


- (NSMutableAttributedString*) setColor:(UIColor*)color words:(NSArray*)words inText:(NSMutableAttributedString*)mutableAttributedString {
    
    NSUInteger count = 0, length = [mutableAttributedString length];
    NSRange range = NSMakeRange(0, length);
    
    for (NSString *op in words) {
        count = 0, length = [mutableAttributedString length];
        range = NSMakeRange(0, length); 
        while(range.location != NSNotFound)
        {
            range = [[mutableAttributedString string] rangeOfString:op options:0 range:range];
            if(range.location != NSNotFound) {
                [mutableAttributedString setTextColor:color range:NSMakeRange(range.location, [op length])];
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count++; 
            }
        }
    }
    
    return mutableAttributedString;
}


- (void) highlightingText: (NSMutableAttributedString*) mutableAttributedString {
    
}




- (void) resetAttributedText {    

    NSMutableAttributedString* mutableAttributedString = [NSMutableAttributedString attributedStringWithString:self.text];

	[mutableAttributedString setTextColor:[UIColor blackColor]];
    [mutableAttributedString setFont:self.font];
    
   
    [self highlightingText:mutableAttributedString];
    
    self.attributedText = mutableAttributedString;
    
    [self setTextAlignment:UITextAlignmentLeft];
    
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


- (void)drawRect:(CGRect)aRect {
    
    if (!_draw) {
        return;
    }
    
    short int cfontSize = self.font.lineHeight;
        
    CGRect r = self.bounds;
    r.origin.y = self.contentOffset.y;

    [[UIColor clearColor] setFill];
	if (_attributedText) {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		
		// flipping the context to draw core text
		// no need to flip our typographical bounds from now on
		CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, r.size.height+6.5), 1.f, -1.f));
        
        NSMutableAttributedString* attrStrWithLinks = [self.attributedText mutableCopy];
        
		if (textFrame == NULL) {

            
            NSArray *paragraphs = [self.text componentsSeparatedByString:@"\n"];
            
            CGSize constraint = CGSizeMake(self.bounds.size.width-8, 999999 /*arbitrarily large number*/);
            NSInteger paragraphNo = 0;
            CGFloat offset = 0;
            
            NSInteger fromlocation = 0;
            
            int linesheight = 0;
            
            
            for (NSString* paragraph in paragraphs) {
                
                // replace \t on spaces
                NSString *_paragraph = [paragraph stringByReplacingOccurrencesOfString:@"\t" withString:@"        "];
                CGSize paragraphSize = [_paragraph sizeWithFont:self.font 
                                             constrainedToSize:constraint 
                                                 lineBreakMode:UILineBreakModeWordWrap];
                
                offset += paragraphSize.height;
                
                if (paragraphSize.height == 0) {
                    offset += self.font.lineHeight;
                }
                
                
                
                if(offset > self.contentOffset.y) {
                    int linescount = paragraphSize.height/cfontSize;
                
                    if (linescount > 1) {

                        int visible = (int)offset%(int)self.contentOffset.y;

                        linesheight = (paragraphSize.height/cfontSize) - visible /cfontSize;
                        
                        if (visible % cfontSize == 0) {
                            linesheight++;
                        }
                        
                        linesheight--;
                        if (linesheight < 0) {
                            linesheight = 0;
                        }
                    }
                    
                    break;
                }
                
                fromlocation += [paragraph length]+1;
                
                paragraphNo++;
            }   
            
            // find visible paragraph
            
            int delta = (int)self.contentOffset.y % cfontSize +linesheight*cfontSize;
            
            if (self.contentOffset.y < 0) {
                delta = self.contentOffset.y;
            }
            
            
            
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStrWithLinks);
            
            
//            double width = self.bounds.size.width-8;
            // Initialize those variables.
        
            // Create a typesetter using the attributed string.
//            CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attrStrWithLinks);
        
            // Find a break for line from the beginning of the string to the given width.
            
            drawingRect = CGRectMake(0, -r.origin.y, self.bounds.size.width-8, r.size.height+delta);
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, drawingRect);
            
            textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(fromlocation,0), path, NULL);

            // ---------------
            CFArrayRef lines = CTFrameGetLines(textFrame);
            CFIndex lineCount = CFArrayGetCount(lines);
            CGPoint lineOrigins[lineCount];
            CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), lineOrigins);
            for (CFIndex lineIndex = 0; lineIndex  < lineCount; lineIndex++) {
                CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
                CFRange _r = CTLineGetStringRange(line);
                
                
                
                NSString *string = [[attrStrWithLinks string] substringWithRange:NSMakeRange(_r.location+_r.length-1, 1)];
                
                BOOL drawnew = NO;
                
                if ([string isEqualToString:@"/"] || [string isEqualToString:@":"]) {
                    
//                    drawnew = YES;
//          
//                    CFIndex count = CTTypesetterSuggestLineBreak(typesetter, _r.location, width);
//                    CTLineRef newline = CTTypesetterCreateLine(typesetter, CFRangeMake(_r.location, count));
//                    CFRange __r = CTLineGetStringRange(newline);
                }
                
                
                CGContextSetTextPosition(ctx, lineOrigins[lineIndex].x, lineOrigins[lineIndex].y-r.origin.y);
                if (drawnew) {
//                    CTLineDraw(newline, ctx);
                } else {
                    CTLineDraw(line, ctx);
                }
                
                
//                CFRelease(newline);
            }
            // ---------------

            
			CGPathRelease(path);
			CFRelease(framesetter);
		}
		
		
//		CTFrameDraw(textFrame, ctx);
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
