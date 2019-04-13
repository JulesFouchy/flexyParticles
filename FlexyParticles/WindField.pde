float timeSpeed = 1 ;

class WindField{
  float minWindStrength = 1.5*timeSpeed ;
  float maxWindStrength = 5*timeSpeed ;
  float minWindAngularShift = -TAU/3 ;
  float maxWindAngularShift = TAU/3 ;
  float spaceBetweenVects = 90 ;
  float stepSize = 0.001 ;
  
  float dx = 0.01 ;
  float dy = 0.01 ;
  float xShift = 0 ;
  float yShift = 0 ;
  float globalDirectionAngle ;
  
  WindField( float globalDirectionAngle ){
    this.globalDirectionAngle = globalDirectionAngle ;
  }
  
  void addValue( PVector pos , float seed ){
    float windStrength = map( noise(pos.x*stepSize+xShift+seed,pos.y*stepSize+yShift) , 0 , 1 , minWindStrength , maxWindStrength ) ;
    float windDirection = map( noise(pos.x*stepSize+xShift+1000+seed,pos.y*stepSize+yShift+1000) , 0 , 1 , minWindAngularShift , maxWindAngularShift ) ;
    pos.x += windStrength*cos(globalDirectionAngle+windDirection) ;
    pos.y += windStrength*sin(globalDirectionAngle+windDirection) ;
  }
  
  void move(){
    xShift += dx ;
    yShift += dy ;
  }
  
  void show(){
    for(float x = 0 ; x <= width ; x += spaceBetweenVects ){
      for(float y = spaceBetweenVects ; y <= width ; y += spaceBetweenVects ){
        PVector pos = new PVector( x , y ) ;
        addValue( pos , 0 ) ;
        stroke(#34930F) ;
        line( x , y , x + (pos.x-x)*10 , y + (pos.y-y)*10 ) ;
      }
    }
  }
  
  void change(){
    noiseSeed(int(random(100000))) ;
  }
}
