//
//  FCRegex.m
//  FCLinkPreview
//
//  Created by Smolski, Aliaksei on 03.08.16.
//  Copyright © 2016 Smolski, Aliaksei. All rights reserved.
//

#import "FCRegex.h"
NSString * const imagePattern = @"(.+?)\\.(gif|jpg|jpeg|png|bmp)$";
NSString * const imageTagPattern = @"<img(.+?)src=\"([^\"]+)\"(.+?)[/]?>";
NSString * const titlePattern = @"<title(.*?)>(.*?)</title>";
NSString * const metatagPattern = @"<meta(.*?)>";
NSString * const metatagContentPattern = @"content=(\"(.*?)\")|('(.*?)')";
NSString * const cannonicalUrlPattern = @"([^\\+&#@%\\?=~_\\|!:,;]+)";
NSString * const rawUrlPattern = @"((http[s]?|ftp|file)://)?((([-a-zA-Z0-9]+\\.)|\\.)+[-a-zA-Z0-9]+)[-a-zA-Z0-9+&@#/%?=~_|!:,\\.;]*";
NSString * const rawTagPattern = @"<[^>]+>";
NSString * const inlineStylePattern = @"<style(.*?)>(.*?)</style>";
NSString * const inlineScriptPattern = @"<script(.*?)>(.*?)</script>";
NSString * const linkPattern = @"<link(.*?)>";
NSString * const scriptPattern = @"<script(.*?)>";
NSString * const commentPattern = @"<!--(.*?)-->";

@implementation FCRegex
 // Test regular expression
+ (BOOL)testString:(NSString *)string regex:(NSString *)regex {
    return [FCRegex pregMatchFirstString:string regex:regex index:0];
}

 // Match first occurrency
+ (NSString *)pregMatchFirstString:(NSString *)string regex:(NSString *)regex index:(NSUInteger)index {
    NSRegularExpression *rx = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:NULL];
    NSTextCheckingResult *match = [rx firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    if (match == nil) {
        return nil;
    }
    NSArray *result = [FCRegex stringMatchesResults:@[match] text:string index:index];
    return result.count == 0 ? nil : result[0];
}

 // Match all occurrencies
+ (NSArray<NSString *> *)pregMatchAllString:(NSString *)string regex:(NSString *)regex index:(NSUInteger)index {
    NSRegularExpression *rx = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *matches = [rx matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    return [FCRegex stringMatchesResults:matches text:string index:index];
}

// Extract matches from string
+ (NSArray<NSString *> *)stringMatchesResults:(NSArray *)results text:(NSString *)text index:(NSUInteger)index {
    NSMutableArray<NSString *> *resValue = [NSMutableArray new];
    [results enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
        NSRange range = [obj rangeAtIndex:index];
        if (text.length > range.location+range.length) {
            [resValue addObject:[text substringWithRange:range]];
        } else {
            [resValue addObject:@""];
        }
    }];
    return resValue;
}

// Return tag pattern
+ (NSString *)tagPattern:(NSString *)tag {
    return [NSString stringWithFormat:@"<%@(.*?)>(.*?)</%@>",tag,tag];
}


@end