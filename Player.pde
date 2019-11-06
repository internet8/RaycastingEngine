class Player {
  public int x = canvasWidth / 4;
  public int y = canvasHeight / 2;
  public int rad = 10;
  public float heading = 0;
  public PVector pos = new PVector(x, y);
  public PVector vel = new PVector(0, 0);
  // controls
  public boolean forward = false;
  public boolean backward = false;
  public boolean left = false;
  public boolean right = false;
  private float movingSpeed = 0.8;
  private float turningSpeed = 0.08;
  
  public void drawPlayer () {
    push();
    pos.add(vel);
    vel.mult(movingSpeed);
    translate(pos.x, pos.y);
    rotate(heading);
    ellipse(0, 0, rad, rad);
    if (!drawRays) {
      triangle(0+10, 0, 0, 0-10, 0, 0+10);
    }
    pop();
  }
  
  public void movePlayer () {
    if (forward) {
      vel.add(PVector.fromAngle(heading));
    } else if (backward) {
      vel.sub(PVector.fromAngle(heading));
    }
  }
  
  public void turnPlayer () {
    if (left) {
      heading -= turningSpeed;
    } else if (right) {
      heading += turningSpeed;
    }
  }
}

void keyPressed() {
  if (key == 'w' || keyCode == UP) {
    player.forward = true;
  } else if (key == 's' || keyCode == DOWN) {
    player.backward = true;
  }
  if (key == 'a' || keyCode == LEFT) {
    player.left = true;
  } else if (key == 'd' || keyCode == RIGHT) {
    player.right = true;
  }
}

void keyReleased() {
  if (key == 'w' || keyCode == UP) {
    player.forward = false;
  } else if (key == 's' || keyCode == DOWN) {
    player.backward = false;
  }
  if (key == 'a' || keyCode == LEFT) {
    player.left = false;
  } else if (key == 'd' || keyCode == RIGHT) {
    player.right = false;
  }
}
