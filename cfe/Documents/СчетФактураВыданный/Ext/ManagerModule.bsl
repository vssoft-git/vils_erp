﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции	
	
#Область Печать
	
&Вместо("ТекстЗапросаДанныхШапкиДляПечатиСчетаФактуры")
Функция ВИЛС_ТекстЗапросаДанныхШапкиДляПечатиСчетаФактуры(ПараметрыПечати)
	
	ПечататьСчетаФактурыПолученные = ПараметрыПечати.Свойство("МассивСчетФактураПолученный");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	СчетаФактурыОснования.Ссылка КАК Ссылка,
	|	МИНИМУМ(СчетаФактурыОснования.ДокументОснование) КАК ДокументОснование
	|ПОМЕСТИТЬ СчетаФактурыОснованияПервые
	|ИЗ
	|	СчетаФактурыОснования КАК СчетаФактурыОснования
	|
	|СГРУППИРОВАТЬ ПО
	|	СчетаФактурыОснования.Ссылка
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетаФактурыОснования.Ссылка КАК Ссылка,
	|	ДанныеОснований.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДанныеОснований.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ДанныеКонтрагента.СтранаРегистрации КАК СтранаРегистрации,
	|	
	|	ВЫБОР КОГДА ЕСТЬNULL(ДанныеОрганизацийПоставщик.ОбособленноеПодразделение, ЛОЖЬ) ТОГДА
	|		ДанныеОрганизацийПоставщик.ГоловнаяОрганизация
	|	ИНАЧЕ
	|		СчетФактураВыданный.Организация
	|	КОНЕЦ КАК Организация,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(ДанныеОрганизацийПокупатель.ОбособленноеПодразделение, ЛОЖЬ) ТОГДА
	|		ДанныеОрганизацийПокупатель.ГоловнаяОрганизация
	|	КОГДА ЕСТЬNULL(ДанныеКонтрагента.ОбособленноеПодразделение, ЛОЖЬ) ТОГДА
	|		ДанныеКонтрагента.ГоловнойКонтрагент
	|	ИНАЧЕ
	|		СчетФактураВыданный.Контрагент
	|	КОНЕЦ КАК Контрагент,
	|   ВЫБОР КОГДА не ТипЗначения(ДанныеОснований.Ссылка) = Тип(Документ.ЗаписьКнигиПродаж) ТОГДА ДанныеОснований.Ссылка.Договор ИНАЧЕ НЕОПРЕДЕЛЕНО КОНЕЦ КАК Договор,    // fix Suetin 05.02.2019 2:40:45
	//|   ДанныеОснований.Договор КАК Договор,    // fix Suetin 05.02.2019 2:40:45
	|	ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(ДанныеОснований.Грузоотправитель) = ТИП(Справочник.Контрагенты)
	|		И ДанныеОснований.Грузоотправитель <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ТОГДА
	|		ДанныеОснований.Грузоотправитель
	|	КОГДА НЕ ДанныеПодразделений.РегистрацияВНалоговомОргане.Ссылка ЕСТЬ NULL ТОГДА
	|		ДанныеПодразделений.РегистрацияВНалоговомОргане
	|	КОГДА ДанныеОснований.Грузоотправитель = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ТОГДА
	|		СчетФактураВыданный.Организация
	|	ИНАЧЕ
	|		ДанныеОснований.Грузоотправитель
	|	КОНЕЦ КАК Грузоотправитель,
	|
	|	ВЫБОР КОГДА ДанныеОснований.Грузополучатель = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ТОГДА
	|		СчетФактураВыданный.Контрагент
	|	ИНАЧЕ
	|		ДанныеОснований.Грузополучатель
	|	КОНЕЦ КАК Грузополучатель,
	|
	|	ВЫБОР КОГДА НЕ ДанныеПодразделений.РегистрацияВНалоговомОргане.Ссылка ЕСТЬ NULL ТОГДА
	|		ДанныеПодразделений.РегистрацияВНалоговомОргане.ЦифровойИндексОбособленногоПодразделения
	|	КОГДА ЕСТЬNULL(ДанныеОрганизацийПоставщик.ОбособленноеПодразделение, ЛОЖЬ) ТОГДА
	|		ДанныеОрганизацийПоставщик.ЦифровойИндексОбособленногоПодразделения
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК ЦифровойИндекс,
	|
	|	ВЫБОР КОГДА НЕ ДанныеПодразделений.РегистрацияВНалоговомОргане.Ссылка ЕСТЬ NULL ТОГДА
	|		ДанныеПодразделений.РегистрацияВНалоговомОргане.КПП
	|	ИНАЧЕ
	|		ДанныеОрганизацийПоставщик.КПП
	|	КОНЕЦ КАК КПППоставщика,
	|
	|	ВЫБОР КОГДА СчетФактураВыданный.КППКонтрагента ПОДОБНО """" ТОГДА
	|		ВЫБОР КОГДА СчетФактураВыданный.Контрагент ССЫЛКА Справочник.Контрагенты ТОГДА """"
	|			  КОГДА СчетФактураВыданный.Контрагент ССЫЛКА Справочник.Организации ТОГДА ЕстьNULL(ДанныеОрганизацийПокупатель.КПП, """")
	|			  ИНАЧЕ """"
	|		КОНЕЦ
	|	ИНАЧЕ
	|		СчетФактураВыданный.КППКонтрагента
	|	КОНЕЦ КАК КПППокупателя,
	|
	|	ВЫБОР КОГДА СчетФактураВыданный.ИННКонтрагента ПОДОБНО """" ТОГДА
	|		ВЫБОР КОГДА СчетФактураВыданный.Контрагент ССЫЛКА Справочник.Контрагенты ТОГДА ЕстьNULL(ДанныеКонтрагента.ИНН, """")
	|			  КОГДА СчетФактураВыданный.Контрагент ССЫЛКА Справочник.Организации ТОГДА ЕстьNULL(ДанныеОрганизацийПокупатель.ИНН, """")
	|			  ИНАЧЕ """"
	|		КОНЕЦ
	|	ИНАЧЕ
	|		СчетФактураВыданный.ИННКонтрагента
	|	КОНЕЦ КАК ИННПокупателя,
	|
	|	ДанныеОрганизацийПоставщик.Префикс КАК Префикс,
	|	ДанныеОснований.Комиссионер КАК Комиссионер,
	|	ДанныеВалюты.Ссылка КАК Валюта,
	|	ДанныеВалюты.НаименованиеПолное КАК ВалютаНаименованиеПолное,
	|	ДанныеВалюты.Код КАК ВалютаКод,
	|//РеквизитыОснованийДляУПД
	|	ВЫБОР
	|		КОГДА НЕ ДанныеОснований.РасчетыЧерезОтдельногоКонтрагента
	|			ИЛИ СчетФактураВыданный.Организация <> ЗНАЧЕНИЕ(Справочник.Организации.УправленческаяОрганизация)
	|		ТОГДА ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ПечататьСчетФактураВыданный
	|
	|ПОМЕСТИТЬ ДанныеОснований
	|ИЗ
	|	СчетаФактурыОснованияПервые КАК СчетаФактурыОснования
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|	ПО СчетФактураВыданный.Ссылка = СчетаФактурыОснования.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеОснований
	|	ПО СчетаФактурыОснования.ДокументОснование = ДанныеОснований.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ДанныеОрганизацийПоставщик
	|	ПО СчетФактураВыданный.Организация = ДанныеОрганизацийПоставщик.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацииВНалоговомОргане КАК ДанныеПодразделений
	|	ПО ДанныеПодразделений.Организация = СчетФактураВыданный.Организация
	|		И ДанныеПодразделений.Подразделение = ЕСТЬNULL(ДанныеОснований.Склад.Подразделение, ДанныеОснований.Подразделение)
	|		И ДанныеПодразделений.Подразделение <> ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ДанныеОрганизацийПокупатель
	|	ПО ДанныеОрганизацийПокупатель.Ссылка = СчетФактураВыданный.Контрагент
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК ДанныеКонтрагента
	|	ПО ДанныеКонтрагента.Ссылка = СчетФактураВыданный.Контрагент
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Валюты КАК ДанныеВалюты
	|	ПО ДанныеОснований.Валюта = ДанныеВалюты.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетаФактурыОснования.Ссылка КАК Ссылка,
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
	|	СчетаФактурыОснования КАК СчетаФактурыОснования
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаТоваров КАК ТаблицаТоваров
	|	ПО СчетаФактурыОснования.ДокументОснование = ТаблицаТоваров.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	СчетаФактурыОснования.Ссылка
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////
	|";
	
	Если ПечататьСчетаФактурыПолученные Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТаблицаОснований.ДокументОснование КАК ДокументОснование,
		|	ТаблицаОснований.Ссылка            КАК Ссылка
		|
		|ПОМЕСТИТЬ СчетаФактурыПолученныеОснования
		|ИЗ
		|	Документ.СчетФактураПолученный.ДокументыОснования КАК ТаблицаОснований
		|ГДЕ
		|	ТаблицаОснований.Ссылка В (&МассивСчетФактураПолученный)
		|;
		|
		|/////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетаФактурыОснования.Ссылка КАК Ссылка,
		|	МИНИМУМ(СчетаФактурыОснования.ДокументОснование) КАК ДокументОснование
		|ПОМЕСТИТЬ СчетаФактурыПолученныеОснованияПервые
		|ИЗ
		|	СчетаФактурыПолученныеОснования КАК СчетаФактурыОснования
		|
		|СГРУППИРОВАТЬ ПО
		|	СчетаФактурыОснования.Ссылка
		|
		|;
		|/////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетаФактурыОснования.Ссылка КАК Ссылка,
		|	ДанныеОснований.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ДанныеКонтрагента.СтранаРегистрации КАК СтранаРегистрации,
		|
		|	ВЫБОР КОГДА ДанныеКонтрагента.ОбособленноеПодразделение ТОГДА
		|		ДанныеКонтрагента.ГоловнойКонтрагент
		|	ИНАЧЕ
		|		ДанныеКонтрагента.Ссылка
		|	КОНЕЦ КАК Организация,
		|
		|	ВЫБОР КОГДА ДанныеОрганизации.ОбособленноеПодразделение ТОГДА
		|		ДанныеОрганизации.ГоловнаяОрганизация
		|	ИНАЧЕ
		|		ДанныеОрганизации.Ссылка
		|	КОНЕЦ КАК Контрагент,
		|
		|	ВЫБОР КОГДА ДанныеОснований.Грузоотправитель = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ТОГДА
		|		СчетФактураПолученный.Контрагент
		|	ИНАЧЕ
		|		ДанныеОснований.Грузоотправитель
		|	КОНЕЦ КАК Грузоотправитель,
		|
		|	ВЫБОР КОГДА ДанныеОснований.Грузополучатель = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ТОГДА
		|		СчетФактураПолученный.Организация
		|	ИНАЧЕ
		|		ДанныеОснований.Грузополучатель
		|	КОНЕЦ КАК Грузополучатель,
		|
		|	ДанныеКонтрагента.КПП КАК КПППоставщика,
		|	ДанныеОрганизации.КПП КАК КПППокупателя,
		|	ДанныеОрганизации.ИНН КАК ИННПокупателя,
		|
		|	ВЫБОР КОГДА ДанныеОснований.Комиссионер = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) ТОГДА
		|		ДанныеОснований.Организация.Префикс
		|	ИНАЧЕ
		|		ДанныеОснований.Комиссионер.Префикс
		|	КОНЕЦ КАК Префикс,
		|	
		|	ДанныеОснований.Комиссионер КАК Комиссионер,
		|	ДанныеВалюты.Ссылка КАК Валюта,
		|	ДанныеВалюты.НаименованиеПолное КАК ВалютаНаименованиеПолное,
		|	ДанныеВалюты.Код КАК ВалютаКод
		|
		|ПОМЕСТИТЬ ДанныеОснованийСчетФактураПолученный
		|ИЗ
		|	СчетаФактурыПолученныеОснованияПервые КАК СчетаФактурыОснования
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученный КАК СчетФактураПолученный
		|	ПО СчетаФактурыОснования.Ссылка = СчетФактураПолученный.Ссылка
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеОснований
		|	ПО СчетаФактурыОснования.ДокументОснование = ДанныеОснований.Ссылка
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ДанныеОрганизации
		|	ПО СчетФактураПолученный.Организация = ДанныеОрганизации.Ссылка
		|	
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК ДанныеКонтрагента
		|	ПО СчетФактураПолученный.Контрагент = ДанныеКонтрагента.Ссылка
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Валюты КАК ДанныеВалюты
		|	ПО ДанныеОснований.Валюта = ДанныеВалюты.Ссылка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|
		|;
		|/////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетаФактурыОснования.Ссылка КАК Ссылка,
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
		|	НоменклатураДокументовПолученные
		|ИЗ
		|	СчетаФактурыПолученныеОснования КАК СчетаФактурыОснования
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаТоваров КАК ТаблицаТоваров
		|	ПО СчетаФактурыОснования.ДокументОснование = ТаблицаТоваров.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	СчетаФактурыОснования.Ссылка
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|/////////////////////////////////////////////////////////////////////////////
		|";
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                                КАК Ссылка,
	|	ДанныеДокумента.ИдентификаторГосКонтракта             КАК ИдентификаторГосКонтракта,
	|	ДанныеОснований.ХозяйственнаяОперация                 КАК ХозяйственнаяОперация,
	|	ДанныеОснований.СтранаРегистрации                     КАК СтранаРегистрации,
	|	
	|	&ПредставлениеСчетФактура                             КАК ПредставлениеДокумента,
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
	|	ДанныеДокумента.Корректировочный                      КАК КорректировочныйСчетФактура,
	|	ЕСТЬNULL(ТаблицаПлатежноРасчетныеДокументы.СтрокаПлатежноРасчетныеДокументы,
	|		ДанныеДокумента.СтрокаПлатежноРасчетныеДокументы) КАК СтрокаПоДокументу,
	|	ДанныеДокумента.Валюта                                КАК ВалютаСчетаФактуры,
	|	ДанныеОснований.Контрагент                            КАК Контрагент,   
	|	ДанныеОснований.Договор                               КАК Договор,         // fix Suetin 05.02.2019 2:42:25
	|	ДанныеОснований.КПППокупателя                         КАК КПППокупателя,
	|	ДанныеОснований.ИННПокупателя                         КАК ИННПокупателя,
	|	ДанныеОснований.Грузополучатель                       КАК Грузополучатель,
	|	ДанныеОснований.Организация                           КАК Организация,
	|	ДанныеОснований.НалогообложениеНДС                    КАК НалогообложениеНДС,
	|	ДанныеОснований.КПППоставщика                         КАК КПППоставщика,
	|	ДанныеОснований.Грузоотправитель                      КАК Грузоотправитель,
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
	|	ВЫБОР
	|		КОГДА НоменклатураДокументов.ЕстьУслуги
	|				И НЕ НоменклатураДокументов.ЕстьТовары
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                                 КАК ТолькоУслуги
	|ИЗ
	|	СчетаФактурыОснованияПервые КАК СчетаФактурыОснования
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный КАК ДанныеДокумента
	|	ПО СчетаФактурыОснования.Ссылка = ДанныеДокумента.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеОснований КАК ДанныеОснований
	|	ПО СчетаФактурыОснования.Ссылка = ДанныеОснований.Ссылка
	|		И ДанныеОснований.ПечататьСчетФактураВыданный
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ НоменклатураДокументов КАК НоменклатураДокументов
	|	ПО СчетаФактурыОснования.Ссылка = НоменклатураДокументов.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|	ПО СчетаФактурыОснования.ДокументОснование = ТаблицаОтветственныеЛица.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПлатежноРасчетныеДокументы КАК ТаблицаПлатежноРасчетныеДокументы
	|	ПО СчетаФактурыОснования.Ссылка = ТаблицаПлатежноРасчетныеДокументы.Ссылка";
	
	Если ПечататьСчетаФактурыПолученные Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|" +
		
		"ВЫБРАТЬ
		|	ДанныеДокумента.Ссылка                                КАК Ссылка,
		|	НЕОПРЕДЕЛЕНО                                          КАК ИдентификаторГосКонтракта,
		|	ДанныеОснований.ХозяйственнаяОперация                 КАК ХозяйственнаяОперация,
		|	ДанныеОснований.СтранаРегистрации                     КАК СтранаРегистрации,
		|	&ПредставлениеСчетФактураПосредника                   КАК ПредставлениеДокумента,
		|	ДанныеДокумента.Номер                                 КАК Номер,
		|	ДанныеДокумента.ДатаСоставления                       КАК Дата,
		|	ВЫБОР КОГДА ДанныеДокумента.Исправление ТОГДА
		|		ДанныеДокумента.НомерИсправления
		|	ИНАЧЕ
		|		НЕОПРЕДЕЛЕНО
		|	КОНЕЦ                                                 КАК НомерИсправления,
		|	ВЫБОР КОГДА ДанныеДокумента.Исправление ТОГДА
		|		ДанныеДокумента.ДатаИсправления
		|	ИНАЧЕ
		|		НЕОПРЕДЕЛЕНО
		|	КОНЕЦ                                                 КАК ДатаИсправления,
		|	ДанныеДокумента.Исправление                           КАК Исправление,
		|	ЛОЖЬ                                                  КАК КорректировочныйСчетФактура,
		|	""""                                                  КАК СтрокаПоДокументу,
		|	ДанныеДокумента.Валюта                                КАК ВалютаСчетаФактуры,
		|	ДанныеОснований.Контрагент                            КАК Контрагент,
		|	ДанныеОснований.Договор                               КАК Договор,         // fix Suetin 05.02.2019 2:42:25
		|	ДанныеОснований.КПППокупателя                         КАК КПППокупателя,
		|	ДанныеОснований.ИННПокупателя                         КАК ИННПокупателя,
		|	ДанныеОснований.Грузополучатель                       КАК Грузополучатель,
		|	ДанныеОснований.Организация                           КАК Организация,
		|	НЕОПРЕДЕЛЕНО                                          КАК НалогообложениеНДС,
		|	ДанныеОснований.КПППоставщика                         КАК КПППоставщика,
		|	ДанныеОснований.Грузоотправитель                      КАК Грузоотправитель,
		|	ДанныеОснований.Префикс                               КАК Префикс,
		|	0                                                     КАК ИндексПодразделения,
		|	""""                                                  КАК Руководитель,
		|	""""                                                  КАК ДолжностьРуководителя,
		|	""""                                                  КАК ГлавныйБухгалтер,
		|	ДанныеОснований.Валюта                                КАК Валюта,
		|	ДанныеОснований.ВалютаНаименованиеПолное              КАК ВалютаНаименованиеПолное,
		|	ДанныеОснований.ВалютаКод                             КАК ВалютаКод,
		|	//ДанныеУПДПолученного
		|	ВЫБОР
		|		КОГДА НоменклатураДокументов.ЕстьУслуги
		|				И НЕ НоменклатураДокументов.ЕстьТовары
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ                                                 КАК ТолькоУслуги
		|
		|ИЗ
		|	СчетаФактурыПолученныеОснованияПервые КАК СчетаФактурыОснования
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученный КАК ДанныеДокумента
		|	ПО СчетаФактурыОснования.Ссылка = ДанныеДокумента.Ссылка
		|	
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеОснованийСчетФактураПолученный КАК ДанныеОснований
		|	ПО СчетаФактурыОснования.Ссылка = ДанныеОснований.Ссылка
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ НоменклатураДокументовПолученные КАК НоменклатураДокументов
		|	ПО СчетаФактурыОснования.Ссылка = НоменклатураДокументов.Ссылка";
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|////////////////////////////////////////////////////////////////////////////
	|";
	
	Если ПараметрыПечати.Свойство("ДополнитьДаннымиУПД") И ПараметрыПечати.ДополнитьДаннымиУПД Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//РеквизитыОснованийДляУПД",
		"	ДанныеОснований.Основание           КАК Основание,
		|	ДанныеОснований.ОснованиеДата       КАК ОснованиеДата,
		|	ДанныеОснований.ОснованиеНомер      КАК ОснованиеНомер,
		|	ДанныеОснований.ДоверенностьНомер   КАК ДоверенностьНомер,
		|	ДанныеОснований.ДоверенностьДата    КАК ДоверенностьДата,
		|	ДанныеОснований.ДоверенностьВыдана  КАК ДоверенностьВыдана,
		|	ДанныеОснований.ДоверенностьЛицо    КАК ДоверенностьЛицо,
		|	ДанныеОснований.Кладовщик           КАК Кладовщик,
		|	ДанныеОснований.ДолжностьКладовщика КАК ДолжностьКладовщика,");
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ДанныеУПДВыданного",
		"	ИСТИНА                              КАК ВыводитьКодНоменклатуры,
		|	НЕ ДанныеДокумента.Корректировочный КАК ПечатьНеТребуется,
		|	1                                   КАК СтатусУПД,");

		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ДанныеУПДПолученного",
		"	НЕОПРЕДЕЛЕНО                        КАК Основание,
		|	НЕОПРЕДЕЛЕНО                        КАК ОснованиеДата,
		|	НЕОПРЕДЕЛЕНО                        КАК ОснованиеНомер,
		|	НЕОПРЕДЕЛЕНО                        КАК ДоверенностьНомер,
		|	НЕОПРЕДЕЛЕНО                        КАК ДоверенностьДата,
		|	НЕОПРЕДЕЛЕНО                        КАК ДоверенностьВыдана,
		|	НЕОПРЕДЕЛЕНО                        КАК ДоверенностьЛицо,
		|	НЕОПРЕДЕЛЕНО                        КАК Кладовщик,
		|	НЕОПРЕДЕЛЕНО                        КАК ДолжностьКладовщика,
		|	ЛОЖЬ                                КАК ВыводитьКодНоменклатуры,
		|	ЛОЖЬ                                КАК ПечатьНеТребуется,
		|	1                                   КАК СтатусУПД,");
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли