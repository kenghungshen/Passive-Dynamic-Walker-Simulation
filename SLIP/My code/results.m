function [x,y]=results(DatasetNumber)
% Function to visualise Bayesian Optimisation for parameters
% Author: Kaur Aare Saar (kas82@cam.ac.uk), August 2016

close all;

%% Load dataset, if missing use the last one
if exist('DatasetNumber','var')==0
	datafiles=dir('data/*.mat');
	lastfile=datafiles(end).name;
	DatasetNumber=str2double(lastfile(9:11));
end
load(['data/BO_data_',num2str(DatasetNumber,'%03.f')])

previousvalues=[-1,0]; % Arbitrary point outside plot for initialisation

%% Parameters colormap
figure(1);
set(gcf, 'Position', get(0, 'Screensize')+[0 0 0 -80]) % Set figure to be full screen
axesParameters=subplot(3,4,1:3);
hold on;
xlabel('Bayesian Optimisation Trial number')
title('Parameters Colormap')
axesParameters.YTick=[];
axesParameters.YLim=[0.5,size(searchrange,1)+0.5]; %#ok<NODEF> 
isc=[];
text(axesParameters,ones(1,length(labels))-0.5,length(labels):-1:1,labels,...
	'VerticalAlignment','middle','HorizontalAlignment','Right');

%% Colormap legend
axesColormap=subplot(3,4,4);
axis off
c=colorbar('north');
c.Position=axesColormap.Position+[axesColormap.Position(3)/4 0 -axesColormap.Position(3)/2 0];
c.Ticks=[];
text(0.24*ones(1,length(labels)),linspace(1-1/length(labels)/2,1/length(labels)/2,length(labels)),num2str(searchrange(:,1)),...
	'HorizontalAlignment','right','VerticalAlignment','middle');
text(0.75*ones(1,length(labels)),linspace(1-1/length(labels)/2,1/length(labels)/2,length(labels)),num2str(searchrange(:,2)),...
	'HorizontalAlignment','left ','VerticalAlignment','middle');
title('Parameters Colormap Legend')

%% Plot for choosing next parameters
axesChoose=subplot(3,4,9:11);
title('Choose next animation parameters')
axis([0.5 length(y)+0.5 -5 5])
xlabel('Bayesian Optimisation Trial number')
ylabel({'Disturbance added on'; 'initial horizontal velocity (%)'})
hold on; box on;
plot(axesChoose,[1 1000],[0 0],'k-');
previous=plot(0,0,'r+','visible','off');
current=plot(0,0,'b+','visible','off');
legend1=legend([current,previous],'Current animation','Previous animations');
set(legend1,'color','none');
subplot(3,4,12);cla;axis off;
text(0,0.5,'Choose parameter set on the plot on the left'); drawnow


while true
	load(['data/BO_data_',num2str(DatasetNumber,'%03.f')])
	%% Update Colormap for parameters over optimisation
	figure(1);
	delete(isc);
	isc=imagesc(axesParameters,flipud((x'-repmat(searchrange(:,1),1,length(y)))./ ...
		(repmat(searchrange(:,2)-searchrange(:,1),1,length(y)))));
	axesParameters.XLim=[0.5 length(y)+0.5];
	
	%% Update Fitness function
	subplot(3,4,5:7)
	plot(y,'-bo')
	axis([0.5 length(y)+0.5 0 inf])
	ylabel('Fitness function')
	xlabel('Bayesian Optimisation Trial number')
	title('Fitness function')
	
	%% Update Plot for choosing next parameters
	axesChoose.XLim=[0.5 length(y)+0.5];
	[X,Y]=ginput(1);
	X=round(X,0);
	if (X<1 || X>length(y) || Y>5 || Y<-5)
		subplot(3,4,12);axis off;cla
		text(0,1,'Chosen parameters out of range, choose again.');
		continue
	end
	selectedtrialno=X;
	selecteddisturbance=Y;
	delete(current);
	previous=plot(previousvalues(end,1),previousvalues(end,2),'r+');
	current=plot(selectedtrialno,selecteddisturbance,'b+');
	legend([current,previous],'Current animation','Previous animations');
	previousvalues=[selectedtrialno,selecteddisturbance];
	drawnow limitrate;
	
	%% Update phaseplot and animation
	animationprofile=[0 0;100 0];
	clear data
	InitialConditions(2)=InitialConditions(2)*(1+selecteddisturbance/100);
	[data]=SLIP_model([InitialConditions,x(selectedtrialno,:)],animationprofile,10);
	
	subplot(3,4,12); cla; axis off;
	text(0,0.5,'Processing, animation starting soon...'); drawnow
	
	figure(2);
	subplot(2,1,1)
	phaseplot(data);
	subplot(2,1,2);
	animation(data,animationprofile);
	figure(1)
	subplot(3,4,12); axis off; cla;
	text(0,0.5,'Choose next parameter set'); drawnow

end
end