#!/bin/bash

############## PARAMETER ###########
OPT=$1
env=`echo $2 | tr "[A-Z]" "[a-z]"`
start_date=$3
end_date=$4
new_id=$5

if [ $# -ne 5 ]; then
  echo "ERROR: Usage: run_view_step.sh <Option> <ENV> <start date> <end date> <loadid>"
  exit 1
fi;
##################################### 
############## EMAIL FILE ############
EMAIL_UTIL=
touch chg_conf_value.txt

EMAIL=chg_conf_value.txt
############# LOCATION #############
### L2 ###
l2_view=
l2_stg=
l2_load=

### L4 ###
l4_view=
l4_stg=
l4_load=

###################################

function chg_view_conf () {
  env=$1
  start_date=$2
  end_date=$3
  new_id=$4
  
  echo "------------------------------Before change------------------------" >> $EMAIL 
  sed -n "9,12p" $env.txt >> $EMAIL
  prev_start_date=`sed -n "9p" $env.txt | awk -F '["]' '{print $2}'`
  prev_end_date=`sed -n "10p" $env.txt | awk -F '["]' '{print $2}'`

  sed -i "s:$prev_start_date:$start_date:" $env.txt
  sed -i "s:$prev_end_date:$end_date:" $env.txt

  prev_id=`sed -n "11p" $env.txt | awk -F '["]' '{print $2}'`
  sed -i "s:$prev_id:$new_id:" $env.txt
  
  echo "------------------------------After change------------------------" >> $EMAIL 
  sed -n "9,12p" $env.txt >> $EMAIL
  
}

function chg_conf () {
  env=$1
  start_date=$2
  end_date=$3
  new_id=$4

  echo "------------------------------Before change------------------------" >> $EMAIL 
  sed -n "9,12p" $env.hql >> $EMAIL
  prev_start_date=`sed -n "9p" $env.hql | awk -F '["]' '{print $2}'`
  prev_end_date=`sed -n "10p" $env.hql | awk -F '["]' '{print $2}'`

  sed -i "s:$prev_start_date:$start_date:" $env.hql
  sed -i "s:$prev_end_date:$end_date:" $env.hql

  prev_id=`sed -n "11p" $env.hql | awk -F '["]' '{print $2}'`
  sed -i "s:$prev_id:$new_id:" $env.hql
  
  echo "------------------------------After change------------------------" >> $EMAIL 
  sed -n "9,12p" $env.hql >> $EMAIL

}

################# OPTION ####################
#
# *) all 
# 1) l2 view
# 2) l2 staging
# 3) l2 load
# 4) l4 view
# 5) l4 staging
# 6) l4 load
#
case $OPT in
0)
  cd $l2_view
  echo "---------------------------------------l2 view-------------------------------------" >> $EMAIL 
  chg_view_conf $env $start_date $end_date $new_id
  cd $l2_stg
  echo "---------------------------------------l2 stage-----------------------------------" >> $EMAIL 
  chg_conf $env $start_date $end_date $new_id
  cd $l2_load
  echo "---------------------------------------l2 load-----------------------------------" >> $EMAIL
  chg_conf $env $start_date $end_date $new_id
  cd $l4_view
  echo "---------------------------------------l4 view-----------------------------------" >> $EMAIL
  chg_view_conf $env $start_date $end_date $new_id
  cd $l4_stg
  echo "---------------------------------------l4 stage-----------------------------------" >> $EMAIL
  chg_conf $env $start_date $end_date $new_id
  cd $l4_load
  echo "---------------------------------------l4 load-----------------------------------" >> $EMAIL
  chg_conf $env $start_date $end_date $new_id
  ;;

1)
  cd $l2_view
  echo "---------------------------------------l2 view-------------------------------------" >> $EMAIL 
  chg_view_conf $env $start_date $end_date $new_id
  ;;
2)
  cd $l2_stg
  echo "---------------------------------------l2 stage-----------------------------------" >> $EMAIL 
  chg_conf $env $start_date $end_date $new_id
  ;;
3)
  cd $l2_load
  echo "---------------------------------------l2 load-----------------------------------" >> $EMAIL
  chg_conf $env $start_date $end_date $new_id
  ;;
4)
  cd $l4_view
  echo "---------------------------------------l4 view-----------------------------------" >> $EMAIL
  chg_view_conf $env $start_date $end_date $new_id
  ;;
5)
  cd $l4_stg
  echo "---------------------------------------l4 stage-----------------------------------" >> $EMAIL
  chg_conf $env $start_date $end_date $new_id
  ;;
6)
  cd $l4_load
  echo "---------------------------------------l4 load-----------------------------------" >> $EMAIL
  chg_conf $env $start_date $end_date $new_id
  ;;
*)
  echo "Wrong Option" >> $EMAIL
esac

################################################


################### SEND EMAIL #################
HOSTNAME=`hostname`
EMAIL_FROM=noreply@`hostname -f`
#EMAIL_TO=""
EMAIL_SUBJ="SKR $HOSTNAME : Result of config file changes"
EMAIL_TO=""

$EMAIL_UTIL/mailer_util.sh "$EMAIL_FROM" "$EMAIL_TO" "$EMAIL_SUBJ" "$EMAIL" "$EMAIL"

######### Remove Email file #######################
rm $EMAIL
###############################################
