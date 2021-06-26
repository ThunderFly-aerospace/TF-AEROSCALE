#!/bin/bash
######################################################################
#
#       Function: parse_params
#
#    Description: Parses params $*.
#
# Inputs/Outputs: $*
#                -p, --printer <file> . PRINTER_CONF=<file>
#                -s, --scad <file> .... SCAD_CONF or SCAD_FILE=<file>
#                -m, --module <file> .. MODULE_CONF=<file>
#                -a, --amf <file> ..... AMF_FILE=<file>
#                -o, --output <file> .. OUT_FILE=<file>
#                -v, --verbose ........ VERBOSE=true
#                -h, --help ........... HELP=true
#
#        Outputs: N/A
#
#  Return values: 0 - OK
######################################################################
function parse_params {
  for param in HELP VERBOSE ; do
    # !param means $($param) -> if $param=one and $one=two then ${!param}=two
    if [ -z "${!param}" ] ; then
      eval ${param}=false
    fi
  done

  param_prev=""
  param=""

  for param in $* ; do
    if [ ${param:0:1} != "-" ] ; then
      case ${param_prev} in
        --printer )
          PRINTER_CONF="${param}"
          verbose_print "Using ${PRINTER_CONF} as printer configuration file."
          param_prev=""
        ;;
        --module )
          verbose_print "Adding ${param} to module configuration files."
          if [ -z "${MODULE_CONF}" ] ; then
            MODULE_CONF=(${param})
          else
            MODULE_CONF[${#MODULE_CONF[*]}]=${param}
          fi
        ;;
        --scad )
          SCAD_CONF="${param}"
          param_prev=""
        ;;
        --amf )
          AMF_FILE="${param}"
          verbose_print "Slic3r will be called on ${AMF_FILE} with merged configuration."
          param_prev=""
        ;;
        --out )
          OUT_FILE="${param}"
          verbose_print "Output file will be ${OUT_FILE}."
          param_prev=""
        ;;
        * )
          verbose_print "Unknown parameter [${param}]."
      esac
      continue
    fi

    case ${param} in
      -p | --printer )
         param_prev="--printer"
      ;;
      -h | --help )
         param_prev=""
         HELP=true
      ;;
      -m | --module )
         param_prev="--module"
      ;;
      -s | --scad )
         param_prev="--scad"
      ;;
      -o | --out )
         param_prev="--out"
      ;;
      -a | --amf )
         param_prev="--amf"
      ;;
      -v | --verbose )
         param_prev=""
         VERBOSE=true
         verbose_print "VERBOSE set to TRUE"
      ;;
      * )
        verbose_print "Unknown parameter [${param}]."
    esac

  done
}
######################################################################
#
#         Function: verbose_print
#
#      Description: Looks for -v in $OPTION to set verbose mode.
#
#           Inputs:
#
# Global variables: VERBOSE
#
#          Outputs: Prints given text if VERBOSE is set
#
#    Return values: 0 - OK
######################################################################
function verbose_print {
  if $VERBOSE ; then
    local text="$*"
    printf "${text}\n" >&2
  fi
}

######################################################################
#
#         Function: merge_files
#
#      Description: Merges two files. Second file has higher priority
#                   if parameter is present in both files.
#
#           Inputs: 2 files to merge
#
# Global variables: VERBOSE
#
#          Outputs: both files merged into second file
#
#    Return values: 0 - OK
#                   1 - Error
######################################################################
function merge_files {
  # Merge parameters to second file (skip parameters already present in
  # second file):
  local file1="${1}"
  local file2="${2}"
  if [ -s ${file2} ]; then
    cat ${file2} | sed 's/\([^ ]*\).*/-e "^\1 "/' | tr -s '\n' ' ' |\
    xargs grep -v ${file1} >> ${file2}
  else
    cat ${file1} > ${file2}
  fi
}

######################################################################
#
#         Function: get_printer_conf
#
#      Description: Saves printer configuration to printer_conf.tmp
#
#           Inputs: printer configuration file
#
# Global variables: VERBOSE
#
#          Outputs: printer_conf.tmp file
#
#    Return values: 0 - OK
######################################################################
function get_printer_conf {
  # Use printer configuration file:
  if [ "${1} " != " " ]; then
    cat ${1} > printer_conf.tmp
  # Use $SLICER_CONF path to configuration file:
  elif [ -e "${SLICER_CONF}" ]; then
    verbose_print "Using configuration ${SLICER_CONF}"
    cat ${SLICER_CONF} > printer_conf.tmp
  # Create empty printer_conf.tmp (or empty it, if present):
  else
    verbose_print "No printer configuration found."
    echo -n "" > printer_conf.tmp
  fi
}

######################################################################
#
#         Function: get_scad_conf
#
#      Description: Saves scad configuration to scad_merged.tmp
#
#           Inputs:
#
# Global variables: VERBOSE
#
#          Outputs: scad_merged.tmp file
#
#    Return values: 0 - OK
######################################################################
function get_scad_conf {
  # Load SCAD configuration:
  if grep -q ".scad$" <<< "${1}"; then
    local scad_file="${1}"
    verbose_print "Using ${scad_file} to read parameters and configuration file."
    # Get params from scad file:
    grep "set_slicing_parameter(" ${scad_file} |\
    sed "s/.*(\([^,]*\), \(.*\))/\1 = \2/" > scad_params.tmp
    cat scad_params.tmp > scad_merged.tmp
    # Get slicing config from scad file:
    if $(grep -s -e '//@set_slicing_config(' ${scad_file} > /dev/null); then
      local scad_conf=$(grep "set_slicing_config([^,]*)$" ${scad_file} |
                  sed 's/.*(\(.*\))/\1/')
      cat $(echo ${scad_file} | sed 's/[^/]*$//')${scad_conf} > scad_conf.tmp
    else
      # Create empty scad_conf.tmp (or empty it, if present):
      echo -n "" > scad_conf.tmp
    fi
    # Merge parameters to file scad_merged.tmp (skip local parameters present in ini):
    if [ -s scad_params.tmp ]; then
      cat scad_params.tmp | sed 's/\([^ ]*\).*/-e "^\1 "/' | tr -s '\n' ' ' |\
      xargs grep -v scad_conf.tmp >> scad_merged.tmp
    else
      cat scad_conf.tmp >> scad_merged.tmp
    fi
  elif [ "${1} " != " " ]; then
    local scad_conf="${1}"
    cat ${scad_conf} > scad_merged.tmp
  else
    verbose_print "SCAD configuration not provided."
    # Create empty scad_merged.tmp (or empty it, if present):
    echo -n "" > scad_merged.tmp
  fi
  rm -f scad_conf.tmp scad_params.tmp 2>/dev/null
}

######################################################################
#
#         Function: get_module_conf
#
#      Description: Saves module configuration to module_conf.tmp
#
#           Inputs: module configuration file
#
# Global variables: VERBOSE
#
#          Outputs: module_conf.tmp file
#
#    Return values: 0 - OK
######################################################################
function get_module_conf {
  # Load module configuration file
  if [ "${1} " != " " ]; then
    cat ${1} > module_conf.tmp
  elif [ -e default.ini ]; then
    verbose_print "Using $(pwd)/default.ini as module configuration."
    cat default.ini > module_conf.tmp
  elif [ $(find $(git rev-parse --show-toplevel) -name default.ini | wc -l) == 1 ]; then
    local module_conf=$(find $(git rev-parse --show-toplevel) -name default.ini)
    verbose_print "Using ${module_conf} as module configuration."
    cat ${module_conf} > module_conf.tmp
  else
    verbose_print "No module configuration found."
    # Create empty module_conf.tmp (or empty it, if present):
    echo "" > module_conf.tmp
  fi
}


######################################################################
#
#         Function: merge_slic3r_conf.sh
#
#      Description: Merge multiple slic3r configurations.
#
#                   Printer configuration is taken from:
#                   1) -p/--printer option
#                   2) $SLICER_CONF path if it exists
#
#                   SCAD configuration is taken from:
#                   1) -s/--scad option
#
#                   Module configuration is taken from:
#                   1) -m/--module option
#                   2) default.ini file in current directory if it exists
#                   3) default.ini file anywhere in current git directory,
#                      if there is only one.
#
#                   Duplicate parameters will be handled with this priority:
#                   1) Highest priority parameters are those from printer configuration.
#                   2) Parameters set_slicing_parameter from SCAD file
#                   3) Parameters from configuration file in set_slicing_config or --scad
#                      option path
#                   4) Lowest priority are parameters from module configuration.
#
#           Inputs: -p, --printer <file> ..... Printer configuration file
#                   -s, --scad <file> ........ SCAD configuration file or SCAD file with
#                                              set_slicing_parameter/config parameters.
#                   -m, --module <file> ...... Module configuration files(s)
#                   -a, --amf ................ Path to AMF file. Script will try to run
#                                              slic3r with merged configuration when this
#                                              option is active.
#                   -o, --output ............. Specify name of output file. If this option
#                                              is not specified, filename will be based on
#                                              --scad option. If neither of those is specified
#                                              filename will be merged_slicer_conf.ini
#                   -v, --verbose ............ VERBOSE=true
#                   -h, --help ............... HELP=true
#
#          Outputs: Merged slic3r configuration file.
#                   GCode if --amf option is given.
#
#    Return values: 0 - OK
#                   1 - Error
######################################################################

function merge_slic3r_conf {
  # Read parameters:
  parse_params $*

  # If -h/--help in params, print help and exit:
  if ${HELP}; then
   echo "Usage ./merge_slic3r_conf.sh [OPTIONS]

    Description: Merge multiple slic3r configurations.

                 Printer configuration is taken from:
                 1) -p/--printer option
                 2) SLICER_CONF path if it exists

                 SCAD configuration is taken from:
                 1) -s/--scad option

                 Module configuration is taken from:
                 1) -m/--module option (this option accepts multiple
                    space-separated configurations)
                 2) default.ini file in current directory if it exists
                 3) default.ini file anywhere in current git directory,
                    if there is only one.

                 Duplicate parameters will be handled with this priority:
                 1) Highest priority parameters are those from printer configuration.
                 2) Parameters set_slicing_parameter from SCAD file
                 3) Parameters from configuration file in set_slicing_config or --scad
                    option path
                 4) Lowest priority are parameters from module configuration.
                    If multpile module configurations are specified, priorities the
                    same as the order in which they are specified (lowest at the end).

         Inputs: -p, --printer <file> ..... Printer configuration file
                 -s, --scad <file> ........ SCAD configuration file or SCAD file with
                                            set_slicing_parameter/config parameters.
                 -m, --module <file> ...... Module configuration file(s)
                 -a, --amf ................ Path to AMF file. Script will try to run
                                            slic3r with merged configuration when this
                                            option is active.
                 -v, --verbose ............ VERBOSE=true
                 -o, --output ............. Specify name of output file. If this option
                                            is not specified, filename will be based on
                                            --scad option. If neither of those is specified
                                            filename will be merged_slicer_conf.ini

        Outputs: Merged slic3r configuration file.
                 GCode if --amf option is given.

  Return values: 0 - OK
                 1 - Error"
    exit 0
  fi

  # Get printer configuration and save it to printer_conf.tmp:
  get_printer_conf ${PRINTER_CONF}

  # Save parameters to file merged_conf.tmp:
  cat printer_conf.tmp > merged_conf.tmp

  # Get SCAD configuration and save it to scad_merged.tmp:
  get_scad_conf "${SCAD_CONF}"

  # Merge SCAD configuration into merged_conf.tmp:
  merge_files scad_merged.tmp merged_conf.tmp

  # Get configuration For each module conf specified (or run with empty parameter once):
  for file in ${MODULE_CONF[*]:-""}; do
    # Get module configuration and save it to module_conf.tmp:
    get_module_conf "$file"
    # Merge SCAD configuration into merged_conf.tmp:
    merge_files module_conf.tmp merged_conf.tmp
  done

  # Clean-up tmp files
  rm -f scad_merged.tmp module_conf.tmp printer_conf.tmp 2>/dev/null

  # If merged_conf.tmp is empty, exit with error code 1:
  if ! [ -s merged_conf.tmp ]; then
    rm -f merged_conf.tmp 2>/dev/null
    printf "ERROR: No configuration to merge found!\n" >&2
    exit 1
  fi

  # If AMF_FILE is specified, call slic3r with merged configuration.
  if [ "${AMF_FILE} " != " " ]; then
    slic3r --load merged_conf.tmp -o $(echo ${AMF_FILE} | sed 's/.amf$/.gcode/') -j 3 ${AMF_FILE}
  fi

  # If OUT_FILE is specified, rename merged_conf.tmp to OUT_FILE:
  if [ "${OUT_FILE} " != " " ]; then
    mv merged_conf.tmp ${OUT_FILE}
  # else if SCAD_FILE is specified, rename merged_conf.tmp to SCAD_FILE.ini:
  elif [ "${SCAD_FILE} " != " " ]; then
    mv merged_conf.tmp $(echo ${SCAD_FILE} | sed 's/.scad$/.ini/')
  # else use default name merged_slicer_conf.ini:
  else
    mv merged_conf.tmp merged_slicer_conf.ini
  fi
}

merge_slic3r_conf $*
