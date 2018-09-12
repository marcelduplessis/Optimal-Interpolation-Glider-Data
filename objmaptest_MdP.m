%test objective mapping function

addpath(genpath('/Users/Marcel/Downloads/datafun'));
addpath(genpath('/Users/Marcel/Downloads/variogram'));

load('/Users/Marcel/Downloads/test_file.mat');

ind = ~isnan(temp);

temp = temp(ind);
time = time(ind);
depth = depth(ind);

%define uniform grid (0.1 days,10 m)
TI=(time(1):0.085:time(end))';
DI=linspace(0,1000,100);

%produce variogram to determine length scales of auto-correlation and error
% vx=variogram(timex,temp,'subsample',3000,'plotit',true);
% vy=variogram(depth,temp,'subsample',3000,'plotit',true);

%define length scales for temperature
LX=1; %no correlation, so choose 1 
LY=250; %distance, this was eye-balled, use distance value where the variogram levels out
E=0.025; %nugget of depth variogram

[ZI,EM]=objmap(time,depth,temp,TI,DI,[LX,LY],E);


%plot to see if it worked
%sz=10;
%raw
scatter(time,depth,sz,temp,'filled')
%
%interpolated
[TII,DII]=meshgrid(TI,DI);
scatter(TII(:),DII(:),sz,ZI(:),'filled')

save('/Users/Marcel/Google Drive/Data/SOCCO_gliders/optimal_interpolated_grids/temp_oi_grid_soscex1_sg543.mat','ZI','EM', 'TI', 'DI');