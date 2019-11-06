
void drawLineWithTexture (PImage img, PImage darkImg, int index, float lineLength, PVector hitPoint, boolean xSide, float distWall) {
  PVector textureCoordinates = null;
  if (xSide) {
    textureCoordinates = new PVector(hitPoint.y - ((int)(hitPoint.y/map.squareSize)) * map.squareSize, 0);
  } else {
    textureCoordinates = new PVector(hitPoint.x - ((int)(hitPoint.x/map.squareSize)) * map.squareSize, 0);
  }
  // wall texture variables
  float yStep = (img.height-1) / lineLength;
  int yCounter;
  int yStart = (int)(canvasHeight - lineLength) / 2;
  int yEnd = canvasHeight - yStart;
  // lighting
  color c;
  color dark = color(0);
  float lightValue;
  // looping rayWidth times
  for (int i = index; i > index - (canvasHeight / rays.size()); i--) {
    yCounter = 0;
    // looping from the first wall pixel to the bottom of the screen
    for (int j = (int)yStart; j <= canvasHeight; j++) {
      // floor and ceiling casting
      if (j > yEnd && floorCasting) {
        float currentDist = canvasHeight / (2.0 * j - canvasHeight);
        double weight = currentDist / distWall;
        double currentFloorX = weight * hitPoint.x + (0.02 - weight) * player.pos.x;
        double currentFloorY = weight * hitPoint.y + (0.02 - weight) * player.pos.y;
        int x, y;
        x = (int)(currentFloorX * 20) % 20;
        y = (int)(currentFloorY * 70) % 70;

        lightValue = map(canvasHeight - j, 0, (canvasHeight / 2)/1.1, lightingValueFrom, lightingValueTo);
        if (lighting) {
          c = lerpColor(floor.pixels[(int)x + (int)y * floor.width], dark, lightValue);
        } else {
          c = floor.pixels[(int)x + (int)y * floor.width];
        }
        frame.set(i, j, c);
        
        if (lighting) {
          c = lerpColor(ceiling.pixels[(int)x + (int)y * ceiling.width], dark, lightValue);
        } else {
          c = ceiling.pixels[(int)x + (int)y * ceiling.width];
        }
        frame.set(i, canvasHeight - j, c);
      } else if (j <= yEnd) { // wall textures
        lightValue = map(distWall, 0, (map.map.length * map.squareSize)/2, lightingValueFrom, lightingValueTo);
        if (j > 0 && j < canvasHeight) {  
          if (xSide) {
            if (drawWallTextures) {
              if (lighting) {
                c = lerpColor(img.pixels[(int)textureCoordinates.x + (int)(yStep * yCounter) * img.width], dark, lightValue);
              } else {
                c = img.pixels[(int)textureCoordinates.x + (int)(textureCoordinates.y + yStep * yCounter) * img.width];
              }
            } else {
              c = color(250);
            }
          } else {
            if (drawWallTextures) {
              if (lighting) {
                c = lerpColor(darkImg.pixels[(int)textureCoordinates.x + (int)(yStep * yCounter) * darkImg.width], dark, lightValue);
              } else {
                c = darkImg.pixels[(int)textureCoordinates.x + (int)(textureCoordinates.y + yStep * yCounter) * darkImg.width];
              }
            } else {
              c = color(200);
            }
          }
          // alterative lightning
          //c = color((c >> 16 & 0xFF) - lightValue, (c >> 8 & 0xFF) - lightValue, (c & 0xFF) - lightValue);
          //c = color(red(c) - lightValue, green(c) - lightValue, blue(c) - lightValue);
          frame.set(i, j, c);
        }
        if (yCounter < (int)lineLength) {
          yCounter++;
        }
      }
    }
  }
}
