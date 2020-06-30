LOAD DATA
	INFILE data.txt	 --имя файла с данными
	INTO TABLE LOAD_DATA 	--имя таблицы  
	 REPLACE 	-- метод загрузки
--задается что разделителем является “;”
	FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
	(
	t1,
	t2,
	t3
	)
