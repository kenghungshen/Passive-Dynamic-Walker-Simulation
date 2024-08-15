function ks_oscipend_view(y,t,l)

% Leg length
L = l;

% Position of base
xst = y(1,3);
yst = 0;

% Position of pend tip
xm = xst+L*sin(y(1,1));
ym = yst+L*cos(y(1,1));


% Initialize figure for animation
figure('Color','w','Renderer','zbuffer')
axis([-1.5 1.5 -0.5 1.5])

%axis off
axis on

% Draw first position
slope = yline(0);
set(slope,'Color','k','LineWidth',0.1);
stleg = line([xst xm],[yst ym]);
set(stleg,'Color','b','LineWidth',2);

xstold=xst;
drawnow             % Force Matlab to draw

% Animate each stride
for i=1:length(t)

            xstold=xst;
            
            xst = y(i,3);
            
            xm = xst+L*sin(y(i,1));          	% Position of hip
            ym = yst+L*cos(y(i,1));
            
            
            
                set([stleg],'Visible','off'); % Clear previous position of legs
            
                stleg = line([xst xm],[yst ym]);                      % Draw new position of stance leg

                
                set(stleg,'Color','k','LineWidth',2);
                
                line([xstold xst],[yst yst],'Color','r','LineWidth',2);

            
            drawnow                                	% Force Matlab to draw
        end
end