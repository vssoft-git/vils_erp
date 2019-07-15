﻿&Вместо("ПодключитьПроверкуАктуальности")
// Подключает функциональность проверки актуализации для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//
Процедура ВИЛС_ПодключитьПроверкуАктуальности(Форма) Экспорт

	//Если Не ЗначениеЗаполнено(Форма.ИдентификаторЗаданияАктуализации) И Не ЗначениеЗаполнено(Форма.АдресХранилищаАктуализации) Тогда
	//	// Задание актуализации не запущено, результата выполнения задания тоже нет - значит не проверяем актуальность.
	//	СкрытьПанельАктуализацииАвтоматически(Форма);
	//	Возврат;
	//КонецЕсли;
	//
	//Форма.ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеАктуализации");
	//Форма.ОтключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеАктуализации");
	//
	//Если ЗначениеЗаполнено(Форма.ИдентификаторЗаданияАктуализации) Тогда
	//	
	//	Элементы = Форма.Элементы;
	//
	//	БухгалтерскиеОтчетыКлиент.СброситьСостояниеАктуализации(Элементы);
	//	Элементы.Актуализация.Видимость = Истина;
	//	Элементы.ИдетПроверкаАктуальности.Видимость = Истина;
	//	
	//	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Форма.ПараметрыОбработчикаОжиданияАктуализации);
	//	Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеАктуализации", Форма.ПараметрыОбработчикаОжиданияАктуализации.ТекущийИнтервал, Истина);
	//	
	//	Возврат;
	//
	//КонецЕсли;
	//
	//Если ЗначениеЗаполнено(Форма.АдресХранилищаАктуализации) Тогда
	//	БухгалтерскиеОтчетыКлиент.ОбработатьРезультатПроверкиАктуальности(Форма.АдресХранилищаАктуализации, Форма);
	//КонецЕсли;
	
КонецПроцедуры
&Вместо("ПроверитьАктуальность")
// Проверяет актуальность для формы отчета.
//
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ВИЛС_ПроверитьАктуальность(Форма, Организация, Период = Неопределено) Экспорт

	// Совместимость с БП.
	
КонецПроцедуры
&Вместо("ПроверитьВыполнениеПроверкиАктуальностиОтчета")
// Проверяет завершение проверки актуальности для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//
Процедура ВИЛС_ПроверитьВыполнениеПроверкиАктуальностиОтчета(Форма) Экспорт

	// Совместимость с БП.

КонецПроцедуры
&Вместо("Актуализировать")
// Запускает актуализацию для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ВИЛС_Актуализировать(Форма, Организация, Период = Неопределено) Экспорт
	
	// Совместимость с БП.
	
КонецПроцедуры
&Вместо("ПроверитьВыполнениеАктуализацииОтчета")
// Проверяет завершение актуализации для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ВИЛС_ПроверитьВыполнениеАктуализацииОтчета(Форма, Организация, Период = Неопределено) Экспорт
	//
	//ПараметрыПроверки = БухгалтерскиеОтчетыКлиентСервер.ИнициализироватьПараметрыПроверкиАктуальности(Форма);
	//
	//ДанныеАктуализации = Новый Структура("ИдентификаторЗаданияАктуализации,АдресХранилищаАктуализации");
	//ЗаполнитьЗначенияСвойств(ДанныеАктуализации, Форма);
	//
	//БухгалтерскиеОтчетыВызовСервера.ПроверитьВыполнениеАктуализацииОтчета(ПараметрыПроверки, ДанныеАктуализации);
	//ЗаполнитьЗначенияСвойств(Форма, ДанныеАктуализации);
	//
	//Если Не ЗначениеЗаполнено(ДанныеАктуализации.ИдентификаторЗаданияАктуализации) Тогда
	//	БухгалтерскиеОтчетыКлиент.ОбработатьРезультатПроверкиАктуальности(ДанныеАктуализации.АдресХранилищаАктуализации, Форма);
	//Иначе
	//	ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(Форма.ПараметрыОбработчикаОжиданияАктуализации);
	//	Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеАктуализации",
	//		Форма.ПараметрыОбработчикаОжиданияАктуализации.ТекущийИнтервал, Истина);
	//КонецЕсли;

КонецПроцедуры
&Вместо("ОтменитьАктуализацию")
// Отменяет актуализации для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ВИЛС_ОтменитьАктуализацию(Форма, Организация, Период = Неопределено) Экспорт
	
	// Совместимость с БП.
	
КонецПроцедуры
&Вместо("ПроверитьЗавершениеАктуализации")
// Проверяет завершение актуализации для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//
Процедура ВИЛС_ПроверитьЗавершениеАктуализации(Форма, Организация, Период = Неопределено) Экспорт
	
	//ПараметрыПроверки = БухгалтерскиеОтчетыКлиентСервер.ИнициализироватьПараметрыПроверкиАктуальности(Форма);
	//
	//ДанныеАктуализации = Новый Структура("ИдентификаторЗаданияАктуализации,АдресХранилищаАктуализации", "", "");
	//
	//БухгалтерскиеОтчетыВызовСервера.ПроверитьВыполнениеАктуализацииОтчета(ПараметрыПроверки, ДанныеАктуализации, Истина);
	//ЗаполнитьЗначенияСвойств(Форма, ДанныеАктуализации);
	//
	//Если ЗначениеЗаполнено(ДанныеАктуализации.ИдентификаторЗаданияАктуализации) Или ЗначениеЗаполнено(ДанныеАктуализации.АдресХранилищаАктуализации) Тогда
	//	ПодключитьПроверкуАктуальности(Форма);
	//Иначе
	//	БухгалтерскиеОтчетыКлиент.ОтобразитьСостояниеАктуализации(Форма);
	//	ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(Форма.ПараметрыОбработчикаОжиданияАктуализации);
	//	Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеАктуализации", Форма.ПараметрыОбработчикаОжиданияАктуализации.ТекущийИнтервал, Истина);
	//КонецЕсли;
	
КонецПроцедуры
&Вместо("ОбработкаОповещенияАктуализации")
// Обработка оповещения об актуализации для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//	Организация - СправочникСсылка.Организации - Организации из отчета.
//	Период - Дата - Конец периода формирования отчета.
//	ИмяСобытия - Строка - Имя события оповещения.
//	Параметр - Произвольный - Параметр события оповещения.
//	Источник - Произвольный - Источник события оповещения.
//
Процедура ВИЛС_ОбработкаОповещенияАктуализации(Форма, Организация, Период, ИмяСобытия, Параметр, Источник) Экспорт
	
	//Если ИмяСобытия = "НачалоРасчетаЗакрытияМесяца" Тогда
	//	Если (Параметр.СписокОрганизаций.Количество() = 0
	//		Или Параметр.СписокОрганизаций.Найти(Организация) <> Неопределено)
	//		И Форма.ДатаАктуальности <= Параметр.Период Тогда
	//		
	//		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Форма.ПараметрыОбработчикаОжиданияАктуализации);
	//		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеАктуализации", Форма.ПараметрыОбработчикаОжиданияАктуализации.ТекущийИнтервал, Истина);
	//		
	//	КонецЕсли;
	//КонецЕсли;

КонецПроцедуры
&Вместо("СкрытьПанельАктуализацииАвтоматически")
// Скрывает панель актуализации на форме отчета автоматически.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//
Процедура ВИЛС_СкрытьПанельАктуализацииАвтоматически(Форма) Экспорт
	
	//Если НЕ ЗначениеЗаполнено(Форма.ИдентификаторЗаданияАктуализации) И ЗначениеЗаполнено(Форма.Отчет.КонецПериода)
	//	И Форма.ДатаАктуальности > Форма.Отчет.КонецПериода Тогда
	//	СкрытьПанельАктуализации(Форма);
	//КонецЕсли;
	
КонецПроцедуры
&Вместо("СкрытьПанельАктуализации")
// Скрывает панель актуализации на форме отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//
Процедура ВИЛС_СкрытьПанельАктуализации(Форма) Экспорт

	Форма.Элементы.Актуализация.Видимость = Ложь;
	
КонецПроцедуры
&Вместо("ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки")
// Обрабатывает навигационную ссылку, если данные не актуальны. Открывает форму обработки закрытия месяца.
//
//	Параметры:
//		ФормаОтчета - УправляемаяФорма - форма отчета, имеет основной реквизит "Отчет";
//		НавигационнаяСсылка - Строка - см. параметр обработки события формы "ОбработкаНавигационнойСсылки";
//		СтандартнаяОбработка - Булево - см. параметр обработки события формы "ОбработкаНавигационнойСсылки".
//
Процедура ВИЛС_ТекстПриНеобходимостиАктуализацииОбработкаНавигационнойСсылки(ФормаОтчета, НавигационнаяСсылка, СтандартнаяОбработка) Экспорт
	
	//ПараметрыАктуализации = Новый Структура("ПериодРегистрации, Организация", НачалоМесяца(ФормаОтчета.Отчет.КонецПериода), ФормаОтчета.Отчет.Организация);

	//Если СтрНайти(НавигационнаяСсылка, "ЗакрытиеМесяца") <> 0 Тогда

	//	СтандартнаяОбработка = Ложь;
	//	
	//	Оповещение = Новый ОписаниеОповещения("ЗакрытиеМесяцаЗавершение", ФормаОтчета);
	//	ФормаЗакрытияМесяца = ОткрытьФорму("Обработка.ОперацииЗакрытияМесяца.Форма", ПараметрыАктуализации, ФормаОтчета, , , , Оповещение);
	//	
	//КонецЕсли;
	
КонецПроцедуры
