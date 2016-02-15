//
//  PMRTextField.m
//  PartyMaker
//
//  Created by 2 on 2/15/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "PMRTextField.h"

@implementation PMRTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 15, 15);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 15, 15);
}

@end
