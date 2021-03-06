//#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

&Вместо("СформироватьПечатнуюФормуИНВ3")   //ИзменениеИКонтроль
Функция ВИЛС_СформироватьПечатнуюФормуИНВ3(СтруктураТипов, ОбъектыПечати, ПараметрыПечати)

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИНВ3";

	УстановитьПривилегированныйРежим(Истина);

	НомерДокумента = 0;

	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
//#Удаление // begin fix Suetin 13.01.2020 13:51:08
//		Если СтруктураОбъектов.Ключ <> "Документ.ИнвентаризационнаяОпись" Тогда 
//			ТекстСообщения = НСтр("ru = 'Формирование печатной формы ""ИНВ-3"" доступно только для документов ""%ТипДокумента%"".';
//			|en = 'INV-3 print form generation is available only for documents ""%ТипДокумента%"".'");
//			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипДокумента%", Метаданные.Документы.ИнвентаризационнаяОпись.Синоним);
//			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
//			Продолжить;
//		КонецЕсли;
//#КонецУдаления
//#Вставка
		Если СтруктураОбъектов.Ключ <> "Документ.ИнвентаризационнаяОпись" и СтруктураОбъектов.Ключ <> "Документ.ВИЛС_ИнвентаризацияТМЦВЭксплуатации" Тогда 
			ТекстСообщения = НСтр("ru = 'Формирование печатной формы ""ИНВ-3"" доступно только для документов ""%ТипДокумента1%"",""%ТипДокумента2%"".';
			|en = 'INV-3 print form generation is available only for documents ""%ТипДокумента1%"",""%ТипДокумента2%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипДокумента1%", Метаданные.Документы.ИнвентаризационнаяОпись.Синоним);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипДокумента2%", Метаданные.Документы.ВИЛС_ИнвентаризацияТМЦВЭксплуатации.Синоним);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
//#КонецВставки    // end fix Suetin 13.01.2020 13:51:19
		МенеджерОбъекта = ОбщегоНазначенияУТ.ПолучитьМодульЛокализации(СтруктураОбъектов.Ключ);
		Если МенеджерОбъекта = Неопределено Тогда
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		КонецЕсли;

		Для Каждого ДокументОснование Из СтруктураОбъектов.Значение Цикл

			НомерДокумента = НомерДокумента + 1;
			Если НомерДокумента > 1 Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;

			ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыИНВ3(ПараметрыПечати, ДокументОснование);
			Если НЕ ДанныеДляПечати = Неопределено Тогда
				ЗаполнитьТабличныйДокументИНВ3(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ДокументОснование);
			КонецЕсли;

		КонецЦикла;

	КонецЦикла;

	УстановитьПривилегированныйРежим(Ложь);

	Возврат ТабличныйДокумент;

КонецФункции

&Вместо("ЗаполнитьТабличныйДокументИНВ3")  //    ИзменениеИКонтроль
Процедура ВИЛС_ЗаполнитьТабличныйДокументИНВ3(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ИнвентаризационнаяОпись)

	ТабличныйДокумент.ПолеСверху = 10;
	ТабличныйДокумент.ПолеСлева = 10;
	ТабличныйДокумент.ПолеСнизу = 10;
	ТабличныйДокумент.ПолеСправа = 10;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;

	Шапка = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ТабличнаяЧасть = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать();
	
	ТЗТиповЗапасов = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выгрузить();		// begin fix Suetin 11.12.2019 15:27:57
	ТЗТиповЗапасовКопия = ТЗТиповЗапасов.Скопировать(, "ТипЗапасов");
	ТЗТиповЗапасов.Свернуть("ТипЗапасов");
	МассивТиповЗапасов = ТЗТиповЗапасов.ВыгрузитьКолонку("ТипЗапасов");
	ТЗТиповЗапасов = Неопределено;            									// end fix Suetin 11.12.2019 15:28:18
	
	Шапка.Следующий();
	СтруктураРеквизитов = Новый Структура("Дата, Склад");
	//СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Шапка.Ссылка, СтруктураРеквизитов);        	// begin fix Suetin 02.12.2019 16:21:57
	Если ТипЗнч(Шапка.Ссылка) = Тип("ДокументСсылка.ИнвентаризационнаяОпись") Тогда
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Шапка.Ссылка, СтруктураРеквизитов);
	ИначеЕсли ТипЗнч(Шапка.Ссылка) = Тип("ДокументСсылка.ВИЛС_ИнвентаризацияТМЦВЭксплуатации") Тогда
		СтруктураРеквизитов.Дата = Шапка.ДатаДокумента;
		СтруктураРеквизитов.Склад = Шапка.Склад;
	Иначе
		Возврат;
	КонецЕсли;	 																									// end fix Suetin 02.12.2019 16:22:02

	Если ДанныеДляПечати.РезультатКурсВалюты <> Неопределено Тогда
		КурсВалюты = ДанныеДляПечати.РезультатКурсВалюты.Выбрать();
		Если КурсВалюты.Следующий() Тогда
			КоэффициентПересчета = КурсВалюты.КоэффициентПересчета;
		Иначе
			КоэффициентПересчета = 1;
		КонецЕсли;
	Иначе  
		КоэффициентПересчета = 1;		
	КонецЕсли;

	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();

	Если ТабличнаяЧасть.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'В рамках периода документа ""%Опись%"" не были оформлены складские акты или не было проведено ни одного пересчета товаров. Нет данных для формирования печатной формы ""ИНВ-3""';
		|en = 'You have not created warehouse acts, or you have not recalculated goods within the period of document ""%Опись%"". No data to generate INV-3 print form.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Опись%", ИнвентаризационнаяОпись);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ИнвентаризационнаяОпись);
		Возврат;
	КонецЕсли;

	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьИНВ3.ПФ_MXL_ИНВ3_ru");
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапки = Макет.ПолучитьОбласть("ШапкаТаблицы");     
	ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвалСтраницы = Макет.ПолучитьОбласть("ПодвалСтраницы");
	ОбластьПодвалОписи = Макет.ПолучитьОбласть("ПодвалОписи");
	
	СтруктураПоиска = Новый Структура();
	Для каждого ТипЗапасов Из МассивТиповЗапасов Цикл
		СтруктураПоиска.Вставить("ТипЗапасов", ТипЗапасов);
		МассивСтрокСТипомЗапасов = ТЗТиповЗапасовКопия.НайтиСтроки(СтруктураПоиска);
		ОбластьЗаголовок.Параметры.Заполнить(Шапка);
		// begin fix Suetin 11.12.2019 16:55:45
		//ОбластьЗаголовок.Параметры.ФормаСобственностиЦенностей = НСтр("ru = 'в собственности организации'");		
		Если ТипЗапасов = Перечисления.ТипыЗапасов.Товар Тогда
			ОбластьЗаголовок.Параметры.ВидЦенностей = НСтр("ru = 'Собственный товар';
			|en = 'Own goods'", Метаданные.Языки.Русский.КодЯзыка);
			ОбластьЗаголовок.Параметры.ФормаСобственностиЦенностей = НСтр("ru = 'в собственности организации';
			|en = 'owned by company'", Метаданные.Языки.Русский.КодЯзыка);
	// begin fix Люкшинова 16.12.2019 15:11:03		
		//ИначеЕсли ТипЗапасов = Перечисления.ТипыЗапасов.МатериалДавальца Тогда
	  ИначеЕсли (ТипЗапасов = Перечисления.ТипыЗапасов.МатериалДавальца 
		 ИЛИ ТипЗапасов = Перечисления.ТипыЗапасов.ПродукцияДавальца) Тогда
// end fix Люкшинова 16.12.2019 15:11:06
			ОбластьЗаголовок.Параметры.ВидЦенностей = НСтр("ru = 'Материал давальца';
			|en = 'Provider''s material'", Метаданные.Языки.Русский.КодЯзыка);
			ОбластьЗаголовок.Параметры.ФормаСобственностиЦенностей = НСтр("ru = 'на забалансовом учете';
			|en = 'on off-balance account'", Метаданные.Языки.Русский.КодЯзыка);
		ИначеЕсли ТипЗапасов = Перечисления.ТипыЗапасов.ТоварНаХраненииСПравомПродажи Тогда
			ОбластьЗаголовок.Параметры.ВидЦенностей = НСтр("ru = 'Товар на хранении';
			|en = 'Goods stored'", Метаданные.Языки.Русский.КодЯзыка);
			ОбластьЗаголовок.Параметры.ФормаСобственностиЦенностей = НСтр("ru = 'на ответственном хранении';
			|en = 'on safe custody'", Метаданные.Языки.Русский.КодЯзыка);
		КонецЕсли; 
		// end fix Suetin 11.12.2019 17:07:52
		ОбластьЗаголовок.Параметры.ДолжностьМОЛ1  = Шапка.ДолжностьКладовщика;
		ОбластьЗаголовок.Параметры.ФИОМОЛ1        = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Шапка.Кладовщик, Шапка.ДатаДокумента);
		// begin fix Люкшинова 03.12.2019 10:15:52
		ОбластьЗаголовок.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.НомерДокумента);
		//ОбластьЗаголовок.Параметры.ОснованиеНомер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.ОснованиеНомер);
		ОбластьЗаголовок.Параметры.ОснованиеНомер = "";                        
	    ОбластьЗаголовок.Параметры.ОснованиеДата = "";
		ОбластьЗаголовок.Параметры.ДатаНачала = "";
		ОбластьЗаголовок.Параметры.ДатаОкончания = "";
		// end fix Люкшинова 03.12.2019 10:15:56  
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьЗаголовок, Шапка.Ссылка);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();

		ИтоговыеСуммы = Новый Структура;

		ИтоговыеСуммы.Вставить("ИтогоПоСтраницеФактКоличество",0);
		ИтоговыеСуммы.Вставить("ИтогоПоСтраницеФактСумма",0);
		ИтоговыеСуммы.Вставить("ИтогоПоСтраницеБухКоличество",0);
		ИтоговыеСуммы.Вставить("ИтогоПоСтраницеБухСумма",0);

		ИтоговыеСуммы.Вставить("ИтогоФактКоличество",0);
		ИтоговыеСуммы.Вставить("ИтогоФактСумма",0);
		ИтоговыеСуммы.Вставить("ИтогоБухКоличество",0);
		ИтоговыеСуммы.Вставить("ИтогоБухСумма",0);

		НомерСтроки = 0;
		НомерСтраницы = 2;
		ПервыйНомерСтроки = 1;
		// Создаем массив для проверки вывода
		МассивВыводимыхОбластей = Новый Массив;

		КоличествоСтрок = ТабличнаяЧасть.Количество();
			
		ТабличнаяЧасть.Сбросить();                                  // begin fix Suetin 11.12.2019 15:18:27
		//Пока ТабличнаяЧасть.Следующий() Цикл                      
		Пока ТабличнаяЧасть.НайтиСледующий(СтруктураПоиска) Цикл    // end fix Suetin 11.12.2019 15:18:30


			НомерСтроки = НомерСтроки + 1;

			ОбластьСтроки.Параметры.Заполнить(ТабличнаяЧасть);

			ОбластьСтроки.Параметры.ТоварНаименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
			ТабличнаяЧасть.ТоварНаименование,
			ТабличнаяЧасть.ХарактеристикаНаименование,
			ТабличнаяЧасть.СерияНаименование);

			ОбластьСтроки.Параметры.НомерСтроки = НомерСтроки;
			ОбластьСтроки.Параметры.Цена = ТабличнаяЧасть.Цена * КоэффициентПересчета;
			ОбластьСтроки.Параметры.СуммаПоУчету = ТабличнаяЧасть.СуммаПоУчету * КоэффициентПересчета; 
			ОбластьСтроки.Параметры.СуммаФактическая = ТабличнаяЧасть.СуммаФактическая * КоэффициентПересчета; 

			Если НомерСтроки = 1 Тогда // первая строка

				ТекстСтраница = НСтр("ru = 'Страница %НомерСтраницы%';
				|en = 'Page %НомерСтраницы%'", Метаданные.Языки.Русский.КодЯзыка);
				ТекстСтраница = СтрЗаменить(ТекстСтраница,"%НомерСтраницы%",2);
				ОбластьШапки.Параметры.НомерСтраницы = ТекстСтраница;

				ТабличныйДокумент.Вывести(ОбластьШапки);

			Иначе

				МассивВыводимыхОбластей.Очистить();
				МассивВыводимыхОбластей.Добавить(ОбластьСтроки);
				МассивВыводимыхОбластей.Добавить(ОбластьПодвалСтраницы);

				Если НомерСтроки <> 1 И Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда

					ОбластьПодвалСтраницы.Параметры.Заполнить(ИтоговыеСуммы);
					ОбластьПодвалСтраницы.Параметры.КоличествоПорядковыхНомеровНаСтраницеПрописью = ЧислоПрописью(НомерСтроки - ПервыйНомерСтроки, ,",,,,,,,,0");
					ОбластьПодвалСтраницы.Параметры.ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью = ФормированиеПечатныхФорм.КоличествоПрописью(ИтоговыеСуммы.ИтогоПоСтраницеФактКоличество);
					ОбластьПодвалСтраницы.Параметры.СуммаФактическиНаСтраницеПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(
					ИтоговыеСуммы.ИтогоПоСтраницеФактСумма,
					ВалютаРеглУчета,
					Ложь);

					ПервыйНомерСтроки = НомерСтроки;

					ТабличныйДокумент.Вывести(ОбластьПодвалСтраницы);

					// Очистим итоги по странице.
					ИтоговыеСуммы.ИтогоПоСтраницеФактКоличество = 0;
					ИтоговыеСуммы.ИтогоПоСтраницеФактСумма = 0;
					ИтоговыеСуммы.ИтогоПоСтраницеБухКоличество = 0;
					ИтоговыеСуммы.ИтогоПоСтраницеБухСумма = 0;

					НомерСтраницы = НомерСтраницы + 1;
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();

					ТекстСтраница = НСтр("ru = 'Страница %НомерСтраницы%';
					|en = 'Page %НомерСтраницы%'", Метаданные.Языки.Русский.КодЯзыка);
					ТекстСтраница = СтрЗаменить(ТекстСтраница,"%НомерСтраницы%",НомерСтраницы);
					ОбластьШапки.Параметры.НомерСтраницы = ТекстСтраница;
					ТабличныйДокумент.Вывести(ОбластьШапки);

				КонецЕсли;

			КонецЕсли;

			ТабличныйДокумент.Вывести(ОбластьСтроки);

			ИтоговыеСуммы.ИтогоПоСтраницеФактКоличество = ИтоговыеСуммы.ИтогоПоСтраницеФактКоличество + ТабличнаяЧасть.КоличествоФактическое;
			ИтоговыеСуммы.ИтогоПоСтраницеФактСумма = ИтоговыеСуммы.ИтогоПоСтраницеФактСумма + ТабличнаяЧасть.СуммаФактическая * КоэффициентПересчета;
			ИтоговыеСуммы.ИтогоПоСтраницеБухКоличество = ИтоговыеСуммы.ИтогоПоСтраницеБухКоличество + ТабличнаяЧасть.КоличествоПоУчету;
			ИтоговыеСуммы.ИтогоПоСтраницеБухСумма = ИтоговыеСуммы.ИтогоПоСтраницеБухСумма + ТабличнаяЧасть.СуммаПоУчету * КоэффициентПересчета;

			ИтоговыеСуммы.ИтогоФактКоличество = ИтоговыеСуммы.ИтогоФактКоличество + ТабличнаяЧасть.КоличествоФактическое;
			ИтоговыеСуммы.ИтогоФактСумма = ИтоговыеСуммы.ИтогоФактСумма + ТабличнаяЧасть.СуммаФактическая * КоэффициентПересчета;
			ИтоговыеСуммы.ИтогоБухКоличество = ИтоговыеСуммы.ИтогоБухКоличество + ТабличнаяЧасть.КоличествоПоУчету;
			ИтоговыеСуммы.ИтогоБухСумма = ИтоговыеСуммы.ИтогоБухСумма + ТабличнаяЧасть.СуммаПоУчету * КоэффициентПересчета;

		КонецЦикла;

		//Если ПервыйНомерСтроки <> НомерСтроки ИЛИ ПервыйНомерСтроки = ТабличнаяЧасть.Количество() Тогда             // begin fix Suetin 11.12.2019 17:53:34
		Если ПервыйНомерСтроки <> НомерСтроки ИЛИ ПервыйНомерСтроки = МассивСтрокСТипомЗапасов.Количество() Тогда     // end fix Suetin 11.12.2019 17:53:38
			ОбластьПодвалСтраницы.Параметры.Заполнить(ИтоговыеСуммы);
			ОбластьПодвалСтраницы.Параметры.КоличествоПорядковыхНомеровНаСтраницеПрописью = ЧислоПрописью(НомерСтроки - ПервыйНомерСтроки + 1, ,",,,,,,,,0");
			ОбластьПодвалСтраницы.Параметры.ОбщееКоличествоЕдиницФактическиНаСтраницеПрописью = ФормированиеПечатныхФорм.КоличествоПрописью(ИтоговыеСуммы.ИтогоПоСтраницеФактКоличество);
			ОбластьПодвалСтраницы.Параметры.СуммаФактическиНаСтраницеПрописью =  РаботаСКурсамиВалют.СформироватьСуммуПрописью(
			ИтоговыеСуммы.ИтогоПоСтраницеФактСумма,
			ВалютаРеглУчета,
			Ложь);

			ТабличныйДокумент.Вывести(ОбластьПодвалСтраницы);
		КонецЕсли;

		ОбластьПодвалОписи.Параметры.КоличествоПорядковыхНомеровПрописью     = ЧислоПрописью(НомерСтроки, ,",,,,,,,,0");
		ОбластьПодвалОписи.Параметры.ОбщееКоличествоЕдиницФактическиПрописью = ФормированиеПечатныхФорм.КоличествоПрописью(ИтоговыеСуммы.ИтогоФактКоличество);
		ОбластьПодвалОписи.Параметры.СуммаФактическиПрописью     			 = РаботаСКурсамиВалют.СформироватьСуммуПрописью(ИтоговыеСуммы.ИтогоФактСумма,
		ВалютаРеглУчета,
		Ложь);
		ОбластьПодвалОписи.Параметры.НачальныйНомерПоПорядку = 1;
		ОбластьПодвалОписи.Параметры.КонечныйНомерПоПорядку	 = НомерСтроки;
		// begin fix Люкшинова 03.12.2019 10:46:40
		//ОбластьПодвалОписи.Параметры.ДолжностьПредседателя	 = Шапка.ДолжностьРуководителя;
		//ОбластьПодвалОписи.Параметры.ФИОпредседателя     	 = Шапка.Руководитель;
	    ОбластьПодвалОписи.Параметры.ДолжностьПредседателя	 = "";
		ОбластьПодвалОписи.Параметры.ФИОпредседателя     	 = "";

		//ОбластьПодвалОписи.Параметры.ДолжностьЧленаКомиссии2 = НСтр("ru = 'Главный бухгалтер';
		//|en = 'Chief Accountant'", Метаданные.Языки.Русский.КодЯзыка);
		//ОбластьПодвалОписи.Параметры.ФИОЧленаКомиссии2       = Шапка.ГлавныйБухгалтер;
	    ОбластьПодвалОписи.Параметры.ДолжностьЧленаКомиссии2 = "";
		ОбластьПодвалОписи.Параметры.ФИОЧленаКомиссии2       = "";

		ОбластьПодвалОписи.Параметры.ДолжностьМОЛ1           = Шапка.ДолжностьКладовщика;
		ОбластьПодвалОписи.Параметры.ФИОМОЛ1                 = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Шапка.Кладовщик, Шапка.ДатаДокумента);

		//ОбластьПодвалОписи.Параметры.ДолжностьРасчетчика	 = НСтр("ru = 'Главный бухгалтер';
		//|en = 'Chief Accountant'", Метаданные.Языки.Русский.КодЯзыка);
		//ОбластьПодвалОписи.Параметры.ФИОРасчетчика		     = Шапка.ГлавныйБухгалтер;
		 ОбластьПодвалОписи.Параметры.ДолжностьРасчетчика	 = "";
		 ОбластьПодвалОписи.Параметры.ФИОРасчетчика		     = "";
		// end fix Люкшинова 03.12.2019 10:46:51
		ТекстСтраница = НСтр("ru = 'Страница %НомерСтраницы%';
		|en = 'Page %НомерСтраницы%'", Метаданные.Языки.Русский.КодЯзыка);
		ТекстСтраница = СтрЗаменить(ТекстСтраница,"%НомерСтраницы%",НомерСтраницы + 1);
		ОбластьПодвалОписи.Параметры.НомерСтраницы = ТекстСтраница;

		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабличныйДокумент.Вывести(ОбластьПодвалОписи);
		// begin fix Suetin 11.12.2019 15:37:33
		Если МассивТиповЗапасов.Найти(ТипЗапасов) < МассивТиповЗапасов.ВГраница() Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли; 
		// end fix Suetin 11.12.2019 15:37:39
	КонецЦикла; 
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

//#КонецЕсли
