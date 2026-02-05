# Postavi Moove kao default temu
php admin/cli/cfg.php --component=core --name=theme --set=moove

# Omogući completion tracking globalno
php admin/cli/cfg.php --component=core --name=enablecompletion --set=1

# Postavi podrazumevani format kursa na Tiles (ako je instaliran)
php admin/cli/cfg.php --component=moodle --name=format --set=tiles