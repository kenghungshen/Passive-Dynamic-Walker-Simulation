function cost_fun_y = ks_osci_pend(x)
% define parameter

g = 9.81;
l=1;

%Amp  = 0.01; %amplitude
%freq = 3.31 ;

Amp = x(1);
freq = x(2);
S = 2*pi*freq;


% Define initial condition

%theta=deg2rad(-1);

% Initialization
y = [];         % Vector to save states
t = [];         % Vector to save times

% solve ode
y0=[0; % initial pend angle
    -Amp*S; % initial pend v
    0; % initial floor x position
    Amp*S*cos(0)]; % initial floor x velocity

tspan = [0 ((S/(2*pi))^-1)*0.25];

[tout,yout] = ode45(@(t,y)f(t,y,Amp,S,g,l),tspan,y0);

%cost_fun_y = (yout(end,1))^2;
cost_fun_y = x(2);



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

%ks_oscipend_view(yout,tout,l)
end