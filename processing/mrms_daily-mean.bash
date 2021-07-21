#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH -J mrmsdaily
#SBATCH -N 1
#SBATCH -A STF011
#SBATCH -o mrmsdaily.%j.out

module load cdo

export PATH="$HOME/sw/util/bin:$PATH"

years="2005"
datadir=/gpfs/alpine/cli900/world-shared/data/collections/mrms/subset_1024x1024
dsetpfx="MRMS_PrecipRate_00.00"

for year in $years; do
    indir=$datadir/netcdf/$year
    odir=$datadir/daily/$year
    echo $odir
    #mkdir -p $odir
    for month in $(seq 1 12); do
        ndays=$(days-in-month $year $month)
        #echo $year $month $ndays
        for day in $(seq 1 $ndays); do
            printf -v imonth "%2.2i" $month
            printf -v iday "%2.2i" $day
            echo $year $imonth $iday
            iflist="${indir}/${dsetpfx}_${year}${imonth}${iday}-*.nc"
            echo "$iflist"
            ofile="${odir}/${dsetpfx}_${year}${imonth}${iday}.tm.nc"
            ofile2="${odir}/${dsetpfx}_${year}${imonth}${iday}.sd.nc"
            echo $ofile
            #cdo -f nc -timmean -cat $iflist $ofile
            cdo -f nc -timstd -cat $iflist $ofile2
        done
        echo
    done
done
