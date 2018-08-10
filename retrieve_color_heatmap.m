function x = retrieve_color_heatmap
% This function constructs the color_heat_map

c(1,:) =    [0.0417         0         0]; % Black
c(2,:) =    [1.0000         0         0]; % Red 
c(3,:) =    [1.0000      0.53         0]; % Orange
c(4,:) =    [1.0000    1.0000         0]; % Yellow
c(5,:) =    [0.47       0.67       0.19]; % Green

l      =    [1,15,25,40,64];
x      =    [];
for i = 1:3
    y = [];
    for j = 1:length(l)-1
        vec_or = [l(j),l(j+1)-1];
        vec_de = [l(j):l(j+1)-1];
        vec_val= [c(j,i),c(j+1,i)];
        int = interp1(vec_or,vec_val,vec_de);
        y = [y int];
    end
    x(:,i) = y;
end
x       = [x;c(end,:)];   
end
