﻿
&Вместо("ПолучитьДанныеДляПечатнойФормыМ15")
Функция ВИЛС_ПолучитьДанныеДляПечатнойФормыМ15(ПараметрыПечати, МассивОбъектов)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка               КАК Ссылка
	|
	|ПОМЕСТИТЬ ТаблицаДанныхДокументов
	|ИЗ
	|	Документ.ПередачаДавальцу КАК ДанныеДокументов
	|
	|ГДЕ
	|	ДанныеДокументов.Ссылка В (&МассивОбъектов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Выполнить();
	
	ПараметрыЗаполнения = ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров();

	ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц, ПараметрыЗаполнения);
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ПериодыКурсовВалютПоДокументам.Ссылка,
	|	КурсыВалют.Валюта,
	|	КурсыВалют.Курс,
	|	КурсыВалют.Кратность
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	(ВЫБРАТЬ
	|		Документы.Ссылка КАК Ссылка,
	|		МАКСИМУМ(КурсыВалют.Период) КАК Период,
	|		КурсыВалют.Валюта КАК Валюта
	|	ИЗ
	|		Документ.ПередачаДавальцу КАК Документы
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|			ПО Документы.Валюта = КурсыВалют.Валюта
	|				И Документы.Дата >= КурсыВалют.Период
	|	ГДЕ
	|		Документы.Ссылка В(&МассивОбъектов)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Документы.Ссылка,
	|		КурсыВалют.Валюта) КАК ПериодыКурсовВалютПоДокументам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|		ПО ПериодыКурсовВалютПоДокументам.Период = КурсыВалют.Период
	|			И ПериодыКурсовВалютПоДокументам.Валюта = КурсыВалют.Валюта
	|
	|;
	|
	|ВЫБРАТЬ
	|	ПередачаДавальцу.Ссылка КАК Ссылка,
	|	ПередачаДавальцу.Номер КАК Номер,
	|	ПередачаДавальцу.Дата КАК Дата,
	|	ПередачаДавальцу.Дата КАК ДатаСоставления,
	|	ПередачаДавальцу.Контрагент КАК Контрагент,
	|	ПередачаДавальцу.Организация КАК Организация,
	|	ПередачаДавальцу.Организация.Префикс КАК Префикс,
	|	ПередачаДавальцу.Основание КАК Основание,
	|	ПередачаДавальцу.Склад КАК Склад,
	|	ПередачаДавальцу.Склад.Наименование КАК СкладНаименование,
	|	ПередачаДавальцу.Подразделение КАК СтруктурноеПодразделение,
	|	ПередачаДавальцу.БанковскийСчетОрганизации КАК БанковскийСчетОрганизации,
	|	ПередачаДавальцу.Валюта КАК Валюта,
	|	"""" КАК ЦенаВключаетНДС,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	ПередачаДавальцу.Отпустил КАК Кладовщик,
	|	ПередачаДавальцу.ОтпустилДолжность КАК ДолжностьКладовщика
	|ИЗ
	|	Документ.ПередачаДавальцу КАК ПередачаДавальцу
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеДокументов
	|		ПО ПередачаДавальцу.Ссылка = ДанныеДокументов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ПередачаДавальцу.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка КАК Ссылка,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Номенклатура.НаименованиеПолное КАК НоменклатураНаименование,
	|	ТаблицаТоваров.Номенклатура.Код КАК НоменклатураКод,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения КАК ЕдиницаИзмеренияКод,
	|	ТаблицаТоваров.Характеристика.НаименованиеПолное КАК ХарактеристикаНаименование,   
	|	ТаблицаТоваров.Серия.Наименование КАК СерияНаименование,       // fix Suetin 21.03.2019 16:16:38
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) = 1
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ТаблицаТоваров.Упаковка
	|	КОНЕЦ КАК Упаковка,
	|	ТаблицаТоваров.КоличествоУпаковок КАК Количество,
	|	0 КАК КоличествоМест,
	|	ВЫРАЗИТЬ(ТаблицаТоваров.Цена * ЕСТЬNULL(КурсыВалют.Курс, 1) / ЕСТЬNULL(КурсыВалют.Кратность, 1) КАК ЧИСЛО(31,2))		КАК Цена,
	|	ВЫРАЗИТЬ(ТаблицаТоваров.СуммаБезНДС * ЕСТЬNULL(КурсыВалют.Курс, 1) / ЕСТЬNULL(КурсыВалют.Кратность, 1) КАК ЧИСЛО(31,2))КАК СуммаБезНДС,
	|	0																														КАК СуммаНДС,
	|	ВЫРАЗИТЬ(ТаблицаТоваров.СуммаБезНДС * ЕСТЬNULL(КурсыВалют.Курс, 1) / ЕСТЬNULL(КурсыВалют.Кратность, 1) КАК ЧИСЛО(31,2))КАК СуммаСНДС,
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА
	|			ТаблицаТоваров.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЭтоВозвратнаяТара
	|ИЗ
	|	ПередачаДавальцуТаблицаТоваров КАК ТаблицаТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалют
	|		ПО ТаблицаТоваров.Ссылка = КурсыВалют.Ссылка
	|ГДЕ
	|	ТаблицаТоваров.ЭтоТовар
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки",
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
	РезультатПоШапке = МассивРезультатов[1];
	РезультатПоТабличнойЧасти = МассивРезультатов[2];
	
	СтруктураДанныхДляПечати = Новый Структура(
		"РезультатПоШапке, РезультатПоТабличнойЧасти",
		РезультатПоШапке,
		РезультатПоТабличнойЧасти);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

&Вместо("ПоместитьВременнуюТаблицуТоваров")
Процедура ВИЛС_ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц, ПараметрыЗаполнения)
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		ПараметрыЗаполнения = ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ПересчитыватьВВалютуРегл", ПараметрыЗаполнения.ПересчитыватьВВалютуРегл);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка КАК Ссылка,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,   
	|	ТаблицаТоваров.Серия КАК Серия,           // fix Suetin 21.03.2019 16:20:23
	|	ТаблицаТоваров.Упаковка КАК Упаковка,
	|	ТаблицаТоваров.Цена КАК Цена,
	|	МАКСИМУМ(ТаблицаТоваров.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ СтрокиТоваров
	|ИЗ
	|	Документ.ПередачаДавальцу.Товары КАК ТаблицаТоваров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеДокументов
	|		ПО ТаблицаТоваров.Ссылка = ДанныеДокументов.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,                    // fix Suetin 21.03.2019 16:20:23
	|	ТаблицаТоваров.Упаковка,
	|	ТаблицаТоваров.Цена
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,   
	|	ТаблицаТоваров.Серия,                    // fix Suetin 21.03.2019 16:20:23
	|	ТаблицаТоваров.Упаковка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	СтрокиТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,    
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Серия КАК Серия,      // fix Suetin 21.03.2019 16:23:04
	|	ТаблицаДокумента.НомерГТД КАК НомерГТД,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	СУММА(ТаблицаДокумента.Количество) КАК Количество,
	|	СУММА(ТаблицаДокумента.КоличествоУпаковок) КАК КоличествоУпаковок,
	|	СУММА(ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСРегл, СтрокиТоваров.Цена * ТаблицаДокумента.КоличествоУпаковок)) КАК СуммаБезНДС,
	|	СтрокиТоваров.Цена,
	|	0 КАК СуммаНДС,
	|	ИСТИНА КАК ЭтоТовар,
	|	ЛОЖЬ КАК ЭтоНеВозвратнаяТара,
	|	ТаблицаДокумента.Упаковка КАК Упаковка
	|ПОМЕСТИТЬ ПередачаДавальцуТаблицаТоваров
	|ИЗ
	|	Документ.ПередачаДавальцу.ВидыЗапасов КАК ТаблицаДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеДокументов
	|		ПО ТаблицаДокумента.Ссылка = ДанныеДокументов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|		ПО ТаблицаДокумента.Ссылка = СуммыДокументовВВалютеРегл.Регистратор
	|			И ТаблицаДокумента.ИдентификаторСтроки = СуммыДокументовВВалютеРегл.ИдентификаторСтроки
	|			И (СуммыДокументовВВалютеРегл.Активность)
	|			И &ПересчитыватьВВалютуРегл
	|		ЛЕВОЕ СОЕДИНЕНИЕ СтрокиТоваров КАК СтрокиТоваров
	|		ПО ТаблицаДокумента.Ссылка = СтрокиТоваров.Ссылка
	|			И ТаблицаДокумента.АналитикаУчетаНоменклатуры.Номенклатура = СтрокиТоваров.Номенклатура
	|			И ТаблицаДокумента.АналитикаУчетаНоменклатуры.Характеристика = СтрокиТоваров.Характеристика    
	|			И ТаблицаДокумента.АналитикаУчетаНоменклатуры.Серия = СтрокиТоваров.Серия       // fix Suetin 21.03.2019 16:23:45
	|			И ТаблицаДокумента.Упаковка = СтрокиТоваров.Упаковка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Ссылка,
	|	СтрокиТоваров.НомерСтроки,
	|	ТаблицаДокумента.НомерГТД,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Номенклатура,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Характеристика,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Серия,
	|	ТаблицаДокумента.Упаковка,
	|	СтрокиТоваров.Цена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СтрокиТоваров";
	
	Запрос.Выполнить();
	
КонецПроцедуры
