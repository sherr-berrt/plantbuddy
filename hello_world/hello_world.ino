
#include "DHT.h"
#include <Arduino.h>
#include "Seeed_BMP280.h"
#include "SoftwareSerial.h"

#include <SD.h>
#include <Wire.h>


const int lightDetect = A6;
//const int tempAndHumidDetect = D3
//const int pressureDetect = IIC

BMP280 bmp280;

DHT dht(3, DHT11);

File csvFile;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  while(!Serial) {
    ;
  }

  if (!bmp280.init()) {
    Serial.println("Error, pressure device not connected or broken");
  }

  csvFile = SD.open("data.csv");


  if(csvFile)
  {
    csvFile.print("Light,");
    csvFile.print("Temperature,");
    csvFile.print("Humidity,");
    csvFile.println("Pressure");
  }
}

void loop() {
  int light;
  float tmp;
  float humi;
  float pressure;

  // put your main code here, to run repeatedly:
  delay(1000);

  light = analogRead(lightDetect);
  tmp = dht.readTemperature();
  humi = dht.readHumidity();
  pressure = bmp280.getPressure();
  //  pressure = analogRead(pressureDetect);

  Serial.println("=newline=");

  Serial.print("light:");
  Serial.println(light);
  Serial.print("temperature:");
  Serial.println(tmp);
  Serial.print("humidity:");
  Serial.println(humi);
  Serial.print("pressure:");
  Serial.println(pressure);

  csvFile= SD.open("data.txt");

  if(csvFile)
  {
    csvFile.print(light);
    csvFile.print(",");
    csvFile.print(tmp);
    csvFile.print(",");
    csvFile.print(humi);
    csvFile.print(",");
    csvFile.println(pressure);
  } else{
//    Serial.println("Error opening csv");
  }
  csvFile.close();
  
}
