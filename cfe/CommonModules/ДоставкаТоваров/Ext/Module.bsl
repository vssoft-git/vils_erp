﻿
&Вместо("ПриИзмененииСпособаДоставки")
Процедура ВИЛС_ПриИзмененииСпособаДоставки(ЭлементыФормы, ДокОбъект)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоставкой") Тогда
		Возврат
	КонецЕсли;
	
	ЭтоДоставкаНаНашСклад = ДоставкаТоваровКлиентСервер.ЭтоРаспоряжениеНаДоставкуНаНашСклад(ДокОбъект.Ссылка);
	
	РеквизитыДоставки = РеквизитыДоставки(ДокОбъект);
	
	ДопИнфоИзмененоПользователем = ДоставкаТоваровКлиентСервер.ДопИнфоИзмененоПользователем(ЭлементыФормы, ДокОбъект);
	
	ЗаполнитьРеквизитыПоСпособуДоставки(ЭлементыФормы, РеквизитыДоставки, ДопИнфоИзмененоПользователем);
	
	Если (РеквизитыДоставки.СпособДоставки = Перечисления.СпособыДоставки.СиламиПеревозчикаПоАдресу            		// begin fix Suetin 21.08.2019 12:23:59
			Или РеквизитыДоставки.СпособДоставки = Перечисления.СпособыДоставки.СиламиПеревозчикаДоНашегоСклада  
			Или РеквизитыДоставки.СпособДоставки = Перечисления.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи)
		И ЗначениеЗаполнено(ДокОбъект.Контрагент) Тогда	
		ЗаполнитьСписокВыбораАдресовПеревозчикаПоКонтрагенту(ЭлементыФормы, ДокОбъект.Контрагент);                               
		ЗаполнитьРеквизитыПоПеревозчику(ЭлементыФормы, РеквизитыДоставки, ДопИнфоИзмененоПользователем);			
	ИначеЕсли (РеквизитыДоставки.СпособДоставки = Перечисления.СпособыДоставки.НашимиСиламиСАдресаОтправителя
			Или РеквизитыДоставки.СпособДоставки = Перечисления.СпособыДоставки.ОтОтправителяОпределяетСлужбаДоставки)
		И ЗначениеЗаполнено(ДокОбъект.Контрагент) Тогда	
		ЗаполнитьСписокВыбораАдресовКонтрагентаПоКонтрагенту(ЭлементыФормы, ДокОбъект.Контрагент);                               
		ЗаполнитьРеквизитыПоПеревозчику(ЭлементыФормы, РеквизитыДоставки, ДопИнфоИзмененоПользователем);			
	КонецЕсли;                                                                                                      // end fix Suetin 21.08.2019 12:24:07
	Если (РеквизитыДоставки.СпособДоставки = Перечисления.СпособыДоставки.СиламиПеревозчикаПоАдресу
		    Или РеквизитыДоставки.СпособДоставки = Перечисления.СпособыДоставки.СиламиПеревозчикаДоНашегоСклада   	// fix Suetin 21.08.2019 12:25:42
			Или РеквизитыДоставки.СпособДоставки = Перечисления.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи)
		И ЗначениеЗаполнено(РеквизитыДоставки.ПеревозчикПартнер) Тогда
		ЗаполнитьСписокВыбораАдресовПеревозчика(ЭлементыФормы, РеквизитыДоставки);
		ЗаполнитьРеквизитыПоПеревозчику(ЭлементыФормы, РеквизитыДоставки, ДопИнфоИзмененоПользователем);  
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ДокОбъект, РеквизитыДоставки);
	
	ЭтоДоговорСоглашение = ТипЗнч(ДокОбъект.Ссылка) = Тип("СправочникСсылка.ДоговорыКонтрагентов")
		Или ТипЗнч(ДокОбъект.Ссылка) = Тип("СправочникСсылка.СоглашенияСПоставщиками");
	
	Если ЭлементыФормы.Найти("СтраницыДоставки") <> Неопределено Тогда
		РаспоряжениеПоСоглашению = ЭтоДоставкаНаНашСклад И ЭтоРаспоряжениеПоСоглашению(ДокОбъект);
		ДоставкаОпределенаВДоговоре = ЭтоДоставкаНаНашСклад И ДоставкаОпределенаВДоговоре(ДокОбъект);
		
		РаспоряжениеПоДоговору = Не ЭтоДоговорСоглашение И ДоставкаОпределенаВДоговоре;
		
		ДоставкаТоваровКлиентСервер.УстановитьСтраницуДоставки(ЭлементыФормы,
			ДокОбъект.СпособДоставки,
			ПолучитьФункциональнуюОпцию("ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками"),
			РаспоряжениеПоСоглашению,
			РаспоряжениеПоДоговору);
	КонецЕсли;
	
	ОсобыеУсловияПеревозкиУстановитьДоступность(ЭлементыФормы, ДокОбъект);
	
КонецПроцедуры

Процедура ЗаполнитьСписокВыбораАдресовПеревозчикаПоКонтрагенту(ЭлементыФормы, Контрагент)	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЭлементыФормы.Найти("АдресДоставкиПеревозчика") <> Неопределено Тогда
		ИмяЭлементаАдрес = "АдресДоставкиПеревозчика";
	Иначе
		Возврат;
	КонецЕсли;
	
	ПеревозчикПартнер = Контрагент;
	
	Если Не ЗначениеЗаполнено(ПеревозчикПартнер) Тогда
		ЭлементыФормы[ИмяЭлементаАдрес].СписокВыбора.Очистить();
		Возврат;
	КонецЕсли;
	
	СписокВыбора = Новый СписокЗначений;
	
	АдресаПолучателяИзКонтактнойИнформации = АдресаПолучателяИзКонтактнойИнформации(ПеревозчикПартнер);
	Для Каждого Стр Из АдресаПолучателяИзКонтактнойИнформации Цикл
		НайденныйЭлементСЗ = ДоставкаТоваровКлиентСервер.НайтиВСпискеСтруктур(СписокВыбора,"АдресДоставки",Стр.АдресДоставки);
		Если НайденныйЭлементСЗ = Неопределено Тогда
			СтруктураВыбора = СтруктураВыбора();
			ЗаполнитьЗначенияСвойств(СтруктураВыбора, Стр);
			СписокВыбора.Добавить(СтруктураВыбора, Стр.Вид + ": " + Стр.АдресДоставки);
		ИначеЕсли Не ЗначениеЗаполнено(НайденныйЭлементСЗ.Значение.АдресДоставкиЗначенияПолей) Тогда
			НайденныйЭлементСЗ.Значение.АдресДоставкиЗначенияПолей = Стр.АдресДоставкиЗначенияПолей;
		КонецЕсли;
	КонецЦикла;
	
	СкопироватьСписокЗначений(ЭлементыФормы[ИмяЭлементаАдрес].СписокВыбора, СписокВыбора)	
КонецПроцедуры

Процедура ЗаполнитьСписокВыбораАдресовКонтрагентаПоКонтрагенту(ЭлементыФормы, Контрагент)	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЭлементыФормы.Найти("АдресПоставщика") <> Неопределено Тогда
		ИмяЭлементаАдрес = "АдресПоставщика";
	Иначе
		Возврат;
	КонецЕсли;
	
	ПеревозчикПартнер = Контрагент;
	
	Если Не ЗначениеЗаполнено(ПеревозчикПартнер) Тогда
		ЭлементыФормы[ИмяЭлементаАдрес].СписокВыбора.Очистить();
		Возврат;
	КонецЕсли;
	
	СписокВыбора = Новый СписокЗначений;
	
	АдресаПолучателяИзКонтактнойИнформации = АдресаПолучателяИзКонтактнойИнформации(ПеревозчикПартнер);
	Для Каждого Стр Из АдресаПолучателяИзКонтактнойИнформации Цикл
		НайденныйЭлементСЗ = ДоставкаТоваровКлиентСервер.НайтиВСпискеСтруктур(СписокВыбора,"АдресДоставки",Стр.АдресДоставки);
		Если НайденныйЭлементСЗ = Неопределено Тогда
			СтруктураВыбора = СтруктураВыбора();
			ЗаполнитьЗначенияСвойств(СтруктураВыбора, Стр);
			СписокВыбора.Добавить(СтруктураВыбора, Стр.Вид + ": " + Стр.АдресДоставки);
		ИначеЕсли Не ЗначениеЗаполнено(НайденныйЭлементСЗ.Значение.АдресДоставкиЗначенияПолей) Тогда
			НайденныйЭлементСЗ.Значение.АдресДоставкиЗначенияПолей = Стр.АдресДоставкиЗначенияПолей;
		КонецЕсли;
	КонецЦикла;
	
	СкопироватьСписокЗначений(ЭлементыФормы[ИмяЭлементаАдрес].СписокВыбора, СписокВыбора)	
КонецПроцедуры


&Вместо("ДоставкаОпределенаВДоговоре")
Функция ВИЛС_ДоставкаОпределенаВДоговоре(ДокОбъект)
	
	Если ДокОбъект = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЭтоДоговор  = (ТипЗнч(ДокОбъект.Ссылка) = Тип("СправочникСсылка.ДоговорыКонтрагентов"));
	
	РаспоряжениеНаДоставкуНаНашСклад = Ложь;
	
	Если ТипЗнч(ДокОбъект) = Тип("ДанныеФормыСтруктура")
		Или ТипЗнч(ДокОбъект) = Тип("Структура") Тогда
		РаспоряжениеНаДоставкуНаНашСклад = ДоставкаТоваровКлиентСервер.ЭтоРаспоряжениеНаДоставкуНаНашСклад(ДокОбъект)
			И ДокОбъект.Свойство("Договор")
			И ЗначениеЗаполнено(ДокОбъект.Договор);
	Иначе
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(ДокОбъект.Ссылка));
		ЕстьДоговор = ОбщегоНазначения.ЕстьРеквизитОбъекта("Договор", МетаданныеОбъекта);
		
		РаспоряжениеНаДоставкуНаНашСклад = 
			(ДоставкаТоваровКлиентСервер.ЭтоРаспоряжениеНаДоставкуНаНашСклад(ДокОбъект)
			 И ЭтоДоговор)
			Или (ЕстьДоговор
				И ЗначениеЗаполнено(ДокОбъект.Договор));
	КонецЕсли;
	
	Если РаспоряжениеНаДоставкуНаНашСклад Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Если ЭтоДоговор Тогда
			СпособДоставки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокОбъект.Ссылка, "СпособДоставки");
		Иначе
			СпособДоставки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокОбъект.Договор, "СпособДоставки");
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
		
		СпособыДоставки = Новый Массив;

		//Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками") Тогда  // begin fix Suetin 21.08.2019 16:37:27
		//	СпособыДоставки.Добавить(Перечисления.СпособыДоставки.СиламиПеревозчикаДоНашегоСклада);
		//КонецЕсли;                                                                                             // end fix Suetin 21.08.2019 16:37:33

		СпособыДоставки.Добавить(Перечисления.СпособыДоставки.СиламиПоставщикаДоНашегоСклада);
		//СпособыДоставки.Добавить(Перечисления.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи);                // begin fix Suetin 21.08.2019 16:37:49
		//СпособыДоставки.Добавить(Перечисления.СпособыДоставки.НашимиСиламиСАдресаОтправителя);
		//СпособыДоставки.Добавить(Перечисления.СпособыДоставки.ОтОтправителяОпределяетСлужбаДоставки);            // end fix Suetin 21.08.2019 16:37:55
		
		ДоставкаИспользуется = СпособыДоставки.Найти(СпособДоставки) <> Неопределено;
		
		Возврат ДоставкаИспользуется;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ПолучательОтправительКонтрагент(ДокОбъект)
	Заполнение = Новый Структура("Контрагент",0);
	ЗаполнитьЗначенияСвойств(Заполнение,ДокОбъект);
	Если Заполнение.Контрагент <> 0 Тогда
		Возврат Новый Структура("ИмяПоля,Значение","Контрагент",ДокОбъект.Контрагент);
	Иначе
		ВызватьИсключение НСтр("ru = 'Получатель (отправитель) - Контрагент не определен.';
								|en = 'Recipient (sender) - Klient is not determined. '");
	КонецЕсли;
КонецФункции

&Вместо("ЗаполнитьСпискиВыбораАдресовПолучателяОтправителя")
Процедура ВИЛС_ЗаполнитьСпискиВыбораАдресовПолучателяОтправителя(ЭлементыФормы, ДокОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПолучательОтправитель = ПолучательОтправитель(ДокОбъект).Значение;
		
	Если Не ЗначениеЗаполнено(ПолучательОтправитель) Тогда
		ДоставкаТоваровКлиентСервер.ОчиститьСпискиВыбораАдресовПолучателяОтправителя(ЭлементыФормы);
		Возврат;
	КонецЕсли;
	
	СписокВыбора = Новый СписокЗначений;
	ПоследниеРеквизитыДоставкиИзЗаданий = ПоследниеРеквизитыДоставкиИзЗаданий(ПолучательОтправитель);
	Для Каждого Стр Из ПоследниеРеквизитыДоставкиИзЗаданий Цикл
		СтруктураВыбора = СтруктураВыбора();
		ЗаполнитьЗначенияСвойств(СтруктураВыбора, Стр);
		СписокВыбора.Добавить(СтруктураВыбора,Стр.АдресДоставки);
	КонецЦикла;
	
	ПоследниеРеквизитыДоставкиИзРаспоряжений = ПоследниеРеквизитыДоставкиИзРаспоряжений(ДокОбъект.Ссылка, ПолучательОтправитель);
	Для Каждого Стр Из ПоследниеРеквизитыДоставкиИзРаспоряжений Цикл
		НайденныйЭлементСЗ = ДоставкаТоваровКлиентСервер.НайтиВСпискеСтруктур(СписокВыбора,"АдресДоставки",Стр.АдресДоставки);
		Если НайденныйЭлементСЗ = Неопределено Тогда
			СтруктураВыбора = СтруктураВыбора();
			ЗаполнитьЗначенияСвойств(СтруктураВыбора, Стр);
			СписокВыбора.Добавить(СтруктураВыбора, Стр.АдресДоставки);
		Иначе
			ДозаполнитьПустыеСвойства(НайденныйЭлементСЗ.Значение, Стр);
		КонецЕсли;
	КонецЦикла;
	
	Если (ТипЗнч(ПолучательОтправитель) <> Тип("СправочникСсылка.СтруктураПредприятия")
		И ТипЗнч(ПолучательОтправитель) <> Тип("Строка")) Тогда
		
		АдресаПолучателяИзКонтактнойИнформации = АдресаПолучателяИзКонтактнойИнформации(ПолучательОтправитель);
		Для Каждого Стр Из АдресаПолучателяИзКонтактнойИнформации Цикл
			НайденныйЭлементСЗ = ДоставкаТоваровКлиентСервер.НайтиВСпискеСтруктур(СписокВыбора,"АдресДоставки",Стр.АдресДоставки);
			Если НайденныйЭлементСЗ = Неопределено Тогда
				СтруктураВыбора = СтруктураВыбора();
				ЗаполнитьЗначенияСвойств(СтруктураВыбора, Стр);
				СписокВыбора.Добавить(СтруктураВыбора, Стр.Вид + ": " + Стр.АдресДоставки);
			Иначе
				ДозаполнитьПустыеСвойства(НайденныйЭлементСЗ.Значение, Стр);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	// begin fix Suetin 21.08.2019 17:33:58
	ПолучательОтправитель = ПолучательОтправительКонтрагент(ДокОбъект).Значение;
	
	Если (ТипЗнч(ПолучательОтправитель) <> Тип("СправочникСсылка.СтруктураПредприятия")
		И ТипЗнч(ПолучательОтправитель) <> Тип("Строка")) Тогда
		
		АдресаПолучателяИзКонтактнойИнформации = АдресаПолучателяИзКонтактнойИнформации(ПолучательОтправитель);
		Для Каждого Стр Из АдресаПолучателяИзКонтактнойИнформации Цикл
			НайденныйЭлементСЗ = ДоставкаТоваровКлиентСервер.НайтиВСпискеСтруктур(СписокВыбора,"АдресДоставки",Стр.АдресДоставки);
			Если НайденныйЭлементСЗ = Неопределено Тогда
				СтруктураВыбора = СтруктураВыбора();
				ЗаполнитьЗначенияСвойств(СтруктураВыбора, Стр);
				СписокВыбора.Добавить(СтруктураВыбора, Стр.Вид + ": " + Стр.АдресДоставки);
			Иначе
				ДозаполнитьПустыеСвойства(НайденныйЭлементСЗ.Значение, Стр);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	// end fix Suetin 21.08.2019 17:34:48
	Если ЭлементыФормы.Найти("АдресДоставкиСамовывоз") <> Неопределено Тогда
		СкопироватьСписокЗначений(ЭлементыФормы.АдресДоставкиСамовывоз.СписокВыбора, СписокВыбора);
	КонецЕсли;
	Если ЭлементыФормы.Найти("АдресДоставкиПолучателя") <> Неопределено Тогда
		СкопироватьСписокЗначений(ЭлементыФормы.АдресДоставкиПолучателя.СписокВыбора, СписокВыбора);
	КонецЕсли;
	Если ЭлементыФормы.Найти("АдресДоставкиПолучателя1") <> Неопределено Тогда
		СкопироватьСписокЗначений(ЭлементыФормы.АдресДоставкиПолучателя1.СписокВыбора, СписокВыбора);
	КонецЕсли;
	Если ЭлементыФормы.Найти("АдресДоставкиПолучателя2") <> Неопределено Тогда
		СкопироватьСписокЗначений(ЭлементыФормы.АдресДоставкиПолучателя2.СписокВыбора, СписокВыбора);
	КонецЕсли;
	Если ЭлементыФормы.Найти("АдресПоставщика") <> Неопределено Тогда
		СкопироватьСписокЗначений(ЭлементыФормы.АдресПоставщика.СписокВыбора, СписокВыбора);
	КонецЕсли;
	Если ЭлементыФормы.Найти("АдресПункта") <> Неопределено Тогда
		СкопироватьСписокЗначений(ЭлементыФормы.АдресПункта.СписокВыбора, СписокВыбора);
	КонецЕсли;
	
КонецПроцедуры

&Вместо("ЗаписатьТоварыКДоставке")
Процедура ВИЛС_ЗаписатьТоварыКДоставке(ТоварыРаспоряжений, ТЧРаспоряжения, ЗаданиеНаПеревозку)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Т.Распоряжение,
	|	Т.Склад,
	|	ИСТИНА КАК ВсеТовары
	|ПОМЕСТИТЬ ПолностьюДоставляемыеРаспоряжения
	|ИЗ
	|	&ПолностьюДоставляемыеРаспоряжения КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыКДоставке.Распоряжение,
	|	ТоварыКДоставке.Склад,
	|	ТоварыКДоставке.Номенклатура,
	|	ТоварыКДоставке.Характеристика,
	|	ТоварыКДоставке.Назначение,
	|	ТоварыКДоставке.Серия,
	|	ТоварыКДоставке.Количество,
	|	ТоварыКДоставке.Вес,            		// begin fix Suetin 23.08.2019 11:43:05
	|	ТоварыКДоставке.Объем,          		// end fix Suetin 23.08.2019 11:43:09
	|	ТоварыКДоставке.ВсеТовары,
	|	ТоварыКДоставке.ПолучательОтправитель
	|ПОМЕСТИТЬ ВТТоварыЗадания
	|ИЗ
	|	&ТоварыКДоставке КАК ТоварыКДоставке
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТТоварыЗадания.Распоряжение,
	|	ВТТоварыЗадания.Склад,
	|	ВТТоварыЗадания.ВсеТовары
	|ПОМЕСТИТЬ РаспоряженияЗадания
	|ИЗ
	|	ВТТоварыЗадания КАК ВТТоварыЗадания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Т.Распоряжение,
	|	Т.ПолучательОтправитель,
	|	Т.Номенклатура,
	|	Т.Склад,
	|	Т.Назначение,
	|	Т.Характеристика,
	|	Т.Серия,
	|	СУММА(Т.Количество) КАК Количество,
	|	СУММА(Т.Вес) КАК Вес,                  	// begin fix Suetin 23.08.2019 11:44:07
	|	СУММА(Т.Объем) КАК Объем,              	// end fix Suetin 23.08.2019 11:44:11
	|	МАКСИМУМ(Т.ВсеТовары) КАК ВсеТовары
	|ПОМЕСТИТЬ ТоварыЗадания
	|ИЗ
	|	ВТТоварыЗадания КАК Т
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Распоряжение,
	|	Т.ПолучательОтправитель,
	|	Т.Номенклатура,
	|	Т.Склад,
	|	Т.Назначение,
	|	Т.Характеристика,
	|	Т.Серия
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Т.Распоряжение,
	|	Т.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Т.Распоряжение,
	|	Т.Склад
	|ПОМЕСТИТЬ ИзмененныеРаспоряжения
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыКДоставке.Распоряжение КАК Распоряжение,
	|		ТоварыКДоставке.Склад КАК Склад,
	|		ТоварыКДоставке.Номенклатура КАК Номенклатура,
	|		ТоварыКДоставке.Характеристика КАК Характеристика,
	|		ТоварыКДоставке.Назначение КАК Назначение,
	|		ТоварыКДоставке.Серия КАК Серия,
	|		ТоварыКДоставке.Количество КАК Количество,
	|		ТоварыКДоставке.Вес КАК Вес,                 // begin fix Suetin 23.08.2019 11:45:35
	|		ТоварыКДоставке.Объем КАК Объем,             // end fix Suetin 23.08.2019 11:45:39
	|		1 КАК СчетИзмененныхСтрок
	|	ИЗ
	|		РегистрСведений.ТоварыКДоставке КАК ТоварыКДоставке
	|	ГДЕ
	|		ТоварыКДоставке.ЗаданиеНаПеревозку = &ЗаданиеНаПеревозку
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыЗадания.Распоряжение,
	|		ТоварыЗадания.Склад,
	|		ТоварыЗадания.Номенклатура,
	|		ТоварыЗадания.Характеристика,
	|		ТоварыЗадания.Назначение,
	|		ТоварыЗадания.Серия,
	|		-ТоварыЗадания.Количество,
	|		-ТоварыЗадания.Вес КАК Вес,                 // begin fix Suetin 23.08.2019 11:45:35
	|		-ТоварыЗадания.Объем КАК Объем,             // end fix Suetin 23.08.2019 11:45:39
	|		-1
	|	ИЗ
	|		ТоварыЗадания КАК ТоварыЗадания) КАК Т
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Распоряжение,
	|	Т.Характеристика,
	|	Т.Назначение,
	|	Т.Серия,
	|	Т.Номенклатура,
	|	Т.Склад
	|
	|ИМЕЮЩИЕ
	|	(СУММА(Т.Количество) <> 0
	|		ИЛИ СУММА(Т.Вес) <> 0                       // begin fix Suetin 23.08.2019 11:47:21
	|		ИЛИ СУММА(Т.Объем) <> 0                     // end fix Suetin 23.08.2019 11:47:25
	|		ИЛИ СУММА(Т.СчетИзмененныхСтрок) <> 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИзмененныеРаспоряжения.Распоряжение,
	|	ИзмененныеРаспоряжения.Склад
	|ПОМЕСТИТЬ ИзмененныеРаспоряженияСвернутые
	|ИЗ
	|	ИзмененныеРаспоряжения КАК ИзмененныеРаспоряжения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ЗаданиеНаПеревозку КАК ЗаданиеНаПеревозку,
	|	ИзмененныеРаспоряженияСвернутые.Распоряжение,
	|	ИзмененныеРаспоряженияСвернутые.Склад,
	|	ТоварыЗадания.Номенклатура,
	|	ТоварыЗадания.Характеристика,
	|	ТоварыЗадания.Назначение,
	|	ТоварыЗадания.Серия,
	|	ТоварыЗадания.Количество,
	|	ТоварыЗадания.Вес,                               // begin fix Suetin 23.08.2019 11:48:27
	|	ТоварыЗадания.Объем,                             // end fix Suetin 23.08.2019 11:48:32
	|	ЕСТЬNULL(ПолностьюДоставляемыеРаспоряжения.ВсеТовары, ТоварыЗадания.ВсеТовары) КАК ВсеТовары,
	|	ТоварыЗадания.ПолучательОтправитель,
	|	ВЫБОР
	|		КОГДА ТоварыЗадания.Распоряжение ЕСТЬ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Удалить
	|ИЗ
	|	ИзмененныеРаспоряженияСвернутые КАК ИзмененныеРаспоряженияСвернутые
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыЗадания КАК ТоварыЗадания
	|		ПО ИзмененныеРаспоряженияСвернутые.Распоряжение = ТоварыЗадания.Распоряжение
	|			И ИзмененныеРаспоряженияСвернутые.Склад = ТоварыЗадания.Склад
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПолностьюДоставляемыеРаспоряжения КАК ПолностьюДоставляемыеРаспоряжения
	|		ПО ИзмененныеРаспоряженияСвернутые.Распоряжение = ПолностьюДоставляемыеРаспоряжения.Распоряжение
	|			И ИзмененныеРаспоряженияСвернутые.Склад = ПолностьюДоставляемыеРаспоряжения.Склад
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТоварыЗадания.Распоряжение,
	|	ТоварыЗадания.Склад";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ЗаданиеНаПеревозку", ЗаданиеНаПеревозку);
	Запрос.УстановитьПараметр("ПолностьюДоставляемыеРаспоряжения",
		ТЧРаспоряжения.Выгрузить(Новый Структура("ДоставляетсяПолностью", Истина), "Распоряжение,Склад"));
	Запрос.УстановитьПараметр("ТоварыКДоставке", ТоварыРаспоряжений);
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Распоряжение") Цикл
		Пока Выборка.СледующийПоЗначениюПоля("Склад") Цикл
			НаборЗаписей = РегистрыСведений.ТоварыКДоставке.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ЗаданиеНаПеревозку.Установить(ЗаданиеНаПеревозку);
			НаборЗаписей.Отбор.Распоряжение.Установить(Выборка.Распоряжение);
			НаборЗаписей.Отбор.Склад.Установить(Выборка.Склад);
			Если Не Выборка.Удалить Тогда
				Если Выборка.ВсеТовары Тогда
					ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(),Выборка,"ЗаданиеНаПеревозку,ПолучательОтправитель,Склад,Распоряжение,ВсеТовары");
				Иначе
					Пока Выборка.Следующий() Цикл
						ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(),Выборка);
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
			НаборЗаписей.Записать(Истина);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры
