Game game;
int width = $(window).width();
int height = $(window).height();

void setup() {
  size(width, height);
  frameRate(30);
  noStroke();
  smooth();
  colorMode(RGB, 255, 255, 255, 100);
  
  game = new Game();
}

void draw() {
  game.draw();
}

class Path {
  static string LEFT = 'Left';
  static string RIGHT = 'Right';
  static string UP = 'Up';
  static string DOWN = 'Down';
  
  int x = -50;
  int y;
  string direction;
  
  Path(int y, string direction) {
    this.y = y;
    this.direction = direction;
  }
  
  int getStartingX() {
    int result = this.x;
    
    switch(this.direction) {
      case(Path.RIGHT):
        result = this.x;
        break;
      case(Path.LEFT):
        result = width + 50;
        break;
    }
    return result;
  }
  
  boolean isVisible(int currentDotX) {
    boolean result;
    
    switch(this.direction) {
      case(Path.RIGHT):
        result = (currentDotX > game.blinky.x + 10);
        break;
      case(Path.LEFT):
        result = (currentDotX < game.blinky.x - 10);
        break;
    }
    
    return result;
  }
}

class Blinky {
  int x, y, radius, currentAngle;
  int[] rightStartAngles = [radians(45), radians(22.5), radians(0)];
  int[] rightEndAngles = [radians(315), radians(337.5), radians(360)];
  int[] leftStartAngles = [radians(225), radians(202.5), radians(180)];
  int[] leftEndAngles = [radians(135), radians(157.5), radians(180)];
  
  Blinky(int x, int y, int r) {
    this.x = x;
    this.y = y;
    this.radius = r;
    this.currentAngle = 2;
  }
  
  void draw() {
    // NOTE: right is 0 degrees
    
    // Calculate current angle
    if(game.step % 5 == 0) {
      if(this.currentAngle == 2) {
        this.currentAngle = 0;
      } else {
        this.currentAngle++;
      }
    }
    
    fill(255, 238, 0, 50);
    this['eat' + game.getCurrentPath().direction]();
  }
  
  void eatRight() {
    this.x += game.distancePerFrame;
    
    arc(this.x, this.y, this.radius, this.radius,
      this.rightStartAngles[this.currentAngle],
      this.rightEndAngles[this.currentAngle]);
  }
  
  void eatLeft() {
    this.x -= game.distancePerFrame;
    
    arc(this.x, this.y, this.radius, this.radius,
      this.leftStartAngles[this.currentAngle],
      radians(360));
    
    arc(this.x, this.y, this.radius, this.radius,
      radians(0),
      this.leftEndAngles[this.currentAngle]);
  }
}

class Game {
  Blinky blinky;
  Path[] paths;
  int distancePerFrame = 3;
  int currentPath = 0;
  int step = 0;
  
  Game() {
    this.paths = [new Path(50, Path.RIGHT), new Path(500, Path.LEFT)];
    
    this.blinky = new Blinky(
      this.paths[this.currentPath].x,
      this.paths[this.currentPath].y,
      50);
  }
  
  void draw() {
    this.step++;
    background(0, 0);
    
    this.blinky.draw();
    this.drawPaths();
    
    if((this.blinky.x > width + 50) || (this.blinky.x < -50)) {
      this.currentPath++;
      
      if(this.currentPath < this.paths.length) {
        this.blinky.y = this.paths[this.currentPath].y;
        this.blinky.x = this.paths[this.currentPath].getStartingX();
      } else {
        noLoop();
        console.log('Done!');
      }
    }
  }
  
  Path getCurrentPath() {
    return this.paths[this.currentPath];
  }
  
  void drawPaths() {
    fill(255, 255, 255, 30);
    
    for(int currentDotX = 0; currentDotX < width; currentDotX += 20) {
      for(int i = 0; i < paths.length; i++) {
        Path p = paths[i];
        
        if(i > this.currentPath || ((i === this.currentPath) && p.isVisible(currentDotX))) {
          ellipse(currentDotX, p.y, 5, 5);
        }
      }
    }
  }
}