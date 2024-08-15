function slope_rimless(gam,steps)

% Gamma: angle of slope (radians), used by integration function
if nargin < 1
    gam = 0.3;
end

% Integration time parameters
if nargin < 2
    steps = 50;  % Number of steps to simulate
end
per = 5;        % Max number of seconds allowed per step

n = 6; % spoke number
alfa = ((2*pi)/n)/2;
g=9.81;

% Calculate stable ICs from theoretically determined equations

y0 = [-1*alfa;
       sqrt(2*g*(1-cos(gam-alfa))+1e2)
        ];
    
% Initialization
y = y0.';     	% Vector to save states
t = 0;          % Vector to save times
tci = 0;        % Collision index vector
h = [0 1e-10 per];    % Integration period in seconds

% Set integration tolerances, turn on collision detection, add more output points
opts = odeset('RelTol',1e-4,'AbsTol',1e-8,'Refine',30,'Events',@collision);

% Loop to perform integration of a noncontinuous function
for i=1:steps
   [tout,yout] = ode45(@(t,y)f(t,y,gam),h,y0,opts); % Integrate for one stride
   y = [y;yout(2:end,:)];                        % Append states to state vector
   t = [t;tout(2:end)];                          	% Append times to time vector
   
   % Calculate once for new ICs

   y0 = [-1*alfa;
         y(end,2)*cos(2*alfa);
         ];                 	% Mapping to calculate new ICs after collision
     
   tci = [tci length(t)];                          	% Append collision index to collision index vector
   h = t(end)+[0 per];                           % New integration period 

end
whos

% Run model animation
slope_rim_view(y,gam,tci,alfa)

%  figure(101)
%  plot(y(:,1))
%  figure(102)
%  plot(y(:,2))
% figure(103)
% plot(tci)
figure(3)
  plot(y(:,1),y(:,2))
  xlabel ('theta')
  ylabel('thetadot')


function ydot=f(t,y,gam)    
% ODE definition
% y1: theta
% y2: thetadot
% gam: slope of incline (radians)

g=9.81;
% First order differential equations for Simplest Walking Model
ydot = [y(2);
        g*sin(y(1)+gam);
        ];


function [val,ist,dir]=collision(t,y)  
% Check for heelstrike collision using zero-crossing detection
n = 6;
alfa = ((2*pi)/n)/2;

val = y(1)-alfa;  % Geometric collision condition, when = 0
ist = 1;            % Stop integrating if collision found
dir = 1;            % Condition only true when passing from - to +