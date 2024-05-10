last_backup=`ls backups/ | grep backup_at_ | tail -1`;

cp -r backups/$last_backup/* ~/;

cd yqi56/pg_tblspc;

ln -s ../../uzb16 16388;
ln -s ../../mwd84 16389;
ln -s ../../orw97 16390;

cd ../..;

pg_ctl start -D yqi56/ || pg_ctl restart -D yqi56/;

