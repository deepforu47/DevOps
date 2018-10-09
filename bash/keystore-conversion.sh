#!/bin/bash

# We have:
#
# 1) $KEY : Secret key in PEM format ("-----BEGIN RSA PRIVATE KEY-----")
# 2) $ME_CERT : Certificate for secret key obtained from some
#    certification outfit, also in PEM format ("-----BEGIN CERTIFICATE-----")
#
# We want to create a fresh Java "keystore" $TARGET_KEYSTORE with the
# password $TARGET_STOREPW
#
# The keystore must contain: $KEY, $MY_CERT
# Execution - $sudo ./script.sh {PVT-KEY} {MY_CERT} {YOUR_CERT} {KEYSTORE_NAME} {TRUSTSTORE_NAME}


# Let's roll:

echo -n Truststore and Keystore Password:
read -s password

KEY=$1
MY_CERT=$2
YOUR_CERT=$3
TARGET_KEYSTORE=$4
TRUST_STORE=$5
TARGET_STOREPW=$password

LOCATION=.

KEY_LOC=$LOCATION/$KEY
MY_CERT_LOC=$LOCATION/$ME_CERT



# ----
# Create PKCS#12 file to import using keytool later
# ----

# From https://www.sslshopper.com/ssl-converter.html:
#PKCS#12/PFX Format
#The PKCS#12 or PFX format is a binary format for storing the server certificate, any intermediate certificates, 
#and the private key in one encryptable file. PFX files usually have extensions such as .pfx and .p12. 
#PFX files are typically used on Windows machines to import and export certificates and private keys.
#When converting a PFX file to PEM format, OpenSSL will put all the certificates and the private key into a single file.
#You will need to open the file in a text editor and copy each certificate and private key (including the BEGIN/END statments) 
#to its own individual text file and save them as certificate.cer, CACert.cer, and privateKey.key respectively.

TMPPW=$$ # Some random password

PKCS12FILE=`mktemp`

if [[ $? != 0 ]]; then
  echo "Creation of temporary PKCS12 file failed -- exiting" >&2; exit 1
fi

TRANSITFILE=`mktemp`

if [[ $? != 0 ]]; then
  echo "Creation of temporary transit file failed -- exiting" >&2; exit 1
fi

cat "$KEY_LOC" "$MY_CERT_LOC" > "$TRANSITFILE"

# Create "pkcs12" format Keystore from our own Certificate and key
echo -e "\n"
openssl pkcs12 -export -passout "pass:$TMPPW" -in "$TRANSITFILE" -name etl-web > "$PKCS12FILE"

/bin/rm "$TRANSITFILE"

# Print out result!!

openssl pkcs12 -passin "pass:$TMPPW" -passout "pass:$TMPPW" -in "$PKCS12FILE" -info

# ----
# Import contents of PKCS12FILE into a Java keystore. WTF, Sun, what were you thinking?
# ----

if [[ -f "$TARGET_KEYSTORE" ]]; then
  /bin/rm "$TARGET_KEYSTORE"
fi

### Create truststore with certificate we got from Server Side ##
YOUR_ALIAS=your_alias
echo -e "Import YOUR cert to trusstore"
keytool -import \
   -noprompt \
   -alias $YOUR_ALIAS \
   -storepass $TARGET_STOREPW \
   -keystore $TRUST_STORE \
   -file $YOUR_CERT

## Convert "pkcs12" format Keystore to "jks" format
keytool -importkeystore \
   -deststorepass  "$TARGET_STOREPW" \
   -destkeypass    "$TARGET_STOREPW" \
   -destkeystore   "$TARGET_KEYSTORE" \
   -srckeystore    "$PKCS12FILE" \
   -srcstoretype  PKCS12 \
   -srcstorepass  "$TMPPW"

/bin/rm "$PKCS12FILE"
echo "Listing result"
keytool -list -storepass "$TARGET_STOREPW" -keystore "$TARGET_KEYSTORE"
