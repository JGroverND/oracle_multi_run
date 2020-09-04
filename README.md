#README
You will need to create a credentials file dblist.txt and encrypt it. The encrypted file
name should be in the variable ENCRYPTED_FILE in etc/omr_init.rc. You will be prompted for 
the key to the file at run time

The file is in the format:
servicename,family,password,hostname
lines starting with "#" and empty lines are ignored
family is somethng like dev,test,prod,other

Create a key
gpg --full-generate-key

Encrypt the credentials file
gpg --encrypt dblist.txt

The system assumes the same account name across all databases and is set up in the 
variable ACCT in the init file

The system assumes use of Oracle directory, the LDAP parameters are specified in the init file
