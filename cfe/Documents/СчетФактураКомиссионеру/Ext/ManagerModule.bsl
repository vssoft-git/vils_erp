
&ИзменениеИКонтроль("ТекстЗапросаДанныхШапкиДляПечатиСчетаФактуры")
Функция ВИЛС_ТекстЗапросаДанныхШапкиДляПечатиСчетаФактуры(ПараметрыПечати)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СчетаФактурыОснования.Ссылка КАК Ссылка,
	|	ДанныеОснований.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеОснований.НалогообложениеНДС КАК НалогообложениеНДС,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(ДанныеОрганизацийПоставщик.ОбособленноеПодразделение, ЛОЖЬ) ТОГДА
	|		ДанныеОрганизацийПоставщик.ГоловнаяОрганизация
	|	ИНАЧЕ
	|		ДанныеСчетаФактуры.Организация
	|	КОНЕЦ КАК Организация,
	|	
	|	ВЫБОР КОГДА ДанныеОснований.Грузоотправитель = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ТОГДА
	|		ДанныеСчетаФактуры.Организация
	|	ИНАЧЕ
	|		ДанныеОснований.Грузоотправитель
	|	КОНЕЦ КАК Грузоотправитель,
	|
	|	ВЫБОР КОГДА НЕ ДанныеПодразделений.РегистрацияВНалоговомОргане ЕСТЬ NULL ТОГДА
	|		ДанныеПодразделений.РегистрацияВНалоговомОргане.ЦифровойИндексОбособленногоПодразделения
	|	КОГДА ЕСТЬNULL(ДанныеОрганизацийПоставщик.ОбособленноеПодразделение, ЛОЖЬ) ТОГДА
	|		ДанныеОрганизацийПоставщик.ЦифровойИндексОбособленногоПодразделения
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК ЦифровойИндекс,
	|
	|	ВЫБОР КОГДА НЕ ДанныеПодразделений.РегистрацияВНалоговомОргане ЕСТЬ NULL ТОГДА
	|		ДанныеПодразделений.РегистрацияВНалоговомОргане.КПП
	|	ИНАЧЕ
	|		ДанныеОрганизацийПоставщик.КПП
	|	КОНЕЦ КАК КПППоставщика,
	|
	|	ДанныеОрганизацийПоставщик.Префикс КАК Префикс,
	|	ДанныеСчетаФактуры.Комиссионер КАК Комиссионер,
#Вставка
	|	ВЫБОР КОГДА ДанныеОснований.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) ТОГДА
	|		ДанныеСчетаФактуры.Договор
	|	ИНАЧЕ
	|		ДанныеОснований.Договор
	|	КОНЕЦ КАК Договор,
	//|	ВЫБОР   // fix Suetin 19.03.2020 16:48:23 НА БУДУЩЕЕ
	//|	КОГДА ДанныеОснований.Договор ССЫЛКА Справочник.ДоговорыКонтрагентов
	//|			И НЕ ДанныеОснований.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) ТОГДА
	//|		ДанныеОснований.Договор
	//|	КОГДА ДанныеОснований.Договор ССЫЛКА Справочник.ДоговорыМеждуОрганизациями
	//|			И НЕ ДанныеОснований.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыМеждуОрганизациями.ПустаяСсылка) ТОГДА
	//|		ДанныеОснований.Договор
	//|	ИНАЧЕ
	//|		ДанныеСчетаФактуры.Договор
	//|	КОНЕЦ КАК Договор,
#КонецВставки	
	|	ДанныеВалюты.Ссылка КАК Валюта,
	|	ДанныеВалюты.НаименованиеПолное КАК ВалютаНаименованиеПолное,
	|	ДанныеВалюты.Код КАК ВалютаКод,
	|//РеквизитыОснованийДляУПД
	|	ВЫБОР
	|		КОГДА НЕ ДанныеОснований.РасчетыЧерезОтдельногоКонтрагента
	|			ИЛИ ДанныеСчетаФактуры.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|		ТОГДА ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ПечататьСчетФактуру
	|
	|ПОМЕСТИТЬ ДанныеОснований
	|ИЗ
	|	СчетаФактурыОснования КАК СчетаФактурыОснования
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураКомиссионеру КАК ДанныеСчетаФактуры
	|	ПО ДанныеСчетаФактуры.Ссылка = СчетаФактурыОснования.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеОснований
	|	ПО СчетаФактурыОснования.ДокументОснование = ДанныеОснований.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ДанныеОрганизацийПоставщик
	|	ПО ДанныеСчетаФактуры.Организация = ДанныеОрганизацийПоставщик.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацииВНалоговомОргане КАК ДанныеПодразделений
	|	ПО ДанныеПодразделений.Организация = ДанныеСчетаФактуры.Организация
	|		И ДанныеПодразделений.Подразделение = ДанныеОснований.Подразделение
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Валюты КАК ДанныеВалюты
	|	ПО ДанныеОснований.Валюта = ДанныеВалюты.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                                КАК Ссылка,
	|	ВЫБОР 
	|		КОГДА ДанныеДокумента.Организация <> ДанныеОснований.Комиссионер ТОГДА
	|			&ПредставлениеСчетФактураКомиссионера
	|		ИНАЧЕ &ПредставлениеСчетФактура
	|	КОНЕЦ                                                 КАК ПредставлениеДокумента,
	|	ДанныеДокумента.Номер                                 КАК Номер,
	|	ВЫБОР КОГДА ДанныеДокумента.Исправление ТОГДА
	|		ЕСТЬNULL(ДанныеДокумента.СчетФактураОснование.Дата, ДАТАВРЕМЯ(1,1,1))
	|	ИНАЧЕ 
	|		ДанныеДокумента.Дата
	|	КОНЕЦ                                                 КАК Дата,
	|	ВЫБОР КОГДА ДанныеДокумента.Исправление ТОГДА
	|		ДанныеДокумента.НомерИсправления 
	|	ИНАЧЕ
	|		НЕОПРЕДЕЛЕНО
	|	КОНЕЦ                                                 КАК НомерИсправления,
	|	ВЫБОР КОГДА ДанныеДокумента.Исправление ТОГДА
	|		ДанныеДокумента.Дата
	|	ИНАЧЕ
	|		НЕОПРЕДЕЛЕНО
	|	КОНЕЦ                                                 КАК ДатаИсправления,
	|	ДанныеДокумента.Исправление                           КАК Исправление,
	|	ЛОЖЬ                                                  КАК КорректировочныйСчетФактура,
	|	ДанныеДокумента.СтрокаПлатежноРасчетныеДокументы      КАК СтрокаПоДокументу,
	|	ДанныеДокумента.Валюта                                КАК ВалютаСчетаФактуры,
	|	ДанныеОснований.Организация                           КАК Организация,
	|	ДанныеОснований.НалогообложениеНДС                    КАК НалогообложениеНДС,
	|	ДанныеОснований.КПППоставщика                         КАК КПППоставщика,
	|	ДанныеОснований.Грузоотправитель                      КАК Грузоотправитель,
#Вставка
	|	ДанныеОснований.Договор 							  КАК Договор,
#КонецВставки	
	|	ДанныеОснований.Префикс                               КАК Префикс,
	|	ДанныеОснований.ЦифровойИндекс                        КАК ИндексПодразделения,
	|	ТаблицаОтветственныеЛица.РуководительНаименование     КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность        КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	ДанныеОснований.Валюта                                КАК Валюта,
	|	ДанныеОснований.ВалютаНаименованиеПолное              КАК ВалютаНаименованиеПолное,
	|	ДанныеОснований.ВалютаКод                             КАК ВалютаКод,
	|	//РеквизитыОснованийДляУПД
	|	//ДанныеУПДВыданного
	|	ЛОЖЬ                                                  КАК ТолькоУслуги
	|ИЗ
	|	СчетаФактурыОснования КАК СчетаФактурыОснования
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураКомиссионеру КАК ДанныеДокумента
	|	ПО СчетаФактурыОснования.Ссылка = ДанныеДокумента.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеОснований КАК ДанныеОснований
	|	ПО СчетаФактурыОснования.Ссылка = ДанныеОснований.Ссылка
	|		И ДанныеОснований.ПечататьСчетФактуру
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|	ПО СчетаФактурыОснования.ДокументОснование = ТаблицаОтветственныеЛица.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетаФактуры.Ссылка      КАК Ссылка,
	|	Покупатели.Покупатель    КАК Грузополучатель,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(ДанныеКонтрагента.ОбособленноеПодразделение, ЛОЖЬ) ТОГДА
	|		ДанныеКонтрагента.ГоловнойКонтрагент
	|	ИНАЧЕ
	|		Покупатели.Покупатель
	|	КОНЕЦ                    КАК Контрагент,
	|
	|	ВЫБОР КОГДА Покупатели.КПППокупателя ПОДОБНО """" ТОГДА
	|		ВЫБОР КОГДА Покупатели.Покупатель ССЫЛКА Справочник.Контрагенты ТОГДА """"
	|			  КОГДА Покупатели.Покупатель ССЫЛКА Справочник.Организации ТОГДА ЕстьNULL(ДанныеОрганизацийПокупатель.КПП, """")
	|			  ИНАЧЕ """"
	|		КОНЕЦ
	|	ИНАЧЕ
	|		Покупатели.КПППокупателя
	|	КОНЕЦ КАК КПППокупателя,
	|
	|	ВЫБОР КОГДА Покупатели.ИННПокупателя ПОДОБНО """" ТОГДА
	|		ВЫБОР КОГДА Покупатели.Покупатель ССЫЛКА Справочник.Контрагенты ТОГДА ЕстьNULL(ДанныеКонтрагента.ИНН, """")
	|			  КОГДА Покупатели.Покупатель ССЫЛКА Справочник.Организации ТОГДА ЕстьNULL(ДанныеОрганизацийПокупатель.ИНН, """")
	|			  ИНАЧЕ """"
	|		КОНЕЦ
	|	ИНАЧЕ
	|		Покупатели.ИННПокупателя
	|	КОНЕЦ КАК ИННПокупателя
	|
	|ИЗ
	|	СчетаФактурыОснования КАК СчетаФактуры
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураКомиссионеру.Покупатели КАК Покупатели
	|	ПО СчетаФактуры.Ссылка = Покупатели.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК ДанныеКонтрагента
	|	ПО ДанныеКонтрагента.Ссылка = Покупатели.Покупатель
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ДанныеОрганизацийПокупатель
	|	ПО ДанныеОрганизацийПокупатель.Ссылка = Покупатели.Покупатель
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|ИТОГИ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////
	|";
	
	Если ПараметрыПечати.Свойство("ДополнитьДаннымиУПД") И ПараметрыПечати.ДополнитьДаннымиУПД Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//РеквизитыОснованийДляУПД",
		"	ДанныеОснований.Основание           КАК Основание,
		|	ДанныеОснований.БанковскийСчетОрганизации КАК БанковскийСчетОрганизации,
		|	ДанныеОснований.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента,
		|	ДанныеОснований.БанковскийСчетГрузоотправителя КАК БанковскийСчетГрузоотправителя,
		|	ДанныеОснований.БанковскийСчетГрузополучателя КАК БанковскийСчетГрузополучателя,
		|	ДанныеОснований.ДоверенностьНомер   КАК ДоверенностьНомер,
		|	ДанныеОснований.ДоверенностьДата    КАК ДоверенностьДата,
		|	ДанныеОснований.ДоверенностьВыдана  КАК ДоверенностьВыдана,
		|	ДанныеОснований.ДоверенностьЛицо    КАК ДоверенностьЛицо,
		|	ДанныеОснований.Кладовщик           КАК Кладовщик,
		|	ДанныеОснований.ДолжностьКладовщика КАК ДолжностьКладовщика,");
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ДанныеУПДВыданного",
		"	ИСТИНА                              КАК ВыводитьКодНоменклатуры,
		|	ИСТИНА                              КАК ТребуетсяНаличиеСФ,
		|	ЛОЖЬ                                КАК ПечатьНеТребуется,
		|	1                                   КАК СтатусУПД,");
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции
