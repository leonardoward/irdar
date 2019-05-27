import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port
int ancho_radar=100;
String dataSerial="";
String dataSerial2="";
int sensor1Value;
int dist=100;
int array_size=parseInt(100*2*PI);
int index=0;
float[][] radius_array=new float[2][array_size]; 
//La primera columna tiene la lista de ángulos, y la segunda tiene la distancia 
//que corresponde a dicho ángulo
int cont;

void setup() {
  size(600, 600, P3D);
  //I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using. 
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  float theta=0.0;
  for(cont=0;cont<array_size;cont++){
    radius_array[0][cont]=theta;
    theta+=0.01;
  }
}

void draw(){
  background(255);
  //----------Mostramos el mapa que ayuda a ubicar las distancias------
  //dist=parseInt(100+100*noise(radius_array[0][index]));
  radius_array[1][index]=dist;
  stroke(0);
  noFill();
  ellipse(width/2, height/2, width/2, width/2); // Adjust for center of window
  ellipse(width/2, height/2, width/4+width/2, width/4+width/2); // Adjust for center of window
  ellipse(width/2, height/2, width, width); // Adjust for center of window
  ellipse(width/2, height/2, width/4, width/4); // Adjust for center of window
  //-----------Manejamos la animación del movimiento del IRDAR----------
  //Guardamos la configuración actual de puntos (translate and rotate)
  pushMatrix();
  stroke(0);
  fill(175);
  translate(width/2, height/2);
  rotateZ(radius_array[0][index]);
  rectMode(CENTER);
  rect(0, 0, ancho_radar, 20, 4);
  //line(ancho_radar/2,0,width,0);
  //line(-ancho_radar/2,0,-dist,0);
  line(-ancho_radar/2,0,-radius_array[1][index],0);
  //theta += 0.02;
  popMatrix();
  //--------------------------------------------------------------------
  //rectMode(CENTER);
  //rect(10, 10, 100, 100);
  //------------Manejamos el arreglo de puntos detectados----------------
  for(cont=0;cont<array_size;cont++){
    // Polar to Cartesian conversion
    float x = -radius_array[1][cont] * cos(radius_array[0][cont]);
    float y = -radius_array[1][cont] * sin(radius_array[0][cont]);
    // Draw an ellipse at x,y
    noStroke();
    fill(0);
    ellipse(x + width/2, y + height/2, 5, 5); // Adjust for center of window   
  }
  //--------------------Aumentamos el contador-------------------------- 
  //--------que se utiliza para la animación y para el mapeo de puntos--
  if(index<array_size-1){
      index++;
  }else{
      index=0; 
  }
  //--------------------------------------------------------------------
  serial();
}
//#######################################################################
//                            Serial Event
//Descripción: se activa cada vez que entra data en el buffer de serial
//#######################################################################
/*
void serial() { 
  while (myPort.available() > 0) {
    val= myPort.readStringUntil('A');
  }
  if(val!=null){
    for(cont=0;cont<val.indexOf("C");cont++){
      dataSerial+=val.charAt(cont);
    }
    println(parseInt(dataSerial)); //print it out in the console
    if(val.charAt(val.indexOf("C")+1)=='0'){
      theta=(parseInt(dataSerial)*PI)/LinesperPI;
    }else{
      theta=((LinesperPI-parseInt(dataSerial))*PI)/LinesperPI;
    }    
    dataSerial="";
    for(cont=(val.indexOf("D")+1);cont<(val.indexOf("A")-1);cont++){
      dataSerial2+=val.charAt(cont);
    }
    dist=100+parseInt(dataSerial2);
    dataSerial2="";
  }
} 
*/
void serial() { 
    int cont_serial=0;
    while (myPort.available() > 0) {
      val= myPort.readStringUntil('E');
      
      if(val!=null && val.length()>7){
        //print(val);
        /*
        while(cont_serial<val.length()){
          print(parseInt(val.charAt(cont_serial)));
          print(" ");
          cont_serial++;
        }
        */ 
        print(val.charAt(0));  //C --> Counts
        print(parseInt(val.charAt(1)));  
        print(val.charAt(2));  //D --> Direction
        print(parseInt(val.charAt(3)));
        print(val.charAt(4));  //A --> Analog Values
        dist=(ancho_radar/2)+(((height-ancho_radar)/2)*parseInt(val.charAt(5)))/100;
        print(parseInt(val.charAt(5)));
        print(parseInt(val.charAt(6)));
        print(val.charAt(7));  //E --> END 
      }    
      println();
      val="";
    }    
}