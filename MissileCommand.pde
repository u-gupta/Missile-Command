int wave;
Particle p[];
PVector g;
float scrHeight;
int counter, rcounter;
City cities[];
float distance;
float altitude;
float velx;
int numb;
int c;
boolean city_dead[];
boolean particle_dead[];
int score;
int particle_count;
Silo s[];
boolean silo_dead[];
Particle missiles[];
int active_missile_counter;
int detonation_counter[];
int detonation_counter_temp[];
int detonation_updater[];
int explosion_counter[];
int explosion_counter_temp[];
int explosion_updater[];
int dead_missiles;
boolean start;
boolean reset;
int extra_particles;
int splitting_particles;
int[] child_particles;
boolean[] is_splitable;
boolean is_killable[];
int immortality_timer[];
boolean explosion_flag[];
Added_enemy bomber;
Added_enemy satellite;
int enemy_counter;
boolean bomber_is_alive;
boolean satellite_is_alive;
int smart_bomb;
boolean smart_bomb_activated;
float smart_bomber_originalvelx,smart_bomber_originalvely;
float smart_timer;
boolean frame;
int score_reduction;

void setup(){
  // frameRate(30);
  size(800,600);
  noCursor();
  reset=false;

  //calling the start function to setup the global variables to their default value
  start();
}
// setting the global variables that are not reset every frame to their default value
void start(){
  score_reduction=0;
  enemy_counter=0;
  bomber_is_alive=false;
  satellite_is_alive=false;
  smart_timer=1;
  start=reset;
  score=0;
  c=0;
  distance=width/11f;
  altitude=height;
  wave=0;
  extra_particles=0;
  add_particles();
  cities=new City[6];
  city_dead= new boolean[cities.length];
  for(int i=0;i<city_dead.length;i++){
    city_dead[i]=false;
  }
  s=new Silo[3];
  silo_dead=new boolean[3];
  missiles=new Particle[31];
  active_missile_counter=0;
  scrHeight=(float)height/18000000f;
  g=new PVector(0 ,9.8*scrHeight);
  detonation_counter= new int[30];
  detonation_updater= new int[30];
  detonation_counter_temp= new int[30];
  for(int i=0;i<30;i++){
   detonation_counter[i]=1;
   detonation_counter_temp[i]=1;
   detonation_updater[i]=1;}
  add_silos();
  dead_missiles=0;
}


//setting up and drawing each frame
void draw(){
  frame=true;
  
  //checking if the game has crossed the start screen
  if(start==true){
    //resetting the background every 3 frames to give all moving obects a sorf of motion blur (tail)
    if(c==3){
    background(130,205,255);
    c=0;}
    c++;
    
    textAlign(LEFT);
    fill(0);
    text("Score: "+(score + score_reduction),10,10);
    fill(0);
    text("Wave: "+wave,(width/2)-20,10);
    for(int i=0;i<particle_dead.length;i++)
      if(particle_dead[i]==false)
        particle_count++;
    text("Particles left: "+ particle_count,width-100,10);
    crosshair();
    
    //checking each particle and handling the various flags to make the particles move if they are alive
    for(int i=0;i<p.length;i++){
      remove_particles();
      explosion_flag[i]=false;
      PVector position = p[i].position;
      if(particle_dead[i]==false){
        p[i].integrate(g);
        fill(2) ;
        rect(position.x, position.y, 2, 2);
      }
      
      //drawing cities and silos every frame for each particle detect collision with each
      add_cities(position.x,position.y);
      draw_silos(position.x,position.y);
    }
    //adding bomber and satellite once every wave
    if(wave>1 && enemy_counter==0){
      add_bomber();
      add_satellite();
      enemy_counter++;
    }
    
    if(wave>1){
      handle_bomber();
      handle_satellite();
    }
    check_wave();
    particle_count=0;
    shoot_missile();
  }
  
  //displaying the start screen and waiting for the input
  if(start==false){
    background(130,205,255);
    crosshair();
    textSize(43);
    textAlign(CENTER);
    fill(38,81,125);
    text("Missile Command",width/2,(height/2)-10);
    textSize(12);
    text("Press Spacebar to Continue!",width/2,(height/2)+10);
    
    if(keyPressed==true && key== ' ')
      start=true;
  }
}

//initializing and drawing the bomber object and initializing its flag
void add_bomber(){
  bomber=new Added_enemy((float)random(width+50,width+250+(200*wave)),(float)height/2,40, (float)random(width/2,width));
  bomber.draw_enemy();
  bomber_is_alive=bomber.is_alive;
}

//moving the bomber every frame, checking if it reached the drop location
//dropping a particle if it reached the drop location
void handle_bomber(){
  bomber.move(wave,0);
  bomber.draw_enemy();
  float velx;
  float vely;
  
  //choosing a random target for the particle amongst the 6 cities
  
  int target=(int)random(0,5);
  
  //setting the particle's initial velocity's x coordinate as per the assigned target
  
  switch(target){
    case 0:velx=(2*distance+distance/192f);break;
    case 1:velx=(3.1*distance+distance/192f);break;
    case 2:velx=(4.2*distance+distance/192f);break;
    case 3:velx=(6.3*distance+distance/192f);break;
    case 4:velx=(7.4*distance+distance/192f);break;
    case 5:velx=(8.5*distance+distance/192f);break;  
    default: velx=0;
  }
  
  //dampning velocity x coordinate to fit the screen size constraints
  velx=(velx+((distance/4f)-(distance/96f)-bomber.enemy.x))/(280+(abs(bomber.enemy.y)/30));
  
  //setting the particle's initial velocity's y coordinate as per the screen size constraints 
  vely=2+(float)wave/32;
  if(bomber.drop_bomb(velx,vely)){
    int original_length=p.length;
    
    //temporary variables to store the original values of the particle array and the  various arrays that work with the particle array
    
    Particle temp[]=p;
    boolean tparticle_dead[]=particle_dead, tis_splitable[]=is_splitable, tis_killable[]=is_killable,texplosion_flag[]=explosion_flag;
    int texplosion_counter[]=explosion_counter, texplosion_counter_temp[]=explosion_counter_temp, texplosion_updater[]=explosion_updater, timmortality_timer[]=immortality_timer;
    
    //initializing the arrays again to store an extra particle dropped by the bomber
    
    p=new Particle[original_length+1];
    particle_dead=new boolean[p.length];
    explosion_counter=new int[p.length];
    explosion_counter_temp=new int[p.length];
    explosion_updater=new int[p.length];
    is_splitable=new boolean[p.length];
    immortality_timer=new int[p.length];
    is_killable=new boolean[p.length];
    explosion_flag=new boolean[p.length];
    for(int i=0;i<original_length;i++){
      is_killable[i]=tis_killable[i];
      immortality_timer[i]=timmortality_timer[i];
      particle_dead[i]=tparticle_dead[i];
      explosion_counter[i]=texplosion_counter[i];
      explosion_counter_temp[i]=texplosion_counter_temp[i];
      explosion_updater[i]=texplosion_updater[i];
      explosion_flag[i]=texplosion_flag[i];
      p[i]=temp[i];
      is_splitable[i]=tis_splitable[i];
    }
    
    //adding the extra particle and its flags at the end of each array
    
    explosion_counter[p.length-1]=1;
    explosion_counter_temp[p.length-1]=1;
    explosion_updater[p.length-1]=1;
    particle_dead[p.length-1]=false;
    is_splitable[p.length-1]=false;
    immortality_timer[p.length-1]=0;
    p[p.length-1]=bomber.bomb;
    is_killable[p.length-1]=true;
  }
}


//initializing and drawing the satellite object and initializing its flag
void add_satellite(){
  satellite=new Added_enemy((float)random(width+100,width+250+(200*wave)),(float)height/4,30, (float)random(width/2,width));
  satellite.draw_enemy();
  satellite_is_alive=satellite.is_alive;
}

//basically doing the same as the bomber handling function with different values to move the satellite at a different speed

void handle_satellite(){
  satellite.move(wave,0.5);
  satellite.draw_enemy();
  float velx;
  float vely;
  int target=(int)random(0,5);
  switch(target){
    case 0:velx=(2*distance+distance/192f);break;
    case 1:velx=(3.1*distance+distance/192f);break;
    case 2:velx=(4.2*distance+distance/192f);break;
    case 3:velx=(6.3*distance+distance/192f);break;
    case 4:velx=(7.4*distance+distance/192f);break;
    case 5:velx=(8.5*distance+distance/192f);break;  
    default: velx=0;
  }
  velx=(velx+((distance/4f)-(distance/96f)-satellite.enemy.x))/(280+(abs(satellite.enemy.y)/30));
  vely=2+(float)wave/32;
  if(satellite.drop_bomb(velx,vely)){
    int original_length=p.length;
    Particle temp[]=p;
    boolean tparticle_dead[]=particle_dead, tis_splitable[]=is_splitable, tis_killable[]=is_killable,texplosion_flag[]=explosion_flag;
    int texplosion_counter[]=explosion_counter, texplosion_counter_temp[]=explosion_counter_temp, texplosion_updater[]=explosion_updater, timmortality_timer[]=immortality_timer;
    p=new Particle[original_length+1];
    particle_dead=new boolean[p.length];
    explosion_counter=new int[p.length];
    explosion_counter_temp=new int[p.length];
    explosion_updater=new int[p.length];
    is_splitable=new boolean[p.length];
    immortality_timer=new int[p.length];
    is_killable=new boolean[p.length];
    explosion_flag=new boolean[p.length];
    for(int i=0;i<original_length;i++){
      is_killable[i]=tis_killable[i];
      immortality_timer[i]=timmortality_timer[i];
      particle_dead[i]=tparticle_dead[i];
      explosion_counter[i]=texplosion_counter[i];
      explosion_counter_temp[i]=texplosion_counter_temp[i];
      explosion_updater[i]=texplosion_updater[i];
      explosion_flag[i]=texplosion_flag[i];
      p[i]=temp[i];
      is_splitable[i]=tis_splitable[i];
    }
    explosion_counter[p.length-1]=1;
    explosion_counter_temp[p.length-1]=1;
    explosion_updater[p.length-1]=1;
    particle_dead[p.length-1]=false;
    is_splitable[p.length-1]=false;
    immortality_timer[p.length-1]=0;
    p[p.length-1]=satellite.bomb;
    is_killable[p.length-1]=true;
  }  
}

//drawing the crosshair to replace the cursor

void crosshair(){
  stroke(0);
  line(mouseX-6,mouseY-6,mouseX-2,mouseY-2);
  line(mouseX+6,mouseY+6,mouseX+2,mouseY+2);
  line(mouseX+6,mouseY-6,mouseX+2,mouseY-2);
  line(mouseX-6,mouseY+6,mouseX-2,mouseY+2);
  noStroke();
  fill(255,0,0);
  circle(mouseX,mouseY,1);
}

//checking the wave condition and handling what happens when the wave is passed or failed
void check_wave(){
  
  //if the wave was passed
    if(check_wave_condition()==1){
      for(int i=0;i<city_dead.length;i++)
        if(city_dead[i]==false)
          score+=(100*(wave>10 ? 6 :((wave+1)/2)));
        score+=((30-active_missile_counter)*5*(wave>10?6:((wave+1)/2)));
      if(score>=10000){
        for(int i=0;i<city_dead.length;i++)
          if(city_dead[i] && score >=10000){
            city_dead[i]=false;
            score-=10000;
            score_reduction+=10000;
          }
      }
      enemy_counter=0;
      add_particles();
      if(wave>5){
        smart_bomb_activated=false;
        smart_bomb=(int)random(0,p.length);
      }
      add_silos();
      active_missile_counter=0;
      for(int i=0;i<detonation_counter.length;i++)
        detonation_counter[i]=detonation_counter_temp[i]=detonation_updater[i]=1;
      for(int i=0;i<missiles.length;i++)
        missiles[i]=null;
    }
    
    //if the wave failed
    if(check_wave_condition()==2){
      fill(30,64,99);
      textAlign(CENTER);
      textSize(23);
      text("You Lose!",width/2,(height/2)-45);
      text("Wave:"+wave,width/2,height/2-20);
      text("Score:"+(score + score_reduction),width/2,height/2+5);
      textSize(12);
      text("Press Spacebar to Try Again.",width/2, (height/2)+30);
      if(keyPressed==true && key==' '){
          reset=true;
          start();
      }
    }
}

//handling everything that happens to the missile after its shot
void shoot_missile(){
  int i=0; //counter to traverse the array containing all active missiles
  
  while(missiles[i]!=null){
    
    //just to confirm we havent crossed the limit of missiles alllowed per wave
    if(active_missile_counter!=31){  
      PVector position=missiles[i].position;
    //moving the missile and applying gravity on it
      missiles[i].integrate(g);
      
      //check to see if the smart bomber needs to created by checking the wave value
      if(wave>5){
        
        if(particle_dead[smart_bomb]==false){
        
        //temporary variable to store the initial particle velocity
          float tvelx=p[smart_bomb].velocity.x, tvely=p[smart_bomb].velocity.y;
          
          //checking if the missile is near its target
          if(missiles[i].desty - missiles[i].position.y <= 50 && abs(missiles[i].destx - missiles[i].position.x) <= 50 && (missiles[i].detonate()!=true || (missiles[i].detonate()==true && detonation_counter[i]>0)) || smart_bomb_activated==true){
            
            ///checking if the smart bomb is less than 50 pixels away from the incoming missile
            if(missiles[i].position.y - p[smart_bomb].position.y <= 50 
            && smart_bomb_activated==false 
            && ((tvelx>0 && missiles[i].position.x - p[smart_bomb].position.x <= 50)||(tvelx<0 && p[smart_bomb].position.x - missiles[i].position.x  <= 50))){
              
              //storing the initial velocity of the particle to be reset after a set timer
              smart_bomber_originalvelx=tvelx;
              smart_bomber_originalvely=tvely;
              
              //double the velocity if its too close to the incoming explosion
              p[smart_bomb].velocity=new PVector(tvelx*2,tvely*2);
              p[smart_bomb].invMass=1;
              
              //to stop the smart bomb to be activated multiple times
              smart_bomb_activated=true;
              smart_timer=160;
            }
            
            //checking if the smart bomb is approaching the incomng missile and is not too close to expected explosion(150 pixels)
            else if(missiles[i].position.y - p[smart_bomb].position.y <= 150 
            && missiles[i].position.y - p[smart_bomb].position.y >= 50 
            && smart_bomb_activated==false 
            && ((tvelx>0 && missiles[i].position.x - p[smart_bomb].position.x <= 50)
            ||(tvelx<0    && p[smart_bomb].position.x - missiles[i].position.x  <= 50))){
              smart_bomber_originalvelx=tvelx;
              smart_bomber_originalvely=tvely;
              
              //slows it down till the explosion is over
              p[smart_bomb].velocity=new PVector(tvelx/8 ,tvely/8  );
              
              //reduce the effect of gravity on the particle by altering its mass
              p[smart_bomb].invMass=4 ;
              
              smart_bomb_activated=true;
              
              //setting a timer for the slowing down effect
              smart_timer=160;
            }
            
            //checking to see if the particle has passsed the explosion site
            else if(smart_timer <= 1 && smart_bomb_activated==true && missiles[i].position.y - p[smart_bomb].position.y < 0 
            || ((tvelx > 0 && missiles[i].position.x - p[smart_bomb].position.x < -50)
            ||(tvelx < 0 && p[smart_bomb].position.x - missiles[i].position.x  < - 50))  ){
              
              //checking if the timer is off
              if(smart_timer<=1){
                
                //reseting the particle
                p[smart_bomb].velocity=new PVector(smart_bomber_originalvelx , smart_bomber_originalvely);
                p[smart_bomb].invMass=1;
                smart_bomb_activated=false;
                }
            }
            else{
              
              //just to keep tract of its velocity and overwrite any false updations
              p[smart_bomb].velocity=new PVector(tvelx,tvely);
              if(frame==true){
                smart_timer--;
                frame=false;  
              }
            }
          
          }              
        }
      }
      
      //if the missile reaches its destination, detonate it and make an explosion circle
      if(missiles[i].detonate()){
        noStroke();
        fill(255,243,166);
        circle(missiles[i].destx,missiles[i].desty,detonation_counter[i]);
        
        //setting the radius of the circle
        if(detonation_counter_temp[i]<40 && detonation_counter[i]>0)
          detonation_counter[i]+=detonation_updater[i];
          
          //setting a timer for the explosion
        detonation_counter_temp[i]+=detonation_updater[i];
        
        //changing the updater for the explosion radius and timer to start reducing the respective value to save a step and variable in updation
        if(abs(detonation_counter_temp[i])==80)
          detonation_updater[i]*=(-1);
        
        //checking collision with satellite or bomber wave 2 onwards
        if(wave>1){
          boolean tempa = bomber_is_alive, tempb = satellite_is_alive;
          bomber_is_alive=bomber.check_collision(missiles[i].destx,missiles[i].desty,detonation_counter[i]);
          satellite_is_alive=satellite.check_collision(missiles[i].destx,missiles[i].desty,detonation_counter[i]);
          if(bomber_is_alive==false && tempa==true &&bomber.is_shot==true)
            score+= (100*(wave>10?6:((wave+1)/2)));
          if(satellite_is_alive==false && tempb==true && satellite.is_shot==true)
            score+= (100*(wave>10?6:((wave+1)/2)));
        }
        
        //checking collision with each particle
        for(int j=0;j<p.length;j++){
          boolean ptemp=particle_dead[j];
          if(is_killable[j])
            particle_dead[j]=p[j].particle_dead(missiles[i].destx,missiles[i].desty,detonation_counter[i]);
          else if(immortality_timer[j]==0){is_killable[j]=true;}
          else if(immortality_timer[j]>0) {immortality_timer[j]--;}
          if(particle_dead[j]==true && ptemp!=true) 
            score+= (25*(wave>10?6:((wave+1)/2)));
          if(((particle_dead[j]==true && ptemp!=true) || explosion_counter[j]!=1)&& explosion_flag[j]==false){
            explosion_flag[j]=true;
            explode_particle(j);
            
            //checking if the particle can be split
            if(is_splitable[j]){
              is_splitable[j]=false;
              split(p[j],0);
            }
          }
          
        }
      }
      else{
        fill(255,10,100);
        rect(position.x,position.y,3,2);
      }
      i++;
    }
    else
    return;
  }
}

//if a particle collides with the missile explosion, explode the particle in a similar way
void explode_particle(int index){
  noStroke();
  fill(255,243,166);
  circle(p[index].position.x,p[index].position.y,explosion_counter[index]);
  if(explosion_counter_temp[index]<40 && explosion_counter[index]>0)
    explosion_counter[index]+=explosion_updater[index];
    explosion_counter_temp[index]+=explosion_updater[index];
  if(abs(explosion_counter_temp[index])==80)
    explosion_updater[index]*=(-1);
  if(wave>1){
    boolean tempa = bomber_is_alive, tempb = satellite_is_alive;
    bomber_is_alive=bomber.check_collision(p[index].position.x,p[index].position.y,explosion_counter[index]);
    satellite_is_alive=satellite.check_collision(p[index].position.x,p[index].position.y,explosion_counter[index]);
    if(bomber_is_alive==false && tempa==true)
      score+= (100*(wave>10?6:((wave+1)/2)));
    if(satellite_is_alive==false && tempb==true)
      score+= (100*(wave>10?6:((wave+1)/2)));
  }
  for(int i=0;i<p.length;i++){
    boolean ptemp=particle_dead[i];
    if(is_killable[i])
      particle_dead[i]=p[i].particle_dead(p[index].position.x,p[index].position.y,explosion_counter[index]);
    else if(immortality_timer[i]==0){is_killable[i]=true;}
    else if(immortality_timer[i]>0) {immortality_timer[i]--;}
    if((particle_dead[i]==true && ptemp!=true)){
      score+= (25*(wave>10?6:((wave+1)/2)));
      
      //calling itself to check if the explosion caused by the particle is exploding more particles
      explode_particle(i);
      if(is_splitable[i]){
        is_splitable[i]=false;
        split(p[i],1);
      }
    }
  }
}

//function to handle splitting particles wave 2 onwards
void split(Particle parent,int check){
  
  //randomly assigning the number of children each particle will have
  int no_of_children=(int)random(2,5);
  int original_length=p.length;
  
  //adding particles to the existing arrays by creating temporary arrays to store the initial values and then reinitializing the existing arrays with a new length to include more particles
  Particle temp[]=p;
  boolean tparticle_dead[]=particle_dead, tis_splitable[]=is_splitable, tis_killable[]=is_killable,texplosion_flag[]=explosion_flag;
  int texplosion_counter[]=explosion_counter, texplosion_counter_temp[]=explosion_counter_temp, texplosion_updater[]=explosion_updater, timmortality_timer[]=immortality_timer;
  p=new Particle[original_length+no_of_children];
  particle_dead=new boolean[p.length];
  explosion_counter=new int[p.length];
  explosion_counter_temp=new int[p.length];
  explosion_updater=new int[p.length];
  is_splitable=new boolean[p.length];
  immortality_timer=new int[p.length];
  is_killable=new boolean[p.length];
  explosion_flag=new boolean[p.length];
  for(int i=0;i<original_length;i++){
    is_killable[i]=tis_killable[i];
    immortality_timer[i]=timmortality_timer[i];
    particle_dead[i]=tparticle_dead[i];
    explosion_counter[i]=texplosion_counter[i];
    explosion_counter_temp[i]=texplosion_counter_temp[i];
    explosion_updater[i]=texplosion_updater[i];
    explosion_flag[i]=texplosion_flag[i];
    p[i]=temp[i];
    is_splitable[i]=tis_splitable[i];
  }
  for(int i=original_length;i<p.length;i++){
    explosion_counter[i]=1;
    explosion_counter_temp[i]=1;
    explosion_updater[i]=1;
    particle_dead[i]=false;
    is_splitable[i]=false;
    int target=(int)random(0,6);
    switch(target){
    case 0:velx=(2*distance+distance/192f);break;
    case 1:velx=(3.1*distance+distance/192f);break;
    case 2:velx=(4.2*distance+distance/192f);break;
    case 3:velx=(6.3*distance+distance/192f);break;
    case 4:velx=(7.4*distance+distance/192f);break;
    case 5:velx=(8.5*distance+distance/192f);break;
    }
    fill(0);
    velx=(velx+((distance/4f)-(distance/96f)-parent.position.x))/(280+(abs(parent.position.y)/30));
    p[i]=new Particle(parent.position.x,parent.position.y,velx,2+(float)wave/32,1);
    if(check==0)
      immortality_timer[i]=160;
    else
      immortality_timer[i]=320;
    is_killable[i]=false;
  }
}

//to set the flag for dead particles so they wont be used in any other function and wont be drawn
void remove_particles(){
  for(int i=0;i<p.length;i++)
    particle_dead[i]=p[i].particle_dead();
}

//to add particles to the particlee array and to initialize all the arrays supporting the main particle arrays with default values
void add_particles(){
  p= new Particle[15+(wave++*5)];
  is_killable=new boolean[p.length];  //to store if a particle is killable or not (helps while splitting particles to give them time to escape the explosion they were born from)
  immortality_timer=new int[p.length]; //to keep track of the time left before the split particles are killable
  is_splitable=new boolean[p.length]; //to keep track of all the splitable particles
  explosion_flag=new boolean[p.length]; // flag to make sure explosion starts once foor each particle
  for(int i=0;i<p.length;i++)
    is_splitable[i]=false;
  if(wave>=2){
    splitting_particles=wave*2;
    for(int i=0;i<splitting_particles;i++){
      int split_random=(int)random(0,p.length);
      if(is_splitable[split_random]==true)
        i--;
      else
        is_splitable[split_random]=true;
    }
  }
  particle_dead=new boolean[p.length];
  explosion_counter=new int[p.length];
  explosion_counter_temp=new int[p.length];
  explosion_updater=new int[p.length];
  for(int i=0;i<p.length;i++){
    is_killable[i]=true;
    immortality_timer[i]=0;
    explosion_counter[i]=1;
    explosion_counter_temp[i]=1;
    explosion_updater[i]=1;
    explosion_flag[i]=false;
    particle_dead[i]=false;
    
    //randomly assigning a starting position to the particle above the visible screen area
    int location= (int)random(0,width);
    int start_height=(int)random(-(p.length*100),0);
    
    //calculating the target based on the starting position of each particle
    
    int target=6*location/800;
    
    //assigning initial velocity to reach the set target
    switch(target){
    case 0:velx=(2*distance+distance/192f);break;
    case 1:velx=(3.1*distance+distance/192f);break;
    case 2:velx=(4.2*distance+distance/192f);break;
    case 3:velx=(6.3*distance+distance/192f);break;
    case 4:velx=(7.4*distance+distance/192f);break;
    case 5:velx=(8.5*distance+distance/192f);break;
    }
    fill(0);
    velx=(velx+((distance/4f)-(distance/96f)-location))/(280+(abs(start_height)/30));
    p[i]=new Particle(location,start_height,velx,2+(float)wave/32,1);
  }
}

//function to initialize and create the city object array
void add_cities(float particleX,float particleY){
  float dimensions[]= new float[4];
  for(int i=0;i<cities.length;i++){
    switch(i){
      case 0:{
        fill(0);
        dimensions[0]=2*distance+(distance/192f);
        dimensions[1]=altitude-5;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]= altitude/80f;
      }break;
      case 1:{
        fill(0);
        dimensions[0]=(3.1*distance)+(distance/192f);
        dimensions[1]=altitude-5;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]=altitude/80f;
      }break;
      case 2:{
        fill(0);
        dimensions[0]=(4.2*distance)+(distance/192f);
        dimensions[1]=altitude-5;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]=altitude/80f;
      }break;
      case 3:{
        fill(0);
        dimensions[0]=(6.3*distance)+(distance/192f);
        dimensions[1]=altitude-5;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]=altitude/80f;
      }break;
      case 4:{
        fill(0);
        dimensions[0]=(7.4*distance)+(distance/192f);
        dimensions[1]=altitude-13;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]=altitude/40f;
      }break;
      case 5:{
        fill(0);
        dimensions[0]=(8.5*distance)+(distance/192f);
        dimensions[1]=altitude-5;
        dimensions[2]=(distance/2f)-(distance/96f);
        dimensions[3]=altitude/80f;
      }break;
    }
    cities[i]=new City(dimensions[0],dimensions[1],(dimensions[0]+dimensions[2]),(dimensions[1]+dimensions[3]));
    if(cities[i].isAlive(particleX,particleY)&&city_dead[i]==false){
      noStroke();
      fill(133,133,133);
    }
    else{
      noStroke();
      fill(123,0,0);
      city_dead[i]=true;
    }
    rect(dimensions[0],dimensions[1],dimensions[2],dimensions[3]);
  }
}

//checking to see if therre are any particles or cities left to decide if the wave has been won(1) or lost(2) or still going on(0)
int check_wave_condition(){
  for(int j=0;j<city_dead.length;j++)
    if(city_dead[j]==false){
      for(int i=0;i<particle_dead.length;i++)
        if(particle_dead[i]==false || bomber_is_alive==true || satellite_is_alive==true)
          return 0;
      return 1;}
  return 2;
  
}

//add the silos each round and reset the missile counter sso that each silo has 10 missile
void add_silos(){
  dead_missiles=0;
  float dimensions[]= new float[4];
  for(int i=0;i<s.length;i++){
    silo_dead[i]=false;
    switch(i){
      case 0: {
        dimensions[0]=0.5*distance+(distance/192f);
        dimensions[1]=altitude-25;
        dimensions[2]=(distance)-(distance/96f);
        dimensions[3]= altitude/20f;
      }break;
      case 1: {
        dimensions[0]=5*distance+(distance/192f);
        dimensions[1]=altitude-25;
        dimensions[2]=(distance)-(distance/96f);
        dimensions[3]= altitude/20f;
      }break;
      case 2: {
        dimensions[0]=9.4*distance+(distance/192f);
        dimensions[1]=altitude-25;
        dimensions[2]=(distance)-(distance/96f);
        dimensions[3]= altitude/20f;
      }break;
    }
    s[i]=new Silo(dimensions[0],dimensions[1],dimensions[0]+dimensions[2],dimensions[1]+dimensions[3]);
  }
}

//drawing the silos each frame with the updated missile counter aand their state(alive or dead)
void draw_silos(float px,float py){
  for(int i=0;i<s.length;i++){
    if(s[i].isAlive(px,py) && silo_dead[i]==false){
      noStroke();
      fill(58,74,44);
      rect(s[i].x1,s[i].y1,s[i].x2-s[i].x1,s[i].y2-s[i].y1);
    }
    else{
      noStroke();
      fill(94,44,29);
      rect(s[i].x1,s[i].y1,s[i].x2-s[i].x1,s[i].y2-s[i].y1);
      silo_dead[i]=true;
      if(s[i].missile_counter!=0)
        dead_missiles=s[i].missile_counter;
      s[i].missile_counter=0;
    }
    textAlign(CENTER);
    fill(255);
    text(s[i].missile_counter,((s[i].x1+s[i].x2)/2),(s[i].y1+s[i].y2)/2);
  }
}

//handling the mouse click event to store the coordinates of the click to launch a missile to the destination from the nearest silo with usaable missiles
void mouseClicked(){
  if(active_missile_counter+dead_missiles<30 && check_wave_condition()!=2 && start==true && s[0].missile_counter+s[1].missile_counter+s[2].missile_counter >0 ){
    float mtargetx=mouseX;
    float mtargety=(600-mouseY);
    int origin=3*(int)(mtargetx-2)/800;
    shoot(origin, mtargetx, mtargety);
  }
}

//handling key press events to give the user control over while silo they want the missile to be launched from
void keyPressed(){
  if((keyCode == UP ||keyCode == RIGHT ||keyCode == LEFT) && start==true ){
    if(active_missile_counter+dead_missiles<30 && check_wave_condition()!=2){
      float mtargetx=mouseX;
      float mtargety=(600-mouseY);
      int origin;
      if(keyCode == UP) origin = 1;
      else if(keyCode == RIGHT) origin = 2;
      else origin = 0;
      shoot(origin, mtargetx, mtargety);
    }
  }
}

//the function actually creating the missile object and giving it initial velocity (which is slightly higher if shot from the center missile silo)
void shoot(int origin, float mtargetx, float mtargety){
      if(s[origin].missile_counter==0){
        switch(origin){
        case 0:{if(s[1].missile_counter!=0) origin=1; else if(s[2].missile_counter!=0) origin=2; }break;
        case 1:{ origin= (int)mtargetx/400; if(origin==1) origin=2; if(s[0].missile_counter==0) origin=2; else if(s[2].missile_counter==0) origin=0;}break;
        case 2:{if(s[1].missile_counter!=0) origin=1; else if(s[0].missile_counter!=0) origin=0; }break;
        }
      }
      if(origin==1)
        s[origin].shoot_missile((s[origin].x1+s[origin].x2)/2,s[origin].y1,(mtargetx-((s[origin].x1+s[origin].x2)/2))/23,-mtargety/23,1,mouseX,mouseY);
      else
        s[origin].shoot_missile((s[origin].x1+s[origin].x2)/2,s[origin].y1,(mtargetx-((s[origin].x1+s[origin].x2)/2))/28,-mtargety/29,1,mouseX,mouseY);
      missiles[active_missile_counter++]=s[origin].missile;

}
