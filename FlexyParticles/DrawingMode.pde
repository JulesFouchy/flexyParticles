float spaceBetweenParticles = 20 ;

String tool = "BROKEN_LINE" ;
PGraphics dmPermanentDrawing ;
PrintWriter file ;
PVector latestClic = new PVector(0,0) ;
PVector latestPoint = new PVector(0,0) ;
boolean figureStarted = false ;

void dmDrawParticle( float x , float y , boolean permanent ){
  if( permanent ){
    dmPermanentDrawing.beginDraw() ;
      dmPermanentDrawing.noStroke() ;
      dmPermanentDrawing.fill(255) ;
      dmPermanentDrawing.ellipse( x , y , particleRadius()*2,particleRadius()*2) ;
    dmPermanentDrawing.endDraw() ;
  }
  else{
    noStroke() ;
    fill(255) ;
    ellipse( x , y , particleRadius()*2,particleRadius()*2) ;
  }
}

void dmAddParticle( float x , float y ){
  file.println( "particles.add( new Particle( "+x+" , "+y+" , particleRadius() , particleColour() ) ) ;" ) ;
  dmDrawParticle( x , y , true ) ;
}

void dmAddLine( PVector P1 , PVector P2 ){
  PVector dir = PVector.sub( P2, P1 ) ;
  float d = dir.mag() ;
  dir.mult(1/d) ;
  for( float dl = 0 ; dl <= d ; dl += spaceBetweenParticles ){
    PVector pt = PVector.add( P1 , PVector.mult(dir,dl) ) ;
    dmAddParticle( pt.x , pt.y ) ;
  }
}

void dmAddLine( PVector P1 , float x2 , float y2 ){
  dmAddLine( P1 , new PVector(x2,y2) ) ;
}

void dmAddCircle( PVector P , float r ){
  float dTheta = spaceBetweenParticles / r ;
  for( float theta = 0 ; theta < TAU ; theta += dTheta ){
    dmAddParticle( P.x + r*cos(theta) , P.y +r*sin(theta) ) ;
  }
}

void dmDrawLine( PVector P1 , PVector P2 ){
  PVector dir = PVector.sub( P2, P1 ) ;
  float d = dir.mag() ;
  dir.mult(1/d) ;
  for( float dl = 0 ; dl <= d ; dl += spaceBetweenParticles ){
    PVector pt = PVector.add( P1 , PVector.mult(dir,dl) ) ;
    dmDrawParticle( pt.x , pt.y , false ) ;
  }
}

void dmDrawLine( PVector P1 , float x2 , float y2 ){
  dmDrawLine( P1 , new PVector( x2 , y2 ) ) ;
}

void dmDrawCircle( PVector P , float r ){
  float dTheta = spaceBetweenParticles / r ;
  for( float theta = 0 ; theta < TAU ; theta += dTheta ){
    dmDrawParticle( P.x + r*cos(theta) , P.y +r*sin(theta) , false ) ;
  }
}

void dmOnClick(){
  if( !figureStarted && tool != "POINT" ){
    figureStarted = true ;
  }
  else{
    switch( tool ){
      case "POINT" :
        dmAddParticle( mouseX , mouseY ) ;
        latestPoint.set(mouseX,mouseY) ;
      break ;
      case "LINE" :
        dmAddLine( latestClic , mouseX, mouseY ) ;
        figureStarted = false ;
      break ;
      case "BROKEN_LINE" :
        dmAddLine( latestClic , mouseX , mouseY ) ;
      break ;
      case "CIRCLE" :
        dmAddCircle( latestClic , dist(latestClic,mouseX,mouseY) ) ;
        figureStarted = false ;
      break ;
    }
  }
  latestClic.set( mouseX , mouseY ) ;
}

void dmDraw(){
  if( figureStarted ){
    switch( tool ){
      case "LINE" : 
        dmDrawLine( latestClic , mouseX , mouseY ) ;
      break ;
      case "BROKEN_LINE" :
        dmDrawLine( latestClic , mouseX , mouseY ) ;
      break ;
      case "CIRCLE" :
        dmDrawCircle( latestClic , dist(latestClic,mouseX,mouseY) ) ;
      break ;
    }
  }
}

void dmKeyPressed(){
  if( keyCode == ENTER ){
    figureStarted = false ;
  }
  if( keyCode == ESC ){
    file.println( "}" ) ;
    file.flush();
    file.close();
    exit() ;
  }
  if( key == 'p' || key == 'P' ){
    tool = "POINT" ;
  }
  if( key == 'l' || key == 'L' ){
    tool = "LINE" ;
  }
  if( key == 'b' || key == 'B' ){
    tool = "BROKEN_LINE" ;
  }
  if( key == 'c' || key == 'C' ){
    tool = "CIRCLE" ;
  }
}

void dmMouseDragged(){
  if( tool == "POINT" ){
    if( dist( latestPoint , mouseX , mouseY ) > spaceBetweenParticles ){
      dmAddParticle( mouseX , mouseY ) ;
      latestPoint.set(mouseX,mouseY) ;
    }
  }
}
