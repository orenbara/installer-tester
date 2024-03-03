#!/bin/bash

# This is the main program which is responsible for execution of test suits
# It will loop through the modules similraly to installer

####
#TODO: Deal with arguments pass to the tester
####

function usage() {
  echo "./installer-tester <tester-contrib-file>"
}

touch tester_exec.log
touch tester_err.log



# Assign the returned values to respective variables
if [ -d "/opt/installer_tester" ]; then
  TESTER_ERR_LOG_FILE="/opt/installer_tester/tester_exec.log"
  TESTER_EXEC_LOG_FILE="/opt/installer_tester/tester_err.log"
fi

if [ -z "${1}" ]; then # Check if param was provided
  usage
  echo "[TESTER|CRITICAL]: bad usage" >> "${TESTER_ERR_LOG_FILE}"
else
  if [ ! -f "${1}" ]; then # check if tester-contrib file coresponding to the param exsits
    echo "[TESTER|CRITICAL]: tester-contrib file provided in arg1: ${1} not found " >> "${TESTER_ERR_LOG_FILE}" 
    else
      . ${1}
      for test in "${test_arr[@]}"; do
        echo "[TESTER|INFO]: executing ${test}" >> "${TESTER_EXEC_LOG_FILE}"
        source ${test}
        test_exit_code=${?}
        case "$test_exit_code" in
          0)
            echo "[TESTER|INFO]: Done ${test}" >> "${TESTER_EXEC_LOG_FILE}"
            continue
            ;;
          
          *)
            echo "[TESTER|INFO]: ${test} resulted with exit code: ${test_exit_code} continue testing" >> "${TESTER_EXEC_LOG_FILE}" 
            echo "[TESTER|CRITICAL]: ${test} exit_code was: ${test_exit_code} continue testing" >> "${TESTER_ERR_LOG_FILE}"
            continue
            ;;
        esac
      done
  fi
fi

echo "[TESTER]: installer-tester done"