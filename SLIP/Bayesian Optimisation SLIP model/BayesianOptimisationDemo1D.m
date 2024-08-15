% Simple 1D Bayesian Optimisation Demonstration.
% Author: Kaur Aare Saar (kas82@cam.ac.uk), August 2016

%% Tabula rasa
clear
clf

%% Define Objective Function
xlimits=[0 10]; % Argument range of the function to optimise
x=linspace(xlimits(1),xlimits(2),10000)';
y=x.*sin(x)+10*sin(2*x); % Function to optimise
noiselevel=0.1; % Gaussian noise added to each sampling

%% Choose Optimisation parameters
%kernel='matern32';				% Fitting is more rough, allows rapid changes
kernel='squaredexponential';	% Fitting is more smooth,
ee=10; % Trade-off coefficient of exploration/exploitation. Use higher values for more exploration.

%% Define starting data
xtest=[]; % Test data arguments, initially empty
ytest=[]; % Test data values, initially empty
idx=randi([1 length(x)]); % Start with random point

%% Run optimisation loop
while true
	xtest=[xtest; x(idx)]; %#ok<AGROW>
	ytest=[ytest; interp1(x,y,xtest(end)) + randn(1)*noiselevel]; %#ok<AGROW>
	
	% Update Gaussian Process
	gp=fitrgp(xtest,ytest,'kernelfunction',kernel,'KernelParameters',[(max(x)-min(x))/length(x) noiselevel]);
	[ymean,ysd,y95range]=predict(gp,x);
	
	% Evaluate Acquisition function
	%epsilon=max(ytest)+30*exp(-length(ytest)/ee); % Max value is unknown to optimiser, use cooling schedule with exploration/exploitation trade-off coefficient
	epsilon=max(y); % Max value of function is known to optimiser
	z=(ymean-epsilon)./ysd;
	P=1/2*(1+erf(z/sqrt(2)));
	[maxz,idx]=max(z);

	clf
	% Plot objective function along with test data
	subplot(2,1,1)
	hold on
	fill([x;flipud(x)],[y95range(:,1);flipud(y95range(:,2))],[0.5 0.5 1])
	plot(x,y,'r-','linewidth',2)
	plot(xtest,ytest,'go','markerfacecolor',[0 1 0])
	plot(xlimits,epsilon*ones(2,1),'--k')
	legend('Estimated 2\sigma value range based on test data','True function','Points at which function is sampled','Threshold for acquisition function','Location','northoutside')
	xlabel('x')
	ylabel('Objective function')
	
	% Plot Acquistion function
	subplot(2,1,2)
	semilogy(x,P)
	hold on
	semilogy(x(idx),max(5.55e-17,1/2*(1+erf(maxz/sqrt(2)))),'o','markerfacecolor',[1 0 0])
	legend('Probability that function is over threshold','Next sampling point','Location','northoutside')
	axis([xlimits 5.55e-17 1]);
	xlabel('x')
	ylabel('Acquistion function')	
	
	k=waitforbuttonpress;
	if ~k; continue; end
end
