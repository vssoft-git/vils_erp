﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

&Вместо("ЗаполнитьТабличныйДокументТН")
Процедура ВИЛС_ЗаполнитьТабличныйДокументТН(ТабличныйДокумент, СтруктураДанных, ОбъектыПечати, КомплектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТранспортнойНакладной.ПФ_MXL_ТранспортнаяНакладная_ru");
	
	ТаблицаДанныхДляПечати = СтруктураДанных.ТаблицаРезультата;
	ДанныеСсылкиДокументов = СтруктураДанных.РезультатИменаТоваров.Выбрать();
	ТаблицаНомеровДокументов = СтруктураДанных.ТаблицаНомеровДокументов.Выбрать();	// fix Suetin 14.02.2019 12:43:56
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ТаблицаДанныхДляПечати Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
			
		ПервыйДокумент    = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Если ТТН с доставкой и нашли связанные с доставкой ошибки - перейдем к следующему документу.
		СтруктураЗаданиеНаПеревозку = Новый Структура("НеНайденоЗаданиеНаПеревозку,
													  |БолееОдногоВхожденияВЗаданияНаПеревозку,
													  |РаспоряжениеНеПроведено",
													  Ложь,Ложь,Ложь);
		ЕстьОшибкиДоставки = Ложь;
		ЗаполнитьЗначенияСвойств(СтруктураЗаданиеНаПеревозку,ДанныеПечати);
		
		Если СтруктураЗаданиеНаПеревозку.НеНайденоЗаданиеНаПеревозку Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для документа %1 не найдено задание на перевозку. 
					|Печать формы 1-Т для документов с доставкой возможна после включения документа в задание на перевозку.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		
		Если СтруктураЗаданиеНаПеревозку.БолееОдногоВхожденияВЗаданияНаПеревозку Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно напечатать форму 1-Т для %1, т.к. найдено более одного задания на перевозку, 
					|в которые включен этот документ.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		
		Если СтруктураЗаданиеНаПеревозку.РаспоряжениеНеПроведено Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Документ %1 не проведен. Печать товарно - транспортной накладной не будет выполнена.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		
		Если ЕстьОшибкиДоставки Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДанныеПечати.ЕстьНепроведенныеДокументыОснования Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В документе %1 присутствуют непроведенные документы-основания. Печать транспортной накладной невозможна.'"),
				ДанныеПечати.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
				
			Продолжить;
			
		КонецЕсли;
				
		ОбластьМакета = Макет.ПолучитьОбласть("ГоризонтальнаяЛицеваяСторона");
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
		
		ОбластьМакетаОборотная = Макет.ПолучитьОбласть("ГоризонтальнаяОборотнаяСторона");
		
		СведенияОГрузополучателе  = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузополучатель,  ДанныеПечати.Дата);
		СведенияОГрузоотправитель = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузоотправитель, ДанныеПечати.Дата);
		СведенияОПеревозчике      = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Перевозчик, ДанныеПечати.Дата);
		СведенияОВодителе         = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Водитель, ДанныеПечати.Дата);
		
		ПредставлениеГрузоотправителя = "";
		ПредставлениеПеревозчика      = "";
		Перевозчик                    = "";
		Грузоотправитель              = "";
		
		РеквизитыМакета = Новый Структура;
		
		Если ЗначениеЗаполнено(ДанныеПечати.Грузополучатель) Тогда 
			Если СведенияОГрузополучателе.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо
				Или СведенияОГрузополучателе.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				РеквизитыМакета.Вставить("Пункт2_1", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, 
					"ПолноеНаименование,ИНН,ЮридическийАдрес"));
			Иначе
				РеквизитыМакета.Вставить("Пункт2_2", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, 
					"ПолноеНаименование,ЮридическийАдрес,Телефоны"));
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеПечати.Грузоотправитель) Тогда 
			Если СведенияОГрузоотправитель.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо
			 Или СведенияОГрузоотправитель.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				ПредставлениеГрузоотправителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, 
					"ПолноеНаименование,ИНН,ЮридическийАдрес");
				РеквизитыМакета.Вставить("Пункт1_1", ПредставлениеГрузоотправителя);
				Грузоотправитель = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, "ПолноеНаименование");
			Иначе
				ПредставлениеГрузоотправителя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, 
					"ПолноеНаименование,ЮридическийАдрес,Телефоны");
				РеквизитыМакета.Вставить("Пункт1_2", ПредставлениеГрузоотправителя);
				Грузоотправитель = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, "ПолноеНаименование");
			КонецЕсли;
		КонецЕсли;

		
		СтруктураПоиска = Новый Структура("ПорядковыйНомер", ДанныеПечати.ПорядковыйНомер);
		
		ИменаЕдиниц  = "";     // fix Suetin 20.02.2019 15:52:57
		ИменаТоваров = "";
		Пока ДанныеСсылкиДокументов.НайтиСледующий(СтруктураПоиска) Цикл								
			ИменаТоваров = ИменаТоваров + ДанныеСсылкиДокументов.НаименованиеВидаНоменклатуры + ", ";
			ИменаЕдиниц  = ИменаЕдиниц  + ДанныеСсылкиДокументов.КоличествоУпаковок + " " + ДанныеСсылкиДокументов.Упаковка + ", ";
		КонецЦикла;			
		
		Если СтрДлина(ИменаТоваров) >= 2 Тогда
			ИменаТоваров = Лев(ИменаТоваров, СтрДлина(ИменаТоваров) - 2);
		КонецЕсли;
		Если СтрДлина(ИменаЕдиниц) >= 2 Тогда      									// begin fix Suetin 20.02.2019 15:54:15
			ИменаЕдиниц = Лев(ИменаЕдиниц, СтрДлина(ИменаЕдиниц) - 2);
		КонецЕсли;                                 									// end fix Suetin 20.02.2019 15:54:19
		РеквизитыМакета.Вставить("Пункт3_1", ИменаТоваров); 
		РеквизитыМакета.Вставить("Пункт3_2", ИменаЕдиниц);
		Если ЗначениеЗаполнено(ДанныеПечати.ПунктПогрузки) Тогда                  	// begin fix Suetin 08.07.2019 17:57:55
			РеквизитыМакета.Вставить("Пункт6_1", ДанныеПечати.ПунктПогрузки);
		Иначе
			РеквизитыМакета.Вставить("Пункт6_1", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель, "ЮридическийАдрес"));
		КонецЕсли;	                                                              	// end fix Suetin 08.07.2019 17:58:01
		РеквизитыМакета.Вставить("Пункт7_1", ДанныеПечати.ПунктРазгрузки);
		
		МассаБруттоСтрока = НСтр("ru = '%МассаБрутто% кг'");
		МассаБруттоСтрока = СтрЗаменить(МассаБруттоСтрока, "%МассаБрутто%", ДанныеПечати.МассаБрутто);
		
		РеквизитыМакета.Вставить("Пункт6_5", МассаБруттоСтрока);
		// begin fix Suetin 14.02.2019 12:45:24
		РеквизитыМакета.Вставить("Пункт3_3", МассаБруттоСтрока);
		РеквизитыМакета.Вставить("Пункт7_5", МассаБруттоСтрока);
		НайденПорядковыйНомер = ТаблицаНомеровДокументов.НайтиСледующий(СтруктураПоиска);
		Если НайденПорядковыйНомер Тогда
			//Если ТипЗнч(ТаблицаНомеровДокументов.ДокументОснование) = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов") Тогда
			//	РеквизитыМакета.Вставить("Пункт3_1", СокрЛП(ТаблицаНомеровДокументов.Комментарий));
			//КонецЕсли;
			
			РеквизитыМакета.Вставить("Пункт0_2",  ТаблицаНомеровДокументов.Дата);
			РеквизитыМакета.Вставить("Пункт0_3",  ТаблицаНомеровДокументов.Номер);
			
			ДолжностьМассив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(ТаблицаНомеровДокументов.Руководитель.Должность);
			Текст6_6 = "";
			РазмерМассива = ДолжностьМассив.Количество() - 1;
			Для Ном = 0 По РазмерМассива Цикл
				Если Не Ном = 0 и РазмерМассива = Ном Тогда
					Текст6_6 = Текст6_6	+ Символы.ПС;
				ИначеЕсли Не Ном = 0 Тогда
					Текст6_6 = Текст6_6	+ " ";
				КонецЕсли;	
				Текст6_6 = Текст6_6 + ДолжностьМассив[Ном];
			КонецЦикла;	
			РеквизитыМакета.Вставить("Пункт6_6",  Текст6_6);
			РеквизитыМакета.Вставить("Пункт7_6",  Текст6_6);
			
			РасшифровкаМассив = Новый Массив();
			РасшифровкаМассив.Добавить(ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(ТаблицаНомеровДокументов.Руководитель.ФизическоеЛицо));
			РасшифровкаМассив.Добавить(ТаблицаНомеровДокументов.Руководитель.ОснованиеПраваПодписи);
			Текст6_61 = "";
			Для Ном = 0 По РасшифровкаМассив.Количество() - 1 Цикл
				Если Не Ном = 0 Тогда
					Текст6_61 = Текст6_61 + Символы.ПС;
				КонецЕсли;	
				Текст6_61 = Текст6_61 + РасшифровкаМассив[Ном];
			КонецЦикла;	
			РеквизитыМакета.Вставить("Пункт6_61", Текст6_61);
			РеквизитыМакета.Вставить("Пункт7_61", Текст6_61);
			РеквизитыМакета.Вставить("Пункт6_2",  ТаблицаНомеровДокументов.НачалоРейсаПлан);
			РеквизитыМакета.Вставить("Пункт7_2",  ТаблицаНомеровДокументов.ОкончаниеРейсаПлан);
			РеквизитыМакета.Вставить("Пункт6_7",  ТаблицаНомеровДокументов.ФИОВодителя);
			РеквизитыМакета.Вставить("Пункт7_7",  ТаблицаНомеровДокументов.ФИОВодителя);
			РеквизитыМакета.Вставить("Пункт6_51", ИменаЕдиниц);
			РеквизитыМакета.Вставить("Пункт7_51", ИменаЕдиниц);
		КонецЕсли;
		// end fix Suetin 14.02.2019 12:47:14
		ОбластьМакета.Параметры.Заполнить(РеквизитыМакета);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		РеквизитыМакета.Очистить();
		
		Если ЗначениеЗаполнено(ДанныеПечати.Перевозчик) Тогда 
			Если СведенияОПеревозчике.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо
			 Или СведенияОПеревозчике.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ИндивидуальныйПредприниматель Тогда
				ПредставлениеПеревозчика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, 
					"ПолноеНаименование,ФактическийАдрес,Телефоны");
				Перевозчик = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, "ПолноеНаименование");
				РеквизитыМакета.Вставить("Пункт10_1", ПредставлениеПеревозчика);
			Иначе
				ПредставлениеПеревозчика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, 
					"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны");
				Перевозчик = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, "ПолноеНаименование");
				РеквизитыМакета.Вставить("Пункт10_2", ПредставлениеПеревозчика);
			КонецЕсли;
		КонецЕсли;
		Если НайденПорядковыйНомер Тогда       		// begin fix Suetin 09.10.2019 16:24:54
			РеквизитыМакета.Вставить("Пункт15_1", ТаблицаНомеровДокументов.СтоимостьУслуги + ТаблицаНомеровДокументов.Номер + " от " + Формат(ТаблицаНомеровДокументов.Дата, "ДФ=дд.ММ.гггг") + "г.");
			ПредставлениеВодителя = "" + ТаблицаНомеровДокументов.ФИОВодителя + " т." + ТаблицаНомеровДокументов.ТелефонВодителя;
		Иначе	                                    // end fix Suetin 09.10.2019 17:13:30
		ПредставлениеВодителя = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.Водитель, ДанныеПечати.Дата);
		КонецЕсли;                                 	// fix Suetin 09.10.2019 16:25:00
		РеквизитыМакета.Вставить("Пункт10_3", ПредставлениеВодителя);
		
		ГрузоподъемностьВТоннахАвтомобиля      = Формат(ДанныеПечати.ГрузоподъемностьВТоннахАвтомобиля,"");
		ВместимостьВКубическихМетрахАвтомобиля = Формат(ДанныеПечати.ВместимостьВКубическихМетрахАвтомобиля,"");
		
		ИнформацияОбАвтомобиле = ""
			+ ?(ПустаяСтрока(ДанныеПечати.ТипАвтомобиля),"",Строка(ДанныеПечати.ТипАвтомобиля) + ", ")
			+ ?(ПустаяСтрока(ДанныеПечати.МаркаАвтомобиля),"",ДанныеПечати.МаркаАвтомобиля  + ", ")
			+ ?(ПустаяСтрока(ГрузоподъемностьВТоннахАвтомобиля),"",ГрузоподъемностьВТоннахАвтомобиля + " " + НСтр("ru = 'т'")  + ", ")
			+ ?(ПустаяСтрока(ВместимостьВКубическихМетрахАвтомобиля),"",ВместимостьВКубическихМетрахАвтомобиля + " " + НСтр("ru = 'куб. м'"));
		
		ИнформацияОбАвтомобиле = СокрЛП(ИнформацияОбАвтомобиле);
		
		Пока Прав(ИнформацияОбАвтомобиле,1) = "," Цикл
			ИнформацияОбАвтомобиле = Лев(ИнформацияОбАвтомобиле, СтрДлина(ИнформацияОбАвтомобиле)-1)
		КонецЦикла;
		
		РеквизитыМакета.Вставить("Пункт11_1", ИнформацияОбАвтомобиле);
		РеквизитыМакета.Вставить("Пункт11_2", ДанныеПечати.ГосНомерАвтомобиля);
		
		СведенияОЗаказчикеПеревозок = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.ЗаказчикПеревозки, ДанныеПечати.Дата,,ДанныеПечати.БанковскийСчетЗаказчикаПеревозки);

		РеквизитыМакета.Вставить("Пункт15_6", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОЗаказчикеПеревозок, 
			"ПолноеНаименование,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет"));
				
		РеквизитыМакета.Вставить("Пункт16_1", ДанныеПечати.Грузоотправитель.Наименование); // fix Suetin 20.02.2019 15:33:15    Грузоотправитель
		РеквизитыМакета.Вставить("Пункт16_2", ДанныеПечати.Перевозчик.Наименование);       // fix Suetin 20.02.2019 15:33:15    Перевозчик
		Если НайденПорядковыйНомер Тогда       // begin fix Suetin 09.10.2019 16:24:54
			РеквизитыМакета.Вставить("Пункт16_11", ТаблицаНомеровДокументов.ОкончаниеРейсаПлан);
			//РеквизитыМакета.Вставить("Пункт16_21", ТаблицаНомеровДокументов.ОкончаниеРейсаПлан);
		Иначе	                               // end fix Suetin 09.10.2019 17:13:30
		РеквизитыМакета.Вставить("Пункт16_11", ДанныеПечати.Дата);
		РеквизитыМакета.Вставить("Пункт16_21", ДанныеПечати.Дата);
		КонецЕсли;                             // fix Suetin 09.10.2019 16:25:00
		ОбластьМакетаОборотная.Параметры.Заполнить(РеквизитыМакета);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаОборотная);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
