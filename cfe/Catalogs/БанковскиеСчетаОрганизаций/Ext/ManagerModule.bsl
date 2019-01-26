﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
&Вместо("ПолучитьБанковскийСчетОрганизацииПоУмолчанию")
// Функция определяет банковский счет выбранной организации.
//
// Возвращает банковский счет организации, если найден один банковский счет.
// Возвращает Неопределено, если банковский счет не найден или счетов больше одного.
//
// Параметры:
//  Организация - СправочникСсылка.Организации - Ссылка на организацию
//	Валюта - СправочникСсылка.Валюты - Валюта банковского счета.
//
// Возвращаемое значение:
//	СправочникСсылка.БанковскиеСчетаОрганизаций - Найденный банковский счет организации.
//
Функция ВИЛС_ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация, Валюта = Неопределено, НаправлениеДеятельности = Неопределено) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	БанковскиеСчетаОрганизаций.Ссылка КАК БанковскийСчетОрганизации
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	НЕ БанковскиеСчетаОрганизаций.ПометкаУдаления
	|	И НЕ БанковскиеСчетаОрганизаций.Закрыт
	|	И (БанковскиеСчетаОрганизаций.Владелец = &Организация
	|		ИЛИ &Организация = Неопределено)
	|	И (БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств = &Валюта
	|		ИЛИ &Валюта = Неопределено)
	|	И (БанковскиеСчетаОрганизаций.НаправлениеДеятельности = &НаправлениеДеятельности
	|			ИЛИ &НаправлениеДеятельности = НЕОПРЕДЕЛЕНО);
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	БанковскиеСчетаОрганизаций.Ссылка КАК БанковскийСчетОрганизации
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	НЕ БанковскиеСчетаОрганизаций.ПометкаУдаления
	|	И НЕ БанковскиеСчетаОрганизаций.Закрыт
	|	И (БанковскиеСчетаОрганизаций.Владелец = &Организация
	|		ИЛИ &Организация = Неопределено)
	|	И (БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств = &Валюта
	|		ИЛИ &Валюта = Неопределено)
	|   И БанковскиеСчетаОрганизаций.НомерСчета = ""40702810100040000331""
	|");
	
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	Запрос.УстановитьПараметр("Валюта", ?(ЗначениеЗаполнено(Валюта), Валюта, Неопределено));
	Запрос.УстановитьПараметр("НаправлениеДеятельности", ?(ЗначениеЗаполнено(НаправлениеДеятельности), НаправлениеДеятельности, Неопределено));
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаПоНаправлению  = Результат[0].Выбрать();
	ВыборкаБезНаправления = Результат[1].Выбрать();
	
	Если ВыборкаПоНаправлению.Количество() = 1 И ВыборкаПоНаправлению.Следующий() Тогда
		
		БанковскийСчетОрганизации = ВыборкаПоНаправлению.БанковскийСчетОрганизации;
		
	ИначеЕсли ВыборкаБезНаправления.Количество() = 1 И ВыборкаБезНаправления.Следующий() Тогда
		
		БанковскийСчетОрганизации = ВыборкаБезНаправления.БанковскийСчетОрганизации;
		
	Иначе
		
		БанковскийСчетОрганизации = Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка();
		
	КонецЕсли;
	
	Возврат БанковскийСчетОрганизации;

КонецФункции
#КонецЕсли