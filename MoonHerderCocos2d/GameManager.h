//
//  GameManager.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//
//

#import "Star.h"
#import "Sun.h"
#import "Line.h"
#import "Moon.h"
#import "NSMutableArray+Shuffle.h"


@class DrawLayer;

@interface GameManager : NSObject {
    

	CCArray * _lines;
	int _rows;
	int _cols;
	BOOL _boosting;
	
	//game data
	int _score;
	int _level;
	int _bestScore;
	int _boostNumber;
	int _collectedStars;
	int _totalCollectedStars;
	int _totalStars;
	float _lineDecrement;
	float _timeDecrement;
	float _lineEnergy;
	float _time;
    int _gameScale;
	

	CCArray * _starsPool;
	CCArray * _linesPool;
	
	int _linesPoolIndex;
	
	float _initialLineDecrement;
	float _lineDecrementRatio;
	
	int _initialStars;
	int _starsRatio;
	
	float _initialTimeDecrement;
	float _timeDecrementRatio;
    
	int _initialBoostNumber;
	int _boostNumberIncrement;
	
	//int _boostInterval;
	//float _boostTimer;
	int _boostSpeed;
	
    NSMutableArray * _gridCells;
	
}
@property int gameScale;
@property (nonatomic, assign) CCArray * lines;
@property (readonly) int rows;
@property (readonly) int columns;
@property (readonly) BOOL boosting;
@property int score;
@property (readonly) int level;
@property (readonly) int bestScore;
@property int boostNumber;
@property int collectedStars;
@property int totalCollectedStars;
@property int totalStars; 
@property (readonly) float lineDecrement; 
@property (readonly) float timeDecrement; 
@property float lineEnergy; 
@property (readonly) float time; 

+(GameManager *) sharedGameManager;

-(id) init;

-(void) updateGameData;
-(void) setBoosting:(BOOL) var;
-(void) setBestScore:(int) var;
-(void) setLevel:(int) var;

-(Line *) lineFromPool;
-(Star *) starFromPool:(int) index;
-(CGPoint) starPosition:(int) index;
-(void) update:(float) dt;
-(void) reset;
-(CGPoint) touchFromLocation:(UITouch *)touch;


@end

