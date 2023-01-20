#!/bin/bash

for ii in SM2RAIN_ASCAT_*200[56789]*.nc;do

	echo ${ii}		
	ncpdq -a time,Rainfall,Rainfall_noise,Conf_flag,ssf,Latitude,Longitude ${ii} ${ii%.nc}_fixed.nc
	
	rm -rf *.tmp
	
	echo ${ii%.nc}_fixed.nc
	cdo select,name=Rainfall -sellonlatbox,-32,75,-42,42  ${ii%.nc}_fixed.nc africa_${ii%.nc}_fixed.nc
	
	echo africa_${ii%.nc}_fixed.nc
done
