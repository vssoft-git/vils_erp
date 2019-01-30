﻿#Область ВидыЗапасов

&Вместо("ЗаполнитьСтрокуВидовЗапасов")
Процедура ВИЛС_ЗаполнитьСтрокуВидовЗапасов(СтрокаТоваров, СтруктураПоиска, Параметры, СоответствиеВидовЗапасов)
	РеквизитыВидаЗапасов = Новый Структура();
	
	РеквизитыВидаЗапасов.Вставить("Организация", Справочники.Организации.УправленческаяОрганизация);
	РеквизитыВидаЗапасов.Вставить("НалогообложениеОрганизации", Неопределено);
	РеквизитыВидаЗапасов.Вставить("ГруппаФинансовогоУчета", Неопределено);
	РеквизитыВидаЗапасов.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
			
		Если СтрокаЗапасов.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоПоСтроке = Мин(Параметры.Количество, СтрокаЗапасов.Количество);
		ВИЛС_КоличествоШТПоСтроке = Цел(Параметры.ВИЛС_КоличествоШТ * Параметры.Количество / КоличествоПоСтроке);     // fix Suetin 29.01.2019 17:37:13
		НоваяСтрока = ВидыЗапасов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
		
		НоваяСтрока.Упаковка = СтрокаТоваров.Упаковка;
		НоваяСтрока.КодТНВЭД = СтрокаТоваров.КодТНВЭД;
		НоваяСтрока.ЗаказКлиента = ?(ЗначениеЗаполнено(СтрокаТоваров.ЗаказКлиента), СтрокаТоваров.ЗаказКлиента, Неопределено);
		НоваяСтрока.АналитикаУчетаНаборов = СтрокаТоваров.АналитикаУчетаНаборов;
		НоваяСтрока.СтавкаНДС = СтрокаТоваров.СтавкаНДС;
		НоваяСтрока.Цена = СтрокаТоваров.Цена;
		НоваяСтрока.ВИЛС_КоличествоШТ = ВИЛС_КоличествоШТПоСтроке;      // fix Suetin 29.01.2019 17:38:13
		НоваяСтрока.Количество = КоличествоПоСтроке;
		Если Параметры.Количество <> 0 Тогда
			НоваяСтрока.КоличествоУпаковок = КоличествоПоСтроке * Параметры.КоличествоУпаковок / Параметры.Количество;
			НоваяСтрока.СуммаВзаиморасчетов = КоличествоПоСтроке * Параметры.СуммаВзаиморасчетов / Параметры.Количество;
			НоваяСтрока.СуммаРучнойСкидки = КоличествоПоСтроке * Параметры.СуммаРучнойСкидки / Параметры.Количество;
			НоваяСтрока.СуммаАвтоматическойСкидки = КоличествоПоСтроке * Параметры.СуммаАвтоматическойСкидки / Параметры.Количество;
		КонецЕсли;
		Если СтрокаЗапасов.Количество <> 0 Тогда
			НоваяСтрока.СуммаСНДС = КоличествоПоСтроке * Параметры.СуммаСНДС / Параметры.Количество;
			НоваяСтрока.СуммаНДС = КоличествоПоСтроке * Параметры.СуммаНДС / Параметры.Количество;
		КонецЕсли;
		СтрокаЗапасов.ВИЛС_КоличествоШТ = СтрокаЗапасов.ВИЛС_КоличествоШТ - НоваяСтрока.ВИЛС_КоличествоШТ;    // fix Suetin 29.01.2019 17:38:39
		СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
		СтрокаЗапасов.СуммаСНДС = СтрокаЗапасов.СуммаСНДС - НоваяСтрока.СуммаСНДС;
		СтрокаЗапасов.СуммаНДС = СтрокаЗапасов.СуммаНДС - НоваяСтрока.СуммаНДС;
		Параметры.ВИЛС_КоличествоШТ = Параметры.ВИЛС_КоличествоШТ - НоваяСтрока.ВИЛС_КоличествоШТ;           // fix Suetin 29.01.2019 17:39:04
		Параметры.Количество = Параметры.Количество - НоваяСтрока.Количество;
		Параметры.КоличествоУпаковок = Параметры.КоличествоУпаковок - НоваяСтрока.КоличествоУпаковок;
		Параметры.СуммаВзаиморасчетов = Параметры.СуммаВзаиморасчетов - НоваяСтрока.СуммаВзаиморасчетов;
		Параметры.СуммаРучнойСкидки = Параметры.СуммаРучнойСкидки - НоваяСтрока.СуммаРучнойСкидки;
		Параметры.СуммаАвтоматическойСкидки = Параметры.СуммаАвтоматическойСкидки - НоваяСтрока.СуммаАвтоматическойСкидки;
		Параметры.СуммаСНДС = Параметры.СуммаСНДС - НоваяСтрока.СуммаСНДС;
		Параметры.СуммаНДС = Параметры.СуммаНДС - НоваяСтрока.СуммаНДС;
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиентуРеглУчет Тогда
			
			ВидЗапасовПолучателя = СоответствиеВидовЗапасов.Получить(СтрокаЗапасов.ВидЗапасов);
			Если ВидЗапасовПолучателя = Неопределено Тогда
				РеквизитыВидаЗапасов.ГруппаФинансовогоУчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаЗапасов.ВидЗапасов, "ГруппаФинансовогоУчета");
				ВидЗапасовПолучателя = Справочники.ВидыЗапасов.ВидЗапасовДокумента(Справочники.Организации.УправленческаяОрганизация,
																						ХозяйственнаяОперация,
																						РеквизитыВидаЗапасов);
				СоответствиеВидовЗапасов.Вставить(СтрокаЗапасов.ВидЗапасов, ВидЗапасовПолучателя);
			КонецЕсли;
			НоваяСтрока.ВидЗапасовПолучателя = ВидЗапасовПолучателя;
		Иначе
			НоваяСтрока.ВидЗапасовПолучателя = Неопределено;
		КонецЕсли;
		
		Если Параметры.Количество = 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&Вместо("ЗаполнитьДопКолонкиВидовЗапасов")
Процедура ВИЛС_ЗаполнитьДопКолонкиВидовЗапасов()
	
	ТаблицаТовары = Товары.Выгрузить(, "АналитикаУчетаНоменклатуры, НоменклатураНабора, ХарактеристикаНабора, АналитикаУчетаНаборов, Упаковка, ЗаказКлиента, КодТНВЭД, 
		|Количество, КоличествоУпаковок, СтавкаНДС, Цена, СуммаВзаиморасчетов, СуммаРучнойСкидки, СуммаАвтоматическойСкидки, СуммаСНДС, СуммаНДС, ВИЛС_КоличествоШТ");    // fix Suetin 29.01.2019 17:40:18	ВИЛС_КоличествоШТ
	ТаблицаТовары.Свернуть("АналитикаУчетаНоменклатуры, АналитикаУчетаНаборов, НоменклатураНабора, ХарактеристикаНабора, Упаковка, ЗаказКлиента, КодТНВЭД, СтавкаНДС, Цена",
		"Количество, КоличествоУпаковок, СуммаВзаиморасчетов, СуммаРучнойСкидки, СуммаАвтоматическойСкидки, СуммаСНДС, СуммаНДС, ВИЛС_КоличествоШТ");                     // fix Suetin 29.01.2019 17:40:18	ВИЛС_КоличествоШТ
		
	Параметры = Новый Структура;
	
	СоответствиеВидовЗапасов = Новый Соответствие();
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры, ЗаказКлиента, КоличествоУпаковок");
	Для Каждого СтрокаТоваров Из ТаблицаТовары Цикл
		Параметры.Вставить("ВИЛС_КоличествоШТ", СтрокаТоваров.ВИЛС_КоличествоШТ);     // fix Suetin 29.01.2019 17:41:01
		Параметры.Вставить("Количество", СтрокаТоваров.Количество);
		Параметры.Вставить("КоличествоУпаковок", СтрокаТоваров.КоличествоУпаковок);
		Параметры.Вставить("СуммаВзаиморасчетов", СтрокаТоваров.СуммаВзаиморасчетов);
		Параметры.Вставить("СуммаРучнойСкидки", СтрокаТоваров.СуммаРучнойСкидки);
		Параметры.Вставить("СуммаАвтоматическойСкидки", СтрокаТоваров.СуммаАвтоматическойСкидки);
		Параметры.Вставить("СуммаСНДС", СтрокаТоваров.СуммаСНДС);
		Параметры.Вставить("СуммаНДС", СтрокаТоваров.СуммаНДС);
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		СтруктураПоиска.КоличествоУпаковок = 0;
		ЗаполнитьСтрокуВидовЗапасов(СтрокаТоваров, СтруктураПоиска, Параметры, СоответствиеВидовЗапасов);
		
		Если ЗначениеЗаполнено(СтрокаТоваров.ЗаказКлиента)
		 И Параметры.Количество <> 0 Тогда
			СтруктураПоиска.ЗаказКлиента = Неопределено;
			ЗаполнитьСтрокуВидовЗапасов(СтрокаТоваров, СтруктураПоиска, Параметры, СоответствиеВидовЗапасов);
		КонецЕсли;
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

&Вместо("ЗаполнитьВидыЗапасов")
Процедура ВИЛС_ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если (Статус <> Перечисления.СтатусыРеализацийТоваровУслуг.КПредоплате
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию)
		И (Не Проведен
		Или ПерезаполнитьВидыЗапасов
		Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
		Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц))Тогда
		
		ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов(Ложь);
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект, МенеджерВременныхТаблиц, Отказ, ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, АналитикаУчетаНаборов, ВидЗапасов, НомерГТД, СтавкаНДС, ЗаказКлиента, КодТНВЭД", "Количество, СуммаСНДС, СуммаНДС, ВИЛС_КоличествоШТ");  // fix Suetin 29.01.2019 17:42:50	ВИЛС_КоличествоШТ
		ЗаполнитьДопКолонкиВидовЗапасов();
		
	ИначеЕсли Статус = Перечисления.СтатусыРеализацийТоваровУслуг.КПредоплате Тогда
		
		ВидыЗапасов.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

&Вместо("ПроверитьИзменениеТоваров")
Функция ВИЛС_ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.ЗаказКлиента КАК ЗаказКлиента,
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|		ТаблицаТоваров.КодТНВЭД КАК КодТНВЭД,
	|		ТаблицаТоваров.Упаковка КАК Упаковка,
	|		ТаблицаТоваров.Цена КАК Цена,
	|		ТаблицаТоваров.Количество КАК Количество,
	|		ТаблицаТоваров.ВИЛС_КоличествоШТ КАК ВИЛС_КоличествоШТ,    // fix Suetin 29.01.2019 19:44:50
	|		ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|		ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|		ТаблицаТоваров.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|		ТаблицаТоваров.СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	|		ТаблицаТоваров.СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.ЗаказКлиента КАК ЗаказКлиента,
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|		ТаблицаВидыЗапасов.КодТНВЭД КАК КодТНВЭД,
	|		ТаблицаВидыЗапасов.Упаковка КАК Упаковка,
	|		ТаблицаВидыЗапасов.Цена КАК Цена,
	|		-ТаблицаВидыЗапасов.Количество КАК Количество,
	|		-ТаблицаВидыЗапасов.ВИЛС_КоличествоШТ КАК ВИЛС_КоличествоШТ,    // fix Suetin 29.01.2019 19:44:50
	|		-ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|		-ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|		-ТаблицаВидыЗапасов.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|		-ТаблицаВидыЗапасов.СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	|		-ТаблицаВидыЗапасов.СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.ЗаказКлиента,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.СтавкаНДС,
	|	ТаблицаТоваров.КодТНВЭД,
	|	ТаблицаТоваров.Упаковка,
	|	ТаблицаТоваров.Цена
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.ВИЛС_КоличествоШТ) <> 0  // fix Suetin 29.01.2019 19:45:38
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаСНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаВзаиморасчетов) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаРучнойСкидки) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаАвтоматическойСкидки) <> 0
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

&Вместо("ВременныеТаблицыДанныхДокумента")
Функция ВИЛС_ВременныеТаблицыДанныхДокумента()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	Неопределено КАК Партнер,
	|	Неопределено КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти,
	|
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|		И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|	ТОГДА
	|		&Подразделение
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ КАК Подразделение,
	|
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|		И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|	ТОГДА
	|		&Менеджер
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	КОНЕЦ КАК Менеджер,
	|
	|	ВЫБОР КОГДА СделкиСКлиентами.ОбособленныйУчетТоваровПоСделке
	|		И &ФормироватьВидыЗапасовПоСделкам
	|	ТОГДА
	|		&Сделка
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)
	|	КОНЕЦ КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|	ПО
	|		СтруктураПредприятия.Ссылка = &Подразделение
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.СделкиСКлиентами КАК СделкиСКлиентами
	|	ПО
	|		СделкиСКлиентами.Ссылка = &Сделка
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНаборов КАК АналитикаУчетаНаборов,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.ВИЛС_КоличествоШТ КАК ВИЛС_КоличествоШТ,  // fix Suetin 30.01.2019 14:15:46
	|	ТаблицаТоваров.Склад КАК Склад,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.КодТНВЭД КАК КодТНВЭД,
	|	ТаблицаТоваров.Упаковка КАК Упаковка,
	|	ТаблицаТоваров.Цена КАК Цена,
	|	ТаблицаТоваров.Сумма + (ТаблицаТоваров.СуммаНДС * &ЦенаВключаетНДС) КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	ТаблицаТоваров.СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	|	ТаблицаТоваров.СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	&Сделка КАК Сделка,
	|	ТаблицаТоваров.ЗаказКлиента КАК Заказ,
	|	ТаблицаТоваров.КодСтроки КАК КодСтроки
	|	
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТоварыЗаказа.Ссылка.Назначение КАК Назначение
	|	
	|ПОМЕСТИТЬ ВтТоварыПодЗаказ
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ЗаказКлиента.Товары КАК ТоварыЗаказа
	|	ПО
	|		ТаблицаТоваров.Заказ = ТоварыЗаказа.Ссылка
	|		И ТаблицаТоваров.КодСтроки = ТоварыЗаказа.КодСтроки
	|		И ТаблицаТоваров.Номенклатура = ТоварыЗаказа.Номенклатура
	|		И ТаблицаТоваров.Характеристика = ТоварыЗаказа.Характеристика
	|ГДЕ
	|	&РеализацияПоЗаказам
	|	И ТаблицаТоваров.Заказ <> Неопределено
	|	И ТоварыЗаказа.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТоварыЗаказа.Ссылка.Назначение КАК Назначение
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЗаменяющиеТовары КАК ТоварыЗаказа
	|	ПО
	|		ТаблицаТоваров.Заказ = ТоварыЗаказа.Ссылка
	|		И ТаблицаТоваров.КодСтроки = ТоварыЗаказа.КодСтроки
	|		И ТаблицаТоваров.Номенклатура = ТоварыЗаказа.Номенклатура
	|		И ТаблицаТоваров.Характеристика = ТоварыЗаказа.Характеристика
	|ГДЕ
	|	&РеализацияПоЗаказам
	|	И ТаблицаТоваров.Заказ <> Неопределено
	|	И ТоварыЗаказа.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НомерСтроки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.АналитикаУчетаНаборов КАК АналитикаУчетаНаборов,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	ТаблицаТоваров.ВИЛС_КоличествоШТ КАК ВИЛС_КоличествоШТ,  // fix Suetin 30.01.2019 14:15:46
	|	ТаблицаТоваров.Склад КАК Склад,
	|	ТаблицаТоваров.Заказ КАК ЗаказКлиента,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.КодТНВЭД КАК КодТНВЭД,
	|	ТаблицаТоваров.Упаковка КАК Упаковка,
	|	ТаблицаТоваров.Цена КАК Цена,
	|	ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	ТаблицаТоваров.СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	|	ТаблицаТоваров.СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	&Сделка КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка) КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтТоварыПодЗаказ КАК ТоварыПодЗаказ
	|	ПО
	|		ТаблицаТоваров.НомерСтроки = ТоварыПодЗаказ.НомерСтроки
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Справочник.Номенклатура КАК СправочникНоменклатура
	|	ПО
	|		ТаблицаТоваров.Номенклатура = СправочникНоменклатура.Ссылка
	|ГДЕ
	|	СправочникНоменклатура.ТипНоменклатуры В (
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНаборов КАК АналитикаУчетаНаборов,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.КодТНВЭД КАК КодТНВЭД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Упаковка КАК Упаковка,
	|	ТаблицаВидыЗапасов.Цена КАК Цена,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.ЗаказКлиента КАК ЗаказКлиента,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.ВИЛС_КоличествоШТ КАК ВИЛС_КоличествоШТ,  // fix Suetin 30.01.2019 14:15:46
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	ТаблицаВидыЗапасов.СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	|	ТаблицаВидыЗапасов.СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки
	|
	|ПОМЕСТИТЬ ВТВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНаборов КАК АналитикаУчетаНаборов,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.КодТНВЭД КАК КодТНВЭД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.Упаковка КАК Упаковка,
	|	ТаблицаВидыЗапасов.Цена КАК Цена,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	Аналитика.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.ЗаказКлиента КАК ЗаказКлиента,
	|	&Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.ВИЛС_КоличествоШТ КАК ВИЛС_КоличествоШТ,  // fix Suetin 30.01.2019 14:15:46
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	ТаблицаВидыЗапасов.СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	|	ТаблицаВидыЗапасов.СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВТВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Склад
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТВидыЗапасов
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Менеджер", Менеджер);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Сделка", Сделка);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС", ?(ЦенаВключаетНДС, 0, 1));
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("РеализацияПоЗаказам", РеализацияПоЗаказам);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоСделкам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	Запрос.УстановитьПараметр("РеализацияПоНесколькимЗаказам", РеализацияПоЗаказам И Не ЗначениеЗаполнено(ЗаказКлиента));
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

#КонецОбласти