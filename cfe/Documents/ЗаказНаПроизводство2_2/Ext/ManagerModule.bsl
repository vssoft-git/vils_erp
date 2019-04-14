﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
&Вместо("СформироватьПечатнуюФормуЗаказНаПроизводство")
Функция ВИЛС_СформироватьПечатнуюФормуЗаказНаПроизводство(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказНаПроизводство2_2_ЗаказНаПроизводство";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаказНаПроизводство2_2.ПФ_MXL_ЗаказНаПроизводство");
	ПервыйДокумент = Истина;
	
	ДанныеДляПечати = ДанныеДляПечатиЗаказНаПроизводство(МассивОбъектов);
	ВыборкаШапка = ДанныеДляПечати.ВыборкаШапка;
	ВыборкаПродукция = ДанныеДляПечати.ВыборкаПродукция;
	
	Пока ВыборкаШапка.Следующий() Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Шапка - Заголовок
		
		Область = Макет.ПолучитьОбласть("Заголовок");
		
		Область.Параметры.ТекстЗаголовка = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(
			ВыборкаШапка,
			СтрШаблон(НСтр("ru = 'Заказ на производство (%1)'"), НРег(ВыборкаШапка.ТипПроизводственногоПроцесса)));
		Область.Параметры.Ссылка = ВыборкаШапка.Ссылка;
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(
			ТабличныйДокумент,
			Макет,
			Область,
			ВыборкаШапка.Ссылка);
	
		ТабличныйДокумент.Вывести(Область);
		
		// Шапка - Организация
		
		Область = Макет.ПолучитьОбласть("Организация");
		Область.Параметры.Заполнить(ВыборкаШапка);
		ТабличныйДокумент.Вывести(Область);
		
		// Шапка - Диспетчер
		
		Область = Макет.ПолучитьОбласть("Диспетчер");
		Область.Параметры.Заполнить(ВыборкаШапка);
		ТабличныйДокумент.Вывести(Область);
		
		// Шапка - Давалец
		
		Если ВыборкаШапка.ПроизводствоИзДавальческогоСырья Тогда
			
			Область = Макет.ПолучитьОбласть("Давалец");
			Область.Параметры.Заполнить(ВыборкаШапка);
			ТабличныйДокумент.Вывести(Область);
			
		КонецЕсли;
		//begin fix Клещ А.Н. 02.04.2019
		НаправлениеДеятельности = ВыборкаШапка.Ссылка.НаправлениеДеятельности;
		Если ЗначениеЗаполнено(НаправлениеДеятельности) Тогда 
			Область = Макет.ПолучитьОбласть("НаправлениеДеятельности");
			Область.Параметры.НаправлениеДеятельности = НаправлениеДеятельности;
			ТабличныйДокумент.Вывести(Область);
		КонецЕсли;
		//end fix Клещ А.Н. 02.04.2019
		
		// Таблица
		
		Если ВыборкаПродукция.НайтиСледующий(Новый Структура("Ссылка", ВыборкаШапка.Ссылка)) Тогда
			
			КолонкаКодов = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
			ВыводитьКоды = ЗначениеЗаполнено(КолонкаКодов);
	
			Если ВыводитьКоды Тогда
		    	
				ОбластьШапка = Макет.ПолучитьОбласть("ШапкаТаблицы_СКодом");
				ОбластьШапка.Параметры.ИмяКолонкиКодов = КолонкаКодов;
				ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаТаблицы_СКодом");
				
			Иначе
				
				ОбластьШапка = Макет.ПолучитьОбласть("ШапкаТаблицы_БезКода");
				ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаТаблицы_БезКода");
		
			КонецЕсли;
			
			ОбластьШапка.Параметры.ИмяКолонкиНоменклатура = ПроизводствоКлиентСервер.ЗаголовокТабличнойЧастиПоТипуПроцесса(
				ВыборкаШапка.ТипПроизводственногоПроцесса);
			
			ТабличныйДокумент.Вывести(ОбластьШапка);
			
			НомерСтроки = 0;
			Выборка = ВыборкаПродукция.Выбрать();
			Пока Выборка.Следующий() Цикл
		
				ОбластьСтрока.Параметры.Заполнить(Выборка);
				
				НомерСтроки = НомерСтроки + 1;
				ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
		
				Если ВыводитьКоды Тогда
					ОбластьСтрока.Параметры.Артикул = Выборка[КолонкаКодов];
				КонецЕсли;
						
				ОбластьСтрока.Параметры.НоменклатураПредставление = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
					Выборка.НоменклатураНаименованиеПолное,
					Выборка.ХарактеристикаНаименованиеПолное);
		
				ТабличныйДокумент.Вывести(ОбластьСтрока);
		
			КонецЦикла;
			
			ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ПодвалТаблицы"));
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
			ТабличныйДокумент,
			НомерСтрокиНачало,
			ОбъектыПечати,
			ВыборкаШапка.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции
#КонецЕсли
