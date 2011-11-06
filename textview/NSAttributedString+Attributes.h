


#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>


/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: NSAttributedString Additions
/////////////////////////////////////////////////////////////////////////////

@interface NSAttributedString (Additions)
+(id)attributedStringWithString:(NSString*)string;
+(id)attributedStringWithAttributedString:(NSAttributedString*)attrStr;

//! Commodity method that call the following sizeConstrainedToSize:fitRange: method with NULL for the fitRange parameter
-(CGSize)sizeConstrainedToSize:(CGSize)maxSize;
//! if fitRange is not NULL, on return it will contain the used range that actually fits the constrained size.
//! Note: Use CGFLOAT_MAX for the CGSize's height if you don't want a constraint for the height.
-(CGSize)sizeConstrainedToSize:(CGSize)maxSize fitRange:(NSRange*)fitRange;
@end


/////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: NSMutableAttributedString Additions
/////////////////////////////////////////////////////////////////////////////

@interface NSMutableAttributedString (Additions)

-(void)setFont:(UIFont*)font;
-(void)setFont:(UIFont*)font range:(NSRange)range;
-(void)setFontName:(NSString*)fontName size:(CGFloat)size lineHeight:(CGFloat)lineHeight;
-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range lineHeight:(CGFloat)lineHeight;
-(void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range;

-(void)setTextColor:(UIColor*)color;
-(void)setTextColor:(UIColor*)color range:(NSRange)range;
-(void)setTextIsUnderlined:(BOOL)underlined;
-(void)setTextIsUnderlined:(BOOL)underlined range:(NSRange)range;
-(void)setTextUnderlineStyle:(int32_t)style range:(NSRange)range; //!< style is a combination of CTUnderlineStyle & CTUnderlineStyleModifiers
-(void)setTextBold:(BOOL)bold range:(NSRange)range;

-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode;
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode range:(NSRange)range;
@end


