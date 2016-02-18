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
    return CGRectInset(bounds, 15, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 15, 10);
}

- (void)awakeFromNib {
    [self setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:16]];
}

@end
