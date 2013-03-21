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
        self.gamefield = malloc(sizeof(Minefield));
        makeGame(self.gamefield, DEFAULT_X, DEFAULT_Y, MINENUMBER);
        [self placeButtons];
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
            /* TODO: refactor view and logic in the same place */
            PlaceButton * button = [[PlaceButton alloc ] initWithCoordX:i
                                                                 CoordY: j];
            self.gamefield->places[i][j].button = button;
            
            button.frame = CGRectMake(BUTTONSIZE, BUTTONSIZE, BUTTONSIZE, BUTTONSIZE);
            [button setCenter:CGPointMake( BUTTONSIZE + i * BUTTONSIZE, BUTTONSIZE + j * BUTTONSIZE)];
            [button setImage: [UIImage imageNamed:@"place.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(clickPlaceAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:button];
        }
    }
}

- (void) clickPlaceAction:(PlaceButton *) sender
{
    coordinate xCoord = sender.xCoord;
    coordinate yCoord = sender.yCoord;

    if (getGameState() == WAITING) {
        makeFirstMove(self.gamefield, xCoord, yCoord, OPEN_PLACE);
    }
    
    if (getGameState() != PLAY)
        return;
    [self openPlaceOnX:xCoord OnY:yCoord];
}

- (void) openPlaceOnX: (coordinate) xCoord
                  OnY: (coordinate) yCoord
{
    if(xCoord < 0 || xCoord >= self.gamefield->xSize ||
       yCoord < 0 || yCoord >= self.gamefield->ySize)
        return;
    
    Place currentPlace;
    PlaceButton *button;
    moveWith(self.gamefield, xCoord, yCoord, OPEN_PLACE);
    /**/
    for(int i = 0; i < MINENUMBER; i++)
        for(int j = 0; j < MINENUMBER; j++)
        {
            currentPlace = self.gamefield->places[i][j];
            button = currentPlace.button;
            if(currentPlace.state != VISIBLE)
                continue;
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            switch (currentPlace.mine) {
                case MINE:
                {
                    [button setTitle: @"*" forState:UIControlStateNormal];
                    [button setImage:nil forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageNamed:@"place_mine.png" ] forState:UIControlStateNormal];
                    
                }
                    break;
                case EMPTY:
                {
                    if(currentPlace.numberOfMinesNear != 0)
                    {
                        unsigned int numberOfMines = currentPlace.numberOfMinesNear;
                        
                        [button setTitle: [NSString stringWithFormat:@"%d", numberOfMines] forState:UIControlStateNormal];
                    }
                    
                    [button setImage:nil forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageNamed:@"place_opened.png" ] forState:UIControlStateNormal];
                    
                }
                    break;
                    
            }
        }
        if (getGameState() != PLAY) {
            [self showResults];
        }
}

- (void) showResults{
    UILabel* gameResult = [[UILabel alloc] initWithFrame:CGRectMake((self.view.window.bounds.size.width / 2), 0.0, 150.0, 43.0) ];
    switch (getGameState()) {
        case WIN:
        {
            [gameResult setTextColor: [UIColor redColor ]];
            gameResult.text = @"You WIN!";
        }
            break;
        case FAIL:
        {
            [gameResult setTextColor: [UIColor blueColor ]];
            gameResult.text = @"You LOSE!";
        }
            break;
            
        default:
            break;
    }
    [gameResult setFont: [UIFont systemFontOfSize:20.0f] ];
    [gameResult setCenter: CGPointMake(self.view.window.bounds.size.width / 2, MINENUMBER * BUTTONSIZE + BUTTONSIZE * 2)];
    [self.view addSubview:gameResult ];
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
