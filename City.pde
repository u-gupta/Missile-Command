class City{
  float x1,y1,x2,y2;
  City(float x1, float y1, float x2, float y2){
      this.x1=x1;
      this.x2=x2;
      this.y1=y1;
      this.y2=y2;
  }
    
  boolean isAlive(float a, float b){
    if(a<x2 && a>x1 && b<y2 && b>y1){
      return false;
    }
    return true;
  }
}
