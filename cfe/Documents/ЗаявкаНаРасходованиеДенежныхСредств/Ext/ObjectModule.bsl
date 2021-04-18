﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
&ИзменениеИКонтроль("ОбработкаПроверкиЗаполнения")
Процедура ВИЛС_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем Ошибки;
	
#Вставка
	// begin fix Suetin 13.08.2020 12:52:46
	Если ВИЛС_ЗаявкаВГрафикеПлатежей Тогда
		ПроверяемыеРеквизиты.Добавить("ВИЛС_ЗаявкаВГрафикеПлатежейДата");
	КонецЕсли; 
	// end fix Suetin 13.08.2020 12:52:53
#КонецВставки
	НепроверяемыеРеквизиты = Новый Массив;
	
	РасшифровкаБезРазбиения = Ложь;
	Если ДополнительныеСвойства.Свойство("РасшифровкаБезРазбиения") И ДополнительныеСвойства.РасшифровкаБезРазбиения Тогда
		РасшифровкаБезРазбиения = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(ОрганизацияПолучатель)
		И Организация = ОрганизацияПолучатель Тогда
		
		Текст = НСтр("ru = 'Одна и та же организация не может являться отправителем и получателем одновременно';
					|en = 'Same company cannot be both a sender and a recipient'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"Организация",,
			Отказ);
	КонецЕсли;
	
	// Платежной картой можно оплачивать только возврат оплаты клиенту.
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту
		И (ФормаОплатыПлатежнаяКарта Или ФормаОплатыЗаявки = Перечисления.ФормыОплаты.ПлатежнаяКарта) Тогда
		
		ТекстОшибки = НСтр("ru = 'Оплату платежной картой можно выбирать только для возврата оплаты клиенту';
							|en = 'Payment by payment card can be selected only for refund to a customer'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ХозяйственнаяОперация",,
			Отказ);
	КонецЕсли;
	
	// Организация-получатель должна быть взаимосвязана с организацией-отправителем по организационной структуре.
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств
		И ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(ОрганизацияПолучатель)
		И Не Справочники.Организации.ОрганизацииВзаимосвязаныПоОрганизационнойСтруктуре(
			Организация, ОрганизацияПолучатель) Тогда
		
		ТекстОшибки = НСтр("ru = 'Организация-получатель должна быть взаимосвязана с организацией-отправителем по организационной структуре.';
							|en = 'Receiving company should be connected with a shipping company by the organizational structure.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ОрганизацияПолучатель",,
			Отказ);
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику Тогда
		НепроверяемыеРеквизиты.Добавить("ДатаАвансовогоОтчета");
		Если Не ЗначениеЗаполнено(ДатаАвансовогоОтчета) Тогда
			ТекстОшибки = НСтр("ru = 'Поле ""Отчитаться"" не заполнено';
								|en = '""Report"" is required'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,,
				"ПериодАвансовогоОтчета",,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если РаспределениеПоСчетам.Итог("Сумма") > СуммаДокумента Тогда
		ТекстОшибки = НСтр("ru = 'Сумма распределения по счетам не может превышать сумму документа';
							|en = 'The amount of allocation by accounts cannot exceed the document amount'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"РаспределениеПоСчетам",,
			Отказ);
	КонецЕсли;
	
	Если ЖелательнаяДатаПлатежа < НачалоДня(Дата) Тогда
		Текст = НСтр("ru = 'Желательная дата платежа не может быть меньше даты документа';
					|en = 'Required payment date cannot be earlier than the document date'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"ЖелательнаяДатаПлатежа",,
			Отказ);
	КонецЕсли;
	
	Для каждого СтрокаРаспределения Из РаспределениеПоСчетам Цикл
		Если СтрокаРаспределения.ДатаПлатежа < НачалоДня(Дата) Тогда
			Текст = НСтр("ru = 'Дата платежа не может быть меньше даты документа';
						|en = 'Payment date cannot be earlier than the document date'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"РаспределениеПоСчетам[" + РаспределениеПоСчетам.Индекс(СтрокаРаспределения) + "].ДатаПлатежа",,
				Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Если Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.Согласована
		И Не ПраваПользователяПовтИсп.СогласованиеЗаявокНаРасходованиеДенежныхСредств() Тогда
		
		ТекстОшибки = НСтр("ru = 'У вас нет права согласования заявок на расходование денежных средств';
							|en = 'You are not authorized to approve payment requests'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,,,
			Отказ);
		
	ИначеЕсли Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.КОплате
		И Не ПраваПользователяПовтИсп.УтверждениеЗаявокНаРасходованиеДенежныхСредств() Тогда
		
		ТекстОшибки = НСтр("ru = 'У вас нет права утверждения к оплате заявок на расходование денежных средств';
							|en = 'You are not authorized to confirm payment requests'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,,,
			Отказ);
	КонецЕсли;
	
	Если Не (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику И СписокФизЛиц) Тогда
		ДенежныеСредстваСервер.ПроверитьЗаполнениеРасшифровкиПлатежа(ЭтотОбъект, СуммаДокумента, ХозяйственнаяОперация, Отказ);
	КонецЕсли;
	
	// Проверяем соответствие валюты заявки, валюты взаиморасчетов и валюты платежа
	Если ПланированиеСуммы = Перечисления.СпособыПланированияОплатыЗаявок.ВВалютеВзаиморасчетов
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПеречислениеВБюджет
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.КонвертацияВалюты
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВыплатаЗарплаты Тогда
		
		ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетовВТабличнойЧасти(Валюта, Дата, РасшифровкаПлатежа);
		ПроверитьСоответствиеВалютыВзаиморасчетов(Отказ);
	КонецЕсли;
	
	ВсеРеквизиты = Новый Массив;
	РеквизитыОперации = Новый Массив;
	
	Документы.ЗаявкаНаРасходованиеДенежныхСредств.ПолучитьМассивыРеквизитов(
		ХозяйственнаяОперация,
		ПеречислениеВБюджет,
		ВсеРеквизиты,
		РеквизитыОперации);
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		ВсеРеквизиты,
		РеквизитыОперации,
		НепроверяемыеРеквизиты);
		
	Если ФормаОплатыЗаявки <> Перечисления.ФормыОплаты.Безналичная Тогда
		НепроверяемыеРеквизиты.Добавить("БанковскийСчетКонтрагента");
	КонецЕсли;
	
	Если РеквизитыОперации.Найти("РасшифровкаПлатежа.СтатьяРасходов") <> Неопределено Тогда
		ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
			ЭтотОбъект, Новый Структура("РасшифровкаПлатежа"), НепроверяемыеРеквизиты, Отказ);
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.НеСогласована
		Или Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.Отклонена Тогда
		
		НепроверяемыеРеквизиты.Добавить("СтатьяДвиженияДенежныхСредств");
		НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств");
		НепроверяемыеРеквизиты.Добавить("Контрагент");
		НепроверяемыеРеквизиты.Добавить("БанковскийСчетКонтрагента");
		НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.Партнер");
		НепроверяемыеРеквизиты.Добавить("СтатьяАктивовПассивов");
		НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.СтатьяРасходов");
		НепроверяемыеРеквизиты.Добавить("ЛицевыеСчетаСотрудников.ЛицевойСчет");
		
		//++ НЕ УТ
		НепроверяемыеРеквизиты.Добавить("ТипПлатежаФЗ275");
		НепроверяемыеРеквизиты.Добавить("ПодтверждающиеДокументы.Файл");
		//-- НЕ УТ
	ИначеЕсли Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.Согласована Тогда
		НепроверяемыеРеквизиты.Добавить("БанковскийСчетКонтрагента");
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств Тогда
		
		Если ФормаОплатыЗаявки = Перечисления.ФормыОплаты.Наличная Тогда
			НепроверяемыеРеквизиты.Добавить("БанковскийСчетПолучатель");
		ИначеЕсли ФормаОплатыЗаявки = Перечисления.ФормыОплаты.Безналичная Тогда
			НепроверяемыеРеквизиты.Добавить("КассаПолучатель");
		Иначе
			НепроверяемыеРеквизиты.Добавить("БанковскийСчетПолучатель");
			НепроверяемыеРеквизиты.Добавить("КассаПолучатель");
		КонецЕсли;
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.КонвертацияВалюты Тогда
		НепроверяемыеРеквизиты.Добавить("БанковскийСчетПолучатель");
		НепроверяемыеРеквизиты.Добавить("КассаПолучатель");
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеВБюджет Тогда
		НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.СтатьяАктивовПассивов");
		НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.СтатьяРасходов");
		НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.АналитикаРасходов");
		Если Не ((ТипНалога = Перечисления.ТипыНалогов.НДФЛ ИЛИ ТипНалога = Перечисления.ТипыНалогов.НДФЛСПревышения) И НДФЛПоВедомостям) Тогда
			НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.Ведомость");
			НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.Подразделение");
		КонецЕсли;
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику Тогда
		Если СписокФизЛиц Тогда
			НепроверяемыеРеквизиты.Добавить("ПодотчетноеЛицо");
			НепроверяемыеРеквизиты.Добавить("БанковскийСчетКонтрагента");
			НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа");
			НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств");
			НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.Сумма");
		Иначе
			НепроверяемыеРеквизиты.Добавить("СтатьяДвиженияДенежныхСредств");
			НепроверяемыеРеквизиты.Добавить("ЛицевыеСчетаСотрудников");
			НепроверяемыеРеквизиты.Добавить("ЛицевыеСчетаСотрудников.ФизическоеЛицо");
			НепроверяемыеРеквизиты.Добавить("ЛицевыеСчетаСотрудников.ЛицевойСчет");
			НепроверяемыеРеквизиты.Добавить("ЛицевыеСчетаСотрудников.Сумма");
		КонецЕсли;
		Если ФормаОплатыЗаявки = Перечисления.ФормыОплаты.Наличная Тогда
			НепроверяемыеРеквизиты.Добавить("ЛицевыеСчетаСотрудников.ЛицевойСчет");
		КонецЕсли;
	КонецЕсли;
	
	ДенежныеСредстваСервер.ДобавитьНепроверяемыеРеквизитыПоВыплатеЗаработнойПлаты(
		ЭтотОбъект, НепроверяемыеРеквизиты, ХозяйственнаяОперацияПоЗарплате);
		
	//++ НЕ УТ
	Если ПлатежиПо275ФЗ Тогда
		
		Если ДоговорСУчастникомГОЗ И ЗначениеЗаполнено(БанковскийСчетКонтрагента) Тогда
			ОтдельныйСчетГОЗ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчетКонтрагента, "ОтдельныйСчетГОЗ");
			Если Не ОтдельныйСчетГОЗ Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Должен быть выбран отдельный банковский счет ГОЗ';
						|en = 'Separate SDO bank account must be selected'"),
					ЭтотОбъект,
					"БанковскийСчетКонтрагента",,
					Отказ);
			КонецЕсли;
		КонецЕсли;
		
		ДенежныеСредстваСервер.ОбработкаПроверкиЗаполненияПодтверждающиеДокументы(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, Ошибки);
		ДенежныеСредстваСервер.ПроверитьЗаполнениеРеквизитовПлатежаГОЗ(ЭтотОбъект, Отказ);
		ПроверитьЗаполнениеДоговоровГОЗ(Отказ, РасшифровкаБезРазбиения);
		ПроверитьЗаполнениеТипаСуммыКредитаДепозита(Отказ, РасшифровкаБезРазбиения);
	Иначе
	//-- НЕ УТ
		НепроверяемыеРеквизиты.Добавить("ПодтверждающиеДокументы");
		НепроверяемыеРеквизиты.Добавить("ДоговорСУчастникомГОЗ");
		НепроверяемыеРеквизиты.Добавить("ТипПлатежаФЗ275");
		НепроверяемыеРеквизиты.Добавить("ПредметОплаты");
		НепроверяемыеРеквизиты.Добавить("ВариантОплаты");
	//++ НЕ УТ
	КонецЕсли;
	//-- НЕ УТ
	
	РеквизитыПлатежаВБюджет = Новый Массив;
	РеквизитыПлатежаВБюджет.Добавить("ВидПеречисленияВБюджет");
	РеквизитыПлатежаВБюджет.Добавить("ПеречислениеВБюджет");
	РеквизитыПлатежаВБюджет.Добавить("КодБК");
	РеквизитыПлатежаВБюджет.Добавить("КодОКАТО");
	РеквизитыПлатежаВБюджет.Добавить("ПоказательДаты");
	РеквизитыПлатежаВБюджет.Добавить("ПоказательНомера");
	РеквизитыПлатежаВБюджет.Добавить("ПоказательОснования");
	РеквизитыПлатежаВБюджет.Добавить("ПоказательПериода");
	РеквизитыПлатежаВБюджет.Добавить("СтатусСоставителя");
	
	РеквизитыДокумента = Метаданные().Реквизиты;
	
	ДатаНачалаПримененияПриказа126н = Константы.ДатаНачалаПримененияПриказа126н.Получить();
	Если ДатаНачалаПримененияПриказа126н <> '00010101' И Дата >= ДатаНачалаПримененияПриказа126н Тогда
		НепроверяемыеРеквизиты.Добавить("ПоказательТипа");
	Иначе
		РеквизитыПлатежаВБюджет.Добавить("ПоказательТипа");
	КонецЕсли;
	
	Для каждого РеквизитПлатежаВБюджет Из РеквизитыПлатежаВБюджет Цикл
		НепроверяемыеРеквизиты.Добавить(РеквизитПлатежаВБюджет);
		Если ПеречислениеВБюджет Тогда
			Если Не ЗначениеЗаполнено(ЭтотОбъект[РеквизитПлатежаВБюджет]) Тогда
				Реквизит = РеквизитыДокумента.Найти(РеквизитПлатежаВБюджет);
				ТекстОшибки = СтрШаблон(НСтр("ru = 'Поле ""%1"" не заполнено';
											|en = 'Field ""%1"" is blank'"), Реквизит.Синоним);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "НадписьРеквизитыПлатежаВБюджет",, Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ПеречислениеВБюджет Тогда
		ДенежныеСредстваСервер.ПроверитьЗаполнениеНалоговыхРеквизитов(ЭтотОбъект, Отказ, НепроверяемыеРеквизиты);
		ДенежныеСредстваСервер.ПроверитьИННиКППНаСоответствие148н(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеВБюджет
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов") Тогда
		НепроверяемыеРеквизиты.Добавить("РасшифровкаПлатежа.СтатьяРасходов");
	КонецЕсли;
	
	ДенежныеСредстваСервер.ПроверитьЗаполнениеПартнера(
		ЭтотОбъект, ХозяйственнаяОперация, НепроверяемыеРеквизиты, РасшифровкаБезРазбиения, Отказ);
	
	Если ЗначениеЗаполнено(НаправлениеДеятельности)
		Или Не НаправленияДеятельностиСервер.УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Тогда
		НепроверяемыеРеквизиты.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ДенежныеСредстваСервер.ПроверитьБанковскийСчетПолучатель(ЭтотОбъект, Отказ);
	ДенежныеСредстваСервер.ПроверитьВалютуКонвертации(ЭтотОбъект, Отказ);
	ПроверитьНаличиеОплатыЗаявки(Отказ);
	
	//++ НЕ УТ
	ПроверитьВедомостиНаВыплатуЗарплаты(Отказ);
	//-- НЕ УТ
	
	Если РасшифровкаБезРазбиения Тогда
		ДенежныеСредстваСервер.ПроверитьЗаполнениеРасшифровкиБезРазбиения(
			ЭтотОбъект, ПроверяемыеРеквизиты, "РасшифровкаПлатежа", "РасшифровкаБезРазбиения", Отказ);
	КонецЕсли;
		
#Вставка
	//begin fix Клещ А.Н. 02.02.2019  
	Если СтрДлина(СокрЛП(НазначениеПлатежа)) > 210 Тогда
		КоличествоСимволов = СтрДлина(СокрЛП(НазначениеПлатежа))-210;
		Текст = НСтр("Назначение платежа не должно превышать длину 210 символов, сократите строку на "+КоличествоСимволов+" символа(ов)");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			"ЖелательнаяДатаПлатежа",
			,
			Отказ);
	КонецЕсли;
	//end fix Клещ А.Н. 02.02.2019
#КонецВставки
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
КонецПроцедуры

&После("ОбработкаЗаполнения")
Процедура ВИЛС_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ОчиститьРеквизитыВИЛС();
КонецПроцедуры

&После("ПриКопировании")
Процедура ВИЛС_ПриКопировании(ОбъектКопирования)
	ОчиститьРеквизитыВИЛС();
КонецПроцедуры

Процедура ОчиститьРеквизитыВИЛС()
	КтоРешил = Неопределено;
	ВИЛС_Исполнитель = Неопределено;
	ВИЛС_КазначейскийКонтрольПройден = Ложь;
	ВИЛС_КурсНаДатуОтгрузки = Ложь;
	ВИЛС_КурсНаДату = '00010101000000';
КонецПроцедуры

//&После("ПередЗаписью")
//Процедура ВИЛС_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
//	Если ПометкаУдаления = Истина
//		и Не РольДоступна("АдминистраторСистемы") 
//		и (ЗначениеЗаполнено(ВИЛС_Исполнитель)
//			или ВИЛС_КазначейскийКонтрольПройден) Тогда
//	
//		Отказ = Истина;
//	КонецЕсли; 
//КонецПроцедуры

&ИзменениеИКонтроль("ПередЗаписью")
Процедура ВИЛС_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	Если РежимЗаписи = РежимЗаписиДокумента.Проведение
		И (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоставщику
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеТаможне
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоКредитам
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеНаДепозиты
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаЗаймов
		//++ НЕ УТ
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаЛизингодателю
		//-- НЕ УТ
		)
		Тогда
		ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетовВТабличнойЧасти(Валюта, Дата, РасшифровкаПлатежа);
		ДенежныеСредстваСервер.ЗаполнитьОрганизациюВТабличнойЧасти(РасшифровкаПлатежа, Организация, ХозяйственнаяОперация);
	КонецЕсли;

	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.ЗаявкаНаРасходованиеДенежныхСредств.ПолучитьМассивыРеквизитов(
	ХозяйственнаяОперация,
	ПеречислениеВБюджет,
	МассивВсехРеквизитов,
	МассивРеквизитовОперации);

	НеиспользуемыеРеквизиты = Новый Массив;

	Если ХозяйственнаяОперацияПоЗарплате = Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета
		Или ХозяйственнаяОперацияПоЗарплате = Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыЧерезКассу Тогда

		НеиспользуемыеРеквизиты.Добавить("Контрагент");
		Если ЛицевыеСчетаСотрудников.Количество() <> 1 Тогда
			НеиспользуемыеРеквизиты.Добавить("БанковскийСчетКонтрагента");
		КонецЕсли;

	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаЗаймаСотруднику
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплатыУТ") Тогда

		РасшифровкаПлатежа.Очистить();
	КонецЕсли;

	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПеречислениеВБюджет
		Или ТипНалога <> Перечисления.ТипыНалогов.НДФЛ Тогда
		НеиспользуемыеРеквизиты.Добавить("НДФЛПоВедомостям");
	КонецЕсли;

	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику Тогда
		Если СписокФизЛиц Тогда
			НеиспользуемыеРеквизиты.Добавить("ПодотчетноеЛицо");
			НеиспользуемыеРеквизиты.Добавить("БанковскийСчетКонтрагента");
			РасшифровкаПлатежа.Очистить();
		КонецЕсли;
	Иначе
		НеиспользуемыеРеквизиты.Добавить("СписокФизЛиц");
	КонецЕсли;

	Для каждого НеиспользуемыйРеквизит Из НеиспользуемыеРеквизиты Цикл
		УдаляемыйРеквизит = МассивРеквизитовОперации.Найти(НеиспользуемыйРеквизит);
		Если УдаляемыйРеквизит <> Неопределено Тогда
			МассивРеквизитовОперации.Удалить(УдаляемыйРеквизит);
		КонецЕсли;
	КонецЦикла;

	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
	ЭтотОбъект,
	МассивВсехРеквизитов,
	МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизитыФормыОплаты(ЭтотОбъект, ФормаОплатыЗаявки, Истина);

	//++ НЕ УТ
	Если Не ПлатежиПо275ФЗ Тогда
		ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизитыОплатыЗаСчетСредствГОЗ(ЭтотОбъект);
	КонецЕсли;
	//-- НЕ УТ

#Удаление
	Если Не (ФормаОплатыБезналичная
		И ХозяйственнаяОперацияПоЗарплате = Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ЮрФизЛицо") = Перечисления.ЮрФизЛицо.ФизЛицо) Тогда
		КодВидаДохода = "";
	КонецЕсли;

#КонецУдаления
#Вставка
	Если Не (ФормаОплатыБезналичная
		И ХозяйственнаяОперацияПоЗарплате = Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыПоЗарплатномуПроекту
		Или ХозяйственнаяОперацияПоЗарплате = Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ЮрФизЛицо") = Перечисления.ЮрФизЛицо.ФизЛицо) Тогда
		КодВидаДохода = "";
	КонецЕсли;

#КонецВставки
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыплатаЗарплаты) И
		СтатьяАктивовПассивов <> ПланыВидовХарактеристик.СтатьиАктивовПассивов.ОплатаТруда Тогда
		СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ПустаяСсылка();
		АналитикаАктивовПассивов = Неопределено;
	КонецЕсли;

	//++ НЕ УТ
	Если ДоговорСУчастникомГОЗ И Не ПеречислениеВБюджет И РасшифровкаПлатежа.Количество() Тогда
		Заказ = РасшифровкаПлатежа[0].Заказ;
		Если ЗначениеЗаполнено(Заказ) Тогда
			Если ТипЗнч(Заказ) = Тип("СправочникСсылка.ДоговорыКонтрагентов")
				Или ТипЗнч(Заказ) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
				ИдентификаторПлатежа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заказ, "ГосударственныйКонтракт.Код");
			Иначе
				ИдентификаторПлатежа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заказ, "Договор.ГосударственныйКонтракт.Код");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТ

	Если ЛицевыеСчетаСотрудников.Количество() = 1
		И (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыплатаЗарплаты
		И ХозяйственнаяОперацияПоЗарплате = Перечисления.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику
		И СписокФизЛиц) Тогда
		БанковскийСчетКонтрагента = ЛицевыеСчетаСотрудников[0].ЛицевойСчет;
	КонецЕсли;

	ДоходыИРасходыСервер.ИнициализироватьПустоеЗначениеСтатьиВТЧ(РасшифровкаПлатежа, "СтатьяРасходов");

	Если РаспределениеПоСчетам.Количество() Тогда
		ДатыПлатежей = РаспределениеПоСчетам.Выгрузить(,"ДатаПлатежа");
		ДатыПлатежей.Сортировать("ДатаПлатежа");
		ДатаПлатежа = ДатыПлатежей[0].ДатаПлатежа;
	Иначе
		ДатаПлатежа = ЖелательнаяДатаПлатежа;
	КонецЕсли;

	МассивСтатейДДС = ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(
	РасшифровкаПлатежа.ВыгрузитьКолонку("СтатьяДвиженияДенежныхСредств"));
	Если МассивСтатейДДС.Количество() = 1 Тогда
		СтатьяДвиженияДенежныхСредств = МассивСтатейДДС[0];
	ИначеЕсли МассивСтатейДДС.Количество() > 1 Тогда
		СтатьяДвиженияДенежныхСредств = Неопределено;
	КонецЕсли;

	ТаблицаРаспределения = РаспределениеПоСчетам.Выгрузить();
	ТаблицаРаспределения.Свернуть("БанковскийСчетКасса, ДатаПлатежа", "Сумма");
	РаспределениеПоСчетам.Загрузить(ТаблицаРаспределения);
	РаспределениеПоСчетам.Сортировать("ДатаПлатежа");

#Вставка
	// begin fix Suetin 28.07.2020 15:06:22
	ЗаписьРазрешена = True;
	If ДополнительныеСвойства.ЭтоНовый Then	//ValueIsFilled(Ссылка)
	ElsIf ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись
		and not Ссылка.Проведен Then
	ElsIf Модифицированность() //и ВИЛС_КазначейскийКонтрольПройден
		and not РольДоступна("АдминистраторСистемы") Then
		УстановитьПривилегированныйРежим(Истина);
		АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
		Прокси = ИнтеграцияС1СДокументооборот.ПолучитьПрокси(,"Администратор","laplandia",Ложь);
		//ДокументСуществует = ВИЛС_Переопределяемый.ПроверитьДокумент(ЭтотОбъект.Ссылка, Прокси);
		//If ДокументСуществует Then
			ЗаписьРазрешена = False;
			If АвторизованныйПользователь = ЭтотОбъект.Ссылка.КтоЗаявил Then
				ЗаписьРазрешена = True;	
			EndIf;
			ValueTable = ВИЛС_Переопределяемый.ВернутьТаблицуСогласований(ЭтотОбъект.Ссылка,Прокси);
			If not ValueTable = Undefined  Then
				For each Value in ValueTable Do
					If ValueIsFilled(Value.result_presentation) Then
						ЗаписьРазрешена = False;
					EndIf;
					If not Value.reviewer_users.Find(АвторизованныйПользователь) = Undefined Then
						ЗаписьРазрешена = True;
					//Else
					//	ЗаписьРазрешена = False;
				    EndIf;
				EndDo; 
			EndIf;
			//Предыдуший = ВИЛС_Переопределяемый.ВернутьПредыдущегоПользователя(Ссылка,Прокси);
			//Следующий = ВИЛС_Переопределяемый.ВернутьСледующегоПользователя(Ссылка,Прокси);
			//Если ТипЗнч(Предыдуший) = Тип("СправочникСсылка.Пользователи")
			//	и АвторизованныйПользователь = Предыдуший
			//	//и ПометкаУдаления
			//	//и Не Ссылка.ПометкаУдаления 
			//									Тогда
			//	ЗаписьРазрешена = Истина;
			//ИначеЕсли ТипЗнч(Следующий) = Тип("СправочникСсылка.Пользователи")
			//	и АвторизованныйПользователь = Следующий
			//	//и ПометкаУдаления
			//	//и Не Ссылка.ПометкаУдаления 
			//									Тогда
			//	ЗаписьРазрешена = Истина;
			//Иначе
			//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Вы не Исполнитель документа.
			//		| Запись не разрешена");
			////ИначеЕсли Не ВИЛС_КазначейскийКонтрольПройден
			////	и Не РольДоступна("АдминистраторСистемы") Тогда
			////	ЗаписьРазрешена = Истина;
			////	Если ЗначениеЗаполнено(Ссылка) Тогда
			////		УстановитьПривилегированныйРежим(Истина);
			////
			////		ЗаписьРазрешена = Ложь;
			////		Прокси = ИнтеграцияС1СДокументооборот.ПолучитьПрокси(,"Администратор","laplandia",Ложь);
			////		ДокументСуществует = ВИЛС_Переопределяемый.ПроверитьДокумент(Ссылка, Прокси);
			////		Если ДокументСуществует Тогда
			////			Параметр 	= ВИЛС_Переопределяемый.УстановитьСтатусДокумента(Ссылка, Прокси);
			////			Предыдуший 	= Параметр.КтоРешил;
			////			Следующий 	= Параметр.Исполнитель;
			////			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Предыдуший " + Предыдуший);
			////			Если ТипЗнч(Предыдуший) = Тип("СправочникСсылка.Пользователи")
			////				и Предыдуший = АвторизованныйПользователь Тогда
			////				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Предыдуший = АвторизованныйПользователь
			////					| Запись разрешена");
			////				ЗаписьРазрешена = Истина;
			////			КонецЕсли; 
			////			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Следующий " + Следующий);
			////			Если ТипЗнч(Следующий) = Тип("СправочникСсылка.Пользователи")
			////				и Следующий = АвторизованныйПользователь Тогда
			////				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Следующий = АвторизованныйПользователь
			////					| Запись разрешена");
			////				ЗаписьРазрешена = Истина;
			////			ИначеЕсли ТипЗнч(Следующий) = Тип("Строка") Тогда
			////				
			////			КонецЕсли;
			////		Иначе
			////			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Согласование не запущено, изменять заявку можно
			////					| Запись разрешена");
			////			ЗаписьРазрешена = Истина;
			////		КонецЕсли;
			////	КонецЕсли;    
			//КонецЕсли;
			
		//Иначе
			//ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Согласование не запущено, изменять заявку можно
			//		| Запись разрешена");
			//ЗаписьРазрешена = Истина;
		//КонецЕсли; 
		
		Если Не ЗаписьРазрешена Тогда
			Отказ = Истина;
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	// end fix Suetin 28.07.2020 15:06:30
	//Если ПометкаУдаления = Истина
	//	и Не РольДоступна("АдминистраторСистемы") 
	//	и (ЗначениеЗаполнено(ВИЛС_Исполнитель)
	//		или ВИЛС_КазначейскийКонтрольПройден) Тогда
	//
	//	Отказ = Истина;
	//КонецЕсли; 
#КонецВставки
КонецПроцедуры

#КонецЕсли
//&После("ПередЗаписью")
//Процедура ВИЛС_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
//	Если ПометкаУдаления = Истина
//		и Не РольДоступна("АдминистраторСистемы") 
//		и (ЗначениеЗаполнено(ВИЛС_Исполнитель)
//			или ВИЛС_КазначейскийКонтрольПройден) Тогда
//	
//		Отказ = Истина;
//	КонецЕсли; 
//КонецПроцедуры

