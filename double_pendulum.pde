float x0 = 300;
float y0 = 300;

float L1 = 140;
float L2 = 140;
float m1 = 1.0;
float m2 = 1.0;
float g = 1.0;
float h = 1.0;

float phi1 = random(90,270)/180.0*PI;
float dphi1 = 0;
float phi2 = random(360)/180.0*PI;
float dphi2 = 0;

int N = 1000;
float[] x_trace = new float[N];
float[] y_trace = new float[N];

float ddphi1 (float phi1, float phi2, float dphi1, float dphi2){
  float n1 = - g*(2*m1+m2)*sin(phi1); 
  float n2 = - m2*g*sin(phi1-2*phi2);
  float n3 = -2*sin(phi1-phi2)*m2*(dphi2*dphi2*L2 + dphi1*dphi1*L1*cos(phi1-phi2));
  float d = L1*(2*m1+m2-m2*cos(2*phi1-2*phi2));
  return (n1+n2+n3)/d;
}

float ddphi2 (float phi1, float phi2, float dphi1, float dphi2){
  float n1 = dphi1*dphi1*L1*(m1+m2); 
  float n2 = g*(m1+m2)*cos(phi1);
  float n3 = dphi2*dphi2*L2*m2*cos(phi1-phi2);
  float d = L2*(2*m1+m2-m2*cos(2*phi1-2*phi2));
  return 2*sin(phi1-phi2)*(n1+n2+n3)/d;
}

void setup(){
  size(600,600);
  frameRate(30);
  
  for (int i=0;i<N;i++){
    x_trace[i] = -1.0;
    y_trace[i] = -1.0;
  }
}

void draw(){
  
  float dd1 = ddphi1(phi1, phi2, dphi1, dphi2);
  float dd2 = ddphi2(phi1, phi2, dphi1, dphi2);
  phi1 += h*dphi1 + pow(h,2)*dd1/2.0;
  phi2 += h*dphi2 + pow(h,2)*dd2/2.0;
  dphi1 += h/2*(dd1 + ddphi1(phi1, phi2, dphi1, dphi2));
  dphi2 += h/2*(dd2 + ddphi2(phi1, phi2, dphi1, dphi2));
  
  
  float x1 = x0 + L1*sin(phi1);
  float y1 = y0 + L1*cos(phi1);
  float x2 = x1 + L2*sin(phi2);
  float y2 = y1 + L2*cos(phi2);
  
  background(0);
  x_trace[0] = x2;
  y_trace[0] = y2;
  for (int i=N-1;i>0;i--){
    x_trace[i] = x_trace[i-1];
    y_trace[i] = y_trace[i-1];
  }
  
  for (int i=N-1;i>0;i--){
    if ( x_trace[i] > 0 && y_trace[i] > 0){
      stroke(50*(N-i)/N);
      strokeWeight(5);
      line(x_trace[i], y_trace[i], x_trace[i-1], y_trace[i-1]);
    }
  }
  
  stroke(230);
  strokeWeight(10);
  line(x0, y0, x1, y1);
  line(x1, y1, x2, y2);
}
