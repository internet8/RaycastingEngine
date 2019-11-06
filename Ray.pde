class Ray {
  public float angle;
  public float realAngle;
  public float x;
  public float y;
  public int length = 500;
  
  Ray (float angle, float x, float y) {
    this.angle = angle;
    this.x = x;
    this.y = y;
  }
  
  public void renderRay () {
    push();
    line(x, y, getEndX(length), getEndY(length));
    pop();
  }
  
  public float getEndX (int dist) {
    return x + dist * (float)Math.sin(realAngle * Math.PI / 180);
  }
  
  public float getEndY (int dist) {
    return y + dist * (float)Math.cos(realAngle * Math.PI / 180);
  }
  
  public void updateRay () {
    this.x = player.pos.x;
    this.y = player.pos.y;
    this.realAngle = angle - player.heading * (float)(180/Math.PI);
  }
}
