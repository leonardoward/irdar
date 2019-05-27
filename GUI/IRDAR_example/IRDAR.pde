class IRDAR {
  //###################################################################
  //##                         Variables                             ##
  //###################################################################
  int ancho_radar;
  int array_size; 
  float[][] radius_array;
  int cont;
  int w;
  int h;
  //###################################################################
  //##                        Constructor                            ##
  //###################################################################
  IRDAR(int ancho_radar_, int array_size_, int h_, int w_){
    h=h_;
    w=w_;
    ancho_radar=ancho_radar_;
    array_size=array_size_;
    radius_array=new float[2][array_size];
    float theta=0.0;
    for(cont=0;cont<array_size;cont++){
      radius_array[0][cont]=theta;
      theta+=0.01;
    }
  }
  //###################################################################
  //##                        Funciones                              ##
  //###################################################################
  void draw_map(int center_x,int center_y,int max_size){
    //----------Mostramos el mapa que ayuda a ubicar las distancias----
    strokeWeight(3); 
    stroke(#2FF00A);
    fill(#21A008);        
    ellipse(center_x, center_y, max_size/2, max_size/2); // Adjust for center of window
    ellipse(center_x, center_y, max_size/4+max_size/2, max_size/4+max_size/2); // Adjust for center of window 
    ellipse(center_x, center_y, max_size/4, max_size/4); // Adjust for center of window
    line(center_x, center_y+max_size/8,center_x,max_size+5);
    line(center_x+max_size/8, center_y,max_size+5,center_y);
    line(center_x, center_y-max_size/8,center_x,height-max_size-5);   
    line(center_x-max_size/8, center_y,5,center_y); 
    ellipse(center_x, center_y, max_size, max_size); // Adjust for center of window
    strokeWeight(1); 
  } 
  void draw_animation(int index, int max_size, int center_x, int center_y){
    //-----------Manejamos la animación del movimiento del IRDAR----------
    //Guardamos la configuración actual de puntos (translate and rotate)
    pushMatrix();
    stroke(0);
    fill(175);
    translate(center_x, center_y);
    rotateZ(radius_array[0][index]);
    rectMode(CENTER);
    rect(0, 0, ancho_radar, 20, 4);
    //line(ancho_radar/2,0,width,0);
    //line(-ancho_radar/2,0,-dist,0);
    /*
    line(-ancho_radar/2,0,-radius_array[1][index],0);
    if(index<array_size/2){
      line(ancho_radar/2,0,radius_array[1][array_size/2+index],0);
    }else{
      line(ancho_radar/2,0,radius_array[1][-array_size/2+index],0);
    }
    */
    strokeWeight(4);
    stroke(#30F50A);
    fill(#30F50A);
    line(-ancho_radar/2,0,-max_size,0);
    line(ancho_radar/2,0,max_size,0);
    strokeWeight(1);
    //theta += 0.02;
    popMatrix();
    //--------------------------------------------------------------------
  }
  void draw_points(int center_x, int center_y){
    //------------Manejamos el arreglo de puntos detectados----------------
    for(cont=0;cont<array_size;cont++){
      // Polar to Cartesian conversion
      float x = -radius_array[1][cont] * cos(radius_array[0][cont]);
      float y = -radius_array[1][cont] * sin(radius_array[0][cont]);
      // Draw an ellipse at x,y
      strokeWeight(4);
      stroke(255);
      fill(255);
      ellipse(x + center_x, y + center_y, 2, 2); // Adjust for center of window   
    }
    strokeWeight(1);
  }
  
  void set_dist(int index,int dist){
    radius_array[1][index]=dist;
  }
}