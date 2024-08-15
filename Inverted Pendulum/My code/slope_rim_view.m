function slope_rim_view(y,gam,tci,alfa)

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

% behind of stance leg
theta = -4*alfa;
ratate_m = [cos(theta) -sin(theta);
    sin(theta) cos(theta)];
sw3 = ratate_m*st_h_vector;
xsw3 = sw3(1,1)+xm;
ysw3 = sw3(2,1)+ym;

% infront of stance leg
theta = 4*alfa;
ratate_m = [cos(theta) -sin(theta);
    sin(theta) cos(theta)];
sw4 = ratate_m*st_h_vector;
xsw4 = sw4(1,1)+xm;
ysw4 = sw4(2,1)+ym;

% infront of stance leg
theta = 6*alfa;
ratate_m = [cos(theta) -sin(theta);
    sin(theta) cos(theta)];
sw5 = ratate_m*st_h_vector;
xsw5 = sw5(1,1)+xm;
ysw5 = sw5(2,1)+ym;

% Initialize figure for animation
figure('Color','w','Renderer','zbuffer')
axis([xsw1 50 (xsw1-50)*tan(gam) 1])

%axis off
axis on

% Draw first position
slope = line([xsw1 100],[ysw1 (xsw1-100)*tan(gam)]);
set(slope,'Color','k','LineWidth',0.1);
stleg = line([xst xm],[yst ym]);
set(stleg,'Color','b','LineWidth',2);
swleg1 = line([xsw1 xm],[ysw1 ym]);
set(swleg1,'Color','b','LineWidth',2);
swleg2 = line([xsw2 xm],[ysw2 ym]);
set(swleg2,'Color','b','LineWidth',2);
swleg3 = line([xsw3 xm],[ysw3 ym]);
set(swleg3,'Color','b','LineWidth',2);
swleg4 = line([xsw4 xm],[ysw4 ym]);
set(swleg4,'Color','b','LineWidth',2);
swleg5 = line([xsw5 xm],[ysw5 ym]);
set(swleg5,'Color','b','LineWidth',2);

drawnow             % Force Matlab to draw

% Animate each stride
for j=1:length(tci)-1
    % On collision switch stance and swing legs
    if j>1
        xst = xsw2;
        yst = ysw2;
       
    end
    
    t1 = tci(j)+1;
    t2 = tci(j+1);
    for i=t1:t2
        if mod(i,20)==0 || i==t1 || i==t2           % When to draw
            
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
                
            % behind stance leg
                theta = -4*alfa;
                ratate_m = [cos(theta) -sin(theta);
                    sin(theta) cos(theta)];
                sw3 = ratate_m*st_h_vector;
                xsw3 = sw3(1,1)+xm;
                ysw3 = sw3(2,1)+ym;
            % infront of stance leg
                theta = 4*alfa;
                ratate_m = [cos(theta) -sin(theta);
                    sin(theta) cos(theta)];
                sw4 = ratate_m*st_h_vector;
                xsw4 = sw4(1)+xm;
                ysw4 = sw4(2)+ym;
                
                % infront of stance leg
                theta = 6*alfa;
                ratate_m = [cos(theta) -sin(theta);
                    sin(theta) cos(theta)];
                sw5 = ratate_m*st_h_vector;
                xsw5 = sw5(1)+xm;
                ysw5 = sw5(2)+ym;
            
                set([stleg swleg1 swleg2 swleg3 swleg4 swleg5],'Visible','off'); % Clear previous position of legs
            
                stleg = line([xst xm],[yst ym]);                      % Draw new position of stance leg
                swleg1 = line([xsw1 xm],[ysw1 ym]);      	% Draw new position of swing leg
                swleg2 = line([xsw2 xm],[ysw2 ym]);      	% Draw new position of swing leg
                swleg3 = line([xsw3 xm],[ysw3 ym]);      	% Draw new position of swing leg
                swleg4 = line([xsw4 xm],[ysw4 ym]);      	% Draw new position of swing leg
                swleg5 = line([xsw5 xm],[ysw5 ym]);      	% Draw new position of swing leg
                
                set(stleg,'Color','b','LineWidth',2);
                set(swleg1,'Color','b','LineWidth',2);
                set(swleg2,'Color','b','LineWidth',2);
                set(swleg3,'Color','b','LineWidth',2);
                set(swleg4,'Color','b','LineWidth',2);
                set(swleg5,'Color','b','LineWidth',2);

            
            drawnow                                	% Force Matlab to draw
        end
    end
end