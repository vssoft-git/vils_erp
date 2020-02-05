﻿
&Вместо("ПолучитьДанныеДляПечатнойФормыМ15")
Функция ВИЛС_ПолучитьДанныеДляПечатнойФормыМ15(ПараметрыПечати, МассивОбъектов)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокументов.ВозвратПринятойМногооборотнойТары	КАК ВернутьМногооборотнуюТару,
	|	ДанныеДокументов.Склад	КАК Склад,
	|	ДанныеДокументов.Ссылка	КАК Ссылка,
	|	ДанныеДокументов.Валюта	КАК Валюта
	|
	|ПОМЕСТИТЬ ТаблицаДанныхДокументов
	|ИЗ
	|	Документ.ВозвратСырьяДавальцу КАК ДанныеДокументов
	|
	|ГДЕ
	|	ДанныеДокументов.Ссылка В (&МассивОбъектов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Выполнить();
	
	ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц, Ложь);
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);	
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратСырья.Ссылка										КАК Ссылка,
	|	ВозвратСырья.Номер										КАК Номер,
	|	ВозвратСырья.Дата										КАК Дата,
	|	ВозвратСырья.Дата										КАК ДатаСоставления,
	|	ВозвратСырья.Контрагент									КАК Контрагент,
	|	ВозвратСырья.Организация								КАК Организация,
	|	ВозвратСырья.Организация.Префикс						КАК Префикс,
	|	ВозвратСырья.Основание									КАК Основание,
	|	ВозвратСырья.Склад										КАК Склад,
	|	ВозвратСырья.Склад.Наименование							КАК СкладНаименование,
	|	ВозвратСырья.Подразделение								КАК СтруктурноеПодразделение,
	|	ВозвратСырья.БанковскийСчетОрганизации					КАК БанковскийСчетОрганизации,
	|	ВозвратСырья.Валюта										КАК Валюта,
	|	ЛОЖЬ													КАК ЦенаВключаетНДС,
	|	ТаблицаОтветственныеЛица.РуководительНаименование		КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность			КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование	КАК ГлавныйБухгалтер,
	|	ВозвратСырья.Отпустил									КАК Кладовщик,
	|	ВозвратСырья.ОтпустилДолжность							КАК ДолжностьКладовщика
	|ИЗ
	|	Документ.ВозвратСырьяДавальцу КАК ВозвратСырья
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ВозвратСырья.Ссылка = ДанныеДокументов.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|	ПО
	|		ВозвратСырья.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка											КАК Ссылка,
	|	ТаблицаТоваров.Номенклатура										КАК Номенклатура,
	|	ТаблицаТоваров.Номенклатура.НаименованиеПолное					КАК НоменклатураНаименование,
	|	ТаблицаТоваров.Номенклатура.Код									КАК НоменклатураКод,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения 						КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения 								КАК ЕдиницаИзмеренияКод,
	|	ВЫБОР КОГДА ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) = 1 ТОГДА
	|		НЕОПРЕДЕЛЕНО
	|	ИНАЧЕ
	|		ТаблицаТоваров.Упаковка
	|	КОНЕЦ															КАК Упаковка,
	|	ТаблицаТоваров.Характеристика.НаименованиеПолное				КАК ХарактеристикаНаименование,
	|	ТаблицаТоваров.Серия.Наименование				     			КАК СерияНаименование,     		// fix Suetin 21.03.2019 15:47:01	
	|	ТаблицаТоваров.КоличествоУпаковок								КАК Количество,
	|	0																КАК КоличествоМест,
	|	ТаблицаТоваров.СуммаБезНДС / ТаблицаТоваров.КоличествоУпаковок	КАК Цена,
	|	ТаблицаТоваров.СуммаБезНДС										КАК СуммаБезНДС,
	|	ТаблицаТоваров.СуммаНДС											КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаБезНДС + ТаблицаТоваров.СуммаНДС			КАК СуммаСНДС,
	|	ТаблицаТоваров.НомерСтроки										КАК НомерСтроки,
	|	ТаблицаТоваров.ЭтоВозвратнаяТара								КАК ЭтоВозвратнаяТара
	|ИЗ
	|	ВозвратСырьяДавальцуТаблицаТоваров КАК ТаблицаТоваров
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ТаблицаТоваров.Упаковка",
		"ТаблицаТоваров.Номенклатура"));
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование",
			"ТаблицаТоваров.Упаковка",
			"ТаблицаТоваров.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКодЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код",
			"ТаблицаТоваров.Упаковка",
			"ТаблицаТоваров.Номенклатура"));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатПоШапке = МассивРезультатов[0];
	РезультатПоТабличнойЧасти = МассивРезультатов[1];
	
	СтруктураДанныхДляПечати = Новый Структура(
		"РезультатПоШапке, РезультатПоТабличнойЧасти",
		РезультатПоШапке,
		РезультатПоТабличнойЧасти);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

&Вместо("ПоместитьВременнуюТаблицуТоваров")
Процедура ВИЛС_ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц, ПересчитыватьВВалютуРегл)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ПересчитыватьВВалютуРегл",       ПересчитыватьВВалютуРегл);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокументов.Ссылка.ВозвратПринятойМногооборотнойТары
	|				И ТаблицаДокумента.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ                               КАК ЭтоВозвратнаяТара,
	|	ТаблицаДокумента.Ссылка             КАК Ссылка,
	|	ТаблицаДокумента.НомерСтроки        КАК НомерСтроки,
	|	ТаблицаДокумента.Номенклатура       КАК Номенклатура,
	|	ТаблицаДокумента.Характеристика     КАК Характеристика,
	|	ТаблицаДокумента.Серия              КАК Серия,     // fix Suetin 21.03.2019 15:47:01
	|	ТаблицаДокумента.Количество         КАК Количество,
	|	ТаблицаДокумента.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ТаблицаДокумента.Сумма              КАК СуммаБезНДС,
	|	НЕОПРЕДЕЛЕНО                        КАК СтавкаНДС,
	|	0                                   КАК СуммаНДС,
	|	НЕОПРЕДЕЛЕНО                        КАК НомерГТД,
	|	ТаблицаДокумента.Упаковка           КАК Упаковка, 
	|	ИСТИНА								КАК ЭтоТовар,
	| 	&ТекстЗапросаЕдиницаИзмерения		КАК ЕдиницаИзмерения,
	|	ДанныеДокументов.Ссылка.Склад       КАК Склад
	|
	|ПОМЕСТИТЬ ВозвратСырьяДавальцуТаблицаТоваров
	|ИЗ
	|	Документ.ВозвратСырьяДавальцу.Товары КАК ТаблицаДокумента
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаДокумента.Ссылка = ДанныеДокументов.Ссылка
	|
	|ГДЕ
	|	ДанныеДокументов.Валюта = &ВалютаРегламентированногоУчета
	|		ИЛИ (НЕ &ПересчитыватьВВалютуРегл)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокументов.Ссылка.ВозвратПринятойМногооборотнойТары
	|				И ТаблицаДокумента.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ                                                   КАК ЭтоВозвратнаяТара,
	|	ТаблицаДокумента.Ссылка                                 КАК Ссылка,
	|	ТаблицаДокумента.НомерСтроки                            КАК НомерСтроки,
	|	ТаблицаДокумента.Номенклатура                           КАК Номенклатура,
	|	ТаблицаДокумента.Характеристика                         КАК Характеристика,
	|	ТаблицаДокумента.Серия                                  КАК Серия,     // fix Suetin 21.03.2019 15:47:01
	|	ТаблицаДокумента.Количество                             КАК Количество,
	|	ТаблицаДокумента.КоличествоУпаковок                     КАК КоличествоУпаковок,
	|	ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСРегл, 0) КАК СуммаБезНДС,
	|	НЕОПРЕДЕЛЕНО                                            КАК СтавкаНДС,
	|	0                                                       КАК СуммаНДС,
	|	НЕОПРЕДЕЛЕНО                                            КАК НомерГТД,
	|	ТаблицаДокумента.Упаковка                               КАК Упаковка,
	|	ИСТИНА													КАК ЭтоТовар,
	|   &ТекстЗапросаЕдиницаИзмерения							КАК ЕдиницаИзмерения,
	|	ДанныеДокументов.Ссылка.Склад                           КАК Склад
	|
	|ИЗ
	|	Документ.ВозвратСырьяДавальцу.Товары КАК ТаблицаДокумента
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаДокумента.Ссылка = ДанныеДокументов.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|	ПО
	|		ТаблицаДокумента.Ссылка = СуммыДокументовВВалютеРегл.Регистратор
	|		И ТаблицаДокумента.ИдентификаторСтроки = СуммыДокументовВВалютеРегл.ИдентификаторСтроки
	|
	|ГДЕ
	|	ДанныеДокументов.Валюта <> &ВалютаРегламентированногоУчета
	|	И &ПересчитыватьВВалютуРегл
	|	И СуммыДокументовВВалютеРегл.Активность
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаЕдиницаИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Ссылка", "ТаблицаДокумента.Упаковка", "ТаблицаДокумента.Номенклатура"));
	
	Запрос.Выполнить();
	
КонецПроцедуры
