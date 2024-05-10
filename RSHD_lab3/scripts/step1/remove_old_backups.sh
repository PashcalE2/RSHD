copies_count=`ls backups/ | grep backup_at_ | wc -l`;
max_copies_count=14;
remove_count=$(( $copies_count - $max_copies_count ));

echo "Количество холодных копий: $(( $copies_count ))";

if (( $remove_count <= 0 )); then
	echo "Еще можно создать копий: $(( -$remove_count ))"
else
	echo "Количество копий для удаления: ${remove_count}";
	
	while (( $remove_count > 0 )); do
		oldest_copy=`ls backups/ | grep backup_at_ | head -1`;
		
		rm -rf backups/$oldest_copy && 
		echo "Копия ${oldest_copy} успешно удалена" || 
		echo "Не удалось удалить копию ${oldest_copy}";
		
		remove_count=$(( $remove_count-- ))
	done;
fi;

echo "Скрипт удаления старых копий завершил работу";

