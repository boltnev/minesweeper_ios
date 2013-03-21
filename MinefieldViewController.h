//
//  MinefieldViewController.h
//  minesweeper
//
//  Created by Ilya Boltnev on 3/21/13.
//  Copyright (c) 2013 Ilya Boltnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceButton.h"
#import "minesweeper.h"

@interface MinefieldViewController : UIViewController
@property  Minefield* gamefield;

- (void) openPlaceOn: (PlaceButton *) sender;

- (void) showResults;

@end
