﻿// begin fix Suetin 05.03.2020 14:47:08

&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	ДобавляемыеРеквизиты 										= Новый Массив();
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ВИЛС_ПреобразоватьСсылкуВНавигационнуюСсылку", Новый ОписаниеТипов("Булево")));
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);

	Если Параметры.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя","ДокументОприходования") Тогда
		Параметры.ТипЗначения 									= Новый ОписаниеТипов("ДокументСсылка.ПриобретениеТоваровУслуг");
		ЭтотОбъект.ВИЛС_ПреобразоватьСсылкуВНавигационнуюСсылку = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	Если ЭтотОбъект.ВИЛС_ПреобразоватьСсылкуВНавигационнуюСсылку Тогда
		Элементы.Представление.Видимость 						= Ложь;
		Ссылка 													= ВИЛС_ПолучитьСсылкуИзНавигационнойСсылки(Параметры.ЗначениеРеквизита);
		Представление 											= Ссылка;
		//Элементы.Ссылка.УстановитьДействие("ПриИзменении", "Ссылка_ПриИзменении");    // Пока не требуется.
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
&ИзменениеИКонтроль("КнопкаОк")
Процедура ВИЛС_КнопкаОк(Команда)
#Удаление	
	Если СтрокаСсылочногоТипа Тогда
		Шаблон = "<a href = ""%1"">%2</a>";
		Если Не ЗначениеЗаполнено(Представление) Тогда
			Представление = Ссылка;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Ссылка) Тогда
			Значение = "";
			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", ПустаяФорматированнаяСтрока());
		Иначе
			Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Ссылка, Представление);
			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(Значение));
		КонецЕсли;
#КонецУдаления
#Вставка
	Если ЭтотОбъект.ВИЛС_ПреобразоватьСсылкуВНавигационнуюСсылку Тогда
		Шаблон = "<a href = ""%1"">%2</a>";
		//Если Не ЗначениеЗаполнено(Представление) Тогда
			Представление = Ссылка;
		//КонецЕсли;
		Если Не ЗначениеЗаполнено(Ссылка) Тогда
			Значение = "";
			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", ПустаяФорматированнаяСтрока());
		Иначе
			ПредставлениеФорматированное = СтрЗаменить(Представление, "Приобретение товаров и услуг ", "");
			МассивРазделенныхСтрок = СтрРазделить(ПредставлениеФорматированное, " ");
			ПредставлениеФорматированное = ОбщегоНазначенияУТКлиентСервер.ПредставлениеДокумента("Приоб", МассивРазделенныхСтрок[0], МассивРазделенныхСтрок[2]);
			Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ПолучитьНавигационнуюСсылку(Ссылка), ПредставлениеФорматированное);   //  Представление
			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Ссылка, ПредставлениеФорматированное)));  //  Представление
		КонецЕсли;
	ИначеЕсли СтрокаСсылочногоТипа Тогда
		Шаблон = "<a href = ""%1"">%2</a>";
		Если Не ЗначениеЗаполнено(Представление) Тогда
			Представление = Ссылка;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Ссылка) Тогда
			Значение = "";
			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", ПустаяФорматированнаяСтрока());
		Иначе
			Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Ссылка, Представление);
			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(Значение));
		КонецЕсли;
#КонецВставки	
	Иначе
		Значение = Ссылка;
	КонецЕсли;
	
	ВозвращаемоеЗначение.Вставить("Значение", Значение);
	Закрыть(ВозвращаемоеЗначение);
КонецПроцедуры

Функция ВИЛС_ПолучитьСсылкуИзНавигационнойСсылки(НС)
    ПерваяТочка = СтрНайти(НС, "e1cib/data/");
    ВтораяТочка = СтрНайти(НС, "?ref=");
	
	Если ПерваяТочка = 0 и ВтораяТочка = 0 Тогда Возврат(Неопределено); КонецЕсли;
	
    ПредставлениеТипа   = Сред(НС, ПерваяТочка + 11, ВтораяТочка - ПерваяТочка - 11);
    ШаблонЗначения = ЗначениеВСтрокуВнутр(ПредопределенноеЗначение(ПредставлениеТипа + ".ПустаяСсылка"));
	ТретьяТочка = СтрНайти(НС, НСтр("ru = '"">'"));
    ЗначениеСсылки = СтрЗаменить(ШаблонЗначения, "00000000000000000000000000000000", Сред(НС, ВтораяТочка + 5, ТретьяТочка - ВтораяТочка - 5));
    Возврат(ЗначениеИзСтрокиВнутр(ЗначениеСсылки));
КонецФункции
//&НаКлиенте
//Процедура Ссылка_ПриИзменении(Элемент)
//	А = 0;
//	

//КонецПроцедуры

//&НаКлиенте       // В этом виде программа падает. Используем процедуру выше (ВИЛС_КнопкаОк)
//Процедура ВИЛС_КнопкаОкИзменениеИКонтроль(Команда)
//#Удаление	
//	Если СтрокаСсылочногоТипа Тогда
//		Шаблон = "<a href = ""%1"">%2</a>";
//		Если Не ЗначениеЗаполнено(Представление) Тогда
//			Представление = Ссылка;
//		КонецЕсли;
//		Если Не ЗначениеЗаполнено(Ссылка) Тогда
//			Значение = "";
//			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", ПустаяФорматированнаяСтрока());
//		Иначе
//			Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Ссылка, Представление);
//			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(Значение));
//		КонецЕсли;
//#КонецУдаления
//#Вставка
//	Если ЭтотОбъект.ВИЛС_ПреобразоватьСсылкуВНавигационнуюСсылку Тогда
//		Если Не ЗначениеЗаполнено(Представление) Тогда
//			Представление = Ссылка;
//		КонецЕсли;
//		Если Не ЗначениеЗаполнено(Ссылка) Тогда
//			Значение = "";
//			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", ПустаяФорматированнаяСтрока());
//		Иначе
//			Значение = ПолучитьНавигационнуюСсылку(Ссылка);
//			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", Строка(Значение));
//		КонецЕсли;
//	ИначеЕсли СтрокаСсылочногоТипа Тогда
//		Шаблон = "<a href = ""%1"">%2</a>";
//		Если Не ЗначениеЗаполнено(Представление) Тогда
//			Представление = Ссылка;
//		КонецЕсли;
//		Если Не ЗначениеЗаполнено(Ссылка) Тогда
//			Значение = "";
//			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", ПустаяФорматированнаяСтрока());
//		Иначе
//			Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Ссылка, Представление);
//			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(Значение));
//		КонецЕсли;
//#КонецВставки	
//	Иначе
//		Значение = Ссылка;
//	КонецЕсли;
//	
//	ВозвращаемоеЗначение.Вставить("Значение", Значение);
//	Закрыть(ВозвращаемоеЗначение);
//КонецПроцедуры


// end fix Suetin 03.03.2020 13:38:30