function animation(data,profile)
% Function animation animates existing simulation data
% Author: Kaur Aare Saar (kas82@cam.ac.uk), August 2016

if ~exist('profile','var')
	profile=[0 0; 10000 0]; % Use flat ground
end

%% Initiliase plot
cla
plot(profile(:,1),profile(:,2),'k')
title('Animation')
xlabel('Horizontal distance (m)')
ylabel('Vertical distance (m)')
hold on
axisrange0=[0 20 -2 3];
axis equal
p=[];

step=0.04; % step size between frames [s]
time=0;
frameno=1;
tic
for i=1:length(data)
	scrnnumber=floor(data(i).q(1,1)/20);
	axisrange=axisrange0+20*[scrnnumber scrnnumber 0 0];
	
	
	switch data(i).type
		case 'double'
			while true
				if time>data(i).t(end)
					time=time-data(i).t(end);
					break
				end
				xx=interp1(data(i).t,data(i).q(:,1),time);
				yy=interp1(data(i).t,data(i).q(:,2),time);
				
				processtime=toc;
				pause(step-processtime);
				tic
				
				delete(p)
				p=plot([data(i).support(1,1),xx,data(i).support(1,2)],...
					[data(i).support(2,1),yy,data(i).support(2,2)],'b','Linewidth',2);
				axis(axisrange)
				drawnow

				time=time+step;
			end
		case 'single'
			while true
				if time>data(i).t(end)
					time=time-data(i).t(end);
					break
				end
				xx=interp1(data(i).t,data(i).q(:,1),time);
				yy=interp1(data(i).t,data(i).q(:,2),time);

				processtime=toc;
				pause(step-processtime);
				tic
				
				delete(p)
				p=plot([data(i).support(1),xx],...
					[data(i).support(2),yy],'b','Linewidth',2);
				axis(axisrange)
				drawnow

				time=time+step;
			end
		case 'flight'
			while true
				if time>data(i).t(end)
					time=time-data(i).t(end);
					break
				end
				xx=interp1(data(i).t,data(i).q(:,1),time);
				yy=interp1(data(i).t,data(i).q(:,2),time);

				processtime=toc;
				pause(step-processtime);
				tic
				
				delete(p)
				p=plot([xx xx+0.02 xx xx-0.02 xx],[yy+0.02 yy yy-0.02 yy yy+0.02],'b','Linewidth',2);
				axis(axisrange)
				drawnow

				time=time+step;
			end
	end
	
end
end

