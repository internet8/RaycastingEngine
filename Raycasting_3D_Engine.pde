// canvas
int canvasWidth = 1600;
int canvasHeight = 800;

// ray variables
boolean closestRay;
float closestRayDist;

// rendering options
boolean drawRays = true;
boolean drawWallTextures = true;
boolean floorCasting = true;
boolean lighting = true;
float lightingValueFrom = 0.0;
float lightingValueTo = 1.0;

// textures
PImage wall;
PImage wallDark;
PImage floor;
PImage ceiling;

// frames
PImage frame = new PImage(canvasHeight, canvasHeight, RGB);
int showFPS = 1000;

// objects
Map map = new Map();
Player player = new Player();
ArrayList<Ray> rays = new ArrayList<Ray>();

void setup(){
  size(1600, 800);
  frameRate(30); 
  
  // adding rays
  for (int i = 50; i < 130; i++) {
    rays.add(new Ray(i, 0, 0));
    rays.add(new Ray(i + 0.2, 0, 0));
    rays.add(new Ray(i + 0.4, 0, 0));
    rays.add(new Ray(i + 0.6, 0, 0));
    rays.add(new Ray(i + 0.8, 0, 0));
  }
  
  // textures
  wall = loadImage("woodTexture.png");
  wallDark = loadImage("woodTextureDark.png");
  floor = loadImage("stoneWall.png");
  ceiling = loadImage("ceilingTexture.png");
}

void draw () {
  background(255);
  
  // showing fps
  if (millis() > showFPS) {
    showFPS += 1000;
    println("fps: " + frameRate);
  }
  
  // drawing 2d version of the map on the left screen
  map.drawMap2D();
  
  // player methods
  player.drawPlayer();
  player.movePlayer();
  player.turnPlayer();
  
  // rendering rays
  int index = 800;
  for (Ray ray : rays) {
    ray.updateRay();
    DrawRay(ray, index, (float)((ray.angle-90) * Math.PI / 180));
    index -= canvasHeight / rays.size();
  }
  image(frame, canvasHeight, 0);
  
  if (!floorCasting) {
    frame = new PImage(canvasHeight, canvasHeight, RGB);
  }
}

void render3D (float dist, int lineIndex, boolean darkSide, PVector hitPoint) {
  // wall size
  //float lineLength = 128 / dist * 554;
  //float lineLength = 64 / dist * 277;
  float lineLength = 96 / dist * 400;
  drawLineWithTexture(wall, wallDark, lineIndex, lineLength, hitPoint, darkSide, dist);
}

void DrawRay (Ray r, int rayIndex, float angle) {
  PVector point1 = getClosestCollisionX(r);
  PVector point2 = getClosestCollisionY(r);
  PVector closestPoint = null;
  if (closestRay) {
    closestPoint = point1;
  } else {
    closestPoint = point2;
  }
  if (drawRays && rayIndex % 3 == 0) {
    line(player.pos.x, player.pos.y, closestPoint.x, closestPoint.y);
  }
  render3D(closestRayDist * cos(angle), rayIndex, closestRay, closestPoint);
  // fisheye
  //render3D(closestRayDist, rayIndex, closestRay);
}

PVector getClosestCollisionX (Ray r) {
  float closestDist = canvasWidth;
  PVector closestPoint = null;
  for (int x = 0; x < canvasHeight; x+= map.squareSize) {
    PVector point = lineLineIntersection(x, 0, x, canvasHeight, r.x, r.y, r.getEndX(canvasWidth), r.getEndY(canvasWidth));
    if (point != null) {
      //println(point.x + ", " + point.y);
      if (point.x < 800 && point.x > 0 && point.y < 800 && point.y > 0) {
        if (map.map[(int)point.y/map.squareSize][(int)(point.x/map.squareSize)] == 1 || map.map[(int)point.y/map.squareSize][(int)(point.x-map.squareSize)/map.squareSize] == 1) {
          float dist = getDistBetweenPoints(point.x, point.y, player.pos.x, player.pos.y);
          if (dist < closestDist) {
            closestDist = dist;
            closestPoint = point;
          }
          // drawing a dot
          /*push();
          strokeWeight(10);
          stroke(255, 0, 0);
          point(point.x, point.y);
          pop();*/
        }
      }
    }
  }
  closestRayDist = closestDist;
  return closestPoint;
}

PVector getClosestCollisionY (Ray r) {
  float closestDist = canvasWidth;
  PVector closestPoint = null;
  for (int y = map.squareSize; y < canvasHeight; y+= map.squareSize) {
    PVector point = lineLineIntersection(0, y, canvasHeight, y, r.x, r.y, r.getEndX(canvasWidth), r.getEndY(canvasWidth));
    if (point != null) {
      //println(point.x + ", " + point.y);
      if (point.x < 800 && point.x > 0 && point.y < 800 && point.y > 0) {
        if (map.map[(int)point.y/map.squareSize][(int)(point.x/map.squareSize)] == 1 || map.map[(int)(point.y-map.squareSize)/map.squareSize][(int)(point.x/map.squareSize)] == 1) {
          float dist = getDistBetweenPoints(point.x, point.y, player.pos.x, player.pos.y);
          if (dist < closestDist) {
            closestDist = dist;
            closestPoint = point;
          }
          // drawing a dot
          /*push();
          strokeWeight(10);
          stroke(255, 0, 0);
          point(point.x, point.y);
          pop();*/
        }
      }
    }
  }
  if (closestDist > closestRayDist) {
    closestRay = true;
  } else {
    closestRayDist = closestDist;
    closestRay = false;
  }
  return closestPoint;
}

PVector lineLineIntersection (float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
    float x = x1 + uA * (x2 - x1);
    float y = y1 + uA * (y2 - y1);
    return new PVector(x, y);
  }
  return null;
}

public static float getDistBetweenPoints (float x1, float y1, float x2, float y2)
{
  return (float)Math.sqrt(Math.pow(Math.abs(x1 - x2), 2) + Math.pow(Math.abs(y1 - y2), 2));
}

public static float GetAngleBetweenPoints (float x1, float y1, float x2, float y2)
{
  float xDiff = x2 - x1;
  float yDiff = y2 - y1;
  return (float)(Math.atan2(yDiff, xDiff) * 180.0f / Math.PI);
}
