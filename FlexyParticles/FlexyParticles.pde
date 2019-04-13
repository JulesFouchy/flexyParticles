String mode = "PLAY" ; //either PLAY , DRAW or IMPORT
//image to import :
String imgPath = "passionProcessing.png" ;
//background colour
color bgColour = #9E8BF2 ;
//You can choose the particle's radius
float particleRadius(){
  return 9 ;
}
//and the particle's colour
color particleColour(){
    //Gradient
  PerlinPos += 0.01 ;
  colorMode( HSB , 1 , 100 , 100 ) ;
  color col = color( map(noise(PerlinPos,0),0,1,minCol,maxCol) , 70,80 ) ;
  colorMode( RGB , 255 ,255 ,255 ) ;
    //Single colour
  //color col = #23107C ;
  return col ;
}



ArrayList<Particle> particles ;
WindField windfield ;
float powerCharged = 25 ;
float PerlinPos = 0 ;
float minCol = 0 ;
float maxCol = 1 ;


void settings(){
  switch( mode ){
    case "PLAY" :
      fullScreen( P2D ) ;
    break ;
    case "IMPORT" :
      fullScreen() ;
    break ;
    case "DRAW" :
      fullScreen() ;
    break ;
  }
}

void setup(){
  switch( mode ){
    case "PLAY" :
      particles = new ArrayList<Particle>() ;
      latestInit( particles ) ;
      windfield = new WindField(PI) ;
      background(bgColour) ;
    break ;
    case "IMPORT" :
      generateFromImage( imgPath ) ;
    break ;
    case "DRAW" :
      dmPermanentDrawing = createGraphics( width , height ) ;
      file = createWriter("LatestInit.pde"); 
      file.println("void latestInit( ArrayList<Particle> particles ){") ;
      background(0) ;
    break ;
  }
}

void draw(){
  switch( mode ){
    case "PLAY" :
      if( mousePressed ){
        if( mouseButton == RIGHT ){
          powerCharged += 1 ;
        }
      }
      noStroke() ;
      fill( bgColour , 50 ) ;
      rect(0,0,width,height) ;
      for( Particle particle : particles ){
        windfield.addValue( particle.pos , 0 ) ;
        if( mousePressed ){
          if(mouseButton == LEFT ){
            particle.setAway( mouseX , mouseY , 250 ) ;
          }
          if( mouseButton == CENTER ){
            particle.pos.set(mouseX,mouseY) ;
          }
        }
        particle.applyBaseForces() ;
        particle.move() ;
        particle.show() ;
      }
      windfield.move() ;
    break ;
    case "DRAW" :
      background(0) ;
      dmDraw() ;
      image(dmPermanentDrawing,0,0) ;
    break ;
  }
}

void mousePressed(){
  switch( mode ){
    case "PLAY" :
    break ;
    case "DRAW" :
      dmOnClick() ;
    break ;
    case "IMPORT" :
    break ;
  }
}

void mouseReleased(){
    switch( mode ){
    case "PLAY" :
      if( mouseButton == LEFT ){
        for( Particle particle : particles ){
          PVector force = PVector.sub(particle.pos,new PVector(mouseX,mouseY)).normalize().mult( 18 ) ;
          particle.applyForce( force ) ;
        }
      }
      if( mouseButton == RIGHT ){
        for( Particle particle : particles ){
          PVector force = PVector.sub(particle.pos,new PVector(mouseX,mouseY)).normalize().mult( powerCharged ) ;
          particle.applyForce( force ) ;
        }
        powerCharged = 25 ;
      }
    break ;
    case "DRAW" :
    break ;
    case "IMPORT" :
    break ;
  }
}

void keyPressed(){
  switch( mode ){
    case "PLAY" :
      if( key == 't' || key == 'T' ){
        for( Particle particle : particles ){
          particle.pos.set(random(-width,3*width),random(-height,3*height) ) ;
        }
      }
    break ;
    case "DRAW" :
      dmKeyPressed() ;
    break ;
    case "IMPORT" :
    break ;
  }
}

void mouseDragged(){
  switch( mode ){
    case "PLAY" :
    break ;
    case "DRAW" :
      dmMouseDragged() ;
    break ;
    case "IMPORT" :
    break ;
  }
}
