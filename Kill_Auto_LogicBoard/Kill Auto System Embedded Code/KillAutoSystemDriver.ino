#define Cell1         A0
#define Cell2         A1
#define Cell3         A2
#define Cell4         A3

//Auto Button Wire Configuration
#define AutoRED       7
//AutoColorGND
//AutoGND
#define AutoButton    A4
#define AutoGREEN     6


//Kill Button Wire Configuration
#define KillRED       4
//KillColorGND
//KillGND
#define KillButton    A5
#define KillGREEN     5

#define KillGate      8


volatile bool AutoModeOn = false;
volatile bool KillModeOn = false;

volatile float Cell1_Voltage;
volatile float Cell2_Voltage;
volatile float Cell3_Voltage;
volatile float Cell4_Voltage;
volatile float Total_Voltage;

unsigned long previousTimeAuto = 0;
unsigned long currentTimeAuto = 0;
int activateTimeAuto = 500; // Button Spam delay

unsigned long previousTimeKill = 0;
unsigned long currentTimeKill = 0;
int activateTimeKill = 500; // Button Spam delay

void setup() {
  Serial.begin(9600);

  //Sends 5v to MOSFET when unkilled
  pinMode(KillGate, OUTPUT);

  //Sends 5v when color desired to 5-12 boost
  pinMode(AutoRED, OUTPUT);
  pinMode(AutoGREEN, OUTPUT);
  pinMode(KillRED, OUTPUT);
  pinMode(KillGREEN, OUTPUT);
}

void loop() {
  if (analogRead(KillButton) == 0) {
    KillMode();
  }
  if (analogRead(AutoButton) == 0) {
    AutoMode();
  }
  delay(100);
}

void AutoMode() {
  currentTimeAuto = millis();
  if (currentTimeAuto - previousTimeAuto > activateTimeAuto) {
    AutoModeOn = !AutoModeOn;
    if (AutoModeOn == true) {
      digitalWrite(AutoGREEN, HIGH);
    }
    else {
      digitalWrite(AutoGREEN, LOW);
    }
  }
    previousTimeAuto = currentTimeAuto;
    Serial.print("Auto Status:");
    Serial.println(AutoModeOn);
}

void KillMode() {
  currentTimeKill = millis();
  if (currentTimeKill - previousTimeKill > activateTimeKill) {
    KillModeOn = !KillModeOn;
    if (KillModeOn == true) {
      digitalWrite(KillGate, LOW);
      digitalWrite(KillRED, HIGH);
    }
    else {
      digitalWrite(KillGate, HIGH);
      digitalWrite(KillRED, LOW);
    }
  }
  previousTimeKill = currentTimeKill;
  Serial.print("Kill Status:");
  Serial.println(KillModeOn);
}
