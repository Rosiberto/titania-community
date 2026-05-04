## Example 1 - connecting ESP32 to the TiTaniA with internet connect 

Neste exemplo, conectaremos o sensor de nível ao TiTaniA usando ESP32.


*1 - Inclusão das Bibliotecas*
```
#include <WiFi.h> 
#include <HTTPClient.h> 
#include <ArduinoJson.h> 
#include <ArduinoJson.hpp> 
``` 

*2 - Definição das variáveis, constantes, credenciais de rede e url*

``` 
const char* ssid     = "XXXX"; 
const char* password = "XXXX"; 
 
//IP_TITANIA - host onde o TiTaniA está instalado (e.g. localhost)
//PORTA         - onde o AgentJson espera receber os dados do sensor
//RESOURCE      - (e.g. /iot/json) recurso cadastrado no Service Group 
//DEVICE_ID     - device cadastrado no Device
//APIKEY        - chave gerada pelo TiTaniA

String IP_TITANIA    = "yyyyyyy"
String PORTA         = "7896"
String RESOURCE      = "zzzzzzz"
String DEVICE_ID     = "wwwwwww"
String APIKEY        = "xxxxxxx"


//definição da URL completa. Não alterar
//verifique se deve usar http ou https
String url = "http://"+IP_TITANIA+":"+PORTA+RESOURCE+"?i="+DEVICE_ID+"&k="+APIKEY; 
 

//Variáveis de tempo 
unsigned long lastTime = 0; 
unsigned long timerDelay = 30000;

/* Pinos correspondentes ao sensor */
#define sensorVCC 2     /*Define vcc como pino 2 */ 
#define sensorSinal A1  /*Define sinal como pino A1 */ 

```

*3 - Configurações*
```
void setup() { 

  Serial.begin(11520);

  /* define 2 como pino de saída do ESP */
  pinMode(sensorvcc, OUTPUT);

  /* vcc tem nível lógico baixo até que haja alguma variação na leitura */
  digitalWrite(sensorvcc, LOW);   
    
 
  WiFi.begin(ssid, password); 
  Serial.println("Conectando..."); 
  
  while(WiFi.status() != WL_CONNECTED) { 
    delay(500); 
    Serial.print("."); 
  } 
  
  Serial.println(""); 
  Serial.print("Conectado a Wi-Fi com IP: "); 
  Serial.println(WiFi.localIP()); 
   
} 
```
 
 
*4 - Medições e Envio*
```
void loop() { 

if ((millis() - lastTime) > timerDelay) { 
  
  //Verifica o estado da conexão Wi-Fi 
  if(WiFi.status()== WL_CONNECTED){
    HTTPClient http;
    String urlPath = url;
    delay(5000);
    
    //captura a leitura do sensor
    int l = leituraSensorNivel();
    
    if ( isnan(l) ) {
      Serial.println("Erro ao obter dados do sensor de nível");
      return;
    }
    http.begin( urlPath.c_str() );
    http.addHeader("Content-Type", "application/json");
    http.addHeader("fiware-service", "titania");
    http.addHeader("fiware-servicepath", "/");
    
    // Coloca a leitura do sensor no formato JSON
    String json;
    DynamicJsonDocument doc(1024);
    
    doc["l"]= l;
    serializeJson(doc, json);
    
    //mostra no serial monitor o valor lido no formato json
    Serial.println(json);
    
    //envia para o IP_TITANIA
    int httpResponseCode = http.POST(json);
    
    //retorno da solicitação
    if (httpResponseCode > 0) {
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode);
      String payload = http.getString();
      Serial.println(payload);
    }else{
      Serial.print("Error code: ");
      Serial.println(httpResponseCode);
    }
    
    http.end();
    
  }else{
    Serial.println("Wi-Fi Desconectado");
  }
  
  lastTime = millis();
  
  }
} 
```


*5 - Coleta das leituras*
```
int leituraSensorNivel() {  
 
 //alimenta o sensor 
 digitalWrite(sensorVCC, HIGH); 
 delay(10);
 
 // Faz a leitura analógica do sensor
 val = analogRead(sensorSinal);
 
 // Desliga o sensor
 digitalWrite(sensorVCC, LOW);
 
 // envia leitura
 return val;             		    
}
```