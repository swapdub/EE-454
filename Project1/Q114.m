clear
clc

x1 = 10;
y1 = 10;
theta1 = atan(y1/x1);

x2 = 20;
y2 = 20;
theta2 = atan(y2/x2);

x3 = 30;
y3 = 30;
theta3 = atan(y3/x3);
theta = 0:0.1:2*    pi;

r1 = x1*cos(theta1) + y1*sin(theta1);
H1 = sin(theta + theta1);

r2 = x2*cos(theta2) + y2*sin(theta2);
H2 = sin(theta + theta2);

r3 = x3*cos(theta3) + y3*sin(theta3);
H3 = sin(theta + theta3);

hold on

plot(H1);
plot(H2);
plot(H3);

hold off