#!/bin/bash
#==========================================================================
#  Unset quotas for main Nova and Neutron resources for a tenant
#  with name $OS_TENANT_NAME.
#  Neutron quotas: floatingip, network, port, router, security-group,
#  security-group-rule subnet.
#  Nova quotas: cores, instances, ram, server-groups, server-group-members.
#
#  Usage: unset_quotas.sh
#==========================================================================

TENANT=
DOMAIN=
ROLE=
USER=
QUOTA_FILE=

function prepare_openstack_tenant
{
    local xtrace
    xtrace=$(set +o | grep xtrace)
    set -o xtrace
    
    # create a role
    if [ ! "$(openstack role show $ROLE 2>/dev/null)" ]; then
        openstack role create ${ROLE}
        [[ $? -ne 0 ]] && die $LINENO "create role ${ROLE} failed"
    fi
   
    if [ x"$DOMAIN" = x"" ]; then
        DOMAIN="default"
    fi

    if [ ! "$openstack domain show $DOMAIN 2>/dev/null"  ]; then
        openstack domain create $DOMAIN
        [[ $? -ne 0 ]] && die $LINENO "create domain ${DOMAIN} failed"
    fi 

    # create a tenant
    if [ ! "$(openstack project show $TENANT 2>/dev/null)" ]; then
        openstack project create --domain ${DOMAIN} --description "$TENANT \
            Project" ${TENANT}
        [[ $? -ne 0 ]] && die $LINENO "create $TENANT project failed"
    fi

    random_passwd=$(openssl rand -base64 10)
    # create a user
    if [ ! "$(openstack user show $USER 2>/dev/null)" ]; then
        openstack user create --domain ${DOMAIN} --password ${random_passwd} \
            ${USER}
        [[ $? -ne 0 ]] && die $LINENO "create $USER user failed"
        openstack role add --project ${TENANT} --user ${USER} \
            ${ROLE}
        [[ $? -ne 0 ]] && die $LINENO "add role for ${TENANT} project failed"
    else
        echo "User $USER has been exists"
    fi

    openstack project list
    project_id=$(openstack project show ${TENANT} -c id -f value)
    
    $xtrace
    echo -e "\033[41;37m"
    echo "The project_id is: $project_id "
    echo "user name is: $USER"
    echo "user password is: $random_passwd"
    echo -e "\033[0m"
}

Usage() {
cat << EOF
###################################################################
# mkdeploydisk.sh usage
###################################################################
Usage: mkdeploydisk.sh [OPTION]... [--OPTION=VALUE]...
    -h, --help              display this help and exit
    --user=xxx            user name to use the project
    --role=xxx            show the user's role in the project, 'user' or 'admin'
    --project=xxx         show the project the user will use
    --domain=xxx          show which domain the user belongs. if not set, use 'default'

for example:
    ./create_project.sh --user=test --role=user --project=test2 --domain=default
EOF
}

###################################################################################
# Get parameters
###################################################################################
while test $# != 0
do
    case $1 in
        --*=*) ac_option=`expr "X$1" : 'X\([^=]*\)='` ; ac_optarg=`expr "X$1" : 'X[^=]*=\(.*\)'` ; ac_shift=:
            ;;  
        *) ac_option=$1 ; ac_optarg=$2 ; ac_shift=shift
            ;;  
    esac

    case $ac_option in
        -h | --help) Usage ; exit ;;
        --user) USER=$ac_optarg ;;
        --role) ROLE=$ac_optarg ;;
        --project) TENANT=$ac_optarg ;;
        --domain) DOMAIN=$ac_optarg ;;
        *) echo "Unknow option $ac_option!" ; Usage ; exit 1 ;;
    esac

    shift
    ${ac_shift}
done

if [ x"$DOMAIN" = x""  ]; then
    DOMAIN="default"
fi
if [ x"$ROLE" = x"" ]; then
    ROLE="user"
fi

if [ x"$USER" = x"" ]  || [ x"$TENANT" = x"" ]; then
    echo "the user and tenant name can not be empty"
    Usage
    exit 1
fi

prepare_openstack_tenant

##############################
# get the nova-admin.rc file
##############################
unset OS_PROJECT_ID
unset OS_PROJECT_NAME
unset OS_USER_DOMAIN_NAME
unset OS_USERNAME
unset OS_PASSWORD
unset OS_REGION_NAME
unset OS_INTERFACE
unset OS_IDENTITY_API_VERSION

set -e
function set_quota_of_tenent()
{
    NEUTRON_QUOTAS=(floatingip network port router security-group security-group-rule subnet)
    NOVA_QUOTAS=(cores instances ram server-groups server-group-members)

    OS_TENANT_ID=$(openstack project show $OS_TENANT_NAME -c id -f value)

    echo "Unsetting Neutron quotas: ${NEUTRON_QUOTAS[@]}"
    for net_quota in ${NEUTRON_QUOTAS[@]}
    do
        neutron quota-update --"$net_quota" -1 $OS_TENANT_ID
    done

    echo "Unsetting Nova quotas: ${NOVA_QUOTAS[@]}"
    for nova_quota in ${NOVA_QUOTAS[@]}
    do
        nova quota-update --"$nova_quota" -1 $OS_TENANT_ID
    done

    echo "Successfully unset all quotas"
    openstack quota show $OS_TENANT_ID
}
