//
//  PlaceButton.h
//  minesweeper
//
//  Created by Ilya Boltnev on 3/21/13.
//  Copyright (c) 2013 Ilya Boltnev. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef int coordinate;

@interface PlaceButton : UIButton
@property coordinate xCoord;
@property coordinate yCoord;

- (id) initWithCoordX: (coordinate) x
               CoordY: (coordinate) y;
@end
