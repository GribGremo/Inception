#!/bin/bash
echo "~~~~~~~~~~SSL certs script~~~~~~~~~~"

#~~~~~~~~~~~~~~~~~OPTIONS TREATMENT~~~~~~~~~~~~~~~~~
#define and store options, (o just an option trigger, o: option with arument necessary, o:: option with unecessary argument) 
#-- is here to comprehend which options are getopt option, and which are script options, $@ is the argument of getopt
OPTS=$(getopt -o p:k:c: --long country:,state:,city:,corp:,status:,domaine: -- "$@")

#Check getopt error
if [[ $? -ne 0 ]]; then
    echo "Invalid script options"
    exit 1
fi

#here we use this to recreate an array of arguments that have been sorted by getopt previously, getopt juste made a string (OPTS)
eval set -- "$OPTS"

#~~~~~~~~~~~~~~~~~INIT DEFAULT VALUES~~~~~~~~~~~~~~~~~

SSL_PATH=/etc/nginx/ssl/certs
KEY=sylabbe.42.fr.key
CRT=sylabbe.42.fr.crt

C=FR
ST=Charente
L=Angouleme
O=42
OU=Student
CN=sylabbe.42.fr

#~~~~~~~~~~~~~~~~~PARSE OPTIONS~~~~~~~~~~~~~~~~~
while true; do
    case "$1" in
        -p)
            echo "allo"
            SSL_PATH="$2"
            shift 2
            ;;
        -k)
            KEY="$2"
            shift 2
            ;;        
        -c)
            CRT="$2"
            shift 2
            ;;        
        --country)
            C="$2"
            shift 2
            ;;        
        --state)
            ST="$2"
            shift 2
            ;;        
        --city)
            L="$2"
            shift 2
            ;;        
        --corp)
            O="$2"
            shift 2
            ;;        
        --status)
            OU="$2"
            shift 2
            ;;        
        --domaine)
            CN="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Unvalid options: $1"
            exit 1
            ;;
    esac
done

#~~~~~~~~~~~~~~~~~CREATION SSL CERTIFICATES~~~~~~~~~~~~~~~~~
#create directory for certs
if [ ! -d ${SSL_PATH} ]; then
    mkdir -p ${SSL_PATH}
    echo "${SSL_PATH} directory created"
fi
if  [ ! -f ${SSL_PATH}/${KEY} ]; then
    #generate SSL certs
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ${SSL_PATH}/${KEY} \
        -out ${SSL_PATH}/${CRT} \
        -subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${CN}"
    echo "SSL certs created"
else
    echo "SSL certs already exists"
fi
