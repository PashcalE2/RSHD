PGDATA=$HOME/yqi56
PGLOCALE=ru_RU.CP1251
PGENCODE=WIN1251
PGUSERNAME=postgres6
PGHOST=pg100
export PGDATA PGLOCALE PGENCODE PGUSERNAME PGHOST

mkdir $PGDATA

initdb --locale=$PGLOCALE --encoding=$PGENCODE --username=$PGUSERNAME

pg_ctl -D /var/db/postgres6/yqi56 -l logfile start

