# Optimal-Interpolation-Glider-Data

Here I will describe how I use the optimal interpolation method obtained from the Scripps Oceanographic Institute ( http://mooring.ucsd.edu/ ) to regrid my data to a common temporal and vertical grid.

This is a little long winded for most people as I use Python as a programming language, while the OI code is written in MATLAB. So, what I do is to first read the Seaglider data into Python using BuoyancyGliderUtils developed by Luke Gregor ( http://github.com/luke-gregor/BuoyancyGliderUtils ) as shown in the code below:

```python
%pylab inline
from netCDF4 import Dataset
import pandas as pd
import buoyancy_glider_utils as bgu
import gzip
import scipy.io as sio

# Read in the glider data from my local computer
fname = '/Users/Marcel/Google Drive/Data/SOCCO_gliders/soscex1/sg543/*.nc'
dat = bgu.seaglider.load_basestation_netCDF_files(fname, verbose=True)

# convert the dates into the MATLAB date number format
t=date2num(list(dat.temperature.data.ctd_time))

# Save the loaded data into a MATLAB readable .mat file
d = {'temp' : dat.temperature.data.temperature.values,
    'depth' : dat.temperature.data.ctd_depth.values,
    'time'  : t}

sio.savemat('/Users/Marcel/Google Drive/Data/SOCCO_gliders/optimal_interpolated_grids/soscex1_temp.mat', d)
```

## Reading the data into MATLAB and performing the optimal interpolation

Now once the data is saved in a .mat format, I switch from Python to MATLAB (long-winded I know, but it works for me so I'm going with it). Once in MATLAB, you need to add the paths for the objmap and variogram and load in the saved .mat file.

```Matlab 
addpath(genpath('/Users/Marcel/Downloads/datafun'));
addpath(genpath('/Users/Marcel/Downloads/variogram'));

load('/Users/Marcel/Google Drive/Data/SOCCO_gliders/optimal_interpolated_grids/test_file.mat');
```

You need to remove any nans that may exists in the dataset:

```matlab
ind = ~isnan(temp);

temp = temp(ind);
time = time(ind);
depth = depth(ind);
```

I perform the objective mapping as follows:

```matlab

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

```