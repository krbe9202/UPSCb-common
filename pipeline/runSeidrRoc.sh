#!/bin/bash
#SBATCH -A facility
#SBATCH -t 4:00:00
#SBATCH -p core -n 1
#SBATCH --mem=16GB

set -ex

# Check for options
NGS=

# usage
USAGETXT=\
"
  Usage: $0 [options] <seidr file> <gold-standard> <score index> <output filename>
  
  Options: 
                -x define your negative golden standard
"

source ${SLURM_SUBMIT_DIR:-$(pwd)}/../UPSCb-common/src/bash/functions.sh

isExec seidr

# Get the options
while getopts x: option
do
        case "$option" in
      x) NGS="-x $OPTARG";;
    \?) ## unknown flag
		abort;;
        esac
done
shift `expr $OPTIND - 1`


if [ $# -ne 4 ]; then
  abort "This script expects 4 arguments"
fi

if [ ! -f $1 ]; then
  abort "The first argument needs to be an existing file"
fi

if [ ! -f $2 ]; then
  abort "The second argument needs to be an existing file"
fi

if [ ! -d $(dirname $4) ]; then
  abort "The third argument directory needs to exist"
fi

# run
seidr roc -p 1000 -E 1 -i $3 -g $2 -n $1 $NGS > $4
