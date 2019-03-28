﻿

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
&Вместо("ПолучитьДанныеДляПечатнойФормыСчетФактура")
Функция ВИЛС_ПолучитьДанныеДляПечатнойФормыСчетФактура(ПараметрыПечати, МассивОбъектов) Экспорт 
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СчетФактураВыданныйАванс.Ссылка КАК Ссылка,
	|	СчетФактураВыданныйАванс.Ссылка КАК ИсходныйСчетФактура,
	|	ЛОЖЬ КАК Корректировочный
	|ПОМЕСТИТЬ СчетаФактуры
	|ИЗ
	|	Документ.СчетФактураВыданныйАванс КАК СчетФактураВыданныйАванс
	|ГДЕ
	|	СчетФактураВыданныйАванс.Ссылка В(&МассивДокументов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.ИсходныйСчетФактура,
	|	ИСТИНА КАК Корректировочный
	|ИЗ
	|	Документ.СчетФактураВыданныйАванс.Авансы КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В(&МассивДокументов)
	|	И ТаблицаДокумента.Ссылка.Корректировочный
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОснований.Ссылка                               КАК Ссылка,
	|	ТаблицаОснований.ИсходныйСчетФактура                  КАК ДокументОснование,
	|	ТаблицаОснований.ИсходныйСчетФактура                  КАК ИсходныйДокумент,
	|	ТаблицаОснований.ИсходныйСчетФактура.Номер КАК НомерСчетаФактуры,
	|	ВЫБОР КОГДА ТаблицаОснований.ИсходныйСчетФактура.Исправление ТОГДА
	|		ЕСТЬNULL(ТаблицаОснований.ИсходныйСчетФактура.СчетФактураОснование.Дата, ДАТАВРЕМЯ(1,1,1))
	|	ИНАЧЕ 
	|		ТаблицаОснований.ИсходныйСчетФактура.Дата
	|	КОНЕЦ КАК ДатаСчетаФактуры,
	|	ВЫБОР КОГДА ТаблицаОснований.ИсходныйСчетФактура.Исправление ТОГДА
	|		ТаблицаОснований.ИсходныйСчетФактура.НомерИсправления 
	|	ИНАЧЕ
	|		НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК НомерИсправленияСчетаФактуры,
	|	ВЫБОР КОГДА ТаблицаОснований.ИсходныйСчетФактура.Исправление ТОГДА
	|		ТаблицаОснований.ИсходныйСчетФактура.Дата
	|	ИНАЧЕ
	|		НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДатаИсправленияСчетаФактуры
	|ИЗ
	|	Документ.СчетФактураВыданныйАванс.Авансы КАК ТаблицаОснований
	|ГДЕ
	|	ТаблицаОснований.Ссылка В(&МассивДокументов)
	|	И ТаблицаОснований.Ссылка.Корректировочный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	ИсходныйДокумент
	|ИТОГИ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка                                 КАК Ссылка,
	|	ВариантыКомплектацииНоменклатуры.Ссылка КАК ВариантКомплектацииНоменклатуры,
	|	ВариантыКомплектацииНоменклатуры.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ВариантыКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора,
	|	ТаблицаДокумента.НоменклатураНабора КАК НоменклатураНабора,
	|	ТаблицаДокумента.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	ТаблицаДокумента.НомерСтроки                            КАК НомерСтроки,
	|	ТаблицаДокумента.Номенклатура                           КАК Номенклатура,
	|	ТаблицаДокумента.Характеристика                         КАК Характеристика,
	|	ТаблицаДокумента.Содержание                         	КАК Содержание,
	|	ТаблицаДокумента.Сумма                              	КАК Сумма,
	|	ТаблицаДокумента.СтавкаНДС                              КАК СтавкаНДС,
	|	ТаблицаДокумента.СуммаНДС                              	КАК СуммаНДС,
	|	
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.Номенклатура.ТипНоменклатуры В
	|				(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга),
	|				ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа))
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ 													КАК ЭтоТовар,
	|	ЛОЖЬ                                                    КАК ЭтоНеВозвратнаяТара,
	|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)  КАК Упаковка
	|
	|ПОМЕСТИТЬ РеализацияТоваровУслугТаблицаТоваров
	|ИЗ
	|	Документ.СчетФактураВыданныйАванс.Авансы КАК ТаблицаДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|		ПО ВариантыКомплектацииНоменклатуры.Владелец = ТаблицаДокумента.НоменклатураНабора
	|		И ВариантыКомплектацииНоменклатуры.Характеристика = ТаблицаДокумента.ХарактеристикаНабора
	|		И ВариантыКомплектацииНоменклатуры.Основной
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка В(ВЫБРАТЬ Т.ИсходныйСчетФактура ИЗ СчетаФактуры КАК Т)
	|	И ТаблицаДокумента.Ссылка.Проведен
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка КАК Ссылка,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА НЕ ТаблицаТоваров.ЭтоТовар
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ЕстьУслуги,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ТаблицаТоваров.ЭтоТовар
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ЕстьТовары
	|ПОМЕСТИТЬ
	|	НоменклатураДокументов
	|ИЗ
	|	РеализацияТоваровУслугТаблицаТоваров КАК ТаблицаТоваров
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетФактура.Ссылка КАК Ссылка,
	|	СчетФактура.НалогообложениеНДС КАК НалогообложениеНДС,
	|	СчетФактура.ИдентификаторГосКонтракта КАК ИдентификаторГосКонтракта,
	|	&ПредставлениеСчетФактура КАК ПредставлениеДокумента,
	|	СчетФактура.Номер КАК Номер,
	|	ВЫБОР КОГДА СчетФактура.Исправление ТОГДА
	|		ЕСТЬNULL(СчетФактура.СчетФактураОснование.Дата, ДАТАВРЕМЯ(1,1,1))
	|	ИНАЧЕ 
	|		СчетФактура.Дата
	|	КОНЕЦ КАК Дата,
	|	ВЫБОР КОГДА СчетФактура.Исправление ТОГДА
	|		СчетФактура.НомерИсправления 
	|	ИНАЧЕ
	|		НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК НомерИсправления,
	|	ВЫБОР КОГДА СчетФактура.Исправление ТОГДА
	|		СчетФактура.Дата
	|	ИНАЧЕ
	|		НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДатаИсправления,
	|	СчетФактура.Исправление КАК Исправление,
	|	НЕОПРЕДЕЛЕНО КАК НомерСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК ДатаСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК НомерИсправленияСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК ДатаИсправленияСчетаФактуры,
	|	СчетФактура.Корректировочный КАК КорректировочныйСчетФактура,
	|	СчетФактура.СтрокаПлатежноРасчетныеДокументы КАК СтрокаПоДокументу,
	|	&ВалютаРеглУчета КАК ВалютаСчетаФактуры,
	|	ВЫБОР
	|		КОГДА СчетФактура.Контрагент.ОбособленноеПодразделение
	|			ТОГДА СчетФактура.Контрагент.ГоловнойКонтрагент
	|		ИНАЧЕ СчетФактура.Контрагент
	|	КОНЕЦ КАК Контрагент,
	|	ВЫБОР
	|		КОГДА СчетФактура.Организация.ОбособленноеПодразделение
	|			ТОГДА СчетФактура.Организация.ГоловнаяОрганизация
	|		ИНАЧЕ СчетФактура.Организация
	|	КОНЕЦ КАК Организация,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	СчетФактура.Организация.Префикс КАК Префикс,
	|	ВЫБОР
	|		КОГДА СчетФактура.Организация.ОбособленноеПодразделение
	|			ТОГДА СчетФактура.Организация.ЦифровойИндексОбособленногоПодразделения
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ИндексПодразделения,
	|	СчетФактура.Контрагент КАК Грузополучатель,
	|	СчетФактура.ДокументОснование.Номер КАК НомерПлатежноРасчетногоДокумента,
	|	СчетФактура.ДокументОснование.Дата КАК ДатаПлатежноРасчетногоДокумента,
	|	СчетФактура.Организация КАК Грузоотправитель,
	|	СчетФактура.Организация.КПП КАК КПППоставщика,
	|
	|	ВЫБОР КОГДА СчетФактура.КППКонтрагента ПОДОБНО """" ТОГДА
	|		ВЫБОР КОГДА СчетФактура.Контрагент ССЫЛКА Справочник.Контрагенты ТОГДА """"
	|			  КОГДА СчетФактура.Контрагент ССЫЛКА Справочник.Организации ТОГДА ЕстьNULL(ДанныеОрганизацийПокупатель.КПП, """")
	|			  ИНАЧЕ """"
	|		КОНЕЦ
	|	ИНАЧЕ
	|		СчетФактура.КППКонтрагента
	|	КОНЕЦ КАК КПППокупателя,
	|
	|	ВЫБОР КОГДА СчетФактура.ИННКонтрагента ПОДОБНО """" ТОГДА
	|		ВЫБОР КОГДА СчетФактура.Контрагент ССЫЛКА Справочник.Контрагенты ТОГДА ЕстьNULL(ДанныеКонтрагента.ИНН, """")
	|			  КОГДА СчетФактура.Контрагент ССЫЛКА Справочник.Организации ТОГДА ЕстьNULL(ДанныеОрганизацийПокупатель.ИНН, """")
	|			  ИНАЧЕ """"
	|		КОНЕЦ
	|	ИНАЧЕ
	|		СчетФактура.ИННКонтрагента
	|	КОНЕЦ КАК ИННПокупателя,
	|
	|	НЕОПРЕДЕЛЕНО КАК АдресДоставки,
	|	&ВалютаРеглУчета КАК Валюта,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаНаименованиеПолное,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКод,
	|	ВЫБОР
	|		КОГДА НоменклатураДокументов.ЕстьУслуги
	|				И НЕ НоменклатураДокументов.ЕстьТовары
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ТолькоУслуги,
	|	ЛОЖЬ КАК ЭтоПередачаНаКомиссию
	//begin fix Клещ А.Н. 28.03.2019  
	|,
	|	ВЫБОР
	|		КОГДА СчетФактура.ДокументОснование ССЫЛКА Документ.ВводОстатков
	|				ИЛИ СчетФактура.ДокументОснование ССЫЛКА Документ.КорректировкаРеализации
	|				ИЛИ СчетФактура.ДокументОснование ССЫЛКА Документ.ПервичныйДокумент
	|				ИЛИ СчетФактура.ДокументОснование ССЫЛКА Документ.СписаниеБезналичныхДенежныхСредств
	|				ИЛИ СчетФактура.ДокументОснование ССЫЛКА Документ.РасходныйКассовыйОрдер
	|				ИЛИ СчетФактура.ДокументОснование ССЫЛКА Документ.ПриходныйКассовыйОрдер
	|				ИЛИ СчетФактура.ДокументОснование ССЫЛКА Документ.ПоступлениеБезналичныхДенежныхСредств
	|				ИЛИ СчетФактура.ДокументОснование ССЫЛКА Документ.ОперацияПоПлатежнойКарте
	|				ИЛИ СчетФактура.ДокументОснование ССЫЛКА Документ.ВозвратТоваровОтКлиента
	|				ИЛИ СчетФактура.ДокументОснование ССЫЛКА Документ.ОперацияПоПлатежнойКарте
	|				ИЛИ СчетФактура.ДокументОснование ССЫЛКА Документ.ВозвратТоваровМеждуОрганизациями
	|			ТОГДА СчетФактура.ДокументОснование.Договор
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяССылка)
	|	КОНЕЦ КАК Договор 
	//end fix Клещ А.Н. 28.03.2019
	|ИЗ
	|	Документ.СчетФактураВыданныйАванс КАК СчетФактура
	|		ЛЕВОЕ СОЕДИНЕНИЕ НоменклатураДокументов КАК НоменклатураДокументов
	|		ПО СчетФактура.Ссылка = НоменклатураДокументов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО СчетФактура.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ДанныеОрганизацийПокупатель
	|		ПО ДанныеОрганизацийПокупатель.Ссылка = СчетФактура.Контрагент
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК ДанныеКонтрагента
	|		ПО ДанныеКонтрагента.Ссылка = СчетФактура.Контрагент
	|ГДЕ
	|	СчетФактура.Ссылка В(&МассивДокументов)
	|	И СчетФактура.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка                КАК Ссылка,
	|	ТаблицаТоваров.НоменклатураНабора    КАК НоменклатураНабора,
	|	ТаблицаТоваров.ХарактеристикаНабора  КАК ХарактеристикаНабора,
	|	МИНИМУМ(ТаблицаТоваров.НомерСтроки)  КАК НомерСтроки,
	|	СУММА(ТаблицаТоваров.Сумма)    		 КАК Сумма,
	|	СУММА(ТаблицаТоваров.СуммаНДС)       КАК СуммаНДС
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыПодготовка
	|ИЗ
	|	РеализацияТоваровУслугТаблицаТоваров КАК ТаблицаТоваров
	|
	|ГДЕ
	|	ТаблицаТоваров.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.НоменклатураНабора,
	|	ТаблицаТоваров.ХарактеристикаНабора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка                                    КАК Ссылка,
	|	Товары.ВариантКомплектацииНоменклатуры           КАК ВариантКомплектацииНоменклатуры,
	|	Товары.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	Товары.НоменклатураНабора,
	|	Товары.ХарактеристикаНабора,
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	ВЫБОР КОГДА Товары.ВариантКомплектацииНоменклатуры.НоменклатураОсновногоКомпонента = Товары.Номенклатура
	|		И Товары.ВариантКомплектацииНоменклатуры.ХарактеристикаОсновногоКомпонента = Товары.Характеристика ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ОсновнаяКомплектующая,
	|	Товары.СтавкаНДС КАК СтавкаНДС
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыДополнительноЧастьПервая
	|ИЗ
	|	РеализацияТоваровУслугТаблицаТоваров КАК Товары
	|
	|ГДЕ
	|	Товары.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Т.Ссылка                                                                                КАК Ссылка,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка                                           КАК ВариантКомплектацииНоменклатуры,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Владелец                                  КАК НоменклатураНабора,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Характеристика                            КАК ХарактеристикаНабора,
	|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура   КАК Номенклатура,
	|	ВариантыКомплектацииНоменклатурыТовары.Характеристика КАК Характеристика,
	|	ЛОЖЬ КАК ОсновнаяКомплектующая,
	|	NULL КАК СтавкаНДС
	|ИЗ
	|	Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК ВариантыКомплектацииНоменклатурыТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ Т.Ссылка ИЗ РеализацияТоваровУслугТаблицаТоваров КАК Т) КАК Т
	|		ПО ИСТИНА
	|ГДЕ
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка В (ВЫБРАТЬ РАЗЛИЧНЫЕ Т.ВариантКомплектацииНоменклатуры ИЗ РеализацияТоваровУслугТаблицаТоваров КАК Т)
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Ссылка,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Владелец,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Характеристика,
	|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура,
	|	ВариантыКомплектацииНоменклатурыТовары.Характеристика,
	|	ВариантыКомплектацииНоменклатурыТовары.Упаковка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка,
	|	Таблица.ВариантКомплектацииНоменклатуры,
	|	Таблица.ВариантПредставленияНабораВПечатныхФормах,
	|	Таблица.НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	МАКСИМУМ(Таблица.СтавкаНДС) КАК СтавкаНДС,
	|	МАКСИМУМ(Таблица.ОсновнаяКомплектующая) КАК ОсновнаяКомплектующая
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыДополнительноЧастьВторая
	|ИЗ
	|	ВременнаяТаблицаНаборыДополнительноЧастьПервая КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Ссылка,
	|	Таблица.ВариантКомплектацииНоменклатуры,
	|	Таблица.ВариантПредставленияНабораВПечатныхФормах,
	|	Таблица.НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Результат.Ссылка,
	|	Результат.ВариантКомплектацииНоменклатуры,
	|	Результат.ВариантПредставленияНабораВПечатныхФормах,
	|	Результат.НоменклатураНабора,
	|	Результат.ХарактеристикаНабора,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Результат.ОсновнаяКомплектующая
	|				ТОГДА Результат.СтавкаНДС
	|			ИНАЧЕ null
	|		КОНЕЦ) КАК СтавкаНДС
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыДополнительно
	|ИЗ
	|	ВременнаяТаблицаНаборыДополнительноЧастьВторая КАК Результат
	|СГРУППИРОВАТЬ ПО
	|	Результат.Ссылка,
	|	Результат.ВариантКомплектацииНоменклатуры,
	|	Результат.ВариантПредставленияНабораВПечатныхФормах,
	|	Результат.НоменклатураНабора,
	|	Результат.ХарактеристикаНабора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаНаборыДополнительно.ВариантКомплектацииНоменклатуры,
	|	ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|
	|	Таблица.Ссылка                            КАК Ссылка,
	|	Таблица.НоменклатураНабора                КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора              КАК ХарактеристикаНабора,
	|	Таблица.НомерСтроки                       КАК НомерСтроки,
	|	ИСТИНА 										КАК ПолныйНабор,
	|	Таблица.Сумма                             КАК Сумма,
	|	Таблица.СуммаНДС                          КАК СуммаНДС,
	|	ВременнаяТаблицаНаборыДополнительно.СтавкаНДС КАК СтавкаНДС
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборы
	|ИЗ
	|	ВременнаяТаблицаНаборыПодготовка КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаНаборыДополнительно КАК ВременнаяТаблицаНаборыДополнительно
	|		ПО Таблица.НоменклатураНабора = ВременнаяТаблицаНаборыДополнительно.НоменклатураНабора
	|		И Таблица.ХарактеристикаНабора = ВременнаяТаблицаНаборыДополнительно.ХарактеристикаНабора
	|		И Таблица.Ссылка = ВременнаяТаблицаНаборыДополнительно.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.ПустаяСсылка) КАК ВариантРасчетаЦеныНабора,
	|	ТаблицаДокумента.НоменклатураНабора КАК НоменклатураНабора,
	|	ТаблицаДокумента.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	ТаблицаДокумента.ЭтоКомплектующие КАК ЭтоКомплектующие,
	|	ТаблицаДокумента.ЭтоНабор КАК ЭтоНабор,
	|	ТаблицаДокумента.ПолныйНабор КАК ПолныйНабор,
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА (ВЫРАЗИТЬ(ТаблицаДокумента.Содержание КАК СТРОКА(1))) <> """"
	|			ТОГДА ВЫРАЗИТЬ(ТаблицаДокумента.Содержание КАК СТРОКА(1000))
	|		КОГДА ТаблицаДокумента.ЭтоНабор
	|			ТОГДА ТаблицаДокумента.Номенклатура.НаименованиеПолное
	|		КОГДА ТаблицаДокумента.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			ТОГДА ТаблицаДокумента.Номенклатура.НаименованиеПолное
	|		ИНАЧЕ &ПредставлениеПредварительнаяОплата
	|	КОНЕЦ КАК НоменклатураНаименование,
	|	ТаблицаДокумента.Характеристика КАК Характеристика,
	|	ТаблицаДокумента.Характеристика.НаименованиеПолное КАК ХарактеристикаНаименование,
	|	"""" КАК НомерГТД,
	|	"""" КАК СтранаПроисхождения,
	|	"""" КАК СтранаПроисхожденияКод,
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК ЕдиницаИзмерения,
	|	0 КАК Количество,
	|	0 КАК Цена,
	|	0 КАК СуммаБезНДС,
	|	ТаблицаДокумента.СуммаНДС КАК СуммаНДС,
	|	ТаблицаДокумента.Сумма КАК СуммаСНДС,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.НомерСтрокиНаборы КАК НомерСтрокиНаборы,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара
	|ПОМЕСТИТЬ РезультатПоТабличнойЧасти
	|ИЗ
	|(
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.Ссылка,
	|
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ПустаяСсылка)
	|		КОНЕЦ КАК ВариантПредставленияНабораВПечатныхФормах,
	|
	|		ТаблицаТоваров.НоменклатураНабора,
	|		ТаблицаТоваров.ХарактеристикаНабора,
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|		КОНЕЦ КАК ЭтоКомплектующие,
	|		ЛОЖЬ КАК ЭтоНабор,
	|		ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.НомерСтроки
	|		ИНАЧЕ
	|			ТаблицаТоваров.НомерСтроки
	|		КОНЕЦ КАК НомерСтрокиНаборы,
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.ПолныйНабор
	|		ИНАЧЕ
	|			ЛОЖЬ
	|		КОНЕЦ КАК ПолныйНабор,
	|		ТаблицаТоваров.Номенклатура,
	|		ТаблицаТоваров.Содержание,
	|		ТаблицаТоваров.СтавкаНДС,
	|		ТаблицаТоваров.Сумма,
	|		ТаблицаТоваров.СуммаНДС,
	|		ТаблицаТоваров.Характеристика,
	|		ТаблицаТоваров.Упаковка
	|	ИЗ
	|		РеализацияТоваровУслугТаблицаТоваров КАК ТаблицаТоваров
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаНаборы КАК ВременнаяТаблицаНаборы
	|			ПО ВременнаяТаблицаНаборы.НоменклатураНабора = ТаблицаТоваров.НоменклатураНабора
	|			 И ВременнаяТаблицаНаборы.ХарактеристикаНабора = ТаблицаТоваров.ХарактеристикаНабора
	|			 И ВременнаяТаблицаНаборы.Ссылка = ТаблицаТоваров.Ссылка
	|
	|	ГДЕ
	|		ТаблицаТоваров.НоменклатураНабора = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|		ИЛИ (ТаблицаТоваров.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	        И ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах В (ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоКомплектующие),
	|	                                                                			  ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие)))
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ВременнаяТаблицаНаборы.Ссылка,
	|		ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах,
	|		ВременнаяТаблицаНаборы.НоменклатураНабора,
	|		ВременнаяТаблицаНаборы.ХарактеристикаНабора,
	|		ЛОЖЬ КАК ЭтоКомплектующие,
	|		ИСТИНА КАК ЭтоНабор,
	|		0 КАК НомерСтроки,
	|		ВременнаяТаблицаНаборы.НомерСтроки КАК НомерСтрокиНаборы,
	|		ВременнаяТаблицаНаборы.ПолныйНабор КАК ПолныйНабор,
	|		ВременнаяТаблицаНаборы.НоменклатураНабора,
	|		"""",
	|		ВременнаяТаблицаНаборы.СтавкаНДС,
	|		ВременнаяТаблицаНаборы.Сумма,
	|		ВременнаяТаблицаНаборы.СуммаНДС,
	|		ВременнаяТаблицаНаборы.ХарактеристикаНабора,
	|		ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка
	|	ИЗ
	|		ВременнаяТаблицаНаборы КАК ВременнаяТаблицаНаборы
	|	ГДЕ
	|		ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах В (ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоНабор),
	|	                                                                        ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие))
	|) КАК ТаблицаДокумента
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка,
	|	Таблица.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	Таблица.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора,
	|	Таблица.НоменклатураНабора КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	Таблица.ЭтоКомплектующие КАК ЭтоКомплектующие,
	|	Таблица.ЭтоНабор КАК ЭтоНабор,
	|	Таблица.ПолныйНабор КАК ПолныйНабор,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.НоменклатураНаименование КАК НоменклатураНаименование,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.ХарактеристикаНаименование КАК ХарактеристикаНаименование,
	|	Таблица.НомерГТД КАК НомерГТД,
	|	Таблица.СтранаПроисхождения КАК СтранаПроисхождения,
	|	Таблица.СтранаПроисхожденияКод КАК СтранаПроисхожденияКод,
	|	МАКСИМУМ(Таблица.СтавкаНДСДо) КАК СтавкаНДСДо,
	|	МАКСИМУМ(Таблица.СтавкаНДС) КАК СтавкаНДС,
	|	Таблица.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	Таблица.Количество КАК Количество,
	|	Таблица.Цена КАК Цена,
	|	СУММА(Таблица.СуммаБезНДС) КАК СуммаБезНДС,
	|	СУММА(Таблица.СуммаНДС) КАК СуммаНДС,
	|	СУММА(Таблица.СуммаНДСДо) КАК СуммаНДСДо,
	|	СУММА(Таблица.СуммаНДСУвеличение) КАК РазницаНДСУвеличение,
	|	СУММА(Таблица.СуммаСНДС) КАК СуммаСНДС,
	|	СУММА(Таблица.СуммаСНДСДо) КАК СуммаСНДСДо,
	|	СУММА(Таблица.СуммаСНДСУвеличение) КАК РазницаСНДСУвеличение,
	|	МАКСИМУМ(Таблица.НомерСтроки) КАК НомерСтроки,
	|	МАКСИМУМ(Таблица.НомерСтрокиНаборы) КАК НомерСтрокиНаборы,
	|	Таблица.ЭтоВозвратнаяТара КАК ЭтоВозвратнаяТара
	|ИЗ
	|	(ВЫБРАТЬ
	|		КорректировочныеСФ.Ссылка КАК Ссылка,
	|		ТаблицаДо.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|		ТаблицаДо.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора,
	|		ТаблицаДо.НоменклатураНабора КАК НоменклатураНабора,
	|		ТаблицаДо.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|		ТаблицаДо.ЭтоКомплектующие КАК ЭтоКомплектующие,
	|		ТаблицаДо.ЭтоНабор КАК ЭтоНабор,
	|		ТаблицаДо.ПолныйНабор КАК ПолныйНабор,
	|		ТаблицаДо.Номенклатура КАК Номенклатура,
	|		ТаблицаДо.НоменклатураНаименование КАК НоменклатураНаименование,
	|		ТаблицаДо.Характеристика КАК Характеристика,
	|		ТаблицаДо.ХарактеристикаНаименование КАК ХарактеристикаНаименование,
	|		ТаблицаДо.НомерГТД КАК НомерГТД,
	|		ТаблицаДо.СтранаПроисхождения КАК СтранаПроисхождения,
	|		ТаблицаДо.СтранаПроисхожденияКод КАК СтранаПроисхожденияКод,
	|		ТаблицаДо.СтавкаНДС КАК СтавкаНДСДо,
	|		НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|		ТаблицаДо.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ТаблицаДо.Количество КАК Количество,
	|		ТаблицаДо.Цена КАК Цена,
	|		ТаблицаДо.СуммаБезНДС КАК СуммаБезНДС,
	|		0 КАК СуммаНДС,
	|		ТаблицаДо.СуммаНДС КАК СуммаНДСДо,
	|		0 КАК СуммаНДСУвеличение,
	|		0 КАК СуммаСНДС,
	|		ТаблицаДо.СуммаСНДС КАК СуммаСНДСДо,
	|		0 КАК СуммаСНДСУвеличение,
	|		ТаблицаДо.НомерСтроки КАК НомерСтроки,
	|		ТаблицаДо.НомерСтрокиНаборы КАК НомерСтрокиНаборы,
	|		ТаблицаДо.ЭтоВозвратнаяТара КАК ЭтоВозвратнаяТара
	|	ИЗ
	|		РезультатПоТабличнойЧасти КАК ТаблицаДо
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ СчетаФактуры КАК КорректировочныеСФ
	|			ПО КорректировочныеСФ.ИсходныйСчетФактура = ТаблицаДо.Ссылка
	|				И КорректировочныеСФ.Корректировочный
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаПосле.Ссылка,
	|		ТаблицаПосле.ВариантПредставленияНабораВПечатныхФормах,
	|		ТаблицаПосле.ВариантРасчетаЦеныНабора,
	|		ТаблицаПосле.НоменклатураНабора,
	|		ТаблицаПосле.ХарактеристикаНабора,
	|		ТаблицаПосле.ЭтоКомплектующие,
	|		ТаблицаПосле.ЭтоНабор,
	|		ТаблицаПосле.ПолныйНабор,
	|		ТаблицаПосле.Номенклатура,
	|		ТаблицаПосле.НоменклатураНаименование,
	|		ТаблицаПосле.Характеристика,
	|		ТаблицаПосле.ХарактеристикаНаименование,
	|		ТаблицаПосле.НомерГТД,
	|		ТаблицаПосле.СтранаПроисхождения,
	|		ТаблицаПосле.СтранаПроисхожденияКод,
	|		НЕОПРЕДЕЛЕНО,
	|		ТаблицаПосле.СтавкаНДС,
	|		ТаблицаПосле.ЕдиницаИзмерения,
	|		ТаблицаПосле.Количество,
	|		ТаблицаПосле.Цена,
	|		ТаблицаПосле.СуммаБезНДС,
	|		0,
	|		0,
	|		ТаблицаПосле.СуммаНДС,
	|		0,
	|		0,
	|		ТаблицаПосле.СуммаСНДС,
	|		ТаблицаПосле.НомерСтроки,
	|		ТаблицаПосле.НомерСтрокиНаборы,
	|		ТаблицаПосле.ЭтоВозвратнаяТара
	|	ИЗ
	|		РезультатПоТабличнойЧасти КАК ТаблицаПосле
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ СчетаФактуры КАК КорректировочныеСФ
	|			ПО КорректировочныеСФ.ИсходныйСчетФактура = ТаблицаПосле.Ссылка
	|				И НЕ КорректировочныеСФ.Корректировочный
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КорректировочныеСФ.Ссылка,
	|		РезультатПоТабличнойЧасти.ВариантПредставленияНабораВПечатныхФормах,
	|		РезультатПоТабличнойЧасти.ВариантРасчетаЦеныНабора,
	|		РезультатПоТабличнойЧасти.НоменклатураНабора,
	|		РезультатПоТабличнойЧасти.ХарактеристикаНабора,
	|		РезультатПоТабличнойЧасти.ЭтоКомплектующие,
	|		РезультатПоТабличнойЧасти.ЭтоНабор,
	|		РезультатПоТабличнойЧасти.ПолныйНабор,
	|		РезультатПоТабличнойЧасти.Номенклатура,
	|		РезультатПоТабличнойЧасти.НоменклатураНаименование,
	|		РезультатПоТабличнойЧасти.Характеристика,
	|		РезультатПоТабличнойЧасти.ХарактеристикаНаименование,
	|		РезультатПоТабличнойЧасти.НомерГТД,
	|		РезультатПоТабличнойЧасти.СтранаПроисхождения,
	|		РезультатПоТабличнойЧасти.СтранаПроисхожденияКод,
	|		НЕОПРЕДЕЛЕНО,
	|		РезультатПоТабличнойЧасти.СтавкаНДС,
	|		РезультатПоТабличнойЧасти.ЕдиницаИзмерения,
	|		РезультатПоТабличнойЧасти.Количество,
	|		РезультатПоТабличнойЧасти.Цена,
	|		РезультатПоТабличнойЧасти.СуммаБезНДС,
	|		РезультатПоТабличнойЧасти.СуммаНДС,
	|		0,
	|		0,
	|		РезультатПоТабличнойЧасти.СуммаСНДС,
	|		0,
	|		0,
	|		РезультатПоТабличнойЧасти.НомерСтроки,
	|		РезультатПоТабличнойЧасти.НомерСтрокиНаборы,
	|		РезультатПоТабличнойЧасти.ЭтоВозвратнаяТара
	|	ИЗ
	|		РезультатПоТабличнойЧасти КАК РезультатПоТабличнойЧасти
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ СчетаФактуры КАК КорректировочныеСФ
	|			ПО КорректировочныеСФ.ИсходныйСчетФактура = РезультатПоТабличнойЧасти.Ссылка
	|	) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Характеристика,
	|	Таблица.НомерГТД,
	|	Таблица.ПолныйНабор,
	|	Таблица.ХарактеристикаНабора,
	|	Таблица.ЭтоНабор,
	|	Таблица.ХарактеристикаНаименование,
	|	Таблица.СтранаПроисхождения,
	|	Таблица.Ссылка,
	|	Таблица.ВариантРасчетаЦеныНабора,
	|	Таблица.ЭтоКомплектующие,
	|	Таблица.Номенклатура,
	|	Таблица.НоменклатураНаименование,
	|	Таблица.ВариантПредставленияНабораВПечатныхФормах,
	|	Таблица.НоменклатураНабора,
	|	Таблица.ЭтоВозвратнаяТара,
	|	Таблица.СтранаПроисхожденияКод,
	|	Таблица.ЕдиницаИзмерения,
	|	Таблица.Цена,
	|	Таблица.Количество
	|
	|УПОРЯДОЧИТЬ ПО
	|	Таблица.Ссылка,
	|	МАКСИМУМ(Таблица.НомерСтрокиНаборы),
	|	Таблица.ЭтоНабор УБЫВ,
	|	МАКСИМУМ(Таблица.НомерСтроки)
	|ИТОГИ ПО
	|	Ссылка";
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	Запрос.УстановитьПараметр("ВалютаРеглУчета", ВалютаРеглУчета);
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("ПредставлениеСчетФактура", НСтр("ru='счет-фактура'"));
	Запрос.УстановитьПараметр("ПредставлениеПредварительнаяОплата", НСтр("ru = 'Предварительная оплата'"));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатПоШапке          = МассивРезультатов[4];
	РезультатПоТабличнойЧасти = МассивРезультатов[11];
	РезультатПоИсходнымДанным = МассивРезультатов[1];
	
	СтруктураДанныхДляПечати 	= Новый Структура("РезультатПоШапке, РезультатПоТабличнойЧасти, РезультатПоИсходнымДанным, СчетФактураНаАванс",
	                                               РезультатПоШапке, РезультатПоТабличнойЧасти, РезультатПоИсходнымДанным, Истина);
	
	Возврат СтруктураДанныхДляПечати;
КонецФункции

#КонецЕсли