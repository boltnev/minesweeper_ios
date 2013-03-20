//
//  MinefieldViewController.m
//  minesweeper
//
//  Created by Ilya Boltnev on 3/21/13.
//  Copyright (c) 2013 Ilya Boltnev. All rights reserved.
//

#import "MinefieldViewController.h"

#define BUTTONSIZE 28
#define MINENUMBER 10

@interface MinefieldViewController ()

@end

@implementation MinefieldViewController
@synthesize gamefield;

- (id)init
{
    self = [super init];
    if (self) {
        [self placeButtons];
        self.gamefield = malloc(sizeof(Minefield));
        makeGame(self.gamefield, DEFAULT_X, DEFAULT_Y, MINENUMBER);
        placeNumbers(self.gamefield);
}
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) placeButtons
{
    for(int i = 0; i < MINENUMBER; i++)
    {
        for(int j = 0; j < MINENUMBER; j++){
            PlaceButton * button = [[PlaceButton alloc ] initWithCoordX:i
                                                                 CoordY: j];
            button.frame = CGRectMake(BUTTONSIZE, BUTTONSIZE, BUTTONSIZE, BUTTONSIZE);
            [button setCenter:CGPointMake( BUTTONSIZE + i * BUTTONSIZE, BUTTONSIZE + j * BUTTONSIZE)];
            [button setImage: [UIImage imageNamed:@"place.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:button];
        }
    }
}

- (void) buttonAction:(PlaceButton *) sender
{
    [sender.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    coordinate xCoord = sender.xCoord;
    coordinate yCoord = sender.yCoord;
    unsigned int numberOfMines = self.gamefield->places[xCoord][yCoord].numberOfMinesNear;
    
    [sender setTitle: [NSString stringWithFormat:@"%d", numberOfMines] forState:UIControlStateNormal];
    [sender setImage:nil forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:@"place_opened.png" ] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
