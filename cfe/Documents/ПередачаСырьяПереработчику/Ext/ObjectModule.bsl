#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Прочее

&Вместо("ВременныеТаблицыДанныхДокумента")
Функция ВИЛС_ВременныеТаблицыДанныхДокумента()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	&Дата                                                     КАК Дата,
	|	&Организация                                              КАК Организация,
	|	Неопределено                                              КАК Партнер,
	|	Неопределено                                              КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)    КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)                  КАК Валюта,
	|	&ХозяйственнаяОперация                                    КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО                                              КАК НалогообложениеНДС,
	|	ЛОЖЬ                                                      КАК ЕстьСделкиВТабличнойЧасти,
	|
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|			И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам ТОГДА
	|		&Подразделение
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ                                                     КАК Подразделение,
	|
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|			И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам ТОГДА
	|		&Менеджер
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	КОНЕЦ                                                     КАК Менеджер,
	|
	|	ВЫБОР КОГДА СделкиСКлиентами.ОбособленныйУчетТоваровПоСделке
	|			И &ФормироватьВидыЗапасовПоСделкам ТОГДА
	|		&Сделка
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка)
	|	КОНЕЦ                                                     КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)                  КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|	ПО
	|		СтруктураПредприятия.Ссылка = &Подразделение
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.СделкиСКлиентами КАК СделкиСКлиентами
	|	ПО
	|		СделкиСКлиентами.Ссылка = &Сделка
	|
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки                    КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура                   КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика                 КАК Характеристика,
	|	ТаблицаТоваров.Серия                          КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий            КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Назначение				  	  КАК Назначение,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры     КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество                     КАК Количество,
	|	ТаблицаТоваров.ВИЛС_КоличествоШТ 			  КАК ВИЛС_КоличествоШТ,  // fix Suetin 30.01.2019 14:15:46
	|	ТаблицаТоваров.Склад                          КАК Склад,
	|	ТаблицаТоваров.ЗаказПереработчику             КАК ЗаказПереработчику,
	|	ТаблицаТоваров.КодСтроки                      КАК КодСтроки,
	|	ТаблицаТоваров.Сумма                          КАК Сумма,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0                                             КАК СуммаСНДС,
	|	0                                             КАК СуммаНДС,
	|	0                                             КАК СуммаВознаграждения,
	|	0                                             КАК СуммаНДСВознаграждения,
	|	&Сделка                                       КАК Сделка,
	|	ИСТИНА                                        КАК ПодбиратьВидыЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)   КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки                 КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов                  КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД                    КАК НомерГТД,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)       КАК СкладОтгрузки,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка)  КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.ЗаказПереработчику          КАК ЗаказПереработчику,
	|	ТаблицаВидыЗапасов.ЗалоговаяСтоимость          КАК ЗалоговаяСтоимость,
	|	ТаблицаВидыЗапасов.КодСтроки                   КАК КодСтроки,
	|	&Сделка                                        КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество                  КАК Количество,
	|	ТаблицаВидыЗапасов.ВИЛС_КоличествоШТ 		   КАК ВИЛС_КоличествоШТ,  // fix Suetin 30.01.2019 14:15:46
	|	&ВидыЗапасовУказаныВручную                     КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВТВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Аналитика.Номенклатура							КАК Номенклатура,
	|	Аналитика.Характеристика						КАК Характеристика,
	|	Аналитика.Серия									КАК Серия,
	|	Аналитика.МестоХранения							КАК Склад,
	|	ТаблицаВидыЗапасов.НомерСтроки					КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов					КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД						КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС					КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СкладОтгрузки				КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.ЗаказПереработчику			КАК ЗаказПереработчику,
	|	ТаблицаВидыЗапасов.ЗалоговаяСтоимость			КАК ЗалоговаяСтоимость,
	|	ТаблицаВидыЗапасов.КодСтроки					КАК КодСтроки,
	|	ТаблицаВидыЗапасов.Сделка						КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество					КАК Количество,
	|	ТаблицаВидыЗапасов.ВИЛС_КоличествоШТ 			КАК ВИЛС_КоличествоШТ,  // fix Suetin 30.01.2019 14:15:46
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную	КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВТВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Склад
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТВидыЗапасов
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка",                          Ссылка);
	Запрос.УстановитьПараметр("Дата",                            Дата);
	Запрос.УстановитьПараметр("Организация",                     Организация);
	Запрос.УстановитьПараметр("Менеджер",                        Менеджер);
	Запрос.УстановитьПараметр("Подразделение",                   Подразделение);
	Запрос.УстановитьПараметр("Сделка",                          Сделка);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация",           ХозяйственнаяОперация);
	Запрос.УстановитьПараметр("ПередачаПоЗаказам",               ПередачаПоЗаказам);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную",       ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоСделкам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоСделкам"));
	Запрос.УстановитьПараметр("РеализацияПоНесколькимЗаказам",   ПередачаПоЗаказам И Не ЗначениеЗаполнено(ЗаказПереработчику));
	Запрос.УстановитьПараметр("ТаблицаТоваров",                  Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов",              ВидыЗапасов);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

&Вместо("ЗаполнитьСтрокуВидовЗапасов")
Процедура ВИЛС_ЗаполнитьСтрокуВидовЗапасов(СтрокаТоваров, СтруктураПоиска, Ресурсы)
	
	Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл
		
		Если СтрокаЗапасов.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		КоличествоПоСтроке = Мин(Ресурсы.КоличествоТоваровПоСтроке, СтрокаЗапасов.Количество);
		ВИЛС_КоличествоШТПоСтроке = Цел(Ресурсы.ВИЛС_КоличествоШТПоСтроке * Ресурсы.КоличествоТоваровПоСтроке / КоличествоПоСтроке);     // fix Suetin 29.01.2019 17:37:13
		НоваяСтрока = ВидыЗапасов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
		
		НоваяСтрока.Упаковка            = СтрокаТоваров.Упаковка;
		НоваяСтрока.ЗаказПереработчику  = СтрокаТоваров.ЗаказПереработчику;
		НоваяСтрока.КодСтроки           = СтрокаТоваров.КодСтроки;
		НоваяСтрока.Количество          = КоличествоПоСтроке;
		НоваяСтрока.ВИЛС_КоличествоШТ 	= ВИЛС_КоличествоШТПоСтроке;      // fix Suetin 29.01.2019 17:38:13
		Если Ресурсы.КоличествоТоваровПоСтроке = 0 Тогда
			НоваяСтрока.КоличествоУпаковок = 0;
		Иначе
			НоваяСтрока.КоличествоУпаковок = Ресурсы.КоличествоУпаковокПоСтроке * КоличествоПоСтроке / Ресурсы.КоличествоТоваровПоСтроке;
		КонецЕсли;
		Если КоличествоПоСтроке = Ресурсы.КоличествоТоваровПоСтроке Тогда
			НоваяСтрока.ЗалоговаяСтоимость = Ресурсы.СуммаПоСтроке;
		Иначе
			НоваяСтрока.ЗалоговаяСтоимость = Ресурсы.СуммаПоСтроке * КоличествоПоСтроке / Ресурсы.КоличествоТоваровПоСтроке;
		КонецЕсли;
		
		Ресурсы.КоличествоТоваровПоСтроке  = Ресурсы.КоличествоТоваровПоСтроке  - НоваяСтрока.Количество;
		Ресурсы.КоличествоУпаковокПоСтроке = Ресурсы.КоличествоУпаковокПоСтроке - НоваяСтрока.КоличествоУпаковок;
		Ресурсы.СуммаПоСтроке              = Ресурсы.СуммаПоСтроке              - НоваяСтрока.ЗалоговаяСтоимость;
		Ресурсы.ВИЛС_КоличествоШТПоСтроке  = Ресурсы.ВИЛС_КоличествоШТПоСтроке  - НоваяСтрока.ВИЛС_КоличествоШТ;      // fix Suetin 30.01.2019 12:53:41
		СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
		СтрокаЗапасов.ВИЛС_КоличествоШТ	= СтрокаЗапасов.ВИЛС_КоличествоШТ - НоваяСтрока.ВИЛС_КоличествоШТ;    // fix Suetin 29.01.2019 17:38:39
		Если Ресурсы.КоличествоТоваровПоСтроке = 0 Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&Вместо("ЗаполнитьДопКолонкиВидовЗапасов")
Процедура ВИЛС_ЗаполнитьДопКолонкиВидовЗапасов()
	
	КолонкиГруппировок = "АналитикаУчетаНоменклатуры, Упаковка, ЗаказПереработчику, КодСтроки";
	КолонкиСуммирования = "Количество, КоличествоУпаковок, Сумма, ВИЛС_КоличествоШТ";     // fix Suetin 30.01.2019 12:51:03
	
	ТаблицаТовары = Товары.Выгрузить(, КолонкиГруппировок + ", " + КолонкиСуммирования);
	ТаблицаТовары.Свернуть(КолонкиГруппировок, КолонкиСуммирования);
	
	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры");
	
	Для Каждого СтрокаТоваров Из ТаблицаТовары Цикл
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("КоличествоТоваровПоСтроке",  СтрокаТоваров.Количество);
		Ресурсы.Вставить("КоличествоУпаковокПоСтроке", СтрокаТоваров.КоличествоУпаковок);
		Ресурсы.Вставить("СуммаПоСтроке",              СтрокаТоваров.Сумма);
		Ресурсы.Вставить("ВИЛС_КоличествоШТПоСтроке",  СтрокаТоваров.ВИЛС_КоличествоШТ);           // fix Suetin 30.01.2019 12:52:03
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		ЗаполнитьСтрокуВидовЗапасов(СтрокаТоваров, СтруктураПоиска, Ресурсы);
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

&Вместо("ЗаполнитьВидыЗапасов")
Процедура ВИЛС_ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц  = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
	 Или ПерезаполнитьВидыЗапасов
	 Или ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	 Или ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
		
		ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
		ПараметрыЗаполнения.ПодбиратьВТЧТоварыПринятыеНаОтветственноеХранение = "Никогда";
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект, МенеджерВременныхТаблиц, Отказ, ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, Склад", "Количество, ВИЛС_КоличествоШТ");  // fix Suetin 30.01.2019 12:42:43     ВИЛС_КоличествоШТ
		ЗаполнитьДопКолонкиВидовЗапасов();
		
		ЗаполнитьВидЗапасовПолучателя();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ВидыЗапасов

&Вместо("ПроверитьИзменениеТоваров")
Функция ВИЛС_ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТоваров.Склад                       КАК Склад,
	|		ТаблицаТоваров.ЗаказПереработчику          КАК ЗаказПереработчику,
	|		ТаблицаТоваров.КодСтроки                   КАК КодСтроки,
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.Количество                  КАК Количество,
	|		ТаблицаТоваров.ВИЛС_КоличествоШТ		   КАК ВИЛС_КоличествоШТ,    // fix Suetin 29.01.2019 19:44:50
	|		ТаблицаТоваров.Сумма                       КАК Сумма
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.Склад                       КАК Склад,
	|		ТаблицаВидыЗапасов.ЗаказПереработчику          КАК ЗаказПереработчику,
	|		ТаблицаВидыЗапасов.КодСтроки                   КАК КодСтроки,
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|		-ТаблицаВидыЗапасов.Количество                 КАК Количество,
	|		-ТаблицаВидыЗапасов.ВИЛС_КоличествоШТ 		   КАК ВИЛС_КоличествоШТ,    // fix Suetin 29.01.2019 19:44:50
	|		-ТаблицаВидыЗапасов.ЗалоговаяСтоимость         КАК Сумма
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.Склад,
	|	ТаблицаТоваров.ЗаказПереработчику,
	|	ТаблицаТоваров.КодСтроки,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|
	|ИМЕЮЩИЕ
	|	(СУММА(Количество) <> 0) ИЛИ (СУММА(Сумма) <> 0) ИЛИ СУММА(ТаблицаТоваров.ВИЛС_КоличествоШТ) <> 0");  // fix Suetin 29.01.2019 19:45:38
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Результат = Запрос.Выполнить();
	Возврат Не Результат.Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли
