# ZeroshellTools
This folder contains scripts for bulk management of accounts in Zeroshell.


### Prerequisites

Before using the script, make sure you have SSH and SCP access to your Zeroshell machine. To activate SCP, access your Zeroshell machine bash and write:
```
chsh -s /bin/bash admin
```

WARNING! In this release, the scripts leave some leftover files behind; also, disconnect.sh seems bugged in some devices, requiring a reboot of the machine to actually disconnect kicked users.

## Scripts

### adduser.sh
```
./adduser.sh PREFIX
```
This script takes in a prefix as a parameter and using a counter file in /Database/utente, will sequentially create an account named PREFIX001 with an increased number and a random password (customizable) each time it's run. Deleting /Database/utente will reset the counter. The script requires the Zeroshell admin password to be written in a variable inside the script. Users will be both added to the local LDAP domain and the default Kerberos 5 Realm.


### addusermultiple.sh:
```
./addusermultiple.sh ITERATIONS PREFIX
```
This script is a wrapper for adduser.sh. It will iterate for the given number of times using the set prefix, and then delete /Database/utente in the end.


### removeuser.sh:
```
./remove.sh ITERATIONS PREFIX
```
This script works similarly to addusermultiple.sh, removing the users starting from 001 to the given ITERATIIONS with the given prefix, from both LDAP and Kerberos 5.


### disconnect.sh
```
./disconnect.sh ITERATIONS PREFIX
```
This script will selectively disconnect all accounts starting with PREFIX from 001 up to ITERATIONS.


## Authors

* **Matteo Franzil** - *Initial work* - [mfranzil](https://github.com/mfranzil)

## License

This project is open source. Please, contact me for suggestions and reviews.

