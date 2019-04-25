﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

&Вместо("СформироватьПечатнуюФормуЗаказНаПеремещение")
// Функция формирует табличный документ с печатной формой заказа,
// разработанной методистами.
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной.
//
Функция ВИЛС_СформироватьПечатнуюФормуЗаказНаПеремещение(МассивОбъектов, ОбъектыПечати)
	
	Колонка = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	ВыводитьКоды = ЗначениеЗаполнено(Колонка);
	
	ИспользоватьУпаковкиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказНаПеремещение";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаказНаПеремещение.ВИЛС_ПФ_MXL_ЗаказНаПеремещение");
	
	ОбластьЗаголовкаПеремещение         = Макет.ПолучитьОбласть("ЗаголовокПеремещение");
	ОбластьЗаголовкаВнутренняяПередача  = Макет.ПолучитьОбласть("ЗаголовокВнутренняяПередача");
	
	Если ВыводитьКоды Тогда
		
		ОбластьКодовШапка  = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
		ОбластьКодовШапка.Параметры.ИмяКолонкиКодов = Колонка;
		
		ОбластьКодовСтрока = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
		ОбластьКодовПодвал = Макет.ПолучитьОбласть("Подвал|КолонкаКодов");
		
	Иначе
		
		ОбластьТовары = Макет.Область("Товар");
		ОбластьТовары.ШиринаКолонки = ОбластьТовары.ШиринаКолонки + Макет.Область("КолонкаКодов").ШиринаКолонки;
		
	КонецЕсли;
	
	Если ИспользоватьУпаковкиНоменклатуры Тогда
		
		ОбластьУпаковокШапка  =  Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаУпаковок");
		ОбластьУпаковокСтрока =  Макет.ПолучитьОбласть("Строка|КолонкаУпаковок");
		ОбластьУпаковокПодвал =  Макет.ПолучитьОбласть("Подвал|КолонкаУпаковок");
		
	Иначе
		
		ОбластьТовары = Макет.Область("Товар");
		ОбластьТовары.ШиринаКолонки = ОбластьТовары.ШиринаКолонки 
									  + Макет.Область("КолонкаУпаковокКоличество").ШиринаКолонки
									  + Макет.Область("КолонкаУпаковокПредставление").ШиринаКолонки;
									  
	КонецЕсли;
	
	ОбластьНомераШапка = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
	ОбластьДанныхШапка = Макет.ПолучитьОбласть("ШапкаТаблицы|Товар");
	ОбластьКонецСтрокиШапка = Макет.ПолучитьОбласть("ШапкаТаблицы|КонецСтроки");
	
	ОбластьНомераСтрока = Макет.ПолучитьОбласть("Строка|НомерСтроки");
	ОбластьДанныхСтрока = Макет.ПолучитьОбласть("Строка|Товар");
	ОбластьКонецСтрокиСтрока = Макет.ПолучитьОбласть("Строка|КонецСтроки");
	
	ОбластьНомераПодвал = Макет.ПолучитьОбласть("Подвал|НомерСтроки");
	ОбластьДанныхПодвал = Макет.ПолучитьОбласть("Подвал|Товар");
	ОбластьКонецСтрокиПодвал = Макет.ПолучитьОбласть("Подвал|КонецСтроки");
	
	ОбластьПодписей = Макет.ПолучитьОбласть("Подписи");
	
	ЗапросПоШапке = Новый Запрос;
	ЗапросПоШапке.Текст = 
		"ВЫБРАТЬ
		|	ЗаказНаПеремещение.Ссылка КАК Ссылка,
		|	ЗаказНаПеремещение.Номер КАК Номер,
		|	ЗаказНаПеремещение.Дата КАК Дата,
		|	ЗаказНаПеремещение.Организация.Префикс КАК Префикс,
		|	ЗаказНаПеремещение.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗаказНаПеремещение.СкладОтправитель) КАК ОтправительПредставление,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЗаказНаПеремещение.СкладПолучатель) КАК ПолучательПредставление,
		|	ВЫБОР КОГДА ЗаказНаПеремещение.Организация.НаименованиеСокращенное = """" ТОГДА
		|		ЗаказНаПеремещение.Организация.Наименование
		|	ИНАЧЕ
		|		ЗаказНаПеремещение.Организация.НаименованиеСокращенное
		|	КОНЕЦ КАК ОрганизацияПредставление,
		|	ВЫБОР КОГДА ЗаказНаПеремещение.ОрганизацияПолучатель.НаименованиеСокращенное = """" ТОГДА
		|		ЗаказНаПеремещение.ОрганизацияПолучатель.Наименование
		|	ИНАЧЕ
		|		ЗаказНаПеремещение.ОрганизацияПолучатель.НаименованиеСокращенное
		|	КОНЕЦ КАК ОрганизацияПолучательПредставление,
		|	ЗаказНаПеремещение.Ответственный.ФизическоеЛицо КАК Менеджер
		|ИЗ
		|	Документ.ЗаказНаПеремещение КАК ЗаказНаПеремещение
		|ГДЕ
		|	ЗаказНаПеремещение.Ссылка В(&МассивДокументов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка";
	
	ЗапросПоШапке.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	УстановитьПривилегированныйРежим(Истина);
	ВыборкаПоШапке = ЗапросПоШапке.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТекстЗапросаПоТоварам =
	"ВЫБРАТЬ
		|	ЗаказыНаПеремещение.Номенклатура КАК Номенклатура,
		|	ЗаказыНаПеремещение.Характеристика КАК Характеристика,
		|	ЗаказыНаПеремещение.КодСтроки КАК КодСтроки,
		|	ЗаказыНаПеремещение.Серия КАК Серия,
		|	СУММА(ЗаказыНаПеремещение.Заказано) КАК Заказано,
		|	Максимум(ДвиженияСерийТоваров.Документ) КАК Документ,
		|	Максимум(ДвиженияСерийТоваров.Регистратор) КАК Регистратор,
		|	ЗаказыНаПеремещение.Регистратор КАК Заказ,
		|   Максимум(ВЫРАЗИТЬ(ДвиженияСерийТоваров.Регистратор.Комментарий КАК СТРОКА(300))) КАК Комментарий
		|ПОМЕСТИТЬ ВТ_СерииПриход
		|ИЗ
		|	РегистрНакопления.ЗаказыНаПеремещение КАК ЗаказыНаПеремещение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДвиженияСерийТоваров КАК ДвиженияСерийТоваров
		|		ПО (ЗаказыНаПеремещение.Номенклатура = ДвиженияСерийТоваров.Номенклатура)
		|			И (ЗаказыНаПеремещение.Характеристика = ДвиженияСерийТоваров.Характеристика)
		|			И (ЗаказыНаПеремещение.Серия = ДвиженияСерийТоваров.Серия)
		|ГДЕ
		|	ЗаказыНаПеремещение.Регистратор В(&МассивОбъектов)
		|	И ДвиженияСерийТоваров.СкладскаяОперация В(&СкладскаяОперация)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказыНаПеремещение.Номенклатура,
		|	ЗаказыНаПеремещение.Характеристика,
		|	ЗаказыНаПеремещение.КодСтроки,
		|	ЗаказыНаПеремещение.Серия,
		|	//ДвиженияСерийТоваров.Документ,
		|	//ДвиженияСерийТоваров.Регистратор,
		|	ЗаказыНаПеремещение.Регистратор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
		|	ЦеныНоменклатуры.Характеристика КАК Характеристика,
		|	ЦеныНоменклатуры.Цена КАК Цена
		|ПОМЕСТИТЬ ВТ_Цены
		|ИЗ
		|	(ВЫБРАТЬ
		|		ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
		|		ЦеныНоменклатурыСрезПоследних.Характеристика КАК Характеристика,
		|		ЦеныНоменклатурыСрезПоследних.Цена КАК Цена
		|	ИЗ
		|		РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		|				&ДатаСреза,
		|				(Номенклатура, Характеристика, Регистратор.ДокументОснование) В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ.Номенклатура,
		|						ВТ.Характеристика,
		|						ВТ.Регистратор
		|					ИЗ
		|						ВТ_СерииПриход КАК ВТ)) КАК ЦеныНоменклатурыСрезПоследних
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ЦеныНоменклатурыСрезПоследних.Номенклатура,
		|		ЦеныНоменклатурыСрезПоследних.Характеристика,
		|		ЦеныНоменклатурыСрезПоследних.Цена
		|	ИЗ
		|		РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
		|				&ДатаСреза,
		|				(Номенклатура, Характеристика, ВЫРАЗИТЬ(Регистратор.Комментарий КАК СТРОКА(300))) В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ.Номенклатура,
		|						ВТ.Характеристика,
		|						ВТ.Комментарий
		|					ИЗ
		|						ВТ_СерииПриход КАК ВТ)) КАК ЦеныНоменклатурыСрезПоследних) КАК ЦеныНоменклатуры
		|
		|СГРУППИРОВАТЬ ПО
		|	ЦеныНоменклатуры.Номенклатура,
		|	ЦеныНоменклатуры.Характеристика,
		|	ЦеныНоменклатуры.Цена
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_СерииПриход.КодСтроки КАК КодСтроки,
		|	ЕСТЬNULL(ВТ_Цены.Цена, 0) КАК Цена,
		|	ВЫРАЗИТЬ(ВТ_СерииПриход.Заказано * ЕСТЬNULL(ВТ_Цены.Цена, 0) КАК ЧИСЛО(15, 0)) КАК Сумма,
		|	ВТ_СерииПриход.Заказ КАК Заказ
		|ПОМЕСТИТЬ ВТ_ЦеныКЗаказу
		|ИЗ
		|	ВТ_СерииПриход КАК ВТ_СерииПриход
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Цены КАК ВТ_Цены
		|		ПО (ВТ_СерииПриход.Номенклатура = ВТ_Цены.Номенклатура)
		|			И ВТ_СерииПриход.Характеристика = ВТ_Цены.Характеристика
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_СерииПриход.КодСтроки,
		|	ЕСТЬNULL(ВТ_Цены.Цена, 0),
		|	ВЫРАЗИТЬ(ВТ_СерииПриход.Заказано * ЕСТЬNULL(ВТ_Цены.Цена, 0) КАК ЧИСЛО(15, 0)),
		|	ВТ_СерииПриход.Заказ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	ТаблицаТовары.Ссылка КАК Ссылка,
		|	СпрНоменклатура.Ссылка КАК Товар,
		|	СпрНоменклатура.НаименованиеПолное КАК ТоварНаименование,
		|	СпрНоменклатура.Код КАК Код,
		|	СпрНоменклатура.Артикул КАК Артикул,
		|	ТаблицаТовары.Характеристика.НаименованиеПолное КАК Характеристика,
		|	ТаблицаТовары.Серия КАК Серия,
		|	ВЫБОР
		|		КОГДА ТаблицаТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|			ТОГДА ПРЕДСТАВЛЕНИЕССЫЛКИ(СпрНоменклатура.ЕдиницаИзмерения)
		|		ИНАЧЕ ПРЕДСТАВЛЕНИЕССЫЛКИ(ТаблицаТовары.Упаковка)
		|	КОНЕЦ КАК ПредставлениеЕдининицыИзмеренияУпаковки,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СпрНоменклатура.ЕдиницаИзмерения) КАК ПредставлениеБазовойЕдиницыИзмерения,
		|	ТаблицаТовары.КоличествоУпаковок КАК КоличествоУпаковок,
		|	ТаблицаТовары.Количество КАК Количество,
		|	ЕСТЬNULL(ВТ_ЦеныКЗаказу.Цена, 0) КАК Цена,
		|	ТаблицаТовары.Количество*ЕСТЬNULL(ВТ_ЦеныКЗаказу.Цена, 0) КАК Сумма
		|ИЗ
		|	Документ.ЗаказНаПеремещение.Товары КАК ТаблицаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
		|		ПО (СпрНоменклатура.Ссылка = ТаблицаТовары.Номенклатура)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ЦеныКЗаказу КАК ВТ_ЦеныКЗаказу
		|		ПО (ТаблицаТовары.Ссылка = ВТ_ЦеныКЗаказу.Заказ)
		|			И (ТаблицаТовары.КодСтроки = ВТ_ЦеныКЗаказу.КодСтроки)
		|ГДЕ
		|	ТаблицаТовары.Ссылка В (&МассивОбъектов)
		|	И НЕ ТаблицаТовары.Отменено
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка
		|ИТОГИ ПО
		|	Ссылка";
	
		//"ВЫБРАТЬ
		//|	ТаблицаТовары.Ссылка КАК Ссылка,
		//|
		//|	СпрНоменклатура.Ссылка                                КАК Товар,
		//|	СпрНоменклатура.НаименованиеПолное                    КАК ТоварНаименование,
		//|	СпрНоменклатура.Код                                   КАК Код,
		//|	СпрНоменклатура.Артикул                               КАК Артикул,
		//|	ТаблицаТовары.Характеристика.НаименованиеПолное       КАК Характеристика,
		//|	ТаблицаТовары.Серия                                   КАК Серия,
		//|
		//|	ВЫБОР КОГДА ТаблицаТовары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) ТОГДА
		//|				ПРЕДСТАВЛЕНИЕССЫЛКИ(СпрНоменклатура.ЕдиницаИзмерения)
		//|			ИНАЧЕ
		//|				ПРЕДСТАВЛЕНИЕССЫЛКИ(ТаблицаТовары.Упаковка)
		//|		КОНЕЦ                                             КАК ПредставлениеЕдининицыИзмеренияУпаковки,
		//|
		//|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СпрНоменклатура.ЕдиницаИзмерения) КАК ПредставлениеБазовойЕдиницыИзмерения,
		//|
		//|	ТаблицаТовары.КоличествоУпаковок КАК КоличествоУпаковок,
		//|	ТаблицаТовары.Количество         КАК Количество
		//|ИЗ
		//|	Документ.ЗаказНаПеремещение.Товары КАК ТаблицаТовары
		//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
		//|		ПО СпрНоменклатура.Ссылка = ТаблицаТовары.Номенклатура
		//|ГДЕ
		//|	ТаблицаТовары.Ссылка В(&МассивОбъектов)
		//|	И НЕ ТаблицаТовары.Отменено
		//|
		//|УПОРЯДОЧИТЬ ПО
		//|	Ссылка
		//|
		//|ИТОГИ ПО
		//|	Ссылка";
	
	ЗапросПоТоварам = Новый Запрос;
	ЗапросПоТоварам.Текст = ТекстЗапросаПоТоварам;
	ЗапросПоТоварам.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	МассивОпераций = Новый Массив;
	МассивОпераций.Добавить(Перечисления.СкладскиеОперации.ВводОстатков);
	МассивОпераций.Добавить(Перечисления.СкладскиеОперации.ПриемкаОтПоставщика);
	
	ЗапросПоТоварам.УстановитьПараметр("СкладскаяОперация", МассивОпераций);
	ЗапросПоТоварам.УстановитьПараметр("ДатаСреза", ТекущаяДата());
	
	
	ВыборкаПоТабличнымЧастям = ЗапросПоТоварам.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаПоШапке.Следующий() Цикл
		
		Шапка = ВыборкаПоШапке;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Если Не ПервыйДокумент Тогда
			
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		// Вывод шапки заказа
		Если Шапка.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеремещениеТоваров Тогда
		
			ОбластьЗаголовка = ОбластьЗаголовкаПеремещение;
		
		Иначе // Хозяйственная операция - Внутренняя передача товаров
		
			ОбластьЗаголовка = ОбластьЗаголовкаВнутренняяПередача;
		
		КонецЕсли;
			
		НазваниеДокумента = НСтр("ru = 'Заказ на перемещение'");
		ОбластьЗаголовка.Параметры.ТекстЗаголовка = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(Шапка,
			НазваниеДокумента);
		ОбластьЗаголовка.Параметры.Заполнить(Шапка);
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабДокумент, Макет, ОбластьЗаголовка, Шапка.Ссылка);
		ТабДокумент.Вывести(ОбластьЗаголовка);
		
		ТабДокумент.Вывести(ОбластьНомераШапка);
		
		Если ВыводитьКоды Тогда
			
			ТабДокумент.Присоединить(ОбластьКодовШапка);
			
		КонецЕсли;
		
		ТабДокумент.Присоединить(ОбластьДанныхШапка);
		
		Если ИспользоватьУпаковкиНоменклатуры Тогда
			
			ТабДокумент.Присоединить(ОбластьУпаковокШапка);
			
		КонецЕсли;
		
		ТабДокумент.Присоединить(ОбластьКонецСтрокиШапка);
		
		// Выборка товаров
		Если Не ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка", Шапка.Ссылка)) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ВыборкаСтрокТовары = ВыборкаПоТабличнымЧастям.Выбрать();
		
		НомерСтроки = 1;
		СуммаИтог = 0;
		Пока ВыборкаСтрокТовары.Следующий() Цикл
		
			ОбластьНомераСтрока.Параметры.НомерСтроки = НомерСтроки;
			ТабДокумент.Вывести(ОбластьНомераСтрока);
			
			Если ВыводитьКоды Тогда
				
				ОбластьКодовСтрока.Параметры.Артикул = ВыборкаСтрокТовары[Колонка];
				ТабДокумент.Присоединить(ОбластьКодовСтрока);
				
			КонецЕсли;
			
			ОбластьДанныхСтрока.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьДанныхСтрока.Параметры.Товар = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				СокрЛП(ВыборкаСтрокТовары.ТоварНаименование),
				СокрЛП(ВыборкаСтрокТовары.Характеристика),
				, // Упаковка
				СокрЛП(ВыборкаСтрокТовары.Серия));
			
			ТабДокумент.Присоединить(ОбластьДанныхСтрока);
			
			Если ИспользоватьУпаковкиНоменклатуры Тогда
				
				ОбластьУпаковокСтрока.Параметры.Заполнить(ВыборкаСтрокТовары);
				ТабДокумент.Присоединить(ОбластьУпаковокСтрока);
				
			КонецЕсли;
			
			ОбластьКонецСтрокиСтрока.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабДокумент.Присоединить(ОбластьКонецСтрокиСтрока);
			
			НомерСтроки = НомерСтроки + 1;
			СуммаИтог = СуммаИтог + ВыборкаСтрокТовары.Сумма;
		КонецЦикла;
		
		ТабДокумент.Вывести(ОбластьНомераПодвал);
		
		Если ВыводитьКоды Тогда
			
			ТабДокумент.Присоединить(ОбластьКодовПодвал);
			
		КонецЕсли;
		
		ТабДокумент.Присоединить(ОбластьДанныхПодвал);
		
		Если ИспользоватьУпаковкиНоменклатуры Тогда
			
			ТабДокумент.Присоединить(ОбластьУпаковокПодвал);
			
		КонецЕсли;
		ОбластьКонецСтрокиПодвал.Параметры.СуммаИтог = Формат(СуммаИтог,"ЧДЦ=2; ЧГ=0")+" руб.";
		ТабДокумент.Присоединить(ОбластьКонецСтрокиПодвал);
		
		// Вывод подписи.
		ОбластьПодписи = Макет.ПолучитьОбласть("Подписи");
		ОбластьПодписи.Параметры.ФИОМенеджер = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Шапка.Менеджер, Шапка.Дата);
		ТабДокумент.Вывести(ОбластьПодписи);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		
	КонецЦикла;
	
	ТабДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли