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
#define R_BUTOON_X 200
#define R_BUTOON_Y 100


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
    for(int i = 0; i < DEFAULT_X; i++)
    {
        for(int j = 0; j < DEFAULT_Y; j++){
            /* TODO: refactor view and logic in the same place */
            PlaceButton * button = [[PlaceButton alloc ] initWithCoordX:i
                                                                 CoordY: j];
            self.gamefield->places[i][j].button = button;
            
            button.frame = CGRectMake(BUTTONSIZE, BUTTONSIZE, BUTTONSIZE, BUTTONSIZE);
            [button setCenter:CGPointMake( BUTTONSIZE + i * BUTTONSIZE, BUTTONSIZE + j * BUTTONSIZE)];
            
            UIImage *image = [UIImage imageNamed:@"place.png"];
            
            [button setBackgroundImage: image forState:UIControlStateNormal];
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setFlag:)];
            [button addGestureRecognizer:longPress];
            [button addTarget:self action:@selector(clickPlaceAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];

            [longPress release];
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
    moveWith(self.gamefield, xCoord, yCoord, OPEN_PLACE);
    [self redrawMinefield];
}

- (void) redrawMinefield
{
    Place currentPlace;
    PlaceButton *button;
    
    for(int i = 0; i < DEFAULT_X; i++)
        for(int j = 0; j < DEFAULT_Y; j++)
        {
            currentPlace = self.gamefield->places[i][j];
            button = currentPlace.button;
            if(currentPlace.state != VISIBLE)
            {
                UIImage *image;
                if(currentPlace.state == FLAG){
                    image = [UIImage imageNamed:@"place_flag.png" ];
                }
                else
                {
                    image = [UIImage imageNamed:@"place.png"];
                }
                [button setBackgroundImage:image
                        forState: UIControlStateNormal];
                continue;
            }
            
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            switch (currentPlace.mine) {
                case MINE:
                {
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
    /*UILabel* gameResult = [[UILabel alloc] initWithFrame:CGRectMake((self.view.window.bounds.size.width / 2), 0.0, 150.0, 43.0) ];*/
    
    switch (getGameState()) {
        case WIN:
        {
            [self showWinMessage];
        }
            break;
        case FAIL:
        {

            [self showFailMessage ];
        }
            break;
            
        default:
            break;
    }
    


}

- (void) showWinMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                    message:@"You Win!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self showRestartButton];
    [alert release];
}

- (void) showFailMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops"
                                                    message:@"You Lose!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self showRestartButton];
    [alert release];
}

- (void) showRestartButton
{
    UIButton *restartButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    restartButton.frame = CGRectMake(R_BUTOON_X, R_BUTOON_Y,R_BUTOON_X, R_BUTOON_Y);
    int centerX = self.view.window.bounds.size.width / 2;
    [restartButton setCenter:CGPointMake( centerX, BUTTONSIZE * DEFAULT_Y + R_BUTOON_Y)];
    [restartButton setTitle:@"Play Again" forState:UIControlStateNormal ];
    [restartButton addTarget:self action: @selector(restart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restartButton];
}

- (void) restart
{
    MinefieldViewController * mineFieldViewController = [[MinefieldViewController alloc] init];
    self.view.window.rootViewController = mineFieldViewController;
    [mineFieldViewController release ];        
}

- (void) setFlag:(UILongPressGestureRecognizer *) gesture
{
    if (getGameState() != PLAY) {
        return;
    }
    
    PlaceButton* sender = (PlaceButton*) gesture.view;
    coordinate xCoord = sender.xCoord;
    coordinate yCoord = sender.yCoord;
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        moveWith(self.gamefield, xCoord, yCoord, SET_FLAG);
        [self redrawMinefield];
    }    
}
-(void) viewWillDisappear:(BOOL)animated
{
    [self clearMemory];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) clearMemory{
    
    for(int i = 0; i < DEFAULT_X; i++)
    {
        for(int j = 0; j < DEFAULT_Y; j++){
            [gamefield->places[i][j].button release];
        }
    }
    
    setGameState(WAITING);
    free(self.gamefield);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
