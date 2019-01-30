﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
&Вместо("ЗаполнитьТабличныйДокументАктОбОказанииУслуг")
Процедура ВИЛС_ЗаполнитьТабличныйДокументАктОбОказанииУслуг(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьАктОбОказанииУслуг.ПФ_MXL_Акт");
	
	ИспользоватьРучныеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ИспользоватьАвтоматическиеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах");
	ПоказыватьНДС = Константы.ВыводитьДопКолонкиНДС.Получить();
	
	ДанныеПечати = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ПервыйДокумент = Истина;
	СтруктураПоиска = Новый Структура("Ссылка");
	СсылкиБезСтрок = Новый Соответствие;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		СтруктураПоиска.Ссылка = ДанныеПечати.Ссылка;
		ВыборкаПоДокументам.Сбросить();
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска) Тогда
			Если СсылкиБезСтрок[ДанныеПечати.Ссылка] = Неопределено Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В документе %1 отсутствуют услуги. Печать акта об оказании услуг не требуется.'"), ДанныеПечати.Ссылка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ДанныеПечати.Ссылка);
			КонецЕсли;
			СсылкиБезСтрок.Вставить(ДанныеПечати.Ссылка,ДанныеПечати.Ссылка);
			Продолжить;
		КонецЕсли;
		ВыборкаПоУслугам = ВыборкаПоДокументам.Выбрать();
		ЗаголовокСкидки = ФормированиеПечатныхФорм.НужноВыводитьСкидки(ВыборкаПоУслугам, ИспользоватьРучныеСкидки Или ИспользоватьАвтоматическиеСкидки);
		ЕстьСкидки = ЗаголовокСкидки.ЕстьСкидки;
		
		ЕстьНДС = ДанныеПечати.УчитыватьНДС;
		ВыборкаПоУслугам.Сбросить();
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку акта
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);

		ТекстЗаголовка = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(ДанныеПечати, НСтр("ru='Акт'"));
		СтруктураДанныхШапки = Новый Структура;
		СтруктураДанныхШапки.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхШапки);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета                                   = Макет.ПолучитьОбласть("Поставщик");
		СтруктураДанныхПоставщик = Новый Структура;
		
		Если ТипЗнч(СтруктураПоиска.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			Сведения = Новый Структура("Представление, СокращенноеНаименование, ПолноеНаименование, НаименованиеДляПечатныхФорм,
			|КодПоОКПО, КодОКВЭД, ИНН, КПП, Телефоны, ЮридическийАдрес, Банк, БИК, КоррСчет, НомерСчета");
			ЮрФизЛицо = ДанныеПечати.Организация;
			Реквизиты = Справочники.Организации.ПолучитьРеквизитыОрганизации(ЮрФизЛицо);
			ДатаПериода = ДанныеПечати.Дата;
			БанковскийСчет = СтруктураПоиска.Ссылка.БанковскийСчетОрганизации;
			РеквизитыСчета = Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(БанковскийСчет);
			Сведения.Вставить("КодОКВЭД", Реквизиты.КодОКВЭД);
			Сведения.Вставить("Представление", 				 Реквизиты.Представление);
			Сведения.Вставить("СокращенноеНаименование", 	 Реквизиты.Представление);
			Сведения.Вставить("ПолноеНаименование", 		 Реквизиты.Наименование);
			Сведения.Вставить("НаименованиеДляПечатныхФорм", Реквизиты.Наименование);
			Сведения.Вставить("ИНН", 						 Реквизиты.ИНН);
			Сведения.Вставить("КодПоОКПО", 					 Реквизиты.КодПоОКПО);
			Сведения.Вставить("ЮрФизЛицо", 					 Реквизиты.ЮрФизЛицо);
			Сведения.Вставить("ФИОФизлица", 				 "");
			Сведения.Вставить("ОфициальноеНаименование", Реквизиты.НаименованиеПолное);
			Сведения.Вставить("Свидетельство", 			 Реквизиты.Свидетельство);
			РеквизитЮрФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЮрФизЛицо, "ЮрФизЛицо");
			Сведения.Вставить("КПП", Реквизиты.КПП);
			Сведения.Вставить("Телефоны", 		  ФормированиеПечатныхФорм.ПолучитьТелефонИзКонтактнойИнформации(ЮрФизЛицо));
			Сведения.Вставить("НомерСчета", 	  РеквизитыСчета.НомерСчета);
			Сведения.Вставить("Банк", 			  РеквизитыСчета.Банк);
			Сведения.Вставить("БИК", 			  РеквизитыСчета.БИК);
			Сведения.Вставить("КоррСчет", 		  РеквизитыСчета.КоррСчет);
			Сведения.Вставить("АдресБанка", 	  РеквизитыСчета.АдресБанка);
			
			Сведения.Вставить("ЮридическийАдрес", ФормированиеПечатныхФорм.ПолучитьАдресИзКонтактнойИнформации(ЮрФизЛицо, "Юридический", ДатаПериода));
			Сведения.Вставить("ФактическийАдрес", ФормированиеПечатныхФорм.ПолучитьАдресИзКонтактнойИнформации(ЮрФизЛицо, "Фактический", ДатаПериода));
			
			ПредставлениеПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(Сведения,			"");
		Иначе
			ПредставлениеПоставщика                         = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата), "ПолноеНаименование");
		КонецЕсли;	
		
		СтруктураДанныхПоставщик.Вставить("ПредставлениеПоставщика", ПредставлениеПоставщика);
		СтруктураДанныхПоставщик.Вставить("Поставщик", ДанныеПечати.Организация);
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхПоставщик);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета                                   = Макет.ПолучитьОбласть("Покупатель");
		СтруктураДанныхПокупатель = Новый Структура;
		ПредставлениеПолучателя                         = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент, ДанныеПечати.Дата), "");

		//ПредставлениеПолучателя                         = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент, ДанныеПечати.Дата), "ПолноеНаименование");
		СтруктураДанныхПокупатель.Вставить("ПредставлениеПолучателя", ПредставлениеПолучателя);
		СтруктураДанныхПокупатель.Вставить("Получатель", ДанныеПечати.Контрагент);
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхПокупатель);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим заголовок таблицы Услуги
		
		СуффиксОбласти = ?(ЕстьСкидки, "СоСкидкой", "") + ?(ЕстьНДС И ПоказыватьНДС, "СНДС", "");
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы" + СуффиксОбласти);
		ОбластьСтроки = Макет.ПолучитьОбласть("Строка" + СуффиксОбласти);
		Если ЕстьСкидки Тогда
			СтруктураЗаголовокСкидки = Новый Структура("Скидка, СуммаБезСкидки", 
				ЗаголовокСкидки.Скидка,
				ЗаголовокСкидки.СуммаСкидки);
			ОбластьМакета.Параметры.Заполнить(СтруктураЗаголовокСкидки);
		КонецЕсли; 
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Сумма       = 0;
		СуммаНДС    = 0;
		НомерСтроки = 0;
		
		// Выводим строки таблицы Услуги
		
		Пока ВыборкаПоУслугам.Следующий() Цикл
		
			НомерСтроки = НомерСтроки + 1;
			
			ОбластьСтроки.Параметры.Заполнить(ВыборкаПоУслугам);
			
			СтруктураДанныхСтроки = Новый Структура;
			СтруктураДанныхСтроки.Вставить("НомерСтроки", НомерСтроки);
			СтруктураДанныхСтроки.Вставить("Товар", НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ВыборкаПоУслугам.УслугаНаименованиеПолное,
				ВыборкаПоУслугам.ХарактеристикаНаименованиеПолное));
			
			Если ЕстьСкидки Тогда
				СтруктураДанныхСтроки.Вставить("Скидка", ?(ЗаголовокСкидки.ТолькоНаценка,- ВыборкаПоУслугам.СуммаСкидки,ВыборкаПоУслугам.СуммаСкидки));
				СтруктураДанныхСтроки.Вставить("СуммаБезСкидки", ФормированиеПечатныхФорм.ФорматСумм(ВыборкаПоУслугам.Сумма + ВыборкаПоУслугам.СуммаСкидки));
			КонецЕсли;
			ОбластьСтроки.Параметры.Заполнить(СтруктураДанныхСтроки);
			Сумма    = Сумма    + ВыборкаПоУслугам.Сумма;
			СуммаНДС = СуммаНДС + ВыборкаПоУслугам.СуммаНДС;
			
			ТабличныйДокумент.Вывести(ОбластьСтроки);
		
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		СтруктураДанныхВсего = Новый Структура("Всего", ФормированиеПечатныхФорм.ФорматСумм(Сумма));
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхВсего);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
		СтруктураДанныхИтогоНДС = Новый Структура;
		СтруктураДанныхИтогоНДС.Вставить("ВсегоНДС", СуммаНДС);
		Если ЕстьНДС Тогда
			СтруктураДанныхИтогоНДС.Вставить("НДС", ?(ДанныеПечати.ЦенаВключаетНДС, " " + НСтр("ru = 'В том числе НДС'"), " " + НСтр("ru = 'Сумма НДС'")));
		Иначе
			СтруктураДанныхИтогоНДС.Вставить("НДС", НСтр("ru='Без налога (НДС)'"));
		КонецЕсли;
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхИтогоНДС);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		СуммаКПрописи = Сумма + ?(ДанныеПечати.ЦенаВключаетНДС, 0, СуммаНДС);
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		
		ИтоговаяСтрока = НСтр("ru = 'Всего оказано услуг %КоличествоНаименований%, на сумму %СуммаДокумента%'");
		ИтоговаяСтрока = СтрЗаменить(ИтоговаяСтрока, "%КоличествоНаименований%", НомерСтроки);
		ИтоговаяСтрока = СтрЗаменить(ИтоговаяСтрока, "%СуммаДокумента%", ФормированиеПечатныхФорм.ФорматСумм(СуммаКПрописи, ДанныеПечати.Валюта));
		
		СтруктураДанныхСуммаПрописью = Новый Структура;
		СтруктураДанныхСуммаПрописью.Вставить("ИтоговаяСтрока", ИтоговаяСтрока);
		СтруктураДанныхСуммаПрописью.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаКПрописи, ДанныеПечати.Валюта));
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхСуммаПрописью);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если ТипЗнч(СтруктураПоиска.Ссылка) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			Руководитель = СтруктураПоиска.Ссылка.Руководитель;
			ГлБухгалтер = СтруктураПоиска.Ссылка.ГлавныйБухгалтер;
			МакетПодписей = ПолучитьМакет("ВИЛС_ПодписиКАкту");
			ОбластьМакета = МакетПодписей.ПолучитьОбласть("Подписи");
			ОбластьМакета.Параметры.Руководитель = Руководитель.ФизическоеЛицо;
			ОбластьМакета.Параметры.Должность = ?(Руководитель.ПравоПодписиПоДоверенности,""+Руководитель.ОснованиеПраваПодписи,Руководитель.Должность);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		Иначе
			ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		

		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли
