//
//  Star.m
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "Star.h"
#import "GameManager.h"


static int *types;
static int TYPE_INDEX = 0;

@implementation Star


-(void) dealloc {
    
    if (types != NULL) {
        free (types);
        types = NULL;
    }
    [super dealloc];
    
}

+(Star *) create {
	Star * star = [[[Star alloc] init] autorelease];
	return star;
}

-(id) init {
	self = [super initWithFrameName:@"star_1.png" withRadius:4 * CC_CONTENT_SCALE_FACTOR()];
	if (self) {
        types = malloc( 16 * sizeof(int));
        types[0] = 4;
        types[1] = 1;
        types[2] = 2;
        types[3] = 3;
        types[4] = 4;
        types[5] = 2;
        types[6] = 3;
        types[7] = 1;
        types[8] = 1;
        types[9] = 3;
        types[10] = 2;
        types[11] = 4;
        types[12] = 4;
        types[13] = 2;
        types[14] = 1;
        types[15] = 3;

	}
	return self;
}


-(void) setValues:(CGPoint) position boost:(BOOL) boost {
	_boost = boost;
	int r;
    
	
	if (boost) {
		[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"boost.png"] ];
        
	} else {
		int index = types[TYPE_INDEX];

        NSString * frameName;
        frameName = [NSString stringWithFormat:@"star_%i.png", (int) index];
        _frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        frameName = [NSString stringWithFormat:@"star_%i_off.png", (int) index];
        _frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        
        _size = 2 + index * 2;
        
        r = floor(((float) rand() / RAND_MAX) * 10);
        if (r > 5) {
            [self setDisplayFrame:_frame1 ];
            _frame = 1;
        } else {
            [self setDisplayFrame:_frame2 ];
            _frame = 2;
        }
  
	}
	
	float random_range = arc4random() % 2 ;
    r = floor(((float) rand() / RAND_MAX) * 10);
    
   
	//offset the stars a bit, so as to get rid of the "Grid Cell" look
    CGPoint p = ccp(position.x + (random_range * r * 0.5f) ,
                    position.y + (random_range * r * 0.5f));
    
	//if too close to the sides, move stars a bit
	if (p.x < 10) p.x = 10;
   	if (p.x > _screenSize.width - 16)
        p.x = _screenSize.width - 16;
	
	//if too close to the top, same thing
    if (p.y > _screenSize.height - 10)
        p.y = _screenSize.height - 10;
      
	
    [self setPosition:p];
    
	TYPE_INDEX += 1;
	if (TYPE_INDEX == 16) TYPE_INDEX = 0;
	
	self.visible = YES;
	
    _blinkTimer = 0.0;
    _blinkInterval = ((float)rand() / RAND_MAX) * 5 + 5;

	

}

-(void) update:(float)dt {
    

    _blinkTimer += dt;
    //change image used, and change opacity when animated
    if (_blinkTimer > _blinkInterval && !_boost) {
        _blinkTimer = 0.0;
        
        if (_frame == 1 ) {
            _frame = 2;
             [self setDisplayFrame:_frame2];
        } else  {
            _frame = 1;
            [self setDisplayFrame:_frame1];
        }
        self.opacity = self.opacity == 150 ? 255 : 150;
        self.rotation += 20;
    }
    
}


@end
