//
//  UIImage+Utility.m
//  PartyMaker
//
//  Created by 2 on 2/14/16.
//  Copyright © 2016 Maksim Stecenko. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)

- (BOOL)isEqualToImage:(UIImage *)image
{
    NSData *selfData = UIImagePNGRepresentation(self);
    NSData *imageData = UIImagePNGRepresentation(image);
    
    return [selfData isEqual:imageData];
}

@end
