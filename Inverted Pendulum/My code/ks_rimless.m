function ks_rimless(steps)

steps = 10;  % Number of steps to simulate
per = 50 ; % time span for max step duration
gam=0;

global s l alfa beta g acc

s = 0.5; % step length
l = 1; % length = 1m
alfa = asin(0.5*s*(l^-1)); % angle between spokes
g = 9.81;
beta = alfa/1.5; 
acc = 5;

% Initialization
y = [];     	% Vector to save states
t = [];         % Vector to save times
tci = 0;        % Collision index vector
h = [0 per];    % Integration period in seconds (tspan)

col_loss = [];

ini_ang_spd = sqrt(2*g*(l^-1)*(cos(0)-cos(alfa)));
   
y0=[-alfa;
    ini_ang_spd;
    0;
    0];

% Set integration tolerances, turn on collision detection, add more output points
opts = odeset('RelTol',1e-4,'AbsTol',1e-8,'Refine',30,'Events',@collision);

% Loop to perform integration of a noncontinuous function
for i=1:steps
   [tout,yout] = ode45(@(t,y)f(t,y),h,y0,opts); % Integrate for one stride
   y = [y;yout(2:end,:)];                       % Append states to state vector
   t = [t;tout(2:end)];                         % Append times to time vector

   % Calculate once for new ICs
   y0 = [-alfa;
         y(end,2)*cos(2*alfa);
         y(end,3)+s
         y(end,4)
         ];                 	% Mapping to calculate new ICs after collision
   tci = [tci length(t)];                      % Append collision index to collision index vector
   h = t(end)+[0 per];                         % New integration period 
   col_loss = [col_loss y(end,2)*(1-cos(2*alfa))];
end

  plt=4;
  figure(1)
  subplot(plt,1,1)
  plot(t,y(:,1))
  title('angle')

  subplot(plt,1,2)
  plot(t,y(:,2))
  title('angular v')

  subplot(plt,1,3)
  plot(t,y(:,3))
  avg_spd = (y(end,3)- y(1,3)) / t(end);
  
  text(t(end)-1,y(length(y)/2,3),{'initial speed = ',num2str(ini_ang_spd),'m/s'})
  text(t(end)-1,y(1,3),{'average speed = ',num2str(avg_spd),'m/s'})
  title('foot location')
  
  subplot(plt,1,4)
  plot(t,y(:,4))
  title('foot velocity')
  % 
%   figure(2)
%   plot(diff(y(:,4)))

  figure(3)
  plot(y(:,1),y(:,2))
  title('Phase plot')
  xlabel ('\theta')
  ylabel('d\theta / dt')

  figure(4)
  scatter([1:length(col_loss)],col_loss,25,'filled')
  title('Collision Loss in each step')
  xlabel('step#')

%  
%  figure(6)
%  plot(h)

% Run model animation: mview.m
ks_full_view(y,gam,tci,alfa)

end

function ydot=f(t,y)    

global  l beta g acc

% ODE definition
% y1: theta
% y2: thetadot
% y3: x (foot position)
% y4: xdot
ctrl = 'angle';
%ctrl = 'velocity';

 if strcmp(ctrl,'angle')
     if y(1) <0 && abs(y(1))> beta
         a=acc;
     elseif abs(y(1))< beta && y(4)<0 %y(1)>0 && y(4)<0
         a=-1*acc;
     else
         a=0;
     end
 
 elseif strcmp(ctrl,'velocity')
    if y(1) <0 && y(2)<sqrt(2*g*(l^-1)*(cos(0)-cos(y(1))))+0.1
        a= -g*tan(y(1));
    elseif y(4)<0 && y(2)>sqrt(2*g*(l^-1)*(cos(0)-cos(y(1))))+0.2
        a=-1*acc;
    else
        a=0;
    end
end

ydot = [y(2);
        g*(l^-1)*sin(y(1))+a*(l^-1)*cos(y(1));
        y(4);
        -a
        ];

end

function [val,ist,dir]=collision(t,y)   %#ok<INUSL>
% Check for heelstrike collision using zero-crossing detection
global alfa 
val = y(1)-alfa;  % Geometric collision condition, when = 0
ist = 1;            % Stop integrating if collision found
dir = 1;            % Condition only true when passing from - to +
end
