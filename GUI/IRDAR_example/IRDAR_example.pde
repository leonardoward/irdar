import processing.serial.*;
PFont f;  
PFont f_2;  
IRDAR irdar;
Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port
String dataSerial="";
String dataSerial2="";
int sensor1Value;
int dist1=100;
int dist2=100;
int index=0;
int index_last=0;
int array_size=parseInt(100*2*PI); //2PI=628pos --> PI=314pos, 
int cont=0;
int promedio=0;
int promedio_final=0;
boolean set_last_index=false;
int top_last_index=0;
byte[] inBuffer = new byte[9];
boolean mostrar_irdar=false;
PImage img; 
String portName;
void setup(){
  size(650, 600, P3D); 
  if(Serial.list().length!=0){
    printArray(Serial.list());
    portName = Serial.list()[0];
    myPort = new Serial(this, portName, 9600);
  }  
  irdar=new IRDAR(100,array_size,height,width);
  //Create Font
  f = createFont("Arial", 12);
  f_2=createFont("Arial", 16);
  img = loadImage("green.jpg");
}

void draw(){
  if(mostrar_irdar){
    draw_irar();
  }else{
    background(0);
   // The image() function displays the image at a location
   // in this case the point (0,0).
   image(img, 0, 0, width, height);
  }
}

void draw_irar(){
  background(0);
  //dist1=parseInt(100+100*noise(irdar.radius_array[0][index]));
  //Sharp 1
  irdar.set_dist(index,dist1);
  if(index_last<index){
    for(cont=index_last+1;cont<index;cont++){
        irdar.set_dist(cont,0);
    }
  }else{
    for(cont=index+1;cont<index_last;cont++){
        irdar.set_dist(cont,0);
    }
  }
  //------------------------Sharp 2-------------------------------------
  if(index<array_size/2){
    irdar.set_dist(array_size/2+index,dist2);
    if(array_size/2+index_last<array_size/2+index){
      for(cont=array_size/2+index_last+1;cont<array_size/2+index;cont++){
          irdar.set_dist(cont,0);
      }
    }else{
      for(cont=array_size/2+index+1;cont<array_size/2+index_last;cont++){
          irdar.set_dist(cont,0);
      }
    }
  }else{
    irdar.set_dist(-array_size/2+index,dist2);
    if(-array_size/2+index_last<-array_size/2+index){
      for(cont=-array_size/2+index_last+1;cont<-array_size/2+index;cont++){
          irdar.set_dist(cont,0);
      }
    }else{
      for(cont=-array_size/2+index+1;cont<-array_size/2+index_last;cont++){
          irdar.set_dist(cont,0);
      }
    }
  }
  
  irdar.draw_map(600/2, 600/2,600-10);
  irdar.draw_animation(index,(600-10)/2,600/2,600/2);
  irdar.draw_points(600/2,600/2);
  index_last=index;
  //println(index_last);
  
  textFont(f, 12); // Step 4: Specify font to be used
  fill(0);         // Step 5: Specify font color
  // Step 6: Display Text
  text("120cm           60cm              30cm   10cm", 10, height/2-10);
  if(portName==null){
    fill(255);         // Step 5: Specify font color
    text("Para conectar presione c", 500, 40);
    textFont(f, 16); // Step 4: Specify font to be used
    text("DESCONECTADO", 500, 20);
  }else{
    fill(255);         // Step 5: Specify font color
    textFont(f, 16); // Step 4: Specify font to be used
    text("CONECTADO", 500, 20);
  }  
  //--------------------Aumentamos el contador-------------------------- 
  //--------que se utiliza para la animación y para el mapeo de puntos--
  /*
  if(index<array_size-1){
      index=index+5;
  }else{
      index=0; 
  }
  */
  if(portName!=null){
    serial();
  }else{
    portName=null;
  }
  //println(index);
}

void serial() { 
    int cont_serial=0;
    while (myPort.available() > 0) {
      val= myPort.readStringUntil('E');
      if(val!=null && val.length()>8){
        //print(val);
        print(val.charAt(0));  //C --> Counts
        print(" "); 
        print(parseInt(val.charAt(1)));  
        print(" "); 
        print(parseInt(val.charAt(2))); 
        print(" "); 
        index=parseInt(val.charAt(1))+parseInt(val.charAt(2));
        if(val.charAt(4)=='1'){
          index=constrain(index*(314/230),0,314);
          set_last_index=false;
        }else{
          if(set_last_index==false){
            top_last_index=index_last;
            set_last_index=true;
          }
          if(top_last_index==0){
            top_last_index=230;
          }
          index=constrain(top_last_index-(index*(314/230)),0,314);
        }        
        print(val.charAt(3));  //D --> Direction
        print(val.charAt(4));
        print(val.charAt(5));  //A --> Analog Values
        print(parseInt(val.charAt(6)));
        print(parseInt(val.charAt(7)));
        println(val.charAt(8));  //E --> END 
        //-----------------------------------------------------------------------
        //Ecuación del sharp 1
        dist1=parseInt(89.41*exp(-0.04*parseInt(val.charAt(6)))+6.41);
        //Regla de 3 para cubrir toda la pantalla
        //dist1=(irdar.ancho_radar/2)+(((height/2)-(irdar.ancho_radar/2))*dist1)/80;
        dist1=constrain((irdar.ancho_radar/2)+(dist1*300)/120,irdar.ancho_radar/2,300);
        //Ecuación del sharp 2
        dist2=parseInt(105.27*exp(-0.04*parseInt(val.charAt(7)))+6.36);
        //dist2=(irdar.ancho_radar/2)+(((height/2)-(irdar.ancho_radar/2))*dist2)/80;
        dist2=constrain((irdar.ancho_radar/2)+(dist2*300)/120,irdar.ancho_radar/2,300);
        //-----------------------------------------------------------------------
        if(cont<10){
          promedio+=dist1;
          cont++;
        }else{
           promedio=promedio/10; 
           promedio_final=promedio;
           promedio=0;
           cont=0;
        }
      }    
      //println();
      val="";
    }    
}

void keyPressed() {
  if(keyCode==10){
    mostrar_irdar=true; 
  }
  if(Serial.list().length!=0 && keyCode==67){
    printArray(Serial.list());
    portName = Serial.list()[0];
    myPort = new Serial(this, portName, 9600);
  }  
}