function phaseplot( data )
% function phaseplot plots phaseplot of exisiting simulation data
% Ground height of the robot vs. direction of the velocity vector

% Author: Kaur Aare Saar (kas82@cam.ac.uk), August 2016


cla
hold on
for i=1:length(data)
	if data(i).type=='flight'
		plot(data(i).q(:,2),atand(data(i).q(:,4)./data(i).q(:,3)),'g')
	elseif data(i).type=='single'
		plot(data(i).q(:,2),atand(data(i).q(:,4)./data(i).q(:,3)),'r')
	elseif data(i).type=='double'
		plot(data(i).q(:,2),atand(data(i).q(:,4)./data(i).q(:,3)),'b')
	end
	ylabel('Direction of velocity vector (deg)')
	xlabel('Ground height of point mass (m)')
	h = zeros(3,1);
	h(1) = plot(1,0,'g');
	h(2) = plot(1,0,'r');
	h(3) = plot(1,0,'b');
	legend1=legend(h, 'Flight','Single','Double');
	title('Phase plot')

end

