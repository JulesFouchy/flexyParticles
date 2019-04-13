class Particle{
  //Movements
  PVector speed ;
  PVector pos ;
  //Rest position
  PVector pos0 ;
  //Visuals
  float r ;
  color colour ;
  //Physics parameters
  float raideur;
  float frotCoef;
  
  Particle( float x0_ , float y0_ , float r_ , color col ){
    //Movements
    speed = new PVector( 0 , 0 ) ;
    pos = new PVector( x0_ , y0_ ) ;
    //Rest position
    pos0 = new PVector( x0_ , y0_ ) ;
    //Visuals
    r = r_ ;
    colour = col ;
    //Physics parameters
    raideur = 0.005 ;
    frotCoef = -0.03 ;
  }
  
  void show(){
    noStroke() ;
    fill( colour ) ;
    ellipse( pos.x , pos.y , 2*r , 2*r ) ;
  }
  
  void applyBaseForces(){
    PVector acc = new PVector( 0 , 0 ) ;
    PVector rappelForce = PVector.sub( pos0 , pos ).mult(raideur) ;
    PVector frottementForce = PVector.mult( speed , frotCoef ) ;
    acc.add(rappelForce).add(frottementForce) ;
    speed.add(acc) ;
  }
  
  void applyForce( PVector force ){
    speed.add( force ) ;
  }
  
  void move(){
    pos.add(speed) ;
  }
  
  void update(){
    applyBaseForces() ;
    move() ;
    show() ;
  }
  
  //Forces 
  void setAway( float x , float y , float r ){
    PVector mouse = new PVector(x,y) ;
    if( pos.dist(mouse) < r ){
      PVector dir = PVector.sub( pos , mouse ) ;
      dir.normalize().mult(r) ;
      pos = PVector.add(mouse,dir) ;
    }
  }
}
