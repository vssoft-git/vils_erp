﻿// begin fix Suetin 08.02.2019 14:24:51
&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	Элементы.КлассификацияЗадолженности.Доступность = Ложь;
	
	МассивДобавляемыхРеквизитов = Новый Массив;
	ДобавляемыйРеквизит = Новый РеквизитФормы("НадписьДней",Новый ОписаниеТипов("Строка"));
	МассивДобавляемыхРеквизитов.Добавить(ДобавляемыйРеквизит);
	ДобавляемыйРеквизит = Новый РеквизитФормы("НадписьДней1",Новый ОписаниеТипов("Строка"));
	МассивДобавляемыхРеквизитов.Добавить(ДобавляемыйРеквизит);
	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
	
	
	ДобавляемыйЭлементГрСВ = Элементы.Вставить("ГруппаУстановленСрокОплатыОтгрузки", Тип("ГруппаФормы"), Элементы.СтраницаУчетнаяИнформация);
	ДобавляемыйЭлементГрСВ.Вид 					= ВидГруппыФормы.ОбычнаяГруппа;
	ДобавляемыйЭлементГрСВ.Отображение 			= ОтображениеОбычнойГруппы.Нет;
	ДобавляемыйЭлементГрСВ.ОтображатьЗаголовок  = Ложь;
	ДобавляемыйЭлементГрСВ.СквозноеВыравнивание = СквозноеВыравнивание.Использовать;
	ДобавляемыйЭлементГрСВ.Группировка 			= ГруппировкаПодчиненныхЭлементовФормы .Вертикальная;
	
	ДобавляемыйЭлементГр = Элементы.Вставить("ГруппаУстановленСрокОплаты", Тип("ГруппаФормы"), ДобавляемыйЭлементГрСВ);
	ДобавляемыйЭлементГр.Вид 					= ВидГруппыФормы.ОбычнаяГруппа;
	ДобавляемыйЭлементГр.Отображение 			= ОтображениеОбычнойГруппы.Нет;
	ДобавляемыйЭлементГр.ОтображатьЗаголовок 	= Ложь;
	 
	ДобавляемыйЭлемент = Элементы.Вставить("УстановленСрокОплаты", Тип("ПолеФормы"), ДобавляемыйЭлементГр);
	ДобавляемыйЭлемент.Вид 						= ВидПоляФормы.ПолеФлажка; 
   	ДобавляемыйЭлемент.ПутьКДанным 				= "Объект.УстановленСрокОплаты";
	ДобавляемыйЭлемент.ПоложениеЗаголовка 		= ПоложениеЗаголовкаЭлементаФормы.Право;
	ДобавляемыйЭлемент.УстановитьДействие("ПриИзменении", "УстановленСрокОплатыПриИзменении");
	
	ДобавляемыйЭлемент = Элементы.Вставить("СрокОплаты", Тип("ПолеФормы"), ДобавляемыйЭлементГр);
	ДобавляемыйЭлемент.Вид 						= ВидПоляФормы.ПолеВвода; 
	ДобавляемыйЭлемент.Заголовок				= " ";
   	ДобавляемыйЭлемент.ПутьКДанным 				= "Объект.СрокОплаты";        
	ДобавляемыйЭлемент.УстановитьДействие("ПриИзменении", "СрокОплатыПриИзменении");
	
	ДобавляемыйЭлемент = Элементы.Вставить("НадписьДней", Тип("ДекорацияФормы"), ДобавляемыйЭлементГр);
	ДобавляемыйЭлемент.Вид 						= ВидДекорацииФормы.Надпись; 
	ДобавляемыйЭлемент.Заголовок				= "календарных дней";
	
	ДобавляемыйЭлементГр = Элементы.Вставить("ГруппаУстановленСрокПоставки", Тип("ГруппаФормы"), ДобавляемыйЭлементГрСВ);
	ДобавляемыйЭлементГр.Вид 					= ВидГруппыФормы.ОбычнаяГруппа;
	ДобавляемыйЭлементГр.Отображение 			= ОтображениеОбычнойГруппы.Нет;
	ДобавляемыйЭлементГр.ОтображатьЗаголовок 	= Ложь;
	 
	ДобавляемыйЭлемент = Элементы.Вставить("ВИЛС_УстановленСрокПоставкиПослеАванса", Тип("ПолеФормы"), ДобавляемыйЭлементГр);
	ДобавляемыйЭлемент.Вид 						= ВидПоляФормы.ПолеФлажка; 
   	ДобавляемыйЭлемент.ПутьКДанным 				= "Объект.ВИЛС_УстановленСрокПоставкиПослеАванса";
	ДобавляемыйЭлемент.ПоложениеЗаголовка 		= ПоложениеЗаголовкаЭлементаФормы.Право;
	ДобавляемыйЭлемент.УстановитьДействие("ПриИзменении", "ВИЛС_УстановленСрокПоставкиПослеАвансаПриИзменении");
	
	ДобавляемыйЭлемент = Элементы.Вставить("ВИЛС_СрокПоставкиПослеАванса", Тип("ПолеФормы"), ДобавляемыйЭлементГр);
	ДобавляемыйЭлемент.Вид 						= ВидПоляФормы.ПолеВвода; 
	ДобавляемыйЭлемент.Заголовок				= " ";
   	ДобавляемыйЭлемент.ПутьКДанным 				= "Объект.ВИЛС_СрокПоставкиПослеАванса";        
	ДобавляемыйЭлемент.УстановитьДействие("ПриИзменении", "ВИЛС_СрокПоставкиПослеАвансаПриИзменении");
	
	ДобавляемыйЭлемент = Элементы.Вставить("НадписьДней1", Тип("ДекорацияФормы"), ДобавляемыйЭлементГр);
	ДобавляемыйЭлемент.Вид 						= ВидДекорацииФормы.Надпись; 
	ДобавляемыйЭлемент.Заголовок				= "календарных дней";
	
	УстановитьВидимостьСрокаОплаты();
	УстановитьВидимостьСрокаПоставки();
	
	Элементы.Подразделение.АвтоОтметкаНезаполненного = Истина;    
КонецПроцедуры

&НаСервере
&Вместо("УстановитьКлассификациюЗадолженности")
Процедура ВИЛС_УстановитьКлассификациюЗадолженности(КлассификацияЗадолженности)
	// fix Suetin 08.02.2019 14:27:49 Ничего не делаем
КонецПроцедуры

&НаКлиенте
Процедура УстановленСрокОплатыПриИзменении()
	Элементы.СтраницаУчетнаяИнформация.ПодчиненныеЭлементы.ГруппаУстановленСрокОплатыОтгрузки.ПодчиненныеЭлементы.ГруппаУстановленСрокОплаты.ПодчиненныеЭлементы.СрокОплаты.Видимость = Объект.УстановленСрокОплаты;
	Элементы.СтраницаУчетнаяИнформация.ПодчиненныеЭлементы.ГруппаУстановленСрокОплатыОтгрузки.ПодчиненныеЭлементы.ГруппаУстановленСрокОплаты.ПодчиненныеЭлементы.НадписьДней.Видимость = Объект.УстановленСрокОплаты;
КонецПроцедуры

&НаКлиенте
Процедура ВИЛС_УстановленСрокПоставкиПослеАвансаПриИзменении()
	Элементы.СтраницаУчетнаяИнформация.ПодчиненныеЭлементы.ГруппаУстановленСрокОплатыОтгрузки.ПодчиненныеЭлементы.ГруппаУстановленСрокПоставки.ПодчиненныеЭлементы.ВИЛС_СрокПоставкиПослеАванса.Видимость = Объект.ВИЛС_УстановленСрокПоставкиПослеАванса;
	Элементы.СтраницаУчетнаяИнформация.ПодчиненныеЭлементы.ГруппаУстановленСрокОплатыОтгрузки.ПодчиненныеЭлементы.ГруппаУстановленСрокПоставки.ПодчиненныеЭлементы.НадписьДней1.Видимость = Объект.ВИЛС_УстановленСрокПоставкиПослеАванса;
КонецПроцедуры	

&НаСервере
Процедура УстановитьВидимостьСрокаОплаты()
	Элементы.СтраницаУчетнаяИнформация.ПодчиненныеЭлементы.ГруппаУстановленСрокОплатыОтгрузки.ПодчиненныеЭлементы.ГруппаУстановленСрокОплаты.ПодчиненныеЭлементы.СрокОплаты.Видимость = Объект.УстановленСрокОплаты;
	Элементы.СтраницаУчетнаяИнформация.ПодчиненныеЭлементы.ГруппаУстановленСрокОплатыОтгрузки.ПодчиненныеЭлементы.ГруппаУстановленСрокОплаты.ПодчиненныеЭлементы.НадписьДней.Видимость = Объект.УстановленСрокОплаты;
КонецПроцедуры	

&НаСервере
Процедура УстановитьВидимостьСрокаПоставки()
	Элементы.СтраницаУчетнаяИнформация.ПодчиненныеЭлементы.ГруппаУстановленСрокОплатыОтгрузки.ПодчиненныеЭлементы.ГруппаУстановленСрокПоставки.ПодчиненныеЭлементы.ВИЛС_СрокПоставкиПослеАванса.Видимость = Объект.ВИЛС_УстановленСрокПоставкиПослеАванса;
	Элементы.СтраницаУчетнаяИнформация.ПодчиненныеЭлементы.ГруппаУстановленСрокОплатыОтгрузки.ПодчиненныеЭлементы.ГруппаУстановленСрокПоставки.ПодчиненныеЭлементы.НадписьДней1.Видимость = Объект.ВИЛС_УстановленСрокПоставкиПослеАванса;
КонецПроцедуры

&НаКлиенте
Процедура СрокОплатыПриИзменении()    
	Если Объект.СрокОплаты > 365 Тогда
		КлассификацияЗадолженности = 1;
	Иначе
		КлассификацияЗадолженности = 0;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ВИЛС_ПриЗаписиНаСервереПосле(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Не ТекущийОбъект.УстановленСрокОплаты Тогда
		ТекущийОбъект.СрокОплаты = 0;
	КонецЕсли;
	Если Не ТекущийОбъект.ВИЛС_УстановленСрокПоставкиПослеАванса Тогда
		ТекущийОбъект.ВИЛС_СрокПоставкиПослеАванса = 0;
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ВИЛС_ОбработкаПроверкиЗаполненияНаСервереПеред(Отказ, ПроверяемыеРеквизиты)
	Если Не ЗначениеЗаполнено(Объект.Подразделение) Тогда
		Текст = НСтр("ru = 'Поле ""Подразделение"" не заполнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,,
			"Объект.Подразделение",,
			Отказ);
	КонецЕсли;
КонецПроцедуры
// end fix Suetin 08.02.2019 14:25:09