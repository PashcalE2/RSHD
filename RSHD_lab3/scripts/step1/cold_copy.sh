reserve_node='postgres2@pg191';
now_date=$(date "+%Y-%m-%d_%H-%M-%S");
new_backup="backup_at_${now_date}";

pg_ctl stop -D ~/yqi56;

rsync -avv ~/yqi56 ~/uzb16 ~/mwd84 ~/orw97 $reserve_node:~/backups/$new_backup;

pg_ctl start -D ~/yqi56 || pg_ctl restart -D ~/yqi56;

ssh $reserve_node "bash ~/remove_old_backups.sh";

echo "Скрипт холодного копирования завершил работу";

