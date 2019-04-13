void generateFromImage(String imagePath){
  spaceBetweenParticles = 20;
  //Open image
  PImage image = loadImage( imagePath ) ;
  //Resize
  float finalProportion = 0.9 ;
  float imRatio = (float)image.width/image.height ;
  float windowRatio = (float)width/height ;
  if( windowRatio < imRatio ){
    image.resize( round(width * finalProportion) , round(width * finalProportion /imRatio) ) ;
  }
  else{
    image.resize( round(height * finalProportion * imRatio) , round(height * finalProportion ) ) ;
  }
  float marginX = (width-image.width)/2 ;
  float marginY = (height-image.height)/2 ;
  //float scale = width/image.width * finalProportion ;
  //float marginX = width * (1-finalProportion) /2 ;
  //float marginY = height * (1-scale) /2 ;
  //image.resize( round(image.width * scale) , round(image.height * scale) ) ;
  //Open file
  image.loadPixels() ;
  file = createWriter("LatestInit.pde"); 
  file.println("void latestInit( ArrayList<Particle> particles ){") ;
  //Put particles
  for( float x = marginX ; x < width-marginX ; x += spaceBetweenParticles ){
    for( float y = marginY ; y < height-marginY ; y += spaceBetweenParticles ){
      float x_ = map( x , marginX , width-marginX , 0 , image.width ) ;
      float y_ = map( y , marginY , height-marginY , 0 , image.height ) ;
      int pixelPos = round(y_)*image.width+round(x_) ;
      if( pixelPos>=0 && pixelPos<image.width*image.height){
        color col = image.pixels[ pixelPos ] ;
        if( alpha(col) > 220 ){
          file.println( "particles.add( new Particle( "+x+" , "+y+" , particleRadius() , color("+red(col)+","+green(col)+","+blue(col)+") ) ) ;" ) ;
        }
      }
    }
  }
  //End file
  file.println( "}" ) ;
  file.flush();
  file.close();
  exit() ;
}
