//
//  PlaceButton.m
//  minesweeper
//
//  Created by Ilya Boltnev on 3/21/13.
//  Copyright (c) 2013 Ilya Boltnev. All rights reserved.
//

#import "PlaceButton.h"

@implementation PlaceButton
@synthesize xCoord;
@synthesize yCoord;

- (id) initWithCoordX: (coordinate) x
               CoordY: (coordinate) y
{
    self = [super init];
    if (self) {
        self.xCoord = x;
        self.yCoord = y;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
