%% This is the the results function 


% Results structure

RP1.orig.strike.degrees = 87;
RP1.orig.dip_angle.degrees = 89;
RP1.orig.dip_direction.degrees = 177;
RP1.orig.strike.radians = '';
RP1.orig.dip_angle.radians = '';
RP1.orig.dip_direction.radians = '';

RP1.run(1).strike.degrees = 87;
RP1.run(1).dip_angle.degrees = 89;
RP1.run(1).dip_direction.degrees = 177;
RP1.run(1).strike.radians = '';
RP1.run(1).dip_angle.radians = '';
RP1.run(1).dip_direction.radians = '';

z = (sqrt((RP1.orig.strike.degrees - RP1.run(1).strike.degrees)^2) - 0)/(360 - 0);
RP1.run(1).strike.z
z = (sqrt((RP1.orig.dip_angle.degrees - RP1.run(1).dip_angle.degrees)^2) - 0)/(90 - 0);
RP1.run(1).dip_angle.z
z = (sqrt((RP1.orig.dip_direction.degrees - RP1.run(1).dip_direction.degrees)^2) - 0)/(360 - 0);
RP1.run(1).dip_direction.z

RP1.run(2).strike.degrees = 87;
RP1.run(2).dip_angle.degrees = 89;
RP1.run(2).dip_direction.degrees = 177;
RP1.run(2).strike.radians = '';
RP1.run(2).dip_angle.radians = '';
RP1.run(2).dip_direction.radians = '';