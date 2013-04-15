//
//  MainMenuViewController.m
//  minesweeper
//
//  Created by Ilya Boltnev on 3/18/13.
//  Copyright (c) 2013 Ilya Boltnev. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MinefieldViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

/*- (id)init
{
    self = [super init];
    if (self) {
        //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    }
    return self;
    
}*/


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (IBAction)startGame:(id)sender {
    MinefieldViewController * mineFieldViewController = [[MinefieldViewController alloc] init];
    self.view.window.rootViewController = mineFieldViewController;
    [mineFieldViewController release ];
}


@end
