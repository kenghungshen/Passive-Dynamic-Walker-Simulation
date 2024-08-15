function ks_view(y,tci)

% Leg length
L = 4;

% Position of stance foot
xst = 0;
yst = 0;

% Position of tip
xm = xst+L*cos(y(1,1));
ym = yst+L*sin(y(1,1));


% Initialize figure for animation
figure('Color','w','Renderer','zbuffer')
axis([-5 5 -5 5])
axis off
strobePlot = 0;   % Draw stroboscopic plot: 1
tracePlot = 0;    % Trace path of hip and swing foot: 1 or 2

% Draw first position

stleg = line([xst xm],[yst ym]);
set(stleg,'Color','k','LineStyle','-');

 if tracePlot==1
%     % Plot position of hip and swing foot
     line([xm],[ym],...
          'Color','k','LineStyle','none','Marker','.','MarkerSize',1);
 end
drawnow             % Force Matlab to draw
 
 flipStride = 1;     % Flag for swing-stance flip


% Animate each stride
for j=1:length(tci)-1
    % On collision switch stance and swing legs
    if j>1
        flipStride = -flipStride;
        if strobePlot==1
            set([stleg],'Visible','off');
        end
    end
    
    t1 = tci(j)+1;
    t2 = tci(j+1);
    for i=t1:t2
        if mod(i,20)==0 || i==t1 || i==t2           % When to draw
            xmold = xm;
            ymold = ym;
            xm = xst+L*sin(y(i,1));          	% Position of hip
            ym = yst+L*cos(y(i,1));
            
            if tracePlot>1
                line([xmold xm],[ymold ym],'Color',[0.5 0.5 0.5]);
            end
            

            if strobePlot~=1
                set([stleg],'Visible','off'); % Clear previous position of legs
            else
                cc = 1-(i-t1)/(t2-t1);           	% Scale leg colors for stroboscopic plot
                set([stleg],'Color',[cc cc cc]);
            end
            
            stleg = line([xst xm],[yst ym]);     	% Draw new position of stance leg
%            swleg = line([xsw xm],[ysw ym]);      	% Draw new position of swing leg
            if flipStride==-1
                set(stleg,'Color','b','LineWidth',2);
            
            else
                set(stleg,'Color','k','LineStyle','-');
            end
            if tracePlot==1
                % Trace path of hip and swing foot
                line([xm],[ym],...
                     'Color','k','LineStyle','none','Marker','.','MarkerSize',1);
            end
            drawnow                                	% Force Matlab to draw
        end
    end
end