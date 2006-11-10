#!/bin/sh



#Script that copies the hostfiles to all the nodes indicating that
#the slave should be used as db host
#
#First it marks the slave mysql database as master.


#Set default home if not already set.
SYSCHECK_HOME=${SYSCHECK_HOME:-"/usr/local/syscheck"}

# Import common resources
. $SYSCHECK_HOME/resources.sh


$MYSQL_BIN -u root --password="$MYSQLROOT_PASSWORD" < $CLUSTERSCRIPT_HOME/makeMaster.sql

# Copy the hostfiles
cp $CLUSTERSCRIPT_HOME/ejbca-ds-node2.xml.templ $CLUSTERSCRIPT_HOME/ejbca-ds-node2.xml
perl -pi -e "s/HOSTNAME_NODE2/$HOSTNAME_NODE2/g" $CLUSTERSCRIPT_HOME/ejbca-ds-node2.xml
perl -pi -e "s/DB_USER/$DB_USER/g" $CLUSTERSCRIPT_HOME/ejbca-ds-node2.xml
perl -pi -e "s/DB_PASSWORD/$DB_PASSWORD/g" $CLUSTERSCRIPT_HOME/ejbca-ds-node2.xml

cp $CLUSTERSCRIPT_HOME/ejbca-ds-node2.xml /usr/local/jboss/server/default/deploy/ejbca-ds.xml
chown jboss:jboss /usr/local/jboss/server/default/deploy/ejbca-ds.xml 
scp $CLUSTERSCRIPT_HOME/ejbca-ds-node2.xml $SSH_USER@$HOSTNAME_NODE1:/usr/local/jboss/server/default/deploy/ejbca-ds.xml
ssh $SSH_USER@$HOSTNAME_NODE1 chown jboss:jboss /usr/local/jboss/server/default/deploy/ejbca-ds.xml

 
cp $EJBCA_HOME/dist/ejbca.ear $JBOSS_HOME/server/default/deploy/ejbca.ear
chown jboss:jboss /usr/local/jboss/server/default/deploy/ejbca.ear
scp $EJBCA_HOME/dist/ejbca.ear $SSH_USER@$HOSTNAME_NODE1:$JBOSS_HOME/server/default/deploy/ejbca.ear
ssh $SSH_USER@$HOSTNAME_NODE1 chown jboss:jboss /usr/local/jboss/server/default/deploy/ejbca.ear

sleep 20

$CLUSTERSCRIPT_HOME/activateCAs.sh
