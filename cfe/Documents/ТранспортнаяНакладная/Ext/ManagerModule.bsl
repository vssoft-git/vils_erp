﻿
&Вместо("ПолучитьДанныеДляПечатнойФормыТранспортнаяНакладная")
Функция ВИЛС_ПолучитьДанныеДляПечатнойФормыТранспортнаяНакладная(ТаблицаНакладных)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаНакладных.ТранспортнаяНакладная КАК ТранспортнаяНакладная,
	|	ТаблицаНакладных.ПорядковыйНомер КАК ПорядковыйНомер
	|ПОМЕСТИТЬ ТаблицаТранспортныхНакладныхБезОснований
	|ИЗ
	|	&ТаблицаНакладных КАК ТаблицаНакладных
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаНакладных.ТранспортнаяНакладная КАК Документ.ТранспортнаяНакладная) КАК ТранспортнаяНакладная,
	|	ТаблицаНакладных.ПорядковыйНомер КАК ПорядковыйНомер,
	|	ТранспортнаяНакладнаяДокументыОснования.ДокументОснование КАК ДокументОснование,
	|	ТранспортнаяНакладнаяДокументыОснования.ДокументОснование.Проведен КАК ДокументОснованиеПроведен,
	|	ТранспортнаяНакладнаяДокументыОснования.НомерСтроки КАК НомерСтрокиВТранспортнойНакладной
	|ПОМЕСТИТЬ ТаблицаТранспортныхНакладных
	|ИЗ
	|	ТаблицаТранспортныхНакладныхБезОснований КАК ТаблицаНакладных
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТранспортнаяНакладная.ДокументыОснования КАК ТранспортнаяНакладнаяДокументыОснования
	|		ПО ТаблицаНакладных.ТранспортнаяНакладная = ТранспортнаяНакладнаяДокументыОснования.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная КАК Ссылка,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Номер КАК Номер,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Дата КАК Дата,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Организация КАК Организация,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Грузополучатель КАК Грузополучатель,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Грузоотправитель КАК Грузоотправитель,	
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.ЗаказчикПеревозки КАК ЗаказчикПеревозки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.БанковскийСчетЗаказчикаПеревозки КАК БанковскийСчетЗаказчикаПеревозки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Отпустил КАК Кладовщик,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.ОтпустилДолжность КАК ДолжностьКладовщика,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Перевозчик КАК Перевозчик,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Водитель КАК Водитель,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.ВидПеревозки КАК ВидПеревозки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АвтомобильМарка КАК МаркаАвтомобиля,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АвтомобильГосударственныйНомер КАК ГосНомерАвтомобиля,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АдресПогрузки КАК ПунктПогрузки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АдресДоставки КАК ПунктРазгрузки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.СрокДоставки КАК СрокДоставки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АвтомобильГрузоподъемностьВТоннах КАК ГрузоподъемностьВТоннахАвтомобиля,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АвтомобильВместимостьВКубическихМетрах КАК ВместимостьВКубическихМетрахАвтомобиля,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АвтомобильТип КАК ТипАвтомобиля,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.МассаБрутто КАК МассаБрутто,
	|	ТаблицаТранспортныхНакладных.ПорядковыйНомер,
	|	НЕ МИНИМУМ(ТаблицаТранспортныхНакладных.ДокументОснованиеПроведен) КАК ЕстьНепроведенныеДокументыОснования
	|ИЗ
	|	ТаблицаТранспортныхНакладных КАК ТаблицаТранспортныхНакладных
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Номер,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Дата,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Организация,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Грузополучатель,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Грузоотправитель,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.ЗаказчикПеревозки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.БанковскийСчетЗаказчикаПеревозки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Отпустил,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.ОтпустилДолжность,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Перевозчик,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.Водитель,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.ВидПеревозки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АвтомобильМарка,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АвтомобильГосударственныйНомер,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АдресПогрузки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АдресДоставки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.СрокДоставки,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АвтомобильГрузоподъемностьВТоннах,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АвтомобильВместимостьВКубическихМетрах,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.АвтомобильТип,
	|	ТаблицаТранспортныхНакладных.ТранспортнаяНакладная.МассаБрутто,
	|	ТаблицаТранспортныхНакладных.ПорядковыйНомер
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаТранспортныхНакладных.ПорядковыйНомер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВнутреннийЗапрос.Ссылка,
	|	ВнутреннийЗапрос.ПорядковыйНомер,
	|   ЕСТЬNULL(ВнутреннийЗапрос.КоличествоУпаковок, 0) 	КАК КоличествоУпаковок,      	// begin fix Suetin 20.02.2019 15:49:44
	|   ВнутреннийЗапрос.Упаковка 							КАК Упаковка,                   // end fix Suetin 20.02.2019 15:49:52
	|	ВнутреннийЗапрос.НаименованиеВидаНоменклатуры
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДокументыОснования.ТранспортнаяНакладная КАК Ссылка,
	|		ДокументыОснования.ПорядковыйНомер КАК ПорядковыйНомер,
	|       ЕСТЬNULL(ДокументТовары.КоличествоУпаковок, 0) 	КАК КоличествоУпаковок,      	// begin fix Suetin 20.02.2019 15:49:44
	|       ВЫБОР
	|			КОГДА ДокументТовары.Номенклатура.ИспользоватьУпаковки
	|				ТОГДА ДокументТовары.Упаковка
	|			ИНАЧЕ ДокументТовары.Номенклатура.ЕдиницаИзмерения
	|		КОНЕЦ 	 										КАК Упаковка,                   // end fix Suetin 20.02.2019 15:49:52
	|		ВЫБОР
	|			КОГДА ВидыНоменклатуры.ИспользоватьИндивидуальноеНаименованиеПриПечати
	|				И НЕ ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """") = """"    	// begin fix Suetin 14.02.2019 14:30:35
	|				ТОГДА ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """")
	|			КОГДА НЕ ЕСТЬNULL(ДокументТовары.Номенклатура, """") = """"    
	|				ТОГДА ЕСТЬNULL(ДокументТовары.Номенклатура, """")       				// end fix Suetin 14.02.2019 14:31:46
	|			ИНАЧЕ &НаименованиеДляПечатиВидовНоменклатуры
	|		КОНЕЦ КАК НаименованиеВидаНоменклатуры
	|	ИЗ
	|		ТаблицаТранспортныхНакладных КАК ДокументыОснования
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров.Товары КАК ДокументТовары
	|			ПО ДокументыОснования.ДокументОснование = ДокументТовары.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|			ПО (ВидыНоменклатуры.Ссылка = ДокументТовары.Номенклатура.ВидНоменклатуры)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДокументыОснования.ТранспортнаяНакладная,
	|		ДокументыОснования.ПорядковыйНомер,
	|       ЕСТЬNULL(ДокументТовары.КоличествоУпаковок, 0) 	КАК КоличествоУпаковок,      	// begin fix Suetin 20.02.2019 15:49:44
	|       ВЫБОР
	|			КОГДА ДокументТовары.Номенклатура.ИспользоватьУпаковки
	|				ТОГДА ДокументТовары.Упаковка
	|			ИНАЧЕ ДокументТовары.Номенклатура.ЕдиницаИзмерения
	|		КОНЕЦ 	 										КАК Упаковка,                   // end fix Suetin 20.02.2019 15:49:52
	|		ВЫБОР
	|			КОГДА ВидыНоменклатуры.ИспользоватьИндивидуальноеНаименованиеПриПечати
	|				И НЕ ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """") = """"    	// begin fix Suetin 14.02.2019 14:30:35
	|				ТОГДА ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """")
	|			КОГДА НЕ ЕСТЬNULL(ДокументТовары.Номенклатура, """") = """"    
	|				ТОГДА ЕСТЬNULL(ДокументТовары.Номенклатура, """")       				// end fix Suetin 14.02.2019 14:31:46
	|			ИНАЧЕ &НаименованиеДляПечатиВидовНоменклатуры
	|		КОНЕЦ
	|	ИЗ
	|		ТаблицаТранспортныхНакладных КАК ДокументыОснования
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратТоваровПоставщику.Товары КАК ДокументТовары
	|			ПО ДокументыОснования.ДокументОснование = ДокументТовары.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|			ПО (ВидыНоменклатуры.Ссылка = ДокументТовары.Номенклатура.ВидНоменклатуры)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДокументыОснования.ТранспортнаяНакладная,
	|		ДокументыОснования.ПорядковыйНомер,
	|       ЕСТЬNULL(ДокументТовары.КоличествоУпаковок, 0) 	КАК КоличествоУпаковок,      	// begin fix Suetin 20.02.2019 15:49:44
	|       ВЫБОР
	|			КОГДА ДокументТовары.Номенклатура.ИспользоватьУпаковки
	|				ТОГДА ДокументТовары.Упаковка
	|			ИНАЧЕ ДокументТовары.Номенклатура.ЕдиницаИзмерения
	|		КОНЕЦ 	 										КАК Упаковка,                   // end fix Suetin 20.02.2019 15:49:52
	|		ВЫБОР
	|			КОГДА ВидыНоменклатуры.ИспользоватьИндивидуальноеНаименованиеПриПечати
	|				И НЕ ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """") = """"    	// begin fix Suetin 14.02.2019 14:30:35
	|				ТОГДА ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """")
	|			КОГДА НЕ ЕСТЬNULL(ДокументТовары.Номенклатура, """") = """"    
	|				ТОГДА ЕСТЬNULL(ДокументТовары.Номенклатура, """")       				// end fix Suetin 14.02.2019 14:31:46
	|			ИНАЧЕ &НаименованиеДляПечатиВидовНоменклатуры
	|		КОНЕЦ
	|	ИЗ
	|		ТаблицаТранспортныхНакладных КАК ДокументыОснования
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КорректировкаРеализации.Товары КАК ДокументТовары
	|			ПО ДокументыОснования.ДокументОснование = ДокументТовары.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|			ПО (ВидыНоменклатуры.Ссылка = ДокументТовары.Номенклатура.ВидНоменклатуры)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
//++ НЕ УТКА
	|	
	|	ВЫБРАТЬ
	|		ДокументыОснования.ТранспортнаяНакладная,
	|		ДокументыОснования.ПорядковыйНомер,
	|       ЕСТЬNULL(ДокументТовары.КоличествоУпаковок, 0) 	КАК КоличествоУпаковок,      	// begin fix Suetin 20.02.2019 15:49:44
	|       ВЫБОР
	|			КОГДА ДокументТовары.Номенклатура.ИспользоватьУпаковки
	|				ТОГДА ДокументТовары.Упаковка
	|			ИНАЧЕ ДокументТовары.Номенклатура.ЕдиницаИзмерения
	|		КОНЕЦ 	 										КАК Упаковка,                   // end fix Suetin 20.02.2019 15:49:52
	|		ВЫБОР
	|			КОГДА ВидыНоменклатуры.ИспользоватьИндивидуальноеНаименованиеПриПечати
	|				И НЕ ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """") = """"    	// begin fix Suetin 14.02.2019 14:30:35
	|				ТОГДА ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """")
	|			КОГДА НЕ ЕСТЬNULL(ДокументТовары.Номенклатура, """") = """"    
	|				ТОГДА ЕСТЬNULL(ДокументТовары.Номенклатура, """")       				// end fix Suetin 14.02.2019 14:31:46
	|			ИНАЧЕ &НаименованиеДляПечатиВидовНоменклатуры
	|		КОНЕЦ
	|	ИЗ
	|		ТаблицаТранспортныхНакладных КАК ДокументыОснования
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПередачаДавальцу.Товары КАК ДокументТовары
	|			ПО ДокументыОснования.ДокументОснование = ДокументТовары.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|			ПО (ВидыНоменклатуры.Ссылка = ДокументТовары.Номенклатура.ВидНоменклатуры)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
//-- НЕ УТКА
//++ НЕ УТ
	|	
	|	ВЫБРАТЬ
	|		ДокументыОснования.ТранспортнаяНакладная,
	|		ДокументыОснования.ПорядковыйНомер,
	|       ЕСТЬNULL(ДокументТовары.КоличествоУпаковок, 0) 	КАК КоличествоУпаковок,      	// begin fix Suetin 20.02.2019 15:49:44
	|       ВЫБОР
	|			КОГДА ДокументТовары.Номенклатура.ИспользоватьУпаковки
	|				ТОГДА ДокументТовары.Упаковка
	|			ИНАЧЕ ДокументТовары.Номенклатура.ЕдиницаИзмерения
	|		КОНЕЦ 	 										КАК Упаковка,                   // end fix Suetin 20.02.2019 15:49:52
	|		ВЫБОР
	|			КОГДА ВидыНоменклатуры.ИспользоватьИндивидуальноеНаименованиеПриПечати
	|				И НЕ ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """") = """"    	// begin fix Suetin 14.02.2019 14:30:35
	|				ТОГДА ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """")
	|			КОГДА НЕ ЕСТЬNULL(ДокументТовары.Номенклатура, """") = """"    
	|				ТОГДА ЕСТЬNULL(ДокументТовары.Номенклатура, """")       				// end fix Suetin 14.02.2019 14:31:46
	|			ИНАЧЕ &НаименованиеДляПечатиВидовНоменклатуры
	|		КОНЕЦ
	|	ИЗ
	|		ТаблицаТранспортныхНакладных КАК ДокументыОснования
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтгрузкаТоваровСХранения.Товары КАК ДокументТовары
	|			ПО ДокументыОснования.ДокументОснование = ДокументТовары.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|			ПО (ВидыНоменклатуры.Ссылка = ДокументТовары.Номенклатура.ВидНоменклатуры)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДокументыОснования.ТранспортнаяНакладная,
	|		ДокументыОснования.ПорядковыйНомер,
	|       ЕСТЬNULL(ДокументТовары.КоличествоУпаковок, 0) 	КАК КоличествоУпаковок,      	// begin fix Suetin 20.02.2019 15:49:44
	|       ВЫБОР
	|			КОГДА ДокументТовары.Номенклатура.ИспользоватьУпаковки
	|				ТОГДА ДокументТовары.Упаковка
	|			ИНАЧЕ ДокументТовары.Номенклатура.ЕдиницаИзмерения
	|		КОНЕЦ 	 										КАК Упаковка,                   // end fix Suetin 20.02.2019 15:49:52
	|		ВЫБОР
	|			КОГДА ВидыНоменклатуры.ИспользоватьИндивидуальноеНаименованиеПриПечати
	|				И НЕ ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """") = """"    	// begin fix Suetin 14.02.2019 14:30:35
	|				ТОГДА ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """")
	|			КОГДА НЕ ЕСТЬNULL(ДокументТовары.Номенклатура, """") = """"    
	|				ТОГДА ЕСТЬNULL(ДокументТовары.Номенклатура, """")       				// end fix Suetin 14.02.2019 14:31:46
	|			ИНАЧЕ &НаименованиеДляПечатиВидовНоменклатуры
	|		КОНЕЦ
	|	ИЗ
	|		ТаблицаТранспортныхНакладных КАК ДокументыОснования
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПередачаСырьяПереработчику.Товары КАК ДокументТовары
	|			ПО ДокументыОснования.ДокументОснование = ДокументТовары.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|			ПО (ВидыНоменклатуры.Ссылка = ДокументТовары.Номенклатура.ВидНоменклатуры)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
//-- НЕ УТ
//++ НЕ УТКА
	|	
	|	ВЫБРАТЬ
	|		ДокументыОснования.ТранспортнаяНакладная,
	|		ДокументыОснования.ПорядковыйНомер,
	|       ЕСТЬNULL(ДокументТовары.КоличествоУпаковок, 0) 	КАК КоличествоУпаковок,      	// begin fix Suetin 20.02.2019 15:49:44
	|       ВЫБОР
	|			КОГДА ДокументТовары.Номенклатура.ИспользоватьУпаковки
	|				ТОГДА ДокументТовары.Упаковка
	|			ИНАЧЕ ДокументТовары.Номенклатура.ЕдиницаИзмерения
	|		КОНЕЦ 	 										КАК Упаковка,                   // end fix Suetin 20.02.2019 15:49:52
	|		ВЫБОР
	|			КОГДА ВидыНоменклатуры.ИспользоватьИндивидуальноеНаименованиеПриПечати
	|				И НЕ ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """") = """"    	// begin fix Suetin 14.02.2019 14:30:35
	|				ТОГДА ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """")
	|			КОГДА НЕ ЕСТЬNULL(ДокументТовары.Номенклатура, """") = """"    
	|				ТОГДА ЕСТЬNULL(ДокументТовары.Номенклатура, """")       				// end fix Suetin 14.02.2019 14:31:46
	|			ИНАЧЕ &НаименованиеДляПечатиВидовНоменклатуры
	|		КОНЕЦ
	|	ИЗ
	|		ТаблицаТранспортныхНакладных КАК ДокументыОснования
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратСырьяДавальцу.Товары КАК ДокументТовары
	|			ПО ДокументыОснования.ДокументОснование = ДокументТовары.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|			ПО (ВидыНоменклатуры.Ссылка = ДокументТовары.Номенклатура.ВидНоменклатуры)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
//-- НЕ УТКА
	|
	|	ВЫБРАТЬ
	|		ДокументыОснования.ТранспортнаяНакладная,
	|		ДокументыОснования.ПорядковыйНомер,
	|       ЕСТЬNULL(ДокументТовары.КоличествоУпаковок, 0) 	КАК КоличествоУпаковок,      	// begin fix Suetin 20.02.2019 15:49:44
	|       ВЫБОР
	|			КОГДА ДокументТовары.Номенклатура.ИспользоватьУпаковки
	|				ТОГДА ДокументТовары.Упаковка
	|			ИНАЧЕ ДокументТовары.Номенклатура.ЕдиницаИзмерения
	|		КОНЕЦ 	 										КАК Упаковка,                   // end fix Suetin 20.02.2019 15:49:52
	|		ВЫБОР
	|			КОГДА ВидыНоменклатуры.ИспользоватьИндивидуальноеНаименованиеПриПечати
	|				И НЕ ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """") = """"    	// begin fix Suetin 14.02.2019 14:30:35
	|				ТОГДА ЕСТЬNULL(ВидыНоменклатуры.НаименованиеДляПечати, """")
	|			КОГДА НЕ ЕСТЬNULL(ДокументТовары.Номенклатура, """") = """"    
	|				ТОГДА ЕСТЬNULL(ДокументТовары.Номенклатура, """")       				// end fix Suetin 14.02.2019 14:31:46
	|			ИНАЧЕ &НаименованиеДляПечатиВидовНоменклатуры
	|		КОНЕЦ
	|	ИЗ
	|		ТаблицаТранспортныхНакладных КАК ДокументыОснования
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК ДокументТовары
	|			ПО ДокументыОснования.ДокументОснование = ДокументТовары.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|			ПО (ВидыНоменклатуры.Ссылка = ДокументТовары.Номенклатура.ВидНоменклатуры)) КАК ВнутреннийЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВнутреннийЗапрос.ПорядковыйНомер,
	|	ВнутреннийЗапрос.НаименованиеВидаНоменклатуры
	// begin fix Suetin 14.02.2019 11:59:58
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТТН.ТранспортнаяНакладная 				КАК ТранспортнаяНакладная,
	|	ТТН.ТранспортнаяНакладная.Руководитель 	КАК Руководитель,
	|	ТТН.ПорядковыйНомер 					КАК ПорядковыйНомер,
	|	ТТН.ДокументОснование 					КАК ДокументОснование,
	|	ТТН.ДокументОснованиеПроведен 			КАК ДокументОснованиеПроведен,
	|	ТТН.ДокументОснование.Номер 			КАК Номер,
	|	ТТН.ДокументОснование.Дата 				КАК Дата
	|ИЗ
	|	ТаблицаТранспортныхНакладных КАК ТТН
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТТН.ПорядковыйНомер
	|";
	// end fix Suetin 14.02.2019 12:00:09
	Запрос.УстановитьПараметр("ТаблицаНакладных", ТаблицаНакладных);
	Запрос.УстановитьПараметр("НаименованиеДляПечатиВидовНоменклатуры", Константы.НаименованиеДляПечатиВидовНоменклатуры.Получить());
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ТаблицаРезультата", РезультатЗапроса[2].Выгрузить());
	СтруктураРезультата.Вставить("РезультатИменаТоваров", РезультатЗапроса[3]);
	// begin fix Suetin 14.02.2019 12:05:32	
	СтруктураРезультата.Вставить("ТаблицаНомеровДокументов", РезультатЗапроса[4]);
	// end fix Suetin 14.02.2019 12:05:40	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СтруктураРезультата
	
КонецФункции
