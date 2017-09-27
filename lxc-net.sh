#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    echo "usage : sh ./lxc-net.sh [physical_interface] [virtual_interface]"
    exit
fi

# get the arguments
physI=$1
virtI=$2

# validation function (loop if answer is not correct)
askCorrect() {
  echo "============================================"
  echo $(printf "The physical interface is : %s" $physI)
  echo $(printf "The virtual interface is : %s" $virtI)
  echo "Is this correct ? Y/n"

  read answer

  case $answer in
    "Y")
      generateRules ;;
    "n")
      echo "canceling..."
      exit ;;
    *)
      askCorrect ;;
  esac
}


# generate the iptables rules
generateRules() {
  echo "Writing rules..."
  eval $(printf "iptables -A FORWARD -i %s -o %s -j ACCEPT" $virtI $physI)
  eval $(printf "iptables -A FORWARD -i %s -o %s -m state --state ESTABLISHED,RELATED -j ACCEPT" $physI $virtI)
  eval $(printf "iptables -t nat -A POSTROUTING -o %s -j MASQUERADE" $physI)
  echo "Done."
  exit
}

askCorrect
