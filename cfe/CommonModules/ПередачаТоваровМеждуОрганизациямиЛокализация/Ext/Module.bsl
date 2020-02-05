﻿
&Вместо("ПолучитьДанныеДляПечатнойФормыМ15")
Функция ВИЛС_ПолучитьДанныеДляПечатнойФормыМ15(ПараметрыПечати, МассивОбъектов)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка               КАК Ссылка,
	|	ДанныеДокументов.Валюта               КАК Валюта
	|
	|ПОМЕСТИТЬ ТаблицаДанныхДокументов
	|ИЗ
	|	Документ.ПередачаТоваровМеждуОрганизациями КАК ДанныеДокументов
	|
	|ГДЕ
	|	ДанныеДокументов.Ссылка В (&МассивОбъектов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Выполнить();
	
	ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц);
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);	
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Дата КАК ДатаСоставления,
	|	ДанныеДокумента.ОрганизацияПолучатель КАК Контрагент,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	ДанныеДокумента.Склад.ТекущийОтветственный КАК Кладовщик,
	|	ДанныеДокумента.Склад.ТекущаяДолжностьОтветственного КАК ДолжностьКладовщика,
	|	ДанныеДокумента.Организация.Префикс КАК Префикс,
	|	ДанныеДокумента.Склад КАК Склад,
	|	ДанныеДокумента.Склад.Наименование КАК СкладНаименование,
	|	ДанныеДокумента.БанковскийСчетОрганизации КАК БанковскийСчетОрганизации,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ИСТИНА КАК ВыводитьКодНоменклатуры,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоПередачаНаКомиссию
	|ИЗ
	|	Документ.ПередачаТоваровМеждуОрганизациями КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ФильтрПоДокументам
	|		ПО ДанныеДокумента.Ссылка = ФильтрПоДокументам.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|ГДЕ
	|	НЕ ДанныеДокумента.РасчетыЧерезОтдельногоКонтрагента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.НомерВходящегоДокумента,
	|	ДанныеДокумента.ДатаВходящегоДокумента,
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.ОрганизацияПолучатель,
	|	ДанныеДокумента.Контрагент,
	|	"""",
	|	"""",
	|	"""",
	|	ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка),
	|	"""",
	|	ДанныеДокумента.Организация.Префикс,
	|	ДанныеДокумента.Склад,
	|	ДанныеДокумента.Склад.Наименование,
	|	ДанныеДокумента.БанковскийСчетКонтрагента,
	|	ДанныеДокумента.Валюта,
	|	ЛОЖЬ КАК ВыводитьКодНоменклатуры,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|ИЗ
	|	Документ.ПередачаТоваровМеждуОрганизациями КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ФильтрПоДокументам
	|		ПО ДанныеДокумента.Ссылка = ФильтрПоДокументам.Ссылка
	|ГДЕ
	|	ДанныеДокумента.РасчетыЧерезОтдельногоКонтрагента
	|	И ДанныеДокумента.ОрганизацияПолучатель <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Номер,
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.Контрагент,
	|	ДанныеДокумента.Организация,
	|	ТаблицаОтветственныеЛица.РуководительНаименование,
	|	ТаблицаОтветственныеЛица.РуководительДолжность,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование,
	|	ДанныеДокумента.Склад.ТекущийОтветственный,
	|	ДанныеДокумента.Склад.ТекущаяДолжностьОтветственного,
	|	ДанныеДокумента.Организация.Префикс,
	|	ДанныеДокумента.Склад,
	|	ДанныеДокумента.Склад.Наименование,
	|	ДанныеДокумента.БанковскийСчетОрганизации,
	|	ДанныеДокумента.Валюта,
	|	ИСТИНА КАК ВыводитьКодНоменклатуры,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|ИЗ
	|	Документ.ПередачаТоваровМеждуОрганизациями КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ФильтрПоДокументам
	|		ПО ДанныеДокумента.Ссылка = ФильтрПоДокументам.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|ГДЕ
	|	ДанныеДокумента.РасчетыЧерезОтдельногоКонтрагента
	|	И ДанныеДокумента.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
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
	|	ТаблицаТоваров.Серия.Наименование КАК СерияНаименование,    // fix Suetin 21.03.2019 16:45:18
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) = 1
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ТаблицаТоваров.Упаковка
	|	КОНЕЦ КАК Упаковка,
	|	ТаблицаТоваров.КоличествоУпаковок КАК Количество,
	|	0 КАК КоличествоМест,
	|	ТаблицаТоваров.СуммаБезНДС / ТаблицаТоваров.КоличествоУпаковок КАК Цена,
	|	ТаблицаТоваров.СуммаБезНДС КАК СуммаБезНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаБезНДС + ТаблицаТоваров.СуммаНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара
	|ИЗ
	|	ПередачаТоваровМеждуОрганизациямиТаблицаТоваров КАК ТаблицаТоваров
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
	РезультатПоШапке = МассивРезультатов[0];
	РезультатПоТабличнойЧасти = МассивРезультатов[1];
	
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
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",     Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ПересчитыватьВВалютуРегл",       ПараметрыЗаполнения.ПересчитыватьВВалютуРегл);
	Запрос.УстановитьПараметр("ВключаяНомераГТД",               ПараметрыЗаполнения.ВключаяНомераГТД);
	Запрос.УстановитьПараметр("ПустаяГТД",                      Справочники.НомераГТД.ПустаяСсылка());
	
	Если ПараметрыЗаполнения.ПересчитыватьВВалютуРегл Тогда
		Если НЕ ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		
			Запрос.Текст = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	РасчетыСКлиентами.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
			|ИЗ
			|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
			|
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		ТаблицаДанныхДокументов КАК ДанныеДокументов
			|	ПО
			|		РасчетыСКлиентами.Регистратор = ДанныеДокументов.Ссылка
			|
			|ГДЕ
			|	ДанныеДокументов.Валюта <> &ВалютаРегламентированногоУчета
			|	И РасчетыСКлиентами.Активность
			|";
			ТаблицаАналитик = Запрос.Выполнить().Выгрузить();
			МассивАналитикУчетаПоПартнерам = ТаблицаАналитик.ВыгрузитьКолонку("АналитикаУчетаПоПартнерам");
			
			Если МассивАналитикУчетаПоПартнерам.Количество() > 0 Тогда
				ОкончаниеПериодаРасчета = КонецМесяца(ВзаиморасчетыСервер.ПолучитьМаксимальнуюДатуВКоллекцииДокументов(МенеджерВременныхТаблиц)) + 1;
				АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
				АналитикиРасчета.АналитикиУчетаПоПартнерам = МассивАналитикУчетаПоПартнерам;
				Попытка
					РаспределениеВзаиморасчетовВызовСервера.РаспределитьВсеРасчетыСКлиентами(ОкончаниеПериодаРасчета, АналитикиРасчета);
				Исключение
					ТекстСообщения = НСтр("ru ='Печатная форма сформирована по неактуальным данным.
					|Необходимо актуализировать взаиморасчеты вручную и переформировать печатную форму.'");
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				КонецПопытки;
			КонецЕсли;
		Иначе
			
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ДанныеДокументов.Ссылка КАК Ссылка
			|ИЗ
			|	ТаблицаДанныхДокументов КАК ДанныеДокументов
			|ГДЕ 
			|	ДанныеДокументов.Валюта <> &ВалютаРегламентированногоУчета
			|	ИЛИ ДанныеДокументов.Валюта <> &ВалютаУправленческогоУчета";
			МассивДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
			РегистрыСведений.СуммыДокументовВВалютеРегл.РассчитатьСуммыДокументовВВалютеРегл(МассивДокументов);
			
		КонецЕсли;
	КонецЕсли;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка                     КАК Ссылка,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка                   КАК Упаковка,
	|	МАКСИМУМ(ТаблицаТоваров.НомерСтроки)      КАК НомерСтроки
	|
	|ПОМЕСТИТЬ СтрокиТоваров
	|ИЗ
	|	Документ.ПередачаТоваровМеждуОрганизациями.Товары КАК ТаблицаТоваров
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаТоваров.Ссылка = ДанныеДокументов.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка                                 КАК Ссылка,
	|	ТаблицаДокумента.НомерСтроки                            КАК НомерСтроки,
	|	ТаблицаДокумента.Номенклатура                           КАК Номенклатура,
	|	ТаблицаДокумента.Характеристика                         КАК Характеристика,  
	|	ТаблицаДокумента.Серия			                        КАК Серия,   // fix Suetin 21.03.2019 16:59:14
	|	&ПустаяГТД                                              КАК НомерГТД,
	|	ТаблицаДокумента.Количество                             КАК Количество,
	|	ТаблицаДокумента.Количество                             КАК КоличествоУпаковок,
	|	
	|	ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаБезНДСРегл,
	|		ТаблицаДокумента.СуммаСНДС - ТаблицаДокумента.СуммаНДС
	|	) КАК СуммаБезНДС,
	|	
	|	ТаблицаДокумента.СтавкаНДС                              КАК СтавкаНДС,
	|	
	|	ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаНДСРегл,
	|		ТаблицаДокумента.СуммаНДС
	|	) КАК СуммаНДС,
	|	
	|	ЛОЖЬ                                                    КАК ЭтоТовар,
	|	ЛОЖЬ                                                    КАК ВернутьМногооборотнуюТару,
	|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)  КАК Упаковка
	|
	|ПОМЕСТИТЬ ПередачаТоваровМеждуОрганизациямиТаблицаТоваров
	|ИЗ
	|	Документ.ПередачаТоваровМеждуОрганизациями.Товары КАК ТаблицаДокумента
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
	|		И СуммыДокументовВВалютеРегл.Активность
	|		И &ПересчитыватьВВалютуРегл
	|
	|ГДЕ
	|	ТаблицаДокумента.Номенклатура.ТипНоменклатуры В (
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа)
	|	)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка                                        КАК Ссылка,
	|	СтрокиТоваров.НомерСтроки                                      КАК НомерСтроки,
	|	Аналитика.Номенклатура                                         КАК Номенклатура,
	|	Аналитика.Характеристика                                       КАК Характеристика,   
	|	Аналитика.Серия			                                       КАК Серия,      // fix Suetin 21.03.2019 16:59:32
	|	
	|	ВЫБОР КОГДА &ВключаяНомераГТД ТОГДА
	|		ТаблицаДокумента.НомерГТД
	|	ИНАЧЕ
	|		&ПустаяГТД
	|	КОНЕЦ КАК НомерГТД,
	|
	|	СУММА(ТаблицаДокумента.Количество)                             КАК Количество,
	|	СУММА(ТаблицаДокумента.КоличествоУпаковок)                     КАК КоличествоУпаковок,
	|	
	|	СУММА(ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаБезНДСРегл,
	|		ТаблицаДокумента.СуммаСНДС - ТаблицаДокумента.СуммаНДС
	|	)) КАК СуммаБезНДС,
	|	
	|	ТаблицаДокумента.СтавкаНДС                                     КАК СтавкаНДС,
	|	
	|	СУММА(ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаНДСРегл,
	|		ТаблицаДокумента.СуммаНДС
	|	)) КАК СуммаНДС,
	|	
	|	ИСТИНА                                                         КАК ЭтоТовар,
	|	ЛОЖЬ                                                           КАК ВернутьМногооборотнуюТару,
	|	ТаблицаДокумента.Упаковка                                      КАК Упаковка
	|
	|ИЗ
	|	Документ.ПередачаТоваровМеждуОрганизациями.ВидыЗапасов КАК ТаблицаДокумента
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
	|		И СуммыДокументовВВалютеРегл.Активность
	|		И &ПересчитыватьВВалютуРегл
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СтрокиТоваров КАК СтрокиТоваров
	|	ПО
	|		ТаблицаДокумента.Ссылка                       = СтрокиТоваров.Ссылка
	|		И ТаблицаДокумента.АналитикаУчетаНоменклатуры = СтрокиТоваров.АналитикаУчетаНоменклатуры
	|		И ТаблицаДокумента.Упаковка                   = СтрокиТоваров.Упаковка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТаблицаДокумента.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Ссылка,
	|	СтрокиТоваров.НомерСтроки,
	|	Аналитика.Номенклатура,
	|	Аналитика.Характеристика,
	|	Аналитика.Серия,      // fix Suetin 21.03.2019 16:59:41
	|	ТаблицаДокумента.СтавкаНДС,
	|	ТаблицаДокумента.Упаковка,
	|
	|	ВЫБОР КОГДА &ВключаяНомераГТД ТОГДА
	|		ТаблицаДокумента.НомерГТД
	|	ИНАЧЕ
	|		&ПустаяГТД
	|	КОНЕЦ
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СтрокиТоваров
	|";
	
	Запрос.Выполнить();
	
КонецПроцедуры
