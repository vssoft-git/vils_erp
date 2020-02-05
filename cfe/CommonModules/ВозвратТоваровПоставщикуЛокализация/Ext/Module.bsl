﻿
&Вместо("ТекстЗапросаДанныхОснованияДляПечатнойФормыСчетФактура")
Функция ВИЛС_ТекстЗапросаДанныхОснованияДляПечатнойФормыСчетФактура()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка                                   КАК Ссылка,
	|	ДанныеДокументов.ХозяйственнаяОперация                    КАК ХозяйственнаяОперация,
	|	ДанныеДокументов.Валюта                                   КАК Валюта,
	|	ДанныеДокументов.Организация                              КАК Организация,
	|	ДанныеДокументов.НалогообложениеНДС                       КАК НалогообложениеНДС,
	|	ДанныеДокументов.Подразделение                            КАК Подразделение,
	|	ДанныеДокументов.Склад                                    КАК Склад,
	|	ДанныеДокументов.Грузоотправитель                         КАК Грузоотправитель,
	|	ДанныеДокументов.Грузополучатель                          КАК Грузополучатель,
	|	ЛОЖЬ                                                      КАК РасчетыЧерезОтдельногоКонтрагента,
	|	НЕОПРЕДЕЛЕНО                                              КАК Номенклатура,
	|	""""                                                      КАК Содержание,
	|	ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)             КАК Комиссионер,
	|	ДанныеДокументов.Основание                                КАК Основание,
	|	ДанныеДокументов.ОснованиеДата                            КАК ОснованиеДата,
	|	ДанныеДокументов.ОснованиеНомер                           КАК ОснованиеНомер,
	|	ДанныеДокументов.ДоверенностьНомер                        КАК ДоверенностьНомер,
	|	ДанныеДокументов.ДоверенностьДата                         КАК ДоверенностьДата,
	|	ДанныеДокументов.ДоверенностьВыдана                       КАК ДоверенностьВыдана,
	|	ДанныеДокументов.ДоверенностьЛицо                         КАК ДоверенностьЛицо,
	|	ВЫРАЗИТЬ(ДанныеДокументов.ДополнительнаяИнформацияПоДоставке КАК СТРОКА(100)) КАК ДополнительнаяИнформацияПоДоставке,     // fix Suetin 01.02.2019 13:42:38
	|	ДанныеДокументов.Договор                                  КАК Договор,                                                    // fix Suetin 05.02.2019 2:13:56
	|	ДанныеДокументов.Отпустил.Наименование                    КАК Кладовщик,
	|	ДанныеДокументов.ОтпустилДолжность                        КАК ДолжностьКладовщика
	|
	|//ОператорПОМЕСТИТЬ
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК ДанныеДокументов
	|ГДЕ
	|	ДанныеДокументов.Ссылка В (&ДокументОснование_ВозвратТоваровПоставщику)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

&ИзменениеИКонтроль("ПолучитьДанныеДляПечатнойФормыУПД")
Функция ВИЛС_ПолучитьДанныеДляПечатнойФормыУПД(ПараметрыПечати, МассивОбъектов)

	КолонкаКодов = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	Если Не ЗначениеЗаполнено(КолонкаКодов) Тогда
		КолонкаКодов = "Код";
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка               КАК Ссылка,
	|	ДанныеДокументов.Валюта               КАК Валюта,
	|	ДанныеДокументов.Организация          КАК Организация,
	|	ДанныеДокументов.Подразделение        КАК Подразделение,
	|	ДанныеДокументов.Склад                КАК Склад
	|
	|ПОМЕСТИТЬ ТаблицаДанныхДокументов
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК ДанныеДокументов
	|
	|ГДЕ
	|	ДанныеДокументов.Ссылка В (&МассивОбъектов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	УчетНДСУП.ДополнитьЗапросПолученияДанныхДляПечатиУПД(Запрос);
	
	Запрос.Выполнить();
	
	ПараметрыЗаполнения = ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров();
	ПараметрыЗаполнения.ВключаяНомераГТД = Истина;
	ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц, ПараметрыЗаполнения);
	
	ПродажиСервер.ПоместитьВременнуюТаблицуДанныхПоставщика(МенеджерВременныхТаблиц);
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	&ПредставлениеСчетФактура КАК ПредставлениеДокумента,
	|	2 КАК СтатусУПД,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Дата,
	|	НЕОПРЕДЕЛЕНО КАК НомерИсправления,
	|	НЕОПРЕДЕЛЕНО КАК ДатаИсправления,
	|	ЛОЖЬ КАК Исправление,
	|	НЕОПРЕДЕЛЕНО КАК НомерСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК ДатаСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК НомерИсправленияСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК ДатаИсправленияСчетаФактуры,
	|	ЛОЖЬ КАК КорректировочныйСчетФактура,
	|	"""" КАК СтрокаПоДокументу,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаСчетаФактуры,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Контрагент.ОбособленноеПодразделение
	|			ТОГДА ДанныеДокумента.Контрагент.ГоловнойКонтрагент
	|		ИНАЧЕ ДанныеДокумента.Контрагент
	|	КОНЕЦ КАК Контрагент,
	|	ДанныеДокумента.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ДанныеПоставщика.ГоловнаяОрганизация КАК Организация,
	|	ДанныеДокумента.Организация.Префикс КАК Префикс,
	|	0 КАК ИндексПодразделения,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Грузополучатель = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Контрагент
	|		ИНАЧЕ ДанныеДокумента.Грузополучатель
	|	КОНЕЦ КАК Грузополучатель,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Грузоотправитель = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Организация
	|		ИНАЧЕ ДанныеДокумента.Грузоотправитель
	|	КОНЕЦ КАК Грузоотправитель,
	|	ДанныеПоставщика.КПППоставщика КАК КПППоставщика,
	|	""""                           КАК КПППокупателя,
	|	ДанныеДокумента.Контрагент.ИНН КАК ИННПокупателя,
#Удаление
	|	НЕОПРЕДЕЛЕНО КАК АдресДоставки,
#КонецУдаления
#Вставка
	|	ДанныеДокумента.АдресДоставки КАК АдресДоставки,
	|	ВЫРАЗИТЬ(ДанныеДокумента.ДополнительнаяИнформацияПоДоставке КАК СТРОКА(100)) КАК ДополнительнаяИнформацияПоДоставке,
	|	ДанныеДокумента.ОснованиеДата КАК ОснованиеДата,
	|	ДанныеДокумента.ОснованиеНомер КАК ОснованиеНомер,
#КонецВставки
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Валюта.НаименованиеПолное КАК ВалютаНаименованиеПолное,
	|	ДанныеДокумента.Валюта.Код КАК ВалютаКод,
	|	ЛОЖЬ КАК ТолькоУслуги,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровКомитенту)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоПередачаНаКомиссию,
	|	ДанныеДокумента.Основание КАК Основание,
	|	ДанныеДокумента.ДоверенностьНомер КАК ДоверенностьНомер,
	|	ДанныеДокумента.ДоверенностьДата КАК ДоверенностьДата,
	|	ДанныеДокумента.ДоверенностьВыдана КАК ДоверенностьВыдана,
	|	ДанныеДокумента.ДоверенностьЛицо КАК ДоверенностьЛицо,
	|	ДанныеДокумента.Отпустил КАК Кладовщик,
	|	ДанныеДокумента.ОтпустилДолжность КАК ДолжностьКладовщика,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Дата >= &ДатаОтраженияВозвратовКорректировочнымиСФ
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ДанныеДокументов.ТребуетсяНаличиеСФ
	|	КОНЕЦ КАК ТребуетсяНаличиеСФ
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеДокументов
	|		ПО ДанныеДокумента.Ссылка = ДанныеДокументов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеПоставщика КАК ДанныеПоставщика
	|		ПО ДанныеДокумента.Ссылка = ДанныеПоставщика.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.Номенклатура.НаименованиеПолное КАК НоменклатураНаименование,
	|	ВЫБОР
	|		КОГДА &КолонкаКодов = ""Артикул""
	|			ТОГДА ТаблицаДокумента.Номенклатура.Артикул
	|		ИНАЧЕ ТаблицаДокумента.Номенклатура.Код
	|	КОНЕЦ КАК НоменклатураКод,
	|	ВЫБОР
	|		КОГДА &ВыводитьБазовыеЕдиницыИзмерения
	|			ТОГДА ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения
	|		ИНАЧЕ &ТекстЗапросаЕдиницаИзмерения
	|	КОНЕЦ КАК ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА &ВыводитьБазовыеЕдиницыИзмерения
	|			ТОГДА ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения.Представление
	|		ИНАЧЕ &ТекстЗапросаНаименованиеЕдиницыИзмерения
	|	КОНЕЦ КАК ЕдиницаИзмеренияНаименование,
	|	ВЫБОР
	|		КОГДА &ВыводитьБазовыеЕдиницыИзмерения
	|			ТОГДА ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения.Код
	|		ИНАЧЕ &ТекстЗапросаКодЕдиницыИзмерения
	|	КОНЕЦ КАК ЕдиницаИзмеренияКод,
	|	ТаблицаДокумента.Характеристика КАК Характеристика,
#Удаление
	|	ТаблицаДокумента.Характеристика.НаименованиеПолное КАК ХарактеристикаНаименование,
#КонецУдаления
#Вставка
	|	ТаблицаДокумента.Характеристика.НаименованиеПолное КАК ХарактеристикаНаименование,
	|	ТаблицаДокумента.Серия                             КАК Серия,
	|	ТаблицаДокумента.Серия.Наименование                КАК СерияНаименование,
#КонецВставки
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаДокумента.НомерГТД КАК НомерГТД,
	|	ТаблицаДокумента.НомерГТД.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ТаблицаДокумента.НомерГТД.СтранаПроисхождения.Код КАК СтранаПроисхожденияКод,
	|	ВЫБОР
	|		КОГДА &ВыводитьБазовыеЕдиницыИзмерения
	|			ТОГДА ТаблицаДокумента.Количество
	|		ИНАЧЕ ТаблицаДокумента.КоличествоУпаковок
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА &ВыводитьБазовыеЕдиницыИзмерения
	|			ТОГДА ТаблицаДокумента.СуммаБезНДС / ТаблицаДокумента.Количество
	|		ИНАЧЕ ТаблицаДокумента.СуммаБезНДС / ТаблицаДокумента.КоличествоУпаковок
	|	КОНЕЦ КАК Цена,
	|	ТаблицаДокумента.СуммаБезНДС КАК СуммаБезНДС,
	|	ТаблицаДокумента.СуммаНДС КАК СуммаНДС,
	|	ТаблицаДокумента.СуммаБезНДС + ТаблицаДокумента.СуммаНДС КАК СуммаСНДС,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара
	|ИЗ
	|	ВозвратТоваровПоставщикуТаблицаТоваров КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|	ИЛИ (ТаблицаДокумента.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|	И НЕ ТаблицаДокумента.Ссылка.ПредусмотренЗалогЗаТару)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТекстЗапросаЕдиницаИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Ссылка",
			"ТаблицаДокумента.Упаковка",
			"ТаблицаДокумента.Номенклатура"));
			
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТекстЗапросаНаименованиеЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование",
			"ТаблицаДокумента.Упаковка",
			"ТаблицаДокумента.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТекстЗапросаКодЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код",
			"ТаблицаДокумента.Упаковка",
			"ТаблицаДокумента.Номенклатура"));
			
	Запрос.УстановитьПараметр("ВыводитьБазовыеЕдиницыИзмерения", Константы.ВыводитьБазовыеЕдиницыИзмерения.Получить());
	Запрос.УстановитьПараметр("ПредставлениеСчетФактура", НСтр("ru = 'счет-фактура';
																|en = 'tax invoice'"));
	Запрос.УстановитьПараметр("КолонкаКодов", КолонкаКодов);
	
	Запрос.УстановитьПараметр("ДатаОтраженияВозвратовКорректировочнымиСФ", УчетНДСУП.НастройкиУчета().ДатаОтраженияВозвратовКорректировочнымиСФ);
	
	МассивРезультатов         = Запрос.ВыполнитьПакет();
	РезультатПоШапке          = МассивРезультатов[0];
	РезультатПоТабличнойЧасти = МассивРезультатов[1];
	
	СтруктураДанныхДляПечати 	= Новый Структура("РезультатПоШапке, РезультатПоТабличнойЧасти",
	                                               РезультатПоШапке, РезультатПоТабличнойЧасти);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции
