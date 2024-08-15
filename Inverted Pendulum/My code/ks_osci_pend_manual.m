

% define parameter

g = 9.81;
l=1;

%Amp  = 0.02; %amplitude
%freq = 1.5 ;

Amp = x_solution(1);
freq = x_solution(2);

S = 2*pi*freq;


% Define initial condition
theta=0;

% Initialization
y = [];         % Vector to save states
t = [];         % Vector to save times


y0=[theta; % initial pend angle
    -Amp*S; % initial pend v
    0; % initial floor x position
    Amp*S*cos(0)]; % initial floor x velocity

tspan = [0 ((S/(2*pi))^-1)*20];

% solve ode
[tout,yout] = ode45(@(t,y)f(t,y,Amp,S,g,l),tspan,y0);


ks_oscipend_view(yout,tout,l)
plot(asin(sin(yout(:,1))),yout(:,2))

% define ydot
function ydot=f(t,y,Amp,S,g,l)  
% ODE definition
% y1: theta
% y2: thetadot

% First order differential equations
ydot = [y(2);
        sin(y(1)) * (g/l) + Amp*(S^2)*sin(S*t)*cos(y(1));
        Amp*S*cos(S*t);
        -Amp*(S^2)*sin(S*t)];
end