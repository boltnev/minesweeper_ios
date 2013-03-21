#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include "PlaceButton.h"

#define DEFAULT_X 10
#define DEFAULT_Y 10
#define DEFAULT_MINES 10
#define MAX_X     100
#define MAX_Y     100
#define MAX_MINES 5000

//Place holds:
enum{
  EMPTY,
  MINE
};

//Place states;
enum{
  HIDDEN,
  VISIBLE,
  FLAG
};
//game Result
enum{
  WAITING,
  WIN,
  FAIL,
  PLAY
};

//actions
enum{
    OPEN_PLACE = 1,
    SET_FLAG   = 2
};

typedef struct t_Place Place;

struct t_Place{
    unsigned numberOfMinesNear;
    int mine;
    int state;
    PlaceButton* button;
};

typedef struct t_Minefield Minefield;

struct t_Minefield{
    int xSize;
    int ySize;
    unsigned minesNumber;
    Place places[MAX_X][MAX_Y];
};



/* GLOBAL GAME STATE, 
   change only with following methods */
void setGameState(int state);
int getGameState();

int g_gamestate;
/**/
void initEmptyMinefield(Minefield *minefield, unsigned x, unsigned y);
void makeGame(Minefield *minefield, unsigned x, unsigned y, unsigned mines);
void drawField(Minefield *field);
void increaseNumberOfMilesAround(Minefield * field, int x, int y);
void placeNumbers(Minefield *field);
void openNearbyPlaces(Minefield *field, int x, int y);
void switch_flag(Place *place);
void openPlace(Minefield *field, int x, int y);
void checkGameState(Minefield *field);
void updateAllMinesPlaces(Minefield *field);
int moveWith(Minefield *field, int x, int y, int action);

/* Simple controls, may be replaced by more advanced */
int makeMove(Minefield *field);

void makeFirstMove(Minefield *field, int x, int y, int action);

/**/

//int play(Minefield *field);
