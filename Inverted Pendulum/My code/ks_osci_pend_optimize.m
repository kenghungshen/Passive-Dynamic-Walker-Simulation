clear
clc


%%
% Create the FMINCON options structure.
options = optimoptions('fmincon','Display','notify-detailed', ...
     'TolCon',1e-4,'TolFun',1e-12,'TolX',1e-8,'MaxFunEvals',100000, ...
     'MaxIter',50000,'Algorithm','interior-point');%,"EnableFeasibilityMode",true);


% Construct initial guess and bounds arrays here {
    
    x_initial = [0.02, 1]; % amplitude & freq
    
    lb = [0.02, 0.5] ; % lower bound 
    ub = [0.02, 200] ;  % upper bound    

% Construct inputs to FMINCON
    A = [] ;
    b = [] ;
    Aeq = [] ;
    beq = [] ;

    nonLinCon = @(x) ks_osci_pend_constraint(x);

% Call FMINCON to solve the problem

    x_solution = fmincon(@ks_osci_pend,x_initial,A,b,Aeq,beq,lb,ub,nonLinCon,options)
    
%%
    
    %ks_osci_pend(x_solution)