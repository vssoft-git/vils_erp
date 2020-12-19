﻿
&ИзменениеИКонтроль("ВыполнитьРассылку")
Функция ВИЛС_ВыполнитьРассылку(Отчеты, ПараметрыДоставки, НаименованиеРассылки, ПараметрыЖурнала)
	РассылкаВыполнена = Ложь;
	
	// Добавление дерева сформированных отчетов - табличных документов и отчетов, сохраненных в форматы (файлов).
	ДеревоОтчетов = СоздатьДеревоОтчетов();
	
	// Заполнение параметрами по умолчанию и проверка на заполненность ключевых параметров доставки.
	Если Не ПроверитьИДозаполнитьПараметрыВыполнения(Отчеты, ПараметрыДоставки, НаименованиеРассылки, ПараметрыЖурнала) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Строка дерева общих (не персонализированных по получателям) отчетов.
	ПараметрыДоставки.СтрокаОбщихОтчетов = ОпределитьСтрокуДереваДляПолучателя(ДеревоОтчетов, Неопределено, ПараметрыДоставки);
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Инициализирована рассылка ''%1'', автор: ''%2''';
			|en = 'The ""%1"" bulk e-mail sending is initialized; from ""%2""'"),
		НаименованиеРассылки, ПараметрыДоставки.Автор);
	
	ЗаписьЖурнала(ПараметрыЖурнала,, ТекстСообщения);
	
	// Формирование и сохранение отчетов.
	НомерОтчета = 1;
	Для Каждого СтрокаОтчет Из Отчеты Цикл
		ТекстЖурнала = НСтр("ru = 'Отчет ''%1'' формируется';
							|en = 'Generating the ""%1"" report'");
		Если СтрокаОтчет.Настройки = Неопределено Тогда
			ТекстЖурнала = ТекстЖурнала + Символы.ПС + НСтр("ru = '(пользовательские настройки не заданы)';
															|en = '(user settings are not set)'");
		КонецЕсли;
		
		ПредставлениеОтчета = Строка(СтрокаОтчет.Отчет);
		
		ЗаписьЖурнала(ПараметрыЖурнала,
			УровеньЖурналаРегистрации.Примечание,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЖурнала, ПредставлениеОтчета));
		
		// Инициализация отчета.
		ПараметрыОтчета = Новый Структура("Отчет, Настройки, Форматы, ОтправлятьЕслиПустой");
		ЗаполнитьЗначенияСвойств(ПараметрыОтчета, СтрокаОтчет);
		Если Не ИнициализироватьОтчет(ПараметрыЖурнала, ПараметрыОтчета, ПараметрыДоставки.Персонализирована) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПараметрыДоставки.Персонализирована И НЕ ПараметрыОтчета.Персонализирован Тогда
			ПараметрыОтчета.Ошибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Отчет ''%1'' не может сформирован, так как в его настройках не указан отбор по получателю рассылки.';
					|en = 'Cannot generate the ""%1"" report as the filter by by a recipient of a bulk e-mail sending is not specified in settings.'"),
				ПредставлениеОтчета);
			
			ЗаписьЖурнала(ПараметрыЖурнала, УровеньЖурналаРегистрации.Ошибка, ПараметрыОтчета.Ошибки);
			Продолжить;
		КонецЕсли;
	
		// Формирование табличных документов и сохранение в форматы.
		Попытка
			Если ПараметрыОтчета.Персонализирован Тогда
				// В разрезе получателей
				Для Каждого КлючИЗначение Из ПараметрыДоставки.Получатели Цикл
					СформироватьИСохранитьОтчет(
						ПараметрыЖурнала,
						ПараметрыОтчета,
						ДеревоОтчетов,
						ПараметрыДоставки,
						КлючИЗначение.Ключ);
				КонецЦикла;
			Иначе
				// Без персонализации
				СформироватьИСохранитьОтчет(
					ПараметрыЖурнала,
					ПараметрыОтчета,
					ДеревоОтчетов,
					ПараметрыДоставки,
					Неопределено);
			КонецЕсли;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Отчет ''%1'' успешно сформирован';
					|en = 'The ""%1"" report is successfully generated'"), ПредставлениеОтчета);
			
			ЗаписьЖурнала(ПараметрыЖурнала, УровеньЖурналаРегистрации.Примечание, ТекстСообщения);

			НомерОтчета = НомерОтчета + 1;
		Исключение
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Отчет ''%1'' не сформирован:';
					|en = 'The ""%1"" report is not generated:'"), ПредставлениеОтчета);
			
			ЗаписьЖурнала(ПараметрыЖурнала,, ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЦикла;
	
	// Проверка на количество сохраненных отчетов.
	Если ДеревоОтчетов.Строки.Найти(3, "Уровень", Истина) = Неопределено Тогда
		ЗаписьЖурнала(ПараметрыЖурнала,
			УровеньЖурналаРегистрации.Предупреждение,
			НСтр("ru = 'Рассылка отчетов не выполнена, так как отчеты пустые или не сформированы из-за ошибок.';
				|en = 'Reports are not mailed as they are empty or were not generated due to errors.'"));
			
		ФайловаяСистема.УдалитьВременныйКаталог(ПараметрыДоставки.КаталогВременныхФайлов);
		Возврат Ложь;
	КонецЕсли;
	
	// Общие отчеты.
	ОбщиеВложения = ПараметрыДоставки.СтрокаОбщихОтчетов.Строки.НайтиСтроки(Новый Структура("Уровень", 3), Истина);
	
	// Отправка личных отчетов (персонализированных).
	Для Каждого СтрокаПолучатель Из ДеревоОтчетов.Строки Цикл
		Если СтрокаПолучатель = ПараметрыДоставки.СтрокаОбщихОтчетов Тогда
			Продолжить; // Пропустить строку дерева общих отчетов.
		КонецЕсли;
		
		// Личные вложения.
		ЛичныеВложения = СтрокаПолучатель.Строки.НайтиСтроки(Новый Структура("Уровень", 3), Истина);
		
		// Проверка на количество сохраненных персональных отчетов.
		Если ЛичныеВложения.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		// Объединение общих и личных вложений.
		ВложенияПолучателя = ОбъединитьМассивы(ОбщиеВложения, ЛичныеВложения);
		
		// Формирование представления отчетов.
		СформироватьПредставлениеОтчетовДляПолучателя(ПараметрыДоставки, СтрокаПолучатель);
		
		// Архивация вложений.
#Удаление
		АрхивацияВложений(ВложенияПолучателя, ПараметрыДоставки, СтрокаПолучатель.Значение);
		
#КонецУдаления
#Вставка
		// begin fix Suetin 18.05.2020 16:23:09		Пароль архива
		//											Расчитывается из Серии и Номера паспорта
		ПаролиПолучателей = Неопределено;
	    Если ПараметрыДоставки.Свойство("ПаролиПолучателей", ПаролиПолучателей) Тогда
		    ПарольАрхива = ПаролиПолучателей.Получить(СтрокаПолучатель.Ключ);
			Если ЗначениеЗаполнено(ПарольАрхива) Тогда
				ВИЛС_АрхивацияВложений(ВложенияПолучателя, ПараметрыДоставки, СтрокаПолучатель.Значение, ПарольАрхива);
			Иначе
			    АрхивацияВложений(ВложенияПолучателя, ПараметрыДоставки, СтрокаПолучатель.Значение);
			КонецЕсли; 
		Иначе
			АрхивацияВложений(ВложенияПолучателя, ПараметрыДоставки, СтрокаПолучатель.Значение);
		КонецЕсли; 
		// end fix Suetin 18.05.2020 16:23:45
#КонецВставки
		ПредставлениеПолучателя = Строка(СтрокаПолучатель.Ключ);
		
		// Доставка.
		Попытка
			ОтправитьОтчетыПолучателю(ВложенияПолучателя, ПараметрыДоставки, СтрокаПолучатель);
			РассылкаВыполнена = Истина;
			ПараметрыДоставки.ВыполненаПоЭлектроннойПочте = Истина;
		Исключение
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось отправить отчеты получателю ''%1'':';
					|en = 'Cannot send reports to the recipient ""%1"":'"), ПредставлениеПолучателя);
			
			ЗаписьЖурнала(ПараметрыЖурнала,, ТекстСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Если РассылкаВыполнена Тогда
			ПараметрыДоставки.Получатели.Удалить(СтрокаПолучатель.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	// Отправка общих отчетов.
	Если ОбщиеВложения.Количество() > 0 Тогда
		// Представление отчетов.
		СформироватьПредставлениеОтчетовДляПолучателя(ПараметрыДоставки, СтрокаПолучатель);
		
		// Архивация вложений.
		АрхивацияВложений(ОбщиеВложения, ПараметрыДоставки, ПараметрыДоставки.КаталогВременныхФайлов);
		
		// Доставка.
		Если ВыполнитьДоставку(ПараметрыЖурнала, ПараметрыДоставки, ОбщиеВложения) Тогда
			РассылкаВыполнена = Истина;
		КонецЕсли;
	КонецЕсли;

	Если РассылкаВыполнена Тогда
		ЗаписьЖурнала(ПараметрыЖурнала, , НСтр("ru = 'Рассылка выполнена';
												|en = 'Bulk email is completed'"));
	Иначе
		ЗаписьЖурнала(ПараметрыЖурнала, , НСтр("ru = 'Рассылка не выполнена';
												|en = 'Bulk email failed'"));
	КонецЕсли;
	
	ФайловаяСистема.УдалитьВременныйКаталог(ПараметрыДоставки.КаталогВременныхФайлов);
	
	// Результат.
	Если ПараметрыЖурнала.Свойство("БылиОшибки") Тогда
		ПараметрыДоставки.БылиОшибки = ПараметрыЖурнала.БылиОшибки;
	КонецЕсли;
	
	Если ПараметрыЖурнала.Свойство("БылиПредупреждения") Тогда
		ПараметрыДоставки.БылиПредупреждения = ПараметрыЖурнала.БылиПредупреждения;
	КонецЕсли;
	
	Возврат РассылкаВыполнена;
КонецФункции

// begin fix Suetin 18.05.2020 16:20:54
Процедура ВИЛС_АрхивацияВложений(Вложения, ПараметрыДоставки, КаталогВременныхФайлов, ПарольАрхива)
	Если Не ПараметрыДоставки.Архивировать Тогда
		Возврат;
	КонецЕсли;

	// Каталог вместе с файлом архивируются, а имя файла меняется на имя архива.
	ПолноеИмяФайла = КаталогВременныхФайлов + ПараметрыДоставки.ИмяАрхива;

	РежимСохранения = РежимСохраненияПутейZIP.СохранятьОтносительныеПути;
	РежимОбработки  = РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно;

	//ЗаписьZipФайла = Новый ЗаписьZipФайла(ПолноеИмяФайла, ПараметрыДоставки.ПарольАрхива); // begin fix Suetin 18.05.2020 16:21:09 	Пароль архива
	ЗаписьZipФайла = Новый ЗаписьZipФайла(ПолноеИмяФайла, ПарольАрхива);                     // end fix Suetin 18.05.2020 16:21:25		Расчитывается из Серии и Номера паспорта

	Для Каждого Вложение Из Вложения Цикл
		ЗаписьZipФайла.Добавить(Вложение.Значение, РежимСохранения, РежимОбработки);
		Если Вложение.Настройки.ФайлСКаталогом = Истина Тогда
			ЗаписьZipФайла.Добавить(Вложение.Настройки.ПолноеИмяКаталога, РежимСохранения, РежимОбработки);
		КонецЕсли;
	КонецЦикла;

	ЗаписьZipФайла.Записать();

	Вложения = Новый Соответствие;
	Вложения.Вставить(ПараметрыДоставки.ИмяАрхива, ПолноеИмяФайла);

	Если ПараметрыДоставки.ИспользоватьЭлектроннуюПочту Тогда
		Если ПараметрыДоставки.ЗаполнитьСформированныеОтчетыВШаблонеСообщения Тогда
			ПараметрыДоставки.ПредставлениеОтчетовПолучателя = 
			ПараметрыДоставки.ПредставлениеОтчетовПолучателя 
			+ Символы.ПС 
			+ Символы.ПС
			+ НСтр("ru = 'Файлы отчетов запакованы в архив';
			|en = 'Report files are archived'")
			+ " ";
		КонецЕсли;

		Если ПараметрыДоставки.ДобавлятьСсылки = "КАрхиву" Тогда
			// Способ доставки подразумевает добавление ссылок.
			Если ПараметрыДоставки.ПисьмоВФорматеHTML Тогда
				ПараметрыДоставки.ПредставлениеОтчетовПолучателя = СокрЛП(
				ПараметрыДоставки.ПредставлениеОтчетовПолучателя
				+"<a href = '"+ ПолноеИмяФайла +"'>"+ ПараметрыДоставки.ИмяАрхива +"</a>");
			Иначе
				ПараметрыДоставки.ПредставлениеОтчетовПолучателя = СокрЛП(
				ПараметрыДоставки.ПредставлениеОтчетовПолучателя
				+""""+ ПараметрыДоставки.ИмяАрхива +""":"+ Символы.ПС +"<"+ ПолноеИмяФайла +">");
			КонецЕсли;
		ИначеЕсли ПараметрыДоставки.ЗаполнитьСформированныеОтчетыВШаблонеСообщения Тогда
			// Доставка только по почте
			ПараметрыДоставки.ПредставлениеОтчетовПолучателя = СокрЛП(
			ПараметрыДоставки.ПредставлениеОтчетовПолучателя
			+""""+ ПараметрыДоставки.ИмяАрхива +"""");
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры
// end fix Suetin 18.05.2020 16:22:40