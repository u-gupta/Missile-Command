
class Added_enemy{
  Particle bomb;
  int bomb_count;
  PVector enemy;
  float drop_location;
  boolean is_alive;
  int r;
  Added_enemy(float x, float y,int r, float drop){
    enemy=new PVector(x,y);
    bomb_count=(int)random(1,5);
    is_alive=true;
    this.r=r;
    drop_location=drop;
  }
  boolean check_drop(){
    if((int)enemy.x<=(int)drop_location && bomb_count>0 && is_alive==true){
      drop_location=(float)random(enemy.x/2,enemy.x);
      return true;
    }
    else
      return false;  
  }
  boolean drop_bomb(float velx, float vely){
    if(check_drop()){
      bomb=new Particle(enemy.x,enemy.y,velx,vely,1);
      bomb_count--;
      return true;
    }
    return false;
  }
  void move(int w, float c){
    if(is_alive==true)
      enemy.x-=(float)(2*(float)(w+c)/8);
    if(enemy.x<0)
      is_alive=false;
  }
  boolean check_collision(float cx, float cy, float cr){
    PVector explosion=new PVector(cx,cy);
    if(explosion.dist(enemy)<=((cr/2)+(r/2)))
      is_alive=false;
    return is_alive;
  }
  void draw_enemy(){
    if(is_alive){
      fill(84,35,35);
      circle(enemy.x,enemy.y,r);
    }
  }
}
