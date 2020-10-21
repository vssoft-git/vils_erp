﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

#Область Печать_М15

&Вместо("ЗаполнитьРеквизитыШапкиМ15")
Процедура ВИЛС_ЗаполнитьРеквизитыШапкиМ15(ДанныеПечати, Макет, ТабличныйДокумент)
	
	// Выводим общие реквизиты шапки
	СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата, ,ДанныеПечати.БанковскийСчетОрганизации);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПредставлениеОрганизации", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации));
	СтруктураПараметров.Вставить("ОрганизацияПоОКПО", СведенияОбОрганизации.КодПоОКПО);
	СтруктураПараметров.Вставить("НомерДокумента", ДанныеПечати.Номер);    // fix Suetin 27.08.2019 15:35:24	ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер));
	// begin fix Suetin 27.08.2019 15:35:07
	Если ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.ОтгрузкаТоваровСХранения") Тогда
		ПредставлениеКонтрагента = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент, ДанныеПечати.Дата), "ПолноеНаименование,ИНН,КПП,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет,");
		ОбластьМакета.Область("R12C5:R12C13").РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
	Иначе	
	ПредставлениеКонтрагента = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент, ДанныеПечати.Дата), "ПолноеНаименование,");
	КонецЕсли;
	// end fix Suetin 27.08.2019 15:35:18
	СтруктураПараметров.Вставить("КонтрагентНаименование", ПредставлениеКонтрагента);
	
	ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры

&Вместо("ЗаполнитьТабличныйДокументМ15")
Процедура ВИЛС_ЗаполнитьТабличныйДокументМ15(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОбщихФорм.ПФ_MXL_М15_ru");
	
	ДанныеПечати        = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	Пока ДанныеПечати.Следующий() Цикл
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ВыборкаПоДокументам.Сбросить();
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска) Тогда
			Если ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов") Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 печать М-15 не требуется'"),
					ДанныеПечати.Ссылка);
			Иначе
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В документе %1 отсутствуют товары. Печать накладной не требуется'"),
					ДанныеПечати.Ссылка);
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим общие реквизиты шапки
		ЗаполнитьРеквизитыШапкиМ15(ДанныеПечати, Макет, ТабличныйДокумент);
		
		// Выводим заголовок таблицы
		ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
		
		НомерСтраницы   = 1;
		
		// Инициализация итогов в документе
		ИтоговыеСуммы = СтруктураИтоговыеСуммы();
		
		// Создаем массив для проверки вывода
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть документа
		ОбластьМакета  = Макет.ПолучитьОбласть("Строка");
		ОбластьПодвала = Макет.ПолучитьОбласть("Подвал");
		
		НомерСтроки = 0;
		ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, НомерСтроки, ВалютаРегламентированногоУчета);
		ЗаполнитьРеквизитыПодвалаМ15(ОбластьПодвала, ДанныеПечати, ИтоговыеСуммы);
		
		Если ДанныеДляПечати.РезультатПоШапке.Колонки.Найти("ВыводитьКодНоменклатуры") <> Неопределено Тогда
			ВыводитьКодНоменклатуры = ДанныеПечати.ВыводитьКодНоменклатуры;
		Иначе
			ВыводитьКодНоменклатуры = Истина;
		КонецЕсли;
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		КоличествоСтрок = СтрокаТовары.Количество();
		Пока СтрокаТовары.Следующий() Цикл
			
			НомерСтроки = НомерСтроки + 1;
			//ЗаполнитьРеквизитыСтрокиТовара(СтрокаТовары, ОбластьМакета, НомерСтроки, ВыводитьКодНоменклатуры);       // begin fix Suetin 21.03.2019 16:01:04
			ЗаполнитьРеквизитыСтрокиТовараССерией(СтрокаТовары, ОбластьМакета, НомерСтроки, ВыводитьКодНоменклатуры);  // end fix Suetin 21.03.2019 16:01:09
			
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьМакета);
			
			Если НомерСтроки = КоличествоСтрок Тогда
				МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
			КонецЕсли;
			
			Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
				НомерСтраницы = НомерСтраницы + 1;
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("НомерСтраницы", "Страница " + НомерСтраницы);
				ЗаголовокТаблицы.Параметры.Заполнить(СтруктураПараметров);
				ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			РассчитатьИтоговыеСуммы(ИтоговыеСуммы, СтрокаТовары);
			
		КонецЦикла;
		
		// Выводим итоги по документу
		ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, НомерСтроки, ВалютаРегламентированногоУчета);
		ЗаполнитьРеквизитыПодвалаМ15(ОбластьПодвала, ДанныеПечати, ИтоговыеСуммы);
		ТабличныйДокумент.Вывести(ОбластьПодвала);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Печать_СчетФактура

&Вместо("ЗаполнитьРеквизитыШапкиСчетФактура")
Процедура ВИЛС_ЗаполнитьРеквизитыШапкиСчетФактура(ДанныеПечати, ДанныеОснований, СведенияОПоставщике, ДанныеКонтрагентов, ТабличныйДокумент, ОпцииПечатиСчетаФактуры)
	
	СведенияОПоставщике = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата);
	СведенияОГрузоотправителе = СведенияОГрузоотправителе(ДанныеПечати);
	
	ДействующиеПостановления = ОпцииПечатиСчетаФактуры.ДействующиеПостановления;
	
	Макет = ОпцииПечатиСчетаФактуры.Макет;
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
	
	НомераДаты = Новый Структура("Номер, Дата, НомерИсправления, ДатаИсправления, РеквизитыОснований");
	
	НомераДаты.Номер = НомерСчетаФактурыНаПечать(ДанныеПечати.Номер, ДанныеПечати.ИндексПодразделения);
	НомераДаты.Дата = Формат(ДанныеПечати.Дата, "ДЛФ=ДД");
	НомераДаты.НомерИсправления = ?(ДанныеПечати.Исправление, ДанныеПечати.НомерИсправления, "--");
	НомераДаты.ДатаИсправления = ?(ДанныеПечати.Исправление, Формат(ДанныеПечати.ДатаИсправления, "ДЛФ=ДД"), "--");
	
	Если ДанныеПечати.КорректировочныйСчетФактура Тогда
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ДанныеОснований.НайтиСледующий(СтруктураПоиска);
		СтрокиОснований = ДанныеОснований.Выбрать();
		
		РеквизитыОснований = "";
		
		Пока СтрокиОснований.СледующийПоЗначениюПоля("ИсходныйДокумент") Цикл
			
			ТекстИсходнойСФ = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = ', № %1 от %2, с учетом исправления № %3 от %4';
					|en = ', No. %1 dated %2, considering correction No. %3 dated %4'", Метаданные.Языки.Русский.КодЯзыка),
				НомерСчетаФактурыНаПечать(СтрокиОснований.НомерСчетаФактуры, ДанныеПечати.ИндексПодразделения),
				Формат(СтрокиОснований.ДатаСчетаФактуры, "ДЛФ=ДД; ДП=--"),
				?(ЗначениеЗаполнено(СтрокиОснований.НомерИсправленияСчетаФактуры), СтрокиОснований.НомерИсправленияСчетаФактуры, "--"),
				Формат(СтрокиОснований.ДатаИсправленияСчетаФактуры, "ДЛФ=ДД; ДП=--"));
				
			РеквизитыОснований = РеквизитыОснований + ТекстИсходнойСФ;
			
		КонецЦикла;
		
		Если Не ПустаяСтрока(РеквизитыОснований) Тогда
			РеквизитыОснований = Сред(РеквизитыОснований, 3);
		КонецЕсли;
		НомераДаты.РеквизитыОснований = РеквизитыОснований;
		
	КонецЕсли;
	
	ОбластьМакета.Параметры.Заполнить(НомераДаты);
	
	СтруктураПараметров = Новый Структура;
	
	// Выводим данные о поставщике.
	ДополнительноеПредставление = "";
	Если ДействующиеПостановления.Постановление914 И СведенияОПоставщике.ОфициальноеНаименование <> СведенияОПоставщике.ПолноеНаименование Тогда
		ДополнительноеПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '(%1)';
				|en = '(%1)'"),
			ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование"));
	КонецЕсли;
	
	ПредставлениеПоставщика = СокрЛП(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 %2';
			|en = '%1 %2'"),
		СведенияОПоставщике.ОфициальноеНаименование,
		ДополнительноеПредставление));
		
	АдресПоставщика = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1';
			|en = '%1'"),
		ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ЮридическийАдрес"));
		
	ИННПоставщика = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1%2';
			|en = '%1%2'"),
		ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ИНН", Ложь),
		?(Не ПустаяСтрока(ДанныеПечати.КПППоставщика), "/" + ДанныеПечати.КПППоставщика, ""));
		
	СтруктураПараметров.Вставить("ПредставлениеПоставщика", ПредставлениеПоставщика);
	СтруктураПараметров.Вставить("АдресПоставщика", АдресПоставщика);
	СтруктураПараметров.Вставить("ИННПоставщика", ИННПоставщика);
	
	Если НЕ ДанныеПечати.КорректировочныйСчетФактура Тогда
		
		// Выводим данные грузоотправителя.
		ТекстГрузоотправителя = "";
		Если ДанныеПечати.ТолькоУслуги 
		 ИЛИ (ДействующиеПостановления.Постановление1137 И ОпцииПечатиСчетаФактуры.СчетФактураНаАванс)
		 ИЛИ ОпцииПечатиСчетаФактуры.СчетФактураНалоговыйАгент Тогда
			ТекстГрузоотправителя = "--";
		ИначеЕсли ДанныеПечати.Организация = ДанныеПечати.Грузоотправитель Тогда
			ТекстГрузоотправителя = НСтр("ru = 'он же';
										|en = 'same'", Метаданные.Языки.Русский.КодЯзыка);
		Иначе
			ТекстГрузоотправителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(
				СведенияОГрузоотправителе, "ПолноеНаименование,ФактическийАдрес");
		КонецЕсли;
		
		ПредставлениеГрузоотправителя = СокрЛП(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1';
				|en = '%1'"),
			ТекстГрузоотправителя));
		
		СтруктураПараметров.Вставить("ПредставлениеГрузоотправителя", ПредставлениеГрузоотправителя);
		
		СтрокаПоДокументу = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1';
				|en = '%1'"),
			?(ПустаяСтрока(ДанныеПечати.СтрокаПоДокументу),
				НСтр("ru = '-- от --';
					|en = '-- dated --'", Метаданные.Языки.Русский.КодЯзыка),
				ДанныеПечати.СтрокаПоДокументу));
		
		СтруктураПараметров.Вставить("ПоДокументу", СтрокаПоДокументу);
		
	КонецЕсли;
	
	ЕстьГрузополучатель = Не ДанныеПечати.КорректировочныйСчетФактура
		И НЕ (ДанныеПечати.ТолькоУслуги
		ИЛИ (ДействующиеПостановления.Постановление1137 И ОпцииПечатиСчетаФактуры.СчетФактураНаАванс)
		ИЛИ ОпцииПечатиСчетаФактуры.СчетФактураНалоговыйАгент);
	
	ПредставлениеПокупателя       = "";
	ПредставлениеАдресаПокупателя = "";
	ПредставлениеИННКПППокупателя = "";
	ПредставлениеГрузополучателя  = "";
	
	ТаблицаКонтрагентов = ТаблицаКонтрагентовСчетаФактуры(ДанныеПечати, ДанныеКонтрагентов);
	
	Для Каждого СтрокаТаблицы Из ТаблицаКонтрагентов Цикл
		
		СведенияОПокупателе = СтрокаТаблицы.СведенияОПокупателе;
		
		ПредставлениеПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1; %2';
				|en = '%1; %2'"),
			ПредставлениеПокупателя,
			ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование", Ложь));
		
		ПредставлениеАдресаПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1; %2';
				|en = '%1; %2'"),
			ПредставлениеАдресаПокупателя,
			ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ЮридическийАдрес", Ложь));
			
		ПредставлениеИННПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1; %2%3';
				|en = '%1; %2%3'"),
			ПредставлениеИННПокупателя,
			СтрокаТаблицы.ИНН,
			?(Не ПустаяСтрока(СтрокаТаблицы.КПП), "/" + СтрокаТаблицы.КПП, ""));
		
		Если ЕстьГрузополучатель Тогда
			СведенияОГрузополучателе = СтрокаТаблицы.СведенияОГрузополучателе;
			ПредставлениеГрузополучателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1; %2';
					|en = '%1; %2'"),
				ПредставлениеГрузополучателя,
				ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, "ПолноеНаименование,ФактическийАдрес", Ложь));
		КонецЕсли;
		
	КонецЦикла;
	
	ПредставлениеПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1';
			|en = '%1'"),
		Сред(ПредставлениеПокупателя, 3));
	
	ПредставлениеАдресаПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1';
			|en = '%1'"),
		Сред(ПредставлениеАдресаПокупателя, 3));
	
	ПредставлениеИННПокупателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1';
			|en = '%1'"),
		Сред(ПредставлениеИННПокупателя, 3));
		
	// begin fix Suetin 05.02.2019 3:08:46
	Если ЗначениеЗаполнено(ДанныеПечати.Договор) Тогда	
		СтруктураПараметров.Вставить("Основание",ДанныеПечати.Договор);
	КонецЕсли;	
	// end fix Suetin 05.02.2019 3:08:53
		
	ПредставлениеГрузополучателя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1';
			|en = '%1'"),
		?(ЕстьГрузополучатель, Сред(ПредставлениеГрузополучателя, 3), "--"));
		
	СтруктураПараметров.Вставить("ПредставлениеПокупателя", ПредставлениеПокупателя);
	СтруктураПараметров.Вставить("АдресПокупателя", ПредставлениеАдресаПокупателя);
	СтруктураПараметров.Вставить("ИННПокупателя", ПредставлениеИННПокупателя);
	Если Не ДанныеПечати.КорректировочныйСчетФактура Тогда
		СтруктураПараметров.Вставить("ПредставлениеГрузополучателя", ПредставлениеГрузополучателя);
	КонецЕсли;
	
	Если ДействующиеПостановления.Постановление1137 И ЗначениеЗаполнено(ДанныеПечати.Валюта) 
		И ОпцииПечатиСчетаФактуры.ПечатьВВалюте Тогда
		
		СтруктураПараметров.Вставить("Валюта", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1, %2';
				|en = '%1, %2'"),
			ДанныеПечати.ВалютаНаименованиеПолное,
			ДанныеПечати.ВалютаКод));
			
	ИначеЕсли ДействующиеПостановления.Постановление1137 Тогда
		СтруктураПараметров.Вставить("Валюта", НСтр("ru = 'Российский рубль, 643';
													|en = 'Russian ruble, 643'", Метаданные.Языки.Русский.КодЯзыка));
	КонецЕсли;
	
	СтруктураПараметровИдентификаторГосКонтракта = Новый Структура("ИдентификаторГосКонтракта");
	ЗаполнитьЗначенияСвойств(СтруктураПараметровИдентификаторГосКонтракта, ДанныеПечати);
	Если ДействующиеПостановления.Постановление981 Тогда
		ПредставлениеИдентификаторГосКонтракта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1';
				|en = '%1'"),
			СокрЛП(СтруктураПараметровИдентификаторГосКонтракта.ИдентификаторГосКонтракта));
	Иначе
		ПредставлениеИдентификаторГосКонтракта = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1';
				|en = '%1'"),
			СокрЛП(СтруктураПараметровИдентификаторГосКонтракта.ИдентификаторГосКонтракта));
	КонецЕсли;
	СтруктураПараметров.Вставить("ИдентификаторГосКонтракта", ПредставлениеИдентификаторГосКонтракта);
	
	Если ОпцииПечатиСчетаФактуры.СчетФактураНалоговыйАгент Тогда
		// для печати подвала берем сведения об организации из сведений о покупателе
		СведенияОПоставщике = СведенияОПокупателе;
	КонецЕсли;
	
	ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
	ТабличныйДокумент.Вывести(ОбластьМакета);

	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыСтрокиТовараССерией(СтрокаТовары, ОбластьМакета, НомерСтроки, ВыводитьКодНоменклатуры = Истина, ВыводитьКодТНВД = Неопределено, СчетФактураНаАванс = Ложь)
	
	ИспользоватьНаборы = ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТовары, "ЭтоНабор");
	
	ПрефиксИПостфикс = НаборыСервер.ПолучитьПрефиксИПостфикс(СтрокаТовары, ИспользоватьНаборы);
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоКомплектующие
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие
		И (СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям
		   ИЛИ СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам) Тогда
		// Область должна остаться незаполненной
		ОбластьМакета.Параметры.Заполнить(НаборыСервер.ПустыеДанные());
	ИначеЕсли ИспользоватьНаборы
		И СтрокаТовары.ЭтоНабор
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие
		И (СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих
			ИЛИ СчетФактураНаАванс) Тогда
		// Область должна остаться незаполненной
		ОбластьМакета.Параметры.Заполнить(НаборыСервер.ПустыеДанные());
	Иначе
		ОбластьМакета.Параметры.Заполнить(СтрокаТовары);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("КоличествоМест", 0);
	СтруктураПараметров.Вставить("КоличествоВОдномМесте", 0);
	СтруктураПараметров.Вставить("НоменклатураКод", "");
	СтруктураПараметров.Вставить("КодТНВЭД", "--");
	
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтрокаТовары);
	ОкруглитьДоЦелого(СтруктураПараметров.КоличествоМест);
	СтруктураПараметров.Вставить("НомерСтроки", НомерСтроки);
	                                               
	ДополнительныеПараметрыПолученияНаименованияДляПечати = НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
	ДополнительныеПараметрыПолученияНаименованияДляПечати.ВозвратнаяТара = СтрокаТовары.ЭтоВозвратнаяТара;	
	Если ВыводитьКодТНВД <> Неопределено Тогда
		ДополнительныеПараметрыПолученияНаименованияДляПечати.КодТНВЭД = ?(НЕ ВыводитьКодТНВД.ВыводитьВКолонке И ВыводитьКодТНВД.ВыводитьВСтроке, СтрокаТовары.КодТНВЭД, "");
		Если НЕ ВыводитьКодТНВД.ВыводитьВКолонке Тогда
			СтруктураПараметров.КодТНВЭД = "--";
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеНоменклатуры =  ПрефиксИПостфикс.Префикс
		+ НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
			Строка(СтрокаТовары.НоменклатураНаименование),
			СтрокаТовары.ХарактеристикаНаименование,
			, СтрокаТовары.СерияНаименование  // fix Suetin 21.03.2019 16:03:22
			,
			ДополнительныеПараметрыПолученияНаименованияДляПечати)
		+ ПрефиксИПостфикс.Постфикс;
	
	СтруктураПараметров.Вставить("ПредставлениеНоменклатуры", ПредставлениеНоменклатуры);
		
	Если Не ВыводитьКодНоменклатуры Тогда
		СтруктураПараметров.НоменклатураКод = "";
	КонецЕсли;
	ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
	
КонецПроцедуры

&Вместо("ЗаполнитьТабличныйДокументТОРГ12")
Процедура ВИЛС_ЗаполнитьТабличныйДокументТОРГ12(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати)
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	КоэффициентПересчетаВТонны     = НоменклатураСервер.КоэффициентПересчетаВТонны(Константы.ЕдиницаИзмеренияВеса.Получить());
	
	ДанныеПечати      	= ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВыводитьГТД = ?(ПараметрыПечати.Свойство("ВыводитьГТД"), ПараметрыПечати.ВыводитьГТД, Ложь);
	
	Если ВыводитьГТД Тогда
		Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОбщихФорм.ПФ_MXL_ТОРГ12_ГТД_ru");
	Иначе
		Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОбщихФорм.ПФ_MXL_ТОРГ12_ru");
	КонецЕсли;
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	
	ПервыйДокумент = Истина;
	Пока ДанныеПечати.Следующий() Цикл
		
		Если ДанныеПечати.Статус = Перечисления.СтатусыРеализацийТоваровУслуг.КПредоплате Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В документе %1 установлен статус ""К предоплате"". Печать ТОРГ-12 в данном статусе не требуется.';
					|en = 'Status of the %1 document is set to ""For prepayment"". It is not required to print TORG-12 in this status.'"),
				ДанныеПечати.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ВыборкаПоДокументам.Сбросить();
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска) Тогда
			Если ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов") Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В документе %1 отсутствуют внеоборотные активы. Печать ТОРГ-12 не требуется';
						|en = 'No capital assets in the %1 document. Do not print TORG-12 '"),
					ДанныеПечати.Ссылка);
			Иначе
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В документе %1 отсутствуют товары. Печать товарной накладной без услуг не требуется';
						|en = 'Goods are missing in document %1. Printing of an invoice without services is not required'"),
					ДанныеПечати.Ссылка);
			КонецЕсли;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ЗаполнитьРеквизитыШапкиТОРГ12(ДанныеПечати, Макет, ТабличныйДокумент);
		
		НомерСтраницы = 1;
		ИтоговыеСуммы = СтруктураИтоговыеСуммы();
		
		// Создаем массив для проверки вывода
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть докмента
		ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаб");
		ОбластьМакетаСтандарт   = Макет.ПолучитьОбласть("Строка");
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьВсего            = Макет.ПолучитьОбласть("Всего");
		
		ИспользоватьНаборы = Ложь;
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ВыборкаПоДокументам, "ЭтоНабор") Тогда
			ИспользоватьНаборы = Истина;
			ОбластьМакетаНабор         = Макет.ПолучитьОбласть("СтрокаНабор");
			ОбластьМакетаКомплектующие = Макет.ПолучитьОбласть("СтрокаКомплектующие");
		КонецЕсли;
		
		ВыводШапки = 0;
		
		Если ДанныеДляПечати.РезультатПоШапке.Колонки.Найти("ВыводитьКодНоменклатуры") <> Неопределено Тогда
			ВыводитьКодНоменклатуры = ДанныеПечати.ВыводитьКодНоменклатуры;
		Иначе
			ВыводитьКодНоменклатуры = Истина;
		КонецЕсли;
		
		ОперацияОблагаетсяНДСУПокупателя = Ложь;
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ДанныеПечати,"НалогообложениеНДС") 
			И ДанныеПечати.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя Тогда
			ОперацияОблагаетсяНДСУПокупателя = Истина;
		КонецЕсли;
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		КоличествоСтрок = СтрокаТовары.Количество();
		НомерСтроки = 0;
		Пока СтрокаТовары.Следующий() Цикл
			
			Если НаборыСервер.ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьМакета = ОбластьМакетаНабор;
			ИначеЕсли НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				ОбластьМакета = ОбластьМакетаКомплектующие;
			Иначе
				ОбластьМакета = ОбластьМакетаСтандарт;
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Тогда
				// begin fix Suetin 08.09.2020 10:28:59
				Если ДанныеДляПечати.РезультатПоТабличнойЧасти.Колонки.Найти("СерияНоменклатуры") = Неопределено Тогда
					ЗаполнитьРеквизитыСтрокиТовара(СтрокаТовары, ОбластьМакета, Неопределено); 
				Иначе
					ЗаполнитьРеквизитыСтрокиТовараССерией(СтрокаТовары, ОбластьМакета, Неопределено);
				КонецЕсли; 
				// end fix Suetin 08.09.2020 10:28:39 
			Иначе
				НомерСтроки = НомерСтроки + 1;
				// begin fix Suetin 08.09.2020 10:28:59
				Если ДанныеДляПечати.РезультатПоТабличнойЧасти.Колонки.Найти("СерияНоменклатуры") = Неопределено Тогда
					ЗаполнитьРеквизитыСтрокиТовара(СтрокаТовары, ОбластьМакета, НомерСтроки); 
				Иначе
					ЗаполнитьРеквизитыСтрокиТовараССерией(СтрокаТовары, ОбластьМакета, НомерСтроки);
				КонецЕсли;
				// end fix Suetin 08.09.2020 10:30:30
			КонецЕсли;
			
			Если ОперацияОблагаетсяНДСУПокупателя Тогда
				ОбластьМакета.Параметры.СтавкаНДС = НСтр("ru = 'НДС исчисляется налоговым агентом';
														|en = 'VAT is calculated by tax agent'", Метаданные.Языки.Русский.КодЯзыка);
				ОбластьМакета.Параметры.СуммаСНДС = "--";
				ОбластьМакета.Параметры.СуммаНДС = "--";
			КонецЕсли;
			
			Если НомерСтроки = 0 И ВыводШапки <> 2 Тогда
				ВыводШапки = 1;
			КонецЕсли;
			
			Если (НомерСтроки = 1 И ВыводШапки = 0) ИЛИ (НомерСтроки = 0 И ВыводШапки = 1) Тогда
				
				ВыводШапки = 2;
				
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("НомерСтраницы", "Страница " + НомерСтраницы);
				ОбластьЗаголовокТаблицы.Параметры.Заполнить(СтруктураПараметров);
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			КонецЕсли;
			
			МассивВыводимыхОбластей.Очистить();
			МассивВыводимыхОбластей.Добавить(ОбластьМакета);
			МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
			Если НомерСтроки = КоличествоСтрок Тогда
				ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, НомерСтроки, ВалютаРегламентированногоУчета);
				ОбластьПодвала = ЗаполнитьРеквизитыПодвалаТОРГ12(ДанныеПечати, ИтоговыеСуммы, Макет, КоэффициентПересчетаВТонны);
				МассивВыводимыхОбластей.Добавить(ОбластьВсего);
				МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
			КонецЕсли;
			
			Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
				ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
				ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
				
				ОбнулитьИтогиПоСтранице(ИтоговыеСуммы);
				
				НомерСтраницы = НомерСтраницы + 1;
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("НомерСтраницы", "Страница " + НомерСтраницы);
				ОбластьЗаголовокТаблицы.Параметры.Заполнить(СтруктураПараметров);
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			Если Не НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
				РассчитатьИтоговыеСуммы(ИтоговыеСуммы, СтрокаТовары);
			КонецЕсли;
			
		КонецЦикла;
		
		// Выводим итоги по последней странице
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
		
		Если ОперацияОблагаетсяНДСУПокупателя Тогда
			ОбластьИтоговПоСтранице.Параметры.ИтогоСуммаСНДСНаСтранице = "--";
			ОбластьИтоговПоСтранице.Параметры.ИтогоСуммаНДСНаСтранице = "--";
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
		
		// Выводим итоги по документу в целом
		ОбластьМакета = Макет.ПолучитьОбласть("Всего");
		ОбластьМакета.Параметры.Заполнить(ИтоговыеСуммы);
		
		Если ОперацияОблагаетсяНДСУПокупателя Тогда
			ОбластьМакета.Параметры.ИтогоСуммаСНДС = "--";
			ОбластьМакета.Параметры.ИтогоСуммаНДС = "--";
		КонецЕсли;
			
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим подвал документа
		ДобавитьИтоговыеДанныеПодвала(ИтоговыеСуммы, НомерСтроки, ВалютаРегламентированногоУчета);
		ОбластьПодвала = ЗаполнитьРеквизитыПодвалаТОРГ12(ДанныеПечати, ИтоговыеСуммы, Макет, КоэффициентПересчетаВТонны);
		ТабличныйДокумент.Вывести(ОбластьПодвала);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

&Вместо("ЗаполнитьРеквизитыШапкиТОРГ12")
Процедура ВИЛС_ЗаполнитьРеквизитыШапкиТОРГ12(ДанныеПечати, Макет, ТабличныйДокумент)
	
	// Выводим общие реквизиты шапки
	СведенияОПоставщике       = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация,      ДанныеПечати.Дата,, ДанныеПечати.БанковскийСчетОрганизации);
	СведенияОПокупателе       = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент,       ДанныеПечати.Дата,, ДанныеПечати.БанковскийСчетКонтрагента);
	СведенияОГрузополучателе  = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузополучатель,  ДанныеПечати.Дата,, ДанныеПечати.БанковскийСчетГрузополучателя);
	СведенияОГрузоотправитель = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузоотправитель, ДанныеПечати.Дата,, ДанныеПечати.БанковскийСчетГрузоотправителя);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("НомерДокумента",СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(ДанныеПечати.Номер, "0"));//begin fix Клещ А.Н. 30.10.2019 СтруктураПараметров.Вставить("НомерДокумента", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер));
	СтруктураПараметров.Вставить("ДатаДокумента", ДанныеПечати.Дата);
	
	Если ДанныеПечати.Организация = ДанныеПечати.Грузоотправитель Тогда
		СтруктураПараметров.Вставить("ПредставлениеОрганизации", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике));
	Иначе
		СтруктураПараметров.Вставить("ПредставлениеОрганизации", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, 
			"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет"));
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ПредставлениеПодразделения", ДанныеПечати.Подразделение);
	СтруктураПараметров.Вставить("ПредставлениеГрузополучателя", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, 
		"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет"));
	СтруктураПараметров.Вставить("ПредставлениеПоставщика", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике));
	СтруктураПараметров.Вставить("ПредставлениеПлательщика", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе));
	СтруктураПараметров.Вставить("ОрганизацияПоОКПО", СведенияОГрузоотправитель.КодПоОКПО);
	СтруктураПараметров.Вставить("ВидДеятельностиПоОКДП", СведенияОПоставщике.КодОКВЭД);
	СтруктураПараметров.Вставить("ГрузополучательПоОКПО", СведенияОГрузополучателе.КодПоОКПО);
	СтруктураПараметров.Вставить("ПоставщикПоОКПО", СведенияОПоставщике.КодПоОКПО);
	СтруктураПараметров.Вставить("ПлательщикПоОКПО", СведенияОПокупателе.КодПоОКПО);
	СтруктураПараметров.Вставить("ОснованиеНомер", ДанныеПечати.ОснованиеНомер);
	СтруктураПараметров.Вставить("ОснованиеДата", ДанныеПечати.ОснованиеДата);
	СтруктураПараметров.Вставить("ТранспортнаяНакладнаяНомер", "");
	СтруктураПараметров.Вставить("ТранспортнаяНакладнаяДата", "");
	
	ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры

&ИзменениеИКонтроль("Печать")
Процедура ВИЛС_Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М4") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"М4",
			НСтр("ru = 'Приходный ордер (М-4)';
				|en = 'Goods receipt note (M-4)'"),
			СформироватьПечатнуюФормуМ4(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТОРГ4") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ТОРГ4",
			НСтр("ru = 'Акт о приемке товара, поступившего без счета поставщика (ТОРГ-4)';
				|en = 'Certificate of goods receiving without purchase proforma invoice (TORG-4)'"),
			СформироватьПечатнуюФормуТОРГ4(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТОРГ12") Тогда
		
		Если ПараметрыПечати["ВыводитьУслуги"] Тогда
			СинонимМакета = НСтр("ru = 'Товарная накладная (ТОРГ-12)';
								|en = 'Invoice (TORG-12)'");
		Иначе
			СинонимМакета = НСтр("ru = 'Товарная накладная без услуг (ТОРГ-12)';
								|en = 'Invoice without services (TORG-12)'");
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ТОРГ12",
			СинонимМакета,
			СформироватьПечатнуюФормуТОРГ12(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М15") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"М15",
			НСтр("ru = 'Накладная (М-15)';
				|en = 'Invoice (M-15)'"),
			СформироватьПечатнуюФормуМ15(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
#Вставка
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М15_ВИЛС") Тогда          // begin fix Suetin 21.10.2020 15:45:03 Ticket#8219989
		
		ПараметрыПечати.Вставить("ВыводитьРабочееНаименование", Истина); 						// fix Suetin 21.10.2020 15:35:49  
		СтрокиКоллекцияПечатныхФорм = КоллекцияПечатныхФорм.НайтиСтроки(Новый Структура("ИмяВРЕГ", "М15_ВИЛС"));
		Для каждого СтрокаТЗ Из СтрокиКоллекцияПечатныхФорм Цикл
			СтрокаТЗ.ИмяВРЕГ = "М15";
			СтрокаТЗ.ИмяМакета = "М15";
		КонецЦикла;    																			// fix Suetin 21.10.2020 19:26:34
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"М15",
			НСтр("ru = 'Накладная (М-15) (ВИЛС, рабочее наименование номенклатуры)';
				|en = 'Invoice (M-15) (VILS, work name of the nomenclature)'"),
			СформироватьПечатнуюФормуМ15(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;  																				// end fix Suetin 21.10.2020 15:45:21
#КонецВставки
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетФактура") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"СчетФактура",
			НСтр("ru = 'Счет-фактура';
				|en = 'Tax invoice'"),
			СформироватьПечатнуюФормуСчетФактура(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетФактураВВалюте") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"СчетФактураВВалюте",
			НСтр("ru = 'Счет-фактура';
				|en = 'Tax invoice'"),
			СформироватьПечатнуюФормуСчетФактура(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "УПД") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"УПД",
			НСтр("ru = 'Универсальный передаточный документ (УПД)';
				|en = 'Universal transfer document (UTD)'"),
			СформироватьПечатнуюФормуУПД(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "УКД") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"УКД",
			НСтр("ru = 'Универсальный корректировочный документ (УКД)';
				|en = 'Universal adjustment document (UAD)'"),
			СформироватьПечатнуюФормуУКД(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
		
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктНаПередачуПрав") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"АктНаПередачуПрав",
			НСтр("ru = 'Акт на передачу прав';
				|en = 'Assignment deed'"),
			СформироватьПечатнуюФормуАктНаПередачуПрав(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "МХ1") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"МХ1",
			НСтр("ru = 'Акт о приеме-передаче ТМЦ на хранение (МХ-1)';
				|en = 'Certificate of inventory handover for storage (MH-1)'"),
			СформироватьПечатнуюФормуМХ1(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "МХ3") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"МХ3",
			НСтр("ru = 'Акт о возврате ТМЦ, сданных на хранение (МХ-3)';
				|en = 'Certificate of stored inventory return (MH-3)'"),
			СформироватьПечатнуюФормуМХ3(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	//++ НЕ УТ
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "МХ18") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"МХ18",
			НСтр("ru = 'Накладная на передачу готовой продукции (МХ-18)';
				|en = 'Invoice for finished product transfer (MH-18)'"),
			СформироватьПечатнуюФормуМХ18(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	//-- НЕ УТ
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, СтруктураТипов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли