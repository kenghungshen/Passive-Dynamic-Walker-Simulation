clear 
clc

%Vector InitialConditions defines the initial state as [x y x' y']
InitialConditions=[0	0.98	1.5	0]; 

% searchrange=[	
% 	45		89;		% touchdown angle when running (deg)
% 	45		89;		% touchdown angle when walking (deg)
% 	1000	50000;	% spring constant (N/m)
% 	];
names=[
	'Touchdown angle when running (deg): ';
	'Touchdown angle when walking (deg): ';
	'Spring stiffness (N/m):             ';
	];
% x=((searchrange(:,2)-searchrange(:,1)).*rand(size(searchrange,1),1)+searchrange(:,1))';

parameters = [70 70 70];

maxtime=100;				% Maximum time for simulation (s)
profile=[0 0; 100 0]; % Flat ground of length 100 (m)
fitnessfunction='Distance';
	
[data,performance]=SLIP_model([InitialConditions, parameters],profile,maxtime);
disp(['        ','Distance:         ',num2str(mean([performance.Distance]),'%.3g'),' ± ',num2str(std([performance.Distance]),'%.3g'), ' (m)'])
disp(['        ','Time:             ',num2str(mean([performance.Time    ]),'%.3g'),' ± ',num2str(std([performance.Time    ]),'%.3g'), ' (s)'])
disp(['        ','Steps:            ',num2str(mean([performance.Steps   ]),'%.3g'),' ± ',num2str(std([performance.Steps   ]),'%.3g')])
disp(['        ','Termination Cause:            ',performance.terminationmsg])

fitness=mean([performance.(fitnessfunction)]); % Use the mean of the fitnesses over all tests for given parameters
animation(data,profile);