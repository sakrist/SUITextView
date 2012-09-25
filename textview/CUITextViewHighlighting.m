//
//  CUITextViewHighlighting.m
//  textview
//
//  Created by Volodymyr Boichentsov on 11/6/11.
//  Copyright (c) 2011 www.developers-life.com. All rights reserved.
//

#import "CUITextViewHighlighting.h"
#import "NSAttributedString+Attributes.h"


#define redColor [UIColor colorWithRed:203.f/255.f green:46.0/255.f blue:31.f/255.f alpha:1]
#define greenColor [UIColor colorWithRed:0 green:100.0/255.f blue:0 alpha:1]



@implementation CUITextViewHighlighting

- (void) setFont:(UIFont *)font {
    self.fontSize = font.pointSize;
    [super setFont:font];
    [super resetAttributedText];
}


- (NSMutableAttributedString*) setColor:(UIColor*)color words:(NSArray*)words inText:(NSMutableAttributedString*)mutableAttributedString {
    return [super setColor:color words:words inText:mutableAttributedString];
}



- (void) highlightingText: (NSMutableAttributedString*) mutableAttributedString {
    
    [super highlightingText:mutableAttributedString];
    

    // Text in @""
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:@"((@\"|\").*?(\"))"
                                              options:NSRegularExpressionDotMatchesLineSeparators 
                                                error:nil];
    NSArray *textArr = [exp matchesInString:[mutableAttributedString string] options:0 range:NSMakeRange(0, [[mutableAttributedString string] length])];
    
    for (NSTextCheckingResult *result in textArr) {
        [mutableAttributedString setTextColor:redColor range:result.range];
    }
    

    // Comments
    exp = [NSRegularExpression regularExpressionWithPattern:@"(//[^\"\n]*)"
                                                    options:0
                                                    error:nil];
    
    NSArray * arrayComments = [exp matchesInString:[mutableAttributedString string] options:0 range:NSMakeRange(0, [[mutableAttributedString string] length])];
    
    for (NSTextCheckingResult *resultComment in arrayComments) {
      
        BOOL inside = NO;
        
        for (NSTextCheckingResult *resultText in textArr) {
            
            NSInteger from = resultText.range.location;
            NSInteger to = resultText.range.location+resultText.range.length;
            
            NSInteger now = resultComment.range.location;
            
            if (from < now && now < to) {
                inside = YES;
                break;
            }
        }
        if (!inside) {
            [mutableAttributedString setTextColor:greenColor range:resultComment.range];
        }
    }

    
    exp = [NSRegularExpression regularExpressionWithPattern:@"((<).*(>))"
                                                    options:0
                                                      error:nil];
    NSArray * arr = [exp matchesInString:[mutableAttributedString string] options:0 range:NSMakeRange(0, [[mutableAttributedString string] length])];
    for (NSTextCheckingResult *result in arr) {
        [mutableAttributedString setTextColor:redColor range:result.range];
    }
    
    
    
    
    UIColor *opColor = [UIColor colorWithRed:120.f/255.f green:78.f/255.f blue:47.f/255.f alpha:1];
    NSArray *array = [NSArray arrayWithObjects:@"#import", @"#define", @"#if", nil];
    [self setColor:opColor words:array inText:mutableAttributedString];
    
    

    opColor = [UIColor colorWithRed:193.f/255.f green:63.f/255.f blue:178.f/255.f alpha:1];
    array = [NSArray arrayWithObjects:@"id", @"_cmd", @"@implementation", @"@synthesize", @"return", @"void", @"self", @"while", @"if", @"else", @"for", @"@end", @"super", @"YES", @"nil", nil];
    [self setColor:opColor words:array inText:mutableAttributedString];

    
    
    opColor = [UIColor colorWithRed:110.f/255.f green:50.f/255.f blue:170.f/255.f alpha:1];
    array = [NSArray arrayWithObjects:@"NSArray", @"UIColor", @"NSUInteger", @"NSRange", @"NSMutableAttributedString", @"NSString", @"location", @"UIFont", @"CGRect", @"CTFramesetterRef", @"CGMutablePathRef", @"CFAttributedStringRef", @"NSAttributedString", nil];
    [self setColor:opColor words:array inText:mutableAttributedString];    

    
    

    NSUInteger count = 0, length = [mutableAttributedString length];
    NSRange range = NSMakeRange(0, length);
    opColor = [UIColor colorWithRed:0 green:100.0/255.f blue:0 alpha:1];
    
    while(range.location != NSNotFound)
    {
        range = [[mutableAttributedString string] rangeOfString:@"//" options:0 range:range];
        if(range.location != NSNotFound) {
            
            NSRange endline_range = NSMakeRange(range.location, length-range.location);
            endline_range = [[mutableAttributedString string] rangeOfString:@"\n" options:0 range:endline_range];
            
            int n_pos = (endline_range.location != NSNotFound)? endline_range.location : length;
            
            int len = (endline_range.location != NSNotFound)? endline_range.location-range.location : length-range.location;
            
            [mutableAttributedString setTextColor:opColor range:NSMakeRange(range.location, len)];
            range = NSMakeRange(n_pos, length - n_pos);
            count++; 
        }
    }
    
    
    count = 0, length = [mutableAttributedString length];
    range = NSMakeRange(0, length);
    opColor = [UIColor colorWithRed:0 green:100.0/255.f blue:0 alpha:1];
    
    while(range.location != NSNotFound)
    {
        range = [[mutableAttributedString string] rangeOfString:@"/*" options:0 range:range];
        if(range.location != NSNotFound) {
            
            NSRange endline_range = NSMakeRange(range.location, length-range.location);
            endline_range = [[mutableAttributedString string] rangeOfString:@"*/" options:0 range:endline_range];
            
            int n_pos = (endline_range.location != NSNotFound)? endline_range.location : length;
            
            int len = (endline_range.location != NSNotFound)? endline_range.location-range.location : length-range.location;
            len += (endline_range.location != NSNotFound)?2:0;
            
            [mutableAttributedString setTextColor:opColor range:NSMakeRange(range.location, len)];
            range = NSMakeRange(n_pos, length - n_pos);
            count++; 
        }
    }
    
    
    
    count = 0, length = [mutableAttributedString length];
    range = NSMakeRange(0, length);
    opColor = [UIColor colorWithRed:203.f/255.f green:46.0/255.f blue:31.f/255.f alpha:1];
    
    while(range.location != NSNotFound)
    {
        range = [[mutableAttributedString string] rangeOfString:@"\"" options:0 range:range];
        
        if(range.location != NSNotFound) {
            
            
            NSString *s = [[mutableAttributedString string] substringWithRange:NSMakeRange(range.location-1, 1)];
            
            if ([s isEqualToString:@"@"]) {
                range.location -= 1;
                range.length += 1;
            }
            
            NSRange endline_range = NSMakeRange(range.location+range.length, length-range.location-range.length);
            endline_range = [[mutableAttributedString string] rangeOfString:@"\"" options:0 range:endline_range];
            
            int n_pos = (endline_range.location != NSNotFound)? endline_range.location : length;
            
            int len = (endline_range.location != NSNotFound)? endline_range.location-range.location : length-range.location;
            len += (endline_range.location != NSNotFound)?1:0;
            
            [mutableAttributedString setTextColor:opColor range:NSMakeRange(range.location, len)];
            range = NSMakeRange(n_pos+range.length, length - n_pos-range.length);
            count++; 
        }
    }
    
    count = 0, length = [mutableAttributedString length];
    range = NSMakeRange(0, length);
    //opColor = [UIColor colorWithRed:0 green:100.0/255.f blue:0 alpha:1];
    
    while(range.location != NSNotFound)
    {
        range = [[mutableAttributedString string] rangeOfString:@"<" options:0 range:range];
        if(range.location != NSNotFound) {
            
            NSRange endline_range = NSMakeRange(range.location, length-range.location);
            endline_range = [[mutableAttributedString string] rangeOfString:@">" options:0 range:endline_range];
            
            int n_pos = (endline_range.location != NSNotFound)? endline_range.location : length;
            
            int len = (endline_range.location != NSNotFound)? endline_range.location-range.location : length-range.location;
            len += (endline_range.location != NSNotFound)?1:0;
            
            [mutableAttributedString setTextColor:opColor range:NSMakeRange(range.location, len)];
            range = NSMakeRange(n_pos, length - n_pos);
            count++; 
        }
    }
    
}



@end
