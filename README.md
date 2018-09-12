# Optimal-Interpolation-Glider-Data

Here I will describe how I use the optimal interpolation method obtained from the Scripps Oceanographic Institute ( http://mooring.ucsd.edu/ ) to regrid my data to a common temporal and vertical grid.

This is a little long winded for most people as I use Python as a programming language, while the OI code is written in MATLAB. So, what I do is to first read the Seaglider data into Python using BuoyancyGliderUtils developed by Luke Gregor ( github.com/luke-gregor/BuoyancyGliderUtils ). 

'''
%pylab inline
from netCDF4 import Dataset
import pandas as pd
import cmocean
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

sio.savemat('/Users/Marcel/Downloads/test_file.mat', d)
'''
