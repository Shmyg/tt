nohup data --deletequeues &>/dev/null 2>&1 &
pteh -t -c -b -r -u 

nohup rdh -udmap &>/dev/null 2>&1 &
nohup rdh -prih  >/dev/null 2>&1 &
nohup rdh -rih >/dev/null 2>&1 &
nohup rdh -cch >/dev/null 2>&1 &
nohup rdh -bch >/dev/null 2>&1 &

# Main modules
nohup startNamingService.sh >/dev/null 2>&1 &
nohup startBillSrv.sh >/dev/null 2>&1 &
nohup prih -t -e >/dev/null 2>&1 &
nohup rih -t -e >/dev/null 2>&1 &
nohup cch >/dev/null 2>&1 &
nohup rlh -01 >/dev/null 2>&1 &
nohup bch -a 0 >/dev/null 2>&1 &
nohup bgh -b $BGH_BILL_IMAGE_ROOT -t3 >/dev/null 2>&1 &

#START_GMD -srv GMD
#~/tools/starweb.sh
