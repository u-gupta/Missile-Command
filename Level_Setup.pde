PVector gravity;

class Level_Setup{
  int wave;
  int noParticles;
  Particle []p;
  int Width;
  int Height;
  PVector gravity;
  Level_Setup(int w, int x, int y){
    wave=w;
    Width=x;
    Height=y;
    noParticles=30+(wave*10);
    p=new Particle[noParticles];
    for(int i=0; i<noParticles;i++){
      
      PVector position = p[i].position ;
      gravity = new PVector(position.x,position.y+(9.8*y/18000));
      p[i].integrate(gravity);
      fill(0);
      rect(position.x,position.y,2,2);
    }
  }
  
}
