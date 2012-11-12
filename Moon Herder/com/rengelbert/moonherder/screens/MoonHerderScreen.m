//
//  MoonHerderScreen.m
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright Done With Computers 2012. All rights reserved.
//	
#import "MoonHerderScreen.h"
#import "MoonHerderData.h"
#import "MoonHerderGame.h"
#import "Star.h"
#import "NumberSprite.h"
#import "NSMutableArray+Shuffle.h"
#import "Line.h"
#import "PowerBar.h"
#import "TimeBar.h"

static NSMutableArray * _grid_cells;
static NSMutableArray *_stars;


/*
The basic class for this Game Screens (never instantiated, only extended)
*/

// MoonHerderScreen implementation
@implementation MoonHerderScreen

@synthesize startPoint = _startPoint, lines = _lines, powerBar = _powerBar, timeBar = _timeBar;

+(NSMutableArray *) gridCells {
    
    return _grid_cells;
}

+(NSMutableArray *) stars {
    
    return _stars;
}


- (void) dealloc {
    
    if (_lines) {
        [_lines release];
        _lines = nil;
    }
	if (_powerBar) [_powerBar release];
	if (_timeBar) [_timeBar release];
    
    [_grid_cells release];
	_grid_cells = nil;
    
	[_stars release];
	_stars = nil;
	
    [_sprites release];
    [_menu release];
    
    [_bgDark release];
    [_bgLight release];
    	
	
	[super dealloc];
}


-(id) initWithGame:(Game *) game {
	
	self = [super initWithGame:game];
    
	if(self != nil) {
		
        _run = NO;
        
        _startPoint = CGPointZero;
        _touchPoint = CGPointZero;
        
        //calculate tile size and number of columns and rows
        _tile_size = 16 * game.screen_ratio;
		
		_cols = game.screenWidth / _tile_size;
		_rows = game.screenHeight * 0.82 / _tile_size;
		
		//the default value for stars (shown in IntroScreen)
        _numStars = 150;
        if (_stars == nil) {
            _stars = [[NSMutableArray arrayWithCapacity:500] retain];
            int len = _cols * _rows;
            for (int i = 0; i < len; i++) {
                [[MoonHerderScreen stars] addObject:[_game getObjectFromPoolWithName:POOL_STARS]];
            }
        }
        
        if (_grid_cells == nil) {
            _grid_cells = [[NSMutableArray arrayWithCapacity:_cols * _rows] retain];
            
            //create grid
            int c;
            int r;
            
            for (r = _rows - 1; r >= 0; r--) {
                for (c = 0; c < _cols; c++) {
                    [_grid_cells addObject:[NSValue valueWithCGPoint:ccp(c,r)]];
                }
            }
        }
        [_grid_cells shuffle];
            
        //values used for star blinking animation
        //up to 30 stars are updated each cycle interval 
        _starsUpdateIndex = 0;
        _starsUpdateRange = 30;
        _starsUpdateInterval = 3;
        _starsUpdateTimer = 0.0;
        
        _gameRate = 10;
       
    }
	
	return self;
}

-(void) destroy  {
	[_game removeChild:self cleanup:NO];
}

//default elements added in every screen
-(void) initScreen {
    
    _container = [[[CCNode alloc] init] retain];
    
    //the sprite batch node and background
    CCTexture2D * texture_sprites;
    CCTexture2D * texture_menu;
    
    //add background
    CCSpriteFrame * dark_frame;
    CCSpriteFrame * light_frame;
    dark_frame = [_game.images getSpriteFrame:@"bg_dark.png"];
    light_frame = [_game.images getSpriteFrame:@"bg_light.png"];
    
    texture_sprites = [_game.images getTexture:@"sprite_sheet.png"];
    texture_menu = [_game.images getTexture:@"menu_sheet.png"];
    
    _sprites = [CCSpriteBatchNode batchNodeWithTexture:texture_sprites];
    _menu = [CCSpriteBatchNode batchNodeWithTexture:texture_menu];
    
   _bgDark = [CCSprite spriteWithSpriteFrame:dark_frame];
    [_bgDark setAnchorPoint:CGPointZero];
    if (_game.screen_ratio == 1) {
        [_bgDark setPosition:ccp(0, -32)];
    }
    
    _bgLight = [[CCSprite spriteWithSpriteFrame:light_frame] retain];
    [_bgLight setAnchorPoint:CGPointZero];
    if (_game.screen_ratio == 1) {
    [_bgLight setPosition:ccp(0, -32)];
    }
    
    //add ground
    _ground = [_game.images getSkin:@"ground.png"];
    
    [_ground setAnchorPoint:CGPointZero];
    
    [self addChild:_container];
}

-(void) update:(float)dt {
    
    [self blinkStars:dt];
}

-(void) blinkStars:(float) dt {
    _starsUpdateTimer += dt;
    
    if (_starsUpdateTimer > _starsUpdateInterval) {
        
        if (_stars.count - _starsUpdateIndex < _starsUpdateRange) {
            _starsUpdateIndex = 0;
        } else if (_starsUpdateIndex + _starsUpdateRange > _stars.count - 1) {
            _starsUpdateIndex += _stars.count - _starsUpdateIndex - 1;
        } else {
            _starsUpdateIndex += _starsUpdateRange;
        }
        
        _starsUpdateTimer = 0;
        _starsUpdateInterval = ((float)rand() / RAND_MAX) * 5;
    }
    
    //update stars within update range
    Star * star;
    for (int i = _starsUpdateIndex; i < _starsUpdateIndex + _starsUpdateRange; i++) {
        if (i < _stars.count) {
            star = [_stars objectAtIndex:i];
            [star update:dt];
        }
        
    }

}

-(void) addStars {
    //add stars
    Star * star;
    CGPoint position;
    NSValue * value;
    for (int i = 0; i < _numStars; i++) {
        value = [_grid_cells objectAtIndex:i];
        [value getValue:&position];
        
        position.x = position.x * _tile_size;
        position.y = _game.screenHeight - position.y * _tile_size;
        
        star = [_stars objectAtIndex:i];
        
        [star setValues:position.x
                   posY:position.y
                  range:_tile_size isBoost:NO];
        
        if (!star.skin.parent) [_sprites addChild:star.skin];
        
    }

}

-(void) clearAllStars {
    
	if (![MoonHerderScreen stars]) return;
    
	//make remaining stars invisible
    int i;
    int len = _stars.count;
	Star * star;
	for (i = 0; i < len; i++) {
		star = [_stars objectAtIndex:i];
		if (star) {
			star.skin.visible = NO;
		}
	}
    
}

@end
