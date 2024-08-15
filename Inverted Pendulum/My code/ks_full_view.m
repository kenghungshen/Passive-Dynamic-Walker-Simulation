function ks_full_view(y,gam,tci,alfa)

% Leg length
L = 1;

% Position of stance foot
xst = 0;
yst = 0;

% Position of hip
xm = xst+L*sin(y(1,1)+gam);
ym = yst+L*cos(y(1,1)+gam);

% Position of swing foot
st_h_vector = [xst-xm; yst-ym]; % stance foot to hip vector

% behind stance leg
theta = -2*alfa;
ratate_m = [cos(theta) -sin(theta);
    sin(theta) cos(theta)];
sw1 = ratate_m*st_h_vector;
xsw1 = sw1(1,1)+xm;
ysw1 = sw1(2,1)+ym;

% infront of stance leg
theta = 2*alfa;
ratate_m = [cos(theta) -sin(theta);
    sin(theta) cos(theta)];
sw2 = ratate_m*st_h_vector;
xsw2 = sw2(1,1)+xm;
ysw2 = sw2(2,1)+ym;

% Initialize figure for animation
figure('Color','w','Renderer','zbuffer')
axis([-1 7 -1 5])

%axis off
axis on

% Draw first position
slope = yline(0);
set(slope,'Color','k','LineWidth',0.1);
stleg = line([xst xm],[yst ym]);
set(stleg,'Color','b','LineWidth',2);
swleg1 = line([xsw1 xm],[ysw1 ym]);
set(swleg1,'Color','b','LineWidth',2);
swleg2 = line([xsw2 xm],[ysw2 ym]);
set(swleg2,'Color','b','LineWidth',2);

xstold=xst;
drawnow             % Force Matlab to draw

% Animate each stride
for j=1:length(tci)-1
    % On collision switch stance and swing legs
%     if j>1
%         xst = xsw2;
%         yst = ysw2;
%        
%     end
    
    t1 = tci(j)+1;
    t2 = tci(j+1);
    for i=t1:t2
        if mod(i,20)==0 || i==t1 || i==t2           % When to draw
            
            if i==t1
            xstold=y(i,3);
            else
            xstold=xst;
            end
            
            
            xst = y(i,3);
            
            xm = xst+L*sin(y(i,1)+gam);          	% Position of hip
            ym = yst+L*cos(y(i,1)+gam);
            
            st_h_vector = [xst-xm; yst-ym];
            % Position of swing leg
            
            % behind stance leg
                theta = -2*alfa;
                ratate_m = [cos(theta) -sin(theta);
                    sin(theta) cos(theta)];
                sw1 = ratate_m*st_h_vector;
                xsw1 = sw1(1,1)+xm;
                ysw1 = sw1(2,1)+ym;
            % infront of stance leg
                theta = 2*alfa;
                ratate_m = [cos(theta) -sin(theta);
                    sin(theta) cos(theta)];
                sw2 = ratate_m*st_h_vector;
                xsw2 = sw2(1)+xm;
                ysw2 = sw2(2)+ym;
                
            
            
                set([stleg swleg1 swleg2],'Visible','off'); % Clear previous position of legs
            
                stleg = line([xst xm],[yst ym]);                      % Draw new position of stance leg
                swleg1 = line([xsw1 xm],[ysw1 ym]);      	% Draw new position of swing leg
                swleg2 = line([xsw2 xm],[ysw2 ym]);      	% Draw new position of swing leg
                
                set(stleg,'Color','k','LineWidth',2);
                set(swleg1,'Color','b','LineWidth',2);
                set(swleg2,'Color','b','LineWidth',2);
                
                line([xstold xst],[yst yst],'Color','r','LineWidth',2);

            
            drawnow                                	% Force Matlab to draw
        end
    end
end