reserve_node='postgres2@pg191';
last_backup=`ssh ${reserve_node} "ls backups/ | grep backup_at_ | tail -1"`;
db_copy_dir='yqi56'
db_put_dir='yqi56'

echo "Загрузка резервной копии: ${last_backup}"

mkdir $db_put_dir;
rsync -avv $reserve_node:~/backups/$last_backup/$db_copy_dir/ $db_put_dir &&
echo "Директория основных файлов БД загружена" || 
echo "Не удалось загрузить директорию основных файлов БД";

mkdir uzb16;
rsync -avv $reserve_node:~/backups/$last_backup/uzb16/ uzb16 &&
echo "Директория файлов таблицы 'street' загружена" || 
echo "Не удалось загрузить директорию файлов таблицы 'street'";

rsync -avv $reserve_node:~/backups/$last_backup/mwd84/ mwd84;
rsync -avv $reserve_node:~/backups/$last_backup/orw97/ orw97;

pg_ctl start -D $db_put_dir/ || pg_ctl restart -D $db_put_dir/;

