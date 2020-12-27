﻿
//&НаСервере
//Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
//	Элементы.ГруппаУстановитьСтатус.Видимость = РольДоступна("ВИЛС_ДиректорПоФинансам") или РольДоступна("ПолныеПрава") ;
//	Элементы.СписокУстановитьСтатусНеСогласована.Видимость = Ложь;
//	Элементы.СписокУстановитьСтатусСогласована.Видимость = Ложь;
//	Элементы.ГруппаФункцииКонтекстноеМеню.Доступность = Ложь;
//КонецПроцедуры

&Вместо("УстановитьСтатусНеСогласована")
&НаКлиенте
Процедура ВИЛС_УстановитьСтатусНеСогласована(Команда)
КонецПроцедуры

&Вместо("УстановитьСтатусСогласована")
&НаКлиенте
Процедура ВИЛС_УстановитьСтатусСогласована(Команда)
	
КонецПроцедуры

&Вместо("УстановитьСтатусКОплате")
&НаКлиенте
Процедура ВИЛС_УстановитьСтатусКОплате(Команда)
	Если ДоступнаРоль("ВИЛС_ДиректорПоФинансам") или ДоступнаРоль("ПолныеПрава") Тогда
		ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
		Если ВыделенныеСтроки.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""К оплате"". Продолжить?'");
		Ответ = Неопределено;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКОплатеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
КонецПроцедуры

&Вместо("УстановитьСтатусОтклонена")
&НаКлиенте
Процедура ВИЛС_УстановитьСтатусОтклонена(Команда)
	Если ДоступнаРоль("ВИЛС_ДиректорПоФинансам") Тогда	
		ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
		Если ВыделенныеСтроки.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""Отклонена"". Продолжить?'");
		Ответ = Неопределено;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусОтклоненаЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ДоступнаРоль(Роль)
	
	Возврат РольДоступна(Роль);
	
КонецФункции
