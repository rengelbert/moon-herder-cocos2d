//
//  GameManager.m
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//
//

#import "GameManager.h"

@implementation GameManager

static GameManager * _instance = nil;

@synthesize lines = _lines, rows = _rows, columns = _cols, boosting = _boosting, score = _score,
level = _level, bestScore = _bestScore, boostNumber = _boostNumber, collectedStars = _collectedStars,
totalCollectedStars = _totalCollectedStars, totalStars = _totalStars, lineDecrement = _lineDecrement,
timeDecrement = _timeDecrement, lineEnergy = _lineEnergy, time = _time, gameScale = _gameScale;

-(void) dealloc {

	[_lines release];
	[_linesPool release];
	[_starsPool release];
    [_gridCells release];
	
	[super dealloc];
}


+(GameManager *) sharedGameManager {
	if (_instance == nil) {
		_instance = [[[GameManager alloc] init] retain];
	}
	return _instance; 
	
}

-(id) init {
	self = [super init];
	if (self) {
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"sprite_sheet.plist"];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        if (screenSize.width > 768) {
            _gameScale = 4;
        } else if (screenSize.width > 320) {
            _gameScale = 2;
        } else {
            _gameScale = 1;
        }

		
        
		_starsPool = [CCArray arrayWithCapacity:STARS_IN_POOL];
		[_starsPool retain];
		_linesPool = [CCArray arrayWithCapacity:50];
		[_linesPool retain];
		
		_lines = [CCArray arrayWithCapacity:50];
		[_lines retain ];
		
		_linesPoolIndex = 0;
		   
		//create stars pool
		for (int i = 0; i < STARS_IN_POOL; i++) {
			[_starsPool addObject:[Star create]];
		}
		 
		//create lines pool
		for (int i = 0; i < 50; i++) {
			[_linesPool addObject:[Line create]];
		}
    
    
		//create grid cells
		_cols = (int) screenSize.width /  (TILE * CC_CONTENT_SCALE_FACTOR());
		_rows = (int) screenSize.height * 0.9f/  (TILE * CC_CONTENT_SCALE_FACTOR());
        
        CCLOG(@"HAHAHAHAHAHAHAHAHAHAHAHAHHAAHHAHAHAHA");
        CCLOG(@"SCREEN  %f   %f", screenSize.width, screenSize.height);
        CCLOG(@"COLS  %i", (int) screenSize.width / (TILE * CC_CONTENT_SCALE_FACTOR()));
        CCLOG(@"COLS ROWS : %i %i", _cols, _rows);
        _gridCells = [[NSMutableArray arrayWithCapacity:_cols * _rows] retain];
        
		//create grid
		int c;
		int r;
        
		//for (r = 0; r < _rows; r++) {
		for (r = _rows - 1; r >= 0; r--) {
			for (c = 0; c < _cols; c++) {
				[_gridCells addObject:[NSValue valueWithCGPoint:ccp(c,r)]];
			}
		}
		
		[_gridCells shuffle];
		
		_initialLineDecrement = 0.07;
		_lineDecrementRatio = 0.009;
			
		_initialStars = 3;
		_starsRatio = 3;
		
		_initialTimeDecrement = 0.006f;
		_timeDecrementRatio = 0.0005f;
		
		_initialBoostNumber = -2;
		_boostNumberIncrement = 1;
		
		//load las best score
        
        if (![[NSUserDefaults standardUserDefaults]integerForKey:@"bestScore"]){
            _bestScore = 0;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:0 forKey:@"bestScore"];
        } else {
            _bestScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"bestScore"];
        }
		 
		[self reset];
         

	}
	
	return self;
}

-(void) updateGameData {
	//increase line decrement value, total stars, boosts, and time decrement

    _lineDecrement = _initialLineDecrement + (_level-1) * _lineDecrementRatio;
    _totalStars = _initialStars + (_level - 1) * _starsRatio;
	
    if (_totalStars > STARS_IN_POOL) {
		_totalStars = STARS_IN_POOL;
	}
    if (_lineDecrement > 0.5f) _lineDecrement = 0.5f;
	
    _collectedStars = 0;
    _timeDecrement = _initialTimeDecrement + (_level - 1) * _timeDecrementRatio;
    _boostNumber = _initialBoostNumber + (_level - 1) *_boostNumberIncrement;
    if (_boostNumber > 5) _boostNumber = 5;
    
    [_gridCells shuffle];
    
    int count = _starsPool.count;
    Star * star;
    for (int i = 0; i < count; i++) {
        star = (Star *) [_starsPool objectAtIndex:i];
        star.visible = NO;
        star.opacity = 255;
        if (star.parent) {
            [star removeFromParentAndCleanup:NO];
        }
    }
    
    [_lines removeAllObjects];
    
    _lineEnergy = 1;
    _time = 1;
    _boostSpeed = 0;
    _boosting = NO;
}


-(void) setBoosting:(BOOL) var {
	_boosting = var;
    
    if (var) {
        _boostSpeed++;
    } else {
        _boostSpeed = 0;
    }

}


-(void) setBestScore:(int) var {
	_bestScore = var;
	
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_bestScore forKey:@"bestScore"];
    
}


-(void) setLevel:(int) var {
	_level = var;
	[self updateGameData];
}

-(Line *) lineFromPool {
	Line * line = (Line *) [_linesPool objectAtIndex:_linesPoolIndex];
	_linesPoolIndex++;
	if (_linesPoolIndex == _linesPool.count) _linesPoolIndex = 0;
	return line;
}


-(Star *) starFromPool:(int) index {
	Star * star = (Star *) [_starsPool objectAtIndex:index];
    return star;
}


-(CGPoint) starPosition:(int) index {
    CGPoint position;
    NSValue * value = [_gridCells objectAtIndex:index];
    [value getValue:&position];
	return position;
}


-(void) update:(float) dt {
	 _time -= _timeDecrement * dt;
    if (_time < 0) _time = 0;
    
    //boosting
    if (_boosting) {
        _lineEnergy += 0.03 * dt * _boostSpeed;
        if (_lineEnergy > 1) _lineEnergy = 1;
        
    }
}


-(void) reset {
	//reset to level 1 values (base values)
    _level = 1;
    _totalCollectedStars = 0;
	[self updateGameData];
}

-(CGPoint) touchFromLocation:(UITouch *)touch {
    CGPoint location = [touch locationInView: [touch view]];
    return [[CCDirector sharedDirector] convertToGL:location];
}

@end

