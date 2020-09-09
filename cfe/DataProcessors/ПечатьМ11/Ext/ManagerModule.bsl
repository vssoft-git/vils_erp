﻿
&ИзменениеИКонтроль("ЗаполнитьТабличныйДокументМ11")
Процедура ВИЛС_ЗаполнитьТабличныйДокументМ11(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)

	ШаблонОшибкиТовары = НСтр("ru = 'В документе %1 отсутствуют товары. Печать М-11 не требуется';
	|en = 'Goods are missing in document %1. Printing of M-11 is not required'");

	ТоварКод = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	Если Не ЗначениеЗаполнено(ТоварКод) Тогда
		ТоварКод = "Код";
	КонецЕсли;

	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьМ11.ПФ_MXL_М11");

	ПервыйДокумент = Истина;
	ВыборкаДокументы = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоТабличнымЧастям = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	СтруктураОтбора = Новый Структура("Ссылка");

	Пока ВыборкаДокументы.Следующий() Цикл

		СтруктураОтбора.Ссылка = ВыборкаДокументы.Ссылка;
		ВыборкаПоТабличнымЧастям.Сбросить();
		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(СтруктураОтбора) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонОшибкиТовары,
			ВыборкаДокументы.Ссылка
			),
			ВыборкаДокументы.Ссылка);
			Продолжить;
		КонецЕсли;

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		ВыборкаПоСкладам = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		Пока ВыборкаПоСкладам.Следующий() Цикл

			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			ПервыйДокумент = Ложь;
			НомерСтраницы   = 1;
			НомерСтроки = 0;

			// Создаем массив для проверки вывода
			МассивВыводимыхОбластей = Новый Массив;

			ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");

			// Вывод шапки.
			ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
			ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьШапка, ВыборкаДокументы.Ссылка);
#Удаление
			ОбластьШапка.Параметры.Заголовок = НСтр("ru = 'ТРЕБОВАНИЕ-НАКЛАДНАЯ №';
			|en = 'REQUISITION NOTE No.'") + ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДокументы.Номер, Ложь, Истина);
#КонецУдаления
#Вставка
			Если ВыборкаДокументы.Организация = Справочники.Организации.УправленческаяОрганизация Тогда
				ОбластьШапка.Параметры.Заголовок = НСтр("ru = 'ТРЕБОВАНИЕ-НАКЛАДНАЯ №';
				|en = 'REQUISITION NOTE No.'") + ВыборкаДокументы.Номер;
			Иначе
				ОбластьШапка.Параметры.Заголовок = НСтр("ru = 'ТРЕБОВАНИЕ-НАКЛАДНАЯ №';
				|en = 'REQUISITION NOTE No.'") + ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДокументы.Номер, Ложь, Истина);
			КонецЕсли; 
#КонецВставки
			ОбластьШапка.Параметры.Заполнить(ВыборкаДокументы);
			ОбластьШапка.Параметры.Заполнить(ВыборкаПоСкладам);
			ОбластьШапка.Параметры.ПредставлениеПодразделения = ВыборкаДокументы.Подразделение;

			СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаДокументы.Организация, ВыборкаДокументы.ДатаДокумента);
			ОбластьШапка.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации);
			ОбластьШапка.Параметры.КодОКПО = СведенияОбОрганизации.КодПоОКПО;
			ТабличныйДокумент.Вывести(ОбластьШапка);

			// Выводим заголовок таблицы
			ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
			ТабличныйДокумент.Вывести(ЗаголовокТаблицы);

			ВыборкаПоСтрокам = ВыборкаПоСкладам.Выбрать();
			КоличествоСтрок = ВыборкаПоСтрокам.Количество();
			Пока ВыборкаПоСтрокам.Следующий() Цикл

				Область = Макет.ПолучитьОбласть("Строка");
				Область.Параметры.Заполнить(ВыборкаПоСтрокам);

				НомерСтроки = НомерСтроки + 1;

				МассивВыводимыхОбластей.Очистить();
				МассивВыводимыхОбластей.Добавить(Область);

				Если НомерСтроки = КоличествоСтрок Тогда
					МассивВыводимыхОбластей.Добавить(ОбластьПодвал);
				КонецЕсли;

				Если ТоварКод = "Артикул" Тогда
					Область.Параметры.НоменклатурныйНомер = ВыборкаПоСтрокам.НоменклатурныйНомерАртикул;
				Иначе
					Область.Параметры.НоменклатурныйНомер = ВыборкаПоСтрокам.НоменклатурныйНомерКод;
				КонецЕсли;

				Область.Параметры.МатериалНаименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				СокрЛП(ВыборкаПоСтрокам.НоменклатураНаименование),
				СокрЛП(ВыборкаПоСтрокам.Характеристика));

				Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
					НомерСтраницы = НомерСтраницы + 1;
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					СтруктураПараметров = Новый Структура;
					СтруктураПараметров.Вставить("НомерСтраницы", "Страница " + НомерСтраницы);
					ЗаголовокТаблицы.Параметры.Заполнить(СтруктураПараметров);
					ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
				КонецЕсли;

				ТабличныйДокумент.Вывести(Область);

			КонецЦикла;

			// Вывод подвала.
			ОбластьПодвал.Параметры.ДолжностьОтправителя = ВыборкаПоСкладам.ДолжностьКладовщикаОтправителя;
			ОбластьПодвал.Параметры.ФИООтправителя = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ВыборкаПоСкладам.КладовщикОтправитель, ВыборкаДокументы.ДатаДокумента);
			ТабличныйДокумент.Вывести(ОбластьПодвал);

		КонецЦикла;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументы.Ссылка);

	КонецЦикла;

КонецПроцедуры
