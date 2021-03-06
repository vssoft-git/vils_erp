#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ОснованиеДляПечати

&Вместо("ТаблицаОснованийДляПечати")
Функция ВИЛС_ТаблицаОснованийДляПечати(Объект)
	ТаблицаОснований = Новый ТаблицаЗначений;
	ТаблицаОснований.Колонки.Добавить("Основание",      Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(300)));
	ТаблицаОснований.Колонки.Добавить("ОснованиеДата",  Новый ОписаниеТипов("Дата",,,,,Новый КвалификаторыДаты(ЧастиДаты.Дата))); 
	ТаблицаОснований.Колонки.Добавить("ОснованиеНомер", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(128)));
	// begin fix Suetin 04.02.2019 15:36:25
	СтруктураОснования = СтруктураОснования(Объект, Перечисления.ПорядокРасчетов.ПоЗаказамНакладным);
	Если ЗначениеЗаполнено(СтруктураОснования.Основание) Тогда
		ДобавленнаяСтрока = ТаблицаОснований.Добавить();
		ЗаполнитьЗначенияСвойств(ДобавленнаяСтрока, СтруктураОснования);
		ДобавленнаяСтрока.Основание = СтруктураОснования.Основание;
	КонецЕсли;
	// end fix Suetin 04.02.2019 15:36:29
	СтруктураОснования = СтруктураОснования(Объект, Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов);
	Если ЗначениеЗаполнено(СтруктураОснования.Основание) Тогда
		ДобавленнаяСтрока = ТаблицаОснований.Добавить();
		ЗаполнитьЗначенияСвойств(ДобавленнаяСтрока, СтруктураОснования);
		ДобавленнаяСтрока.Основание = СтруктураОснования.Основание;
		
		Если ЗначениеЗаполнено(СтруктураОснования.ОснованиеДата) И ЗначениеЗаполнено(СтруктураОснования.ОснованиеНомер) Тогда
			ТекстРасширенный = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '%1 № %2 от %3'"),
					СтруктураОснования.Основание, СтруктураОснования.ОснованиеНомер, Формат(СтруктураОснования.ОснованиеДата, "ДЛФ=DD"));
			
			ДобавленнаяСтрока = ТаблицаОснований.Добавить();
			ЗаполнитьЗначенияСвойств(ДобавленнаяСтрока, СтруктураОснования);
			ДобавленнаяСтрока.Основание = ТекстРасширенный;
		КонецЕсли;
	КонецЕсли;
	// begin fix Suetin 04.02.2019 15:36:38
	//СтруктураОснования = СтруктураОснования(Объект, Перечисления.ПорядокРасчетов.ПоЗаказамНакладным);
	//Если ЗначениеЗаполнено(СтруктураОснования.Основание) Тогда
	//	ДобавленнаяСтрока = ТаблицаОснований.Добавить();
	//	ЗаполнитьЗначенияСвойств(ДобавленнаяСтрока, СтруктураОснования);
	//	ДобавленнаяСтрока.Основание = СтруктураОснования.Основание;
	//КонецЕсли;
	// end fix Suetin 04.02.2019 15:36:42	
	Возврат ТаблицаОснований;
	
КонецФункции

&Вместо("СтруктураОснования")
Функция ВИЛС_СтруктураОснования(Объект, ПорядокРасчетов)
	
	СтруктураОснование = Новый Структура;
	СтруктураОснование.Вставить("Основание");
	СтруктураОснование.Вставить("ОснованиеНомер");
	СтруктураОснование.Вставить("ОснованиеДата");
	
	Если ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов
		И ЗначениеЗаполнено(Объект.Договор) Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ДоговорыКонтрагентов.НаименованиеДляПечати КАК Основание,
			|	ДоговорыКонтрагентов.Дата КАК ОснованиеДата,
			|	ДоговорыКонтрагентов.Номер КАК ОснованиеНомер
			|ИЗ
			|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
			|ГДЕ
			|	ДоговорыКонтрагентов.Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Объект.Договор);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			СтруктураОснование.Основание = СокрЛП(Выборка.Основание);
			СтруктураОснование.ОснованиеДата = Объект.Дата;   //  ТТН	Выборка.ОснованиеДата;   // begin fix Suetin 01.02.2019 11:18:21
			СтруктураОснование.ОснованиеНомер = СокрЛП(Объект.Номер); // ТТН	СокрЛП(Выборка.ОснованиеНомер);  // end fix Suetin 01.02.2019 11:18:43
		КонецЕсли;
		
	ИначеЕсли ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоЗаказамНакладным
		И Объект.АктПоЗаказам Тогда
		
		МассивЗаказов = Неопределено;
		Если ЗначениеЗаполнено(Объект.ЗаказКлиента) Тогда
			МассивЗаказов = Новый Массив;
			МассивЗаказов.Добавить(Объект.ЗаказКлиента);
		ИначеЕсли Объект.Услуги.Количество() <> 0 Тогда 
			Если ТипЗнч(Объект) = Тип("Структура") Тогда
				МассивЗаказов = Объект.Услуги.ВыгрузитьКолонку("ЗаказКлиента");
			Иначе
				МассивЗаказов = Объект.Услуги.Выгрузить(,"ЗаказКлиента").ВыгрузитьКолонку("ЗаказКлиента");
			КонецЕсли;
		КонецЕсли;
		
		Если МассивЗаказов <> Неопределено Тогда
		
			Запрос = Новый Запрос(
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	ЗаказыКлиентов.НомерПоДаннымКлиента КАК НомерПоДаннымКлиента,
				|	ЗаказыКлиентов.ДатаПоДаннымКлиента  КАК ДатаПоДаннымКлиента,
				|	ЗаказыКлиентов.Номер                КАК Номер,
				|	ЗаказыКлиентов.Дата                 КАК Дата,
				|	&СинонимЗаказа                      КАК Синоним
				|ИЗ
				|	Документ.ЗаказКлиента КАК ЗаказыКлиентов
				|ГДЕ
				|	ЗаказыКлиентов.Ссылка В(&МассивЗаказов)");
			
			Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
			Запрос.УстановитьПараметр("СинонимЗаказа", НСтр("ru='Заказ клиента'"));
			Выборка = Запрос.Выполнить().Выбрать();
			
			ТекстПоЗаказам = "";
			ОдноОснование = Выборка.Количество() = 1;
			Пока Выборка.Следующий() Цикл
				Если ЗначениеЗаполнено(Выборка.НомерПоДаннымКлиента) И ЗначениеЗаполнено(Выборка.ДатаПоДаннымКлиента) Тогда
					ТекстПоЗаказам = ТекстПоЗаказам + ", " +
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = '%1 № %2 от %3'"),
							Выборка.Синоним, Выборка.НомерПоДаннымКлиента, Формат(Выборка.ДатаПоДаннымКлиента, "ДЛФ=DD"));
					ДатаПоЗаказам  = Выборка.ДатаПоДаннымКлиента;
					НомерПоЗаказам = Выборка.НомерПоДаннымКлиента;
				Иначе
					ТекстПоЗаказам = ТекстПоЗаказам + ", " + ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(Выборка, Выборка.Синоним);
					ДатаПоЗаказам  = Выборка.Дата;
					НомерПоЗаказам = Выборка.Номер;
				КонецЕсли;
			КонецЦикла;
			СтруктураОснование.Основание =  СокрЛП(Сред(ТекстПоЗаказам, 3));
			СтруктураОснование.ОснованиеДата = ?(ОдноОснование, ДатаПоЗаказам, "");
			СтруктураОснование.ОснованиеНомер = ?(ОдноОснование,ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(НомерПоЗаказам),"");
		КонецЕсли;
		// begin fix Suetin 04.02.2019 15:34:01
		Если ЗначениеЗаполнено(Объект.Договор) Тогда 
			Запрос = Новый Запрос(
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	ДоговорыКонтрагентов.НаименованиеДляПечати КАК Основание,
				|	ДоговорыКонтрагентов.Дата КАК ОснованиеДата,
				|	ДоговорыКонтрагентов.Номер КАК ОснованиеНомер
				|ИЗ
				|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
				|ГДЕ
				|	ДоговорыКонтрагентов.Ссылка = &Ссылка");
			Запрос.УстановитьПараметр("Ссылка", Объект.Договор);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				Если МассивЗаказов <> Неопределено Тогда
					СтруктураОснование.Основание = СокрЛП(Выборка.Основание) + "; " + СокрЛП(СтруктураОснование.Основание);   //;
				Иначе
					СтруктураОснование.Основание = СокрЛП(Выборка.Основание);
				КонецЕсли;	
				СтруктураОснование.ОснованиеДата = Объект.Дата;   //  ТТН
				СтруктураОснование.ОснованиеНомер = СокрЛП(Объект.Номер); // ТТН
			КонецЕсли;
		КонецЕсли;	
		// end fix Suetin 04.02.2019 15:34:08
	КонецЕсли;
	
	Возврат СтруктураОснование; // Возврат значения по умолчанию
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли