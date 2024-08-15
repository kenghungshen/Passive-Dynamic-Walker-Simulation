function full_ks(gam,steps)

% Gamma: angle of slope (radians), used by integration function
if nargin < 1
    gam = 0;
end

% Integration time parameters
if nargin < 2
    steps = 18;  % Number of steps to simulate
end
per = 5;        % Max number of seconds allowed per step


% Initial desired step length
s = 0.4;

% IC constants
l=1; % length
alpha = asin(0.5*s/l);

g=9.81;

    
% Initialization
y = [];     	% Vector to save states
t = [];          % Vector to save times
tci = 0;        % Collision index vector
h = [0 per];    % Integration period in seconds

y0=[-1*alpha;
    sqrt(2*g/l*(1-cos(alpha)))];
% Set integration tolerances, turn on collision detection, add more output points
opts = odeset('RelTol',1e-4,'AbsTol',1e-8,'Refine',30,'Events',@collision);

% Loop to perform integration of a noncontinuous function
for i=1:steps
   [tout,yout] = ode45(@(t,y)f(t,y,gam),h,y0,opts); % Integrate for one stride
   y = [y;yout(2:end,:)];                        	%#ok<AGROW> % Append states to state vector
   t = [t;tout(2:end)];                          	%#ok<AGROW> % Append times to time vector
   c2y1 = cos(2*y(end,1));                         	% Calculate once for new ICs
   y0 = [-y(end,1);
         c2y1*y(end,2)
         ];                 	% Mapping to calculate new ICs after collision
   tci = [tci length(t)];                          	%#ok<AGROW> % Append collision index to collision index vector
   h = t(end)+[0 per];                              % New integration period 
end
whos
% % Graph collision map
% figure(1)
% plot(t,y(:,3)-2*y(:,1))
% grid on
% xlabel('time ( sqrt(l/g) )')
% ylabel('\phi(t)-2\theta(t) (rad.)')
% 
% % Graph angular positions - the stride function
% figure(2)
% hold on
% plot(t,y(:,1),'r',t,y(:,3),'b--')
% grid on
% title('Stride Function')
% xlabel('time ( sqrt(l/g) )')
% ylabel('\phi(t), \theta(t) (rad.)')
% 
% % Graph angular velocities
% figure(3)
% hold on
% plot(t,y(:,2),'r',t,y(:,4),'b--')
% grid on
% title('Angular Velocities')
% xlabel('time ( sqrt(l/g) )')
% ylabel('\phi^.(t), \theta^.(t) (rad./sqrt(l/g))')
% 
% % Phase plot of phi versus theta
% figure(4)
% plot(y(:,1),y(:,3))
% grid on
% title('Phase Portrait')
% xlabel('\theta(t) (rad.)')
% ylabel('\phi(t) (rad.)')
% 
% % Plot Hamiltonian
% H = 0.5*y(:,2).*y(:,2)+cos(y(:,1)-gam);
% figure(5)
% plot(t,H-H(1))
% grid on
% title('Hamiltonian - Total Energy of System')
% xlabel('time ( sqrt(l/g) )')
% ylabel('Hamiltonian: H(t)-H(0)')

% Run model animation: mview.m
ks_full_view(y,gam,tci)



function ydot=f(t,y,gam)    %#ok<INUSL>
% ODE definition
% y1: theta
% y2: thetadot

g=9.81;
l=1;
gl = g/l;

% First order differential equations for Simplest Walking Model
ydot = [y(2);
        gl*sin(y(1))
        ];

% ydot = [y(2);
%         gl*sin(y(1))+a*cos(y(1)/l)
%         ];


function [val,ist,dir]=collision(t,y)   %#ok<INUSL>
% Check for heelstrike collision using zero-crossing detection

val = 0.2014+y(1);  % Geometric collision condition, when = 0
ist = 1;            % Stop integrating if collision found
dir = -1;            % Condition only true when passing from + to -