#!/bin/bash

mytables="authorization,cust_acct_card,cust_dwh,transaction"
IFS=',' read -a tableArray <<< "$mytables"

echo "table1 : ${tableArray[0]}"
echo "table2 : ${tableArray[1]}"
echo "table3 : ${tableArray[2]}"
echo "table4 : ${tableArray[3]}"
