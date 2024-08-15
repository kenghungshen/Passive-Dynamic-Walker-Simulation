%%%%
% SLIP model parameters optimisation using Gaussian Processes and Bayesian
% Optimisation
% Author: Kaur Aare Saar (kas82@cam.ac.uk), August 2016
%%%%

%% Tabula Rasa
clear; close all; clc

%% Define filename for saving optimisation results
datafiles=dir('data/*.mat');
if isempty(datafiles)
	lastnumber=0;
else
	lastnumber=str2double(datafiles(end).name(9:11)); % last existing file number in data directory
end
matfilename=['data/BO_data_',num2str(lastnumber+1,'%03.f'),'.mat'];
	
%% Set Initial Conditions and Search Ranges
% Vector InitialConditions defines the initial state as [x y x' y']
% Normally x=y'=0

InitialConditions=[0	0.98	1.3	0]; % walking
%InitialConditions=[0	0.95	1.6	0]; % skipping
%InitialConditions=[0	0.95	5	0]; % running
% InitialConditions=[0 0.9 1.5 0];


% Matrix searchrange defines minimum and maximum values for each parameter in
% which to seach for best performance
searchrange=[	
	45		89;		% touchdown angle when running (deg)
	45		89;		% touchdown angle when walking (deg)
	1000	50000;	% spring constant (N/m)
	];
names=[
	'Touchdown angle when running (deg): ';
	'Touchdown angle when walking (deg): ';
	'Spring stiffness (N/m):             ';
	];
labels={
	' \alpha_1 ( ^\circ )';
	' \alpha_2 ( ^\circ )';
	' k ( N / m )';
	};
parameter_count=size(searchrange,1);

%% Performance assessment and optimisation parameters
disturbance=0.01;			% Relative amplitude of Gaussian noise added to initial conditions
totaltests=30;				% Number of tests to average over for each parameter set
maxtime=500;				% Maximum time for simulation (s)
fitnessfunction='Distance';	% Fitness function to use as objective function 'Time', 'Steps' or 'Distance'
maxexpectedfitness=maxtime*InitialConditions(3);

profile=[0 0; 1000 0];		% Flat ground of length 1000 (m)
N=5;						% Number of iterations to run the optimisation for
KernelMode='ARDMatern32';				% Allow more rapid changes in the objective function
%KernelMode='ARDSquaredExponential';	% Force the objective function to be smoother


%% Choose random sample for first evaluation
x=((searchrange(:,2)-searchrange(:,1)).*rand(size(searchrange,1),1)+searchrange(:,1))'; % random initial guess within search range (KS_note)
y=[];


%% Iterate
for sample_no = length(y)+1:N
	% Evaluate function at
	parameters = x(end,:);
	disp(['Evaluation number ',num2str(sample_no)]);
	disp('    Parameters:');
	disp([repmat(' ',parameter_count,8),names,num2str(parameters','%-.3g')]);
	
	for test_no=1:totaltests
		ICwithdisturbance=InitialConditions+disturbance*InitialConditions.*randn(1,4); % add disturbance to initial conditions
		[~,performance(test_no)]=SLIP_model([ICwithdisturbance, parameters],profile,maxtime); %#ok<SAGROW> 
	end
 	disp(['    Average performance over ',num2str(totaltests),' tests:'])
 	disp(['        ','Distance:         ',num2str(mean([performance.Distance]),'%.3g'),' ± ',num2str(std([performance.Distance]),'%.3g'), ' (m)'])
 	disp(['        ','Time:             ',num2str(mean([performance.Time    ]),'%.3g'),' ± ',num2str(std([performance.Time    ]),'%.3g'), ' (s)'])
 	disp(['        ','Steps:            ',num2str(mean([performance.Steps   ]),'%.3g'),' ± ',num2str(std([performance.Steps   ]),'%.3g')])
 	fitness=mean([performance.(fitnessfunction)]); % Use the mean of the fitnesses over all tests for given parameters
	
	y = [y; fitness]; %#ok<AGROW>
	save(matfilename);
	
 	% Update GP
 	if sample_no==N; break; end
 	disp('    Updating Gaussian process')
 	gp=fitrgp(x,y,'KernelFunction',KernelMode); % introduced in MATLAB 2015b 
 	
  	% Find new sampling point
  	xNew = getNextSample(gp,searchrange,y,x,maxexpectedfitness);
  	x = [x; xNew]; %#ok<AGROW>
end