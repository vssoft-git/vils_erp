﻿
&НаСервере
&ИзменениеИКонтроль("ЗаполнитьПоУказаннымНаСервере")
Процедура ВИЛС_ЗаполнитьПоУказаннымНаСервере(Порядок)
	
	Если Не ЗначениеЗаполнено(ОбъектРасчетов) ИЛИ Не ЗначениеЗаполнено(КлючАналитикиУчетаПоПартнерам) Тогда
		ТекстИсключения = НСтр("ru = 'Для частичного заполнения указжите Объект расчетов и Ключ аналитики учета по партнерам.';
								|en = 'For partial filling, specify ""Settlements object"" and ""Dimension key of accounting by partners"".'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ОсновныеПараметры = ОперативныеВзаиморасчетыСервер.СтруктураПараметровЗаполненияВзаиморасчетов();
	ОсновныеПараметры.ОбъектРасчетов = ОбъектРасчетов;
	ОсновныеПараметры.АналитикаУчетаПоПартнерам = КлючАналитикиУчетаПоПартнерам;
	Если ЗначениеЗаполнено(ДатаНачалаПересчета) Тогда
		ОсновныеПараметры.ПорядокФакт = ОперативныеВзаиморасчетыСервер.Порядок(ДатаНачалаПересчета,"",,Тип("ДокументСсылка.РегистраторРасчетов"));
		ОсновныеПараметры.ПорядокПлан = ОперативныеВзаиморасчетыСервер.Порядок(ДатаНачалаПересчета,"",,Тип("ДокументСсылка.РегистраторРасчетов"));
	КонецЕсли;
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаВзаиморасчетов",ОбъектРасчетов.Метаданные()) Тогда
		ОсновныеПараметры.ВалютаРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектРасчетов, "ВалютаВзаиморасчетов");
		
		ОсновныеПараметры.ЭтоРасчетыСКлиентами = Истина;
		ОперативныеВзаиморасчетыСервер.ЗаполнитьОперативныеВзаиморасчеты(ОсновныеПараметры);
		
		ОсновныеПараметры.ЭтоРасчетыСКлиентами = Ложь;
		ОперативныеВзаиморасчетыСервер.ЗаполнитьОперативныеВзаиморасчеты(ОсновныеПараметры);
	ИначеЕсли ТипЗнч(ОбъектРасчетов) = Тип("ДокументСсылка.ПоступлениеБезналичныхДенежныхСредств") 
		ИЛИ ТипЗнч(ОбъектРасчетов) = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств")
		ИЛИ ТипЗнч(ОбъектРасчетов) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер")
		ИЛИ ТипЗнч(ОбъектРасчетов) = Тип("ДокументСсылка.РасходныйКассовыйОрдер")
		ИЛИ ТипЗнч(ОбъектРасчетов) = Тип("ДокументСсылка.АвансовыйОтчет")
		ИЛИ ТипЗнч(ОбъектРасчетов) = Тип("ДокументСсылка.ОперацияПоПлатежнойКарте") Тогда
		ВалютаРасшифровки = ОбъектРасчетов.РасшифровкаПлатежа[0].ВалютаВзаиморасчетов;
		
		ОсновныеПараметры.ВалютаРасчетов = ВалютаРасшифровки;
		ОсновныеПараметры.ЭтоРасчетыСКлиентами = Истина;
		ОперативныеВзаиморасчетыСервер.ЗаполнитьОперативныеВзаиморасчеты(ОсновныеПараметры);
		
		ОсновныеПараметры.ЭтоРасчетыСКлиентами = Ложь;
		ОперативныеВзаиморасчетыСервер.ЗаполнитьОперативныеВзаиморасчеты(ОсновныеПараметры);
	Иначе
		
		ОсновныеПараметры.ВалютаРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектРасчетов, "Валюта");
		
		ОсновныеПараметры.ЭтоРасчетыСКлиентами = Истина;
		ОперативныеВзаиморасчетыСервер.ЗаполнитьОперативныеВзаиморасчеты(ОсновныеПараметры);
		
		ОсновныеПараметры.ЭтоРасчетыСКлиентами = Ложь;
		ОперативныеВзаиморасчетыСервер.ЗаполнитьОперативныеВзаиморасчеты(ОсновныеПараметры);
		
	КонецЕсли;
КонецПроцедуры
