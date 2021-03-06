# (c) David T. Nguyen
# December 2014
# dunguk@gmail.com


# usage:
# ./start
# runs the iRAM service to clean up the main memory (RAM)

# =======
# INIT
# =======

echo "iRAM starting...\n"

TOTAL=`./get_total_mem.sh`

echo "Before applying iRAM:\n"
BEFORE=`./get_free_mem.sh`
echo "$BEFORE \n"
let BEFORE_PCT=${BEFORE}*100/${TOTAL}
echo "${BEFORE_PCT}% free memory" 

echo "Init...\n"
./cleanall.sh
# =======================================


# ============
# CONFIGURE
# ============


echo "Running configure script...\n"
source configure.sh
cat configure.sh
echo "\n"

#setprop dalvik.vm.heapsize "$HEAP_SIZE"

# =======================================

if [ "$BEFORE_PCT" -ge "$MIN_MEM" ]; then
	echo "The system has enough free memory. No need to execute iRAM."
	exit 1
else 
	echo "Low memory!!! I'm executing iRAM to save your life!\n"
fi



# =====================
# BACKGROUND PROCESSES
# =====================
echo "Getting background processes...\n"
./get_bg_processes.sh bg_processes.txt
echo "\n"

echo "Applying whitelist...\n"
cat whitelist.dat
echo "\n"
./filter_whitelist.sh bg_processes.txt bg_processes2.txt
echo "\n"

echo "Getting PIDs...\n"
./get_pids.sh bg_processes2.txt bg_processes_pid.txt

echo "Killing PIDs...\n"
./kill_pids.sh bg_processes_pid.txt

# ======================================


# ================                                                             
# SYSTEM CACHES                                                                
# ================                                                             
# clean cache only when aggression level is 2 or 3

if [ "$AGGRESSION_LEVEL" -ge 2 ]; then 
	echo "Cleaning cache...\n"                                                     
	./clean_cache.sh
fi                                                               
# =======================================                                      



# =====================                  
# FOREGROUND PROCESSES                   
# =====================    
# clean foreground processes only when aggression level is 3 or higher

if [ "$AGGRESSION_LEVEL" -ge 3 ]; then

	echo "Getting foreground processes...\n"
	./get_fg_processes.sh fg_processes.txt
	echo "\n"

	echo "Applying whitelist...\n"                                
	cat whitelist.dat
	echo "\n"                        
	./filter_whitelist.sh fg_processes.txt fg_processes2.txt
	echo "\n" 

	echo "Getting PIDs...\n"
	./get_pids.sh fg_processes.txt fg_processes_pids.txt

	echo "Killing PIDs...\n"                                
	./kill_pids.sh fg_processes_pids.txt       
fi
# ======================================

# ======================
# APPLICATION DATA
# ======================

#echo "Getting packages...\n"
#./get_packages.sh

#echo "Applying whitelist...\n"
#cat whitelist.dat
#echo "\n"
#./filter_whitelist.sh packages.txt packages2.txt
#echo "\n"

#echo "Cleaning packages...\n"
#./clean_packages.sh

# ================================================


sleep 5

echo "iRAM finished.\n"

echo "After applying iRAM:\n"
AFTER=`./get_free_mem.sh`
echo "$AFTER \n"
let AFTER_PCT=${AFTER}*100/${TOTAL}
echo "${AFTER_PCT}% free memory"     
