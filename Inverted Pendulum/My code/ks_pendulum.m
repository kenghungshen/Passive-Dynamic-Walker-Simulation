function ks_pendulum(steps)

%if nargin < 1
    steps = 8; % reset after collision
%end

theta=0.01;
per=10; % max time per iteration

% Initialization
y = [];         % Vector to save states
t = [];         % Vector to save times
tci = 0;        % Collision index vector
h = [0 per];	% Integration period in seconds

% IC
y0=[theta;
    0];

% Set integration tolerances, turn on collision detection, add more output points
opts = odeset('RelTol',1e-4,'AbsTol',1e-8,'Refine',30,'Events',@collision);

% Loop to perform integration of a noncontinuous function
for i=1:steps
   [tout,yout] = ode45(@(t,y)f(t,y),h,y0,opts);   % Integrate for one stride
   y = [y;yout];                                        %#ok<AGROW> % Append states to state vector
   t = [t;tout];                                        %#ok<AGROW> % Append times to time vector
   
   tci = [tci length(t)];                               %#ok<AGROW> % Append collision index to collision index vector
   h = t(end)+[0 per];                                  % New integration period 
end


% Run model animation
ks_view(y,tci)



function ydot=f(t,y)  %#ok<INUSL>
% ODE definition
% y1: theta
% y2: thetadot

g = 9.81;
l=4;


% First order differential equations
ydot = [y(2);
        g*sin(y(1))/l];


function [val,ist,dir]=collision(t,y)   %#ok<INUSL>
% Check for heelstrike collision using zero-crossing detection

val = cos(y(1));    	% Geometric collision condition, when = 0
ist = 1;				% Stop integrating if collision found
dir = -1;				% Condition only true when passing from - to +