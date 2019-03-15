﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

&Вместо("ДанныеДляПечатныхФормСчетаНаОплатуИзвещения")
Функция ВИЛС_ДанныеДляПечатныхФормСчетаНаОплатуИзвещения(ПараметрыПечати, МассивОбъектов)
	
	Если ПараметрыПечати <> Неопределено И ПараметрыПечати.Свойство("ОтображатьСкидки") Тогда
		ОтображатьСкидки = ПараметрыПечати.ОтображатьСкидки;
	Иначе
		ОтображатьСкидки = (Константы.ОтображениеСкидокВПечатныхФормахДокументовПродажи.Получить()
			<> Перечисления.ВариантыВыводаСкидокВПечатныхФормах.НеВыводитьСкидки);
	КонецЕсли; 
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Документы.Ссылка КАК Ссылка,
	|	Документы.Номер КАК Номер,
	|	Документы.Дата КАК Дата,
	|	НЕОПРЕДЕЛЕНО КАК ДокументОснование,
	|	ЕСТЬNULL(Документы.БанковскийСчет.Владелец, Документы.Организация) КАК Организация,
	|	Документы.Организация КАК ОрганизацияПоставщик,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	ВЫБОР
	|		КОГДА Документы.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС)
	|				ИЛИ Документы.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК УчитыватьНДС,
	|	Документы.Контрагент КАК Контрагент,
	|	Документы.Договор КАК Договор,
	|	Документы.Контрагент.ЮрФизЛицо КАК КонтрагентЮрФизЛицо, 
	|	Документы.БанковскийСчет КАК БанковскийСчет,
	|	
	|	ВЫБОР КОГДА Документы.БанковскийСчет.ИностранныйБанк
	|		ИЛИ Документы.БанковскийСчет.ВалютаДенежныхСредств <> Константы.ВалютаРегламентированногоУчета
	|		ИЛИ Документы.БанковскийСчетКонтрагента.ИностранныйБанк ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ПлатежЗаРубеж,
	|	Документы.БанковскийСчет.ВалютаДенежныхСредств КАК ВалютаДенежныхСредств,
	|	Документы.БанковскийСчет.СВИФТБанка КАК СВИФТБанка,
	|	Документы.БанковскийСчет.СВИФТБанкаДляРасчетов КАК СВИФТБанкаДляРасчетов,
	|	Документы.БанковскийСчет.АдресБанка КАК АдресБанка,
	|	Документы.БанковскийСчет.АдресБанкаДляРасчетов КАК АдресБанкаДляРасчетов,
	|	Документы.БанковскийСчет.СчетВБанкеДляРасчетов КАК СчетВБанкеДляРасчетов,
	|	
	|	Документы.БанковскийСчет.НомерСчета КАК НомерБанковскогоСчета,
	|	ВЫБОР
	|		КОГДА Документы.БанковскийСчет.РучноеИзменениеРеквизитовБанка
	|			ТОГДА Документы.БанковскийСчет.БИКБанка
	|		ИНАЧЕ КлассификаторБанков.Код
	|	КОНЕЦ КАК БИКБанк,
	|	ВЫБОР
	|		КОГДА Документы.БанковскийСчет.РучноеИзменениеРеквизитовБанка
	|			ТОГДА Документы.БанковскийСчет.НаименованиеБанка
	|		ИНАЧЕ КлассификаторБанков.Наименование
	|	КОНЕЦ КАК НаименованиеБанка,
	|	ВЫБОР
	|		КОГДА Документы.БанковскийСчет.РучноеИзменениеРеквизитовБанка
	|			ТОГДА Документы.БанковскийСчет.КоррСчетБанка
	|		ИНАЧЕ КлассификаторБанков.КоррСчет
	|	КОНЕЦ КАК КоррСчетБанка,
	|	ВЫБОР
	|		КОГДА Документы.БанковскийСчет.РучноеИзменениеРеквизитовБанка
	|			ТОГДА Документы.БанковскийСчет.ГородБанка
	|		ИНАЧЕ КлассификаторБанков.Город
	|	КОНЕЦ КАК ГородБанка,
	|	ВЫБОР
	|		КОГДА Документы.БанковскийСчет.РучноеИзменениеРеквизитовБанкаДляРасчетов
	|			ТОГДА Документы.БанковскийСчет.БИКБанкаДляРасчетов
	|		ИНАЧЕ КлассификаторБанковКорреспондентовРФ.Код
	|	КОНЕЦ КАК БИКБанкаДляРасчетов,
	|	ВЫБОР
	|		КОГДА Документы.БанковскийСчет.РучноеИзменениеРеквизитовБанкаДляРасчетов
	|			ТОГДА Документы.БанковскийСчет.НаименованиеБанкаДляРасчетов
	|		ИНАЧЕ КлассификаторБанковКорреспондентовРФ.Наименование
	|	КОНЕЦ КАК НаименованиеБанкаДляРасчетов,
	|	ВЫБОР
	|		КОГДА Документы.БанковскийСчет.РучноеИзменениеРеквизитовБанкаДляРасчетов
	|			ТОГДА Документы.БанковскийСчет.КоррСчетБанкаДляРасчетов
	|		ИНАЧЕ КлассификаторБанковКорреспондентовРФ.КоррСчет
	|	КОНЕЦ КАК КоррСчетБанкаДляРасчетов,
	|	ВЫБОР
	|		КОГДА Документы.БанковскийСчет.РучноеИзменениеРеквизитовБанкаДляРасчетов
	|			ТОГДА Документы.БанковскийСчет.ГородБанкаДляРасчетов
	|		ИНАЧЕ КлассификаторБанковКорреспондентовРФ.Город
	|	КОНЕЦ КАК ГородБанкаДляРасчетов,
 	|	Документы.БанковскийСчет.ТекстКорреспондента КАК БанковскийСчетТекстКорреспондента,
	|	Документы.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	Документы.Валюта КАК Валюта,
	|	Документы.Менеджер.ФизическоеЛицо КАК Менеджер,
	|	Документы.ДополнительнаяИнформация КАК ДополнительнаяИнформация,
	|	Документы.СуммаДокумента КАК СуммаКВозврату,
	|	ЛОЖЬ КАК ЧастичнаяОплата,
	|	Документы.НазначениеПлатежа КАК НазначениеПлатежа,
	|	100 КАК ПроцентОплаты,
	|	Документы.СуммаДокумента КАК СуммаДокумента,
	|	Документы.Грузоотправитель КАК Грузоотправитель,
	|	Документы.Грузополучатель КАК Грузополучатель,
	|	Документы.ИдентификаторПлатежа КАК ИдентификаторПлатежа,
	|	ЛОЖЬ КАК СчетКВозврату
	|ИЗ
	|	Документ.ЗаказКлиента КАК Документы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО Документы.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ПО Документы.БанковскийСчет.Банк = КлассификаторБанков.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанковКорреспондентовРФ
	|		ПО Документы.БанковскийСчет.БанкДляРасчетов = КлассификаторБанковКорреспондентовРФ.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константы
	|		ПО ИСТИНА
	|ГДЕ
	|	Документы.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документы.МоментВремени
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1														КАК Порядок,
	|	ЭтапыГрафикаОплаты.Ссылка								КАК Ссылка,
	|	ЭтапыГрафикаОплаты.НомерСтроки							КАК НомерСтроки,
	|	ЭтапыГрафикаОплаты.ДатаПлатежа							КАК ДатаПлатежа,
	|	ЭтапыГрафикаОплаты.ПроцентПлатежа						КАК ПроцентПлатежа,
	|	ЭтапыГрафикаОплаты.СуммаПлатежа							КАК СуммаПлатежа,
	|	ЛОЖЬ													КАК ЭтоЗалогЗаТару
	|ИЗ
	|	Документ.ЗаказКлиента.ЭтапыГрафикаОплаты КАК ЭтапыГрафикаОплаты
	|ГДЕ
	|	ЭтапыГрафикаОплаты.Ссылка В(&МассивОбъектов)
	|	И ЭтапыГрафикаОплаты.СуммаПлатежа <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2														КАК Порядок,
	|	ЭтапыГрафикаОплаты.Ссылка								КАК Ссылка,
	|	ЭтапыГрафикаОплаты.НомерСтроки							КАК НомерСтроки,
	|	ЭтапыГрафикаОплаты.ДатаПлатежа							КАК ДатаПлатежа,
	|	ЭтапыГрафикаОплаты.ПроцентЗалогаЗаТару					КАК ПроцентПлатежа,
	|	ЭтапыГрафикаОплаты.СуммаЗалогаЗаТару					КАК СуммаПлатежа,
	|	ИСТИНА													КАК ЭтоЗалогЗаТару
	|ИЗ
	|	Документ.ЗаказКлиента.ЭтапыГрафикаОплаты КАК ЭтапыГрафикаОплаты
	|ГДЕ
	|	ЭтапыГрафикаОплаты.Ссылка В(&МассивОбъектов)
	|	И ЭтапыГрафикаОплаты.Ссылка.ТребуетсяЗалогЗаТару
	|	И ЭтапыГрафикаОплаты.СуммаЗалогаЗаТару <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки,
	|	Порядок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка,
	|
	|	ВариантыКомплектацииНоменклатуры.Ссылка КАК ВариантКомплектацииНоменклатуры,
	|	ВариантыКомплектацииНоменклатуры.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ВариантыКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора,
	|	Таблица.НоменклатураНабора                              КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора                            КАК ХарактеристикаНабора,
	|
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Упаковка КАК Упаковка,
	|	Таблица.Количество КАК Количество,
	|	Таблица.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			Таблица.Цена
	|		ИНАЧЕ Таблица.Сумма/Таблица.КоличествоУпаковок 
	|	КОНЕЦ КАК Цена,
	|	Таблица.Сумма КАК Сумма,
	|	Таблица.СтавкаНДС КАК СтавкаНДС,
	|	Таблица.СуммаНДС КАК СуммаНДС,
	|	Таблица.ДатаОтгрузки КАК ДатаОтгрузки,
	|	ВЫБОР
	|		КОГДА
	|			Таблица.Ссылка.ВернутьМногооборотнуюТару
	|			И Таблица.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЭтоВозвратнаяТара,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			Таблица.СуммаРучнойСкидки + Таблица.СуммаАвтоматическойСкидки
	|		ИНАЧЕ 0 
	|	КОНЕЦ КАК СуммаСкидки,
	|	Таблица.Сумма + Таблица.СуммаРучнойСкидки + Таблица.СуммаАвтоматическойСкидки КАК СуммаБезСкидки,
	|	Таблица.Содержание КАК Содержание
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК Таблица
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|		ПО ВариантыКомплектацииНоменклатуры.Владелец = Таблица.НоменклатураНабора
	|		И ВариантыКомплектацииНоменклатуры.Характеристика = Таблица.ХарактеристикаНабора
	|		И ВариантыКомплектацииНоменклатуры.Основной
	|
	|ГДЕ
	|	Таблица.Ссылка В(&МассивОбъектов)
	|	И Таблица.Отменено = ЛОЖЬ
	|	И (Таблица.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ИЛИ Таблица.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		И (НЕ Таблица.Ссылка.ВернутьМногооборотнуюТару ИЛИ Таблица.Ссылка.ТребуетсяЗалогЗаТару))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка                 КАК Ссылка,
	|	Таблица.НоменклатураНабора     КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора   КАК ХарактеристикаНабора,
	|	МИНИМУМ(Таблица.НомерСтроки)   КАК НомерСтроки,
	|	СУММА(Таблица.Сумма)           КАК Сумма,
	|	СУММА(Таблица.СуммаНДС)        КАК СуммаНДС,
	|	МАКСИМУМ(Таблица.ДатаОтгрузки) КАК ДатаОтгрузки,
	|	СУММА(Таблица.СуммаСкидки)     КАК СуммаСкидки,
	|	СУММА(Таблица.СуммаБезСкидки)  КАК СуммаБезСкидки
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыПодготовка
	|ИЗ
	|	Товары КАК Таблица
	|
	|ГДЕ
	|	Таблица.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Ссылка,
	|	Таблица.НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка                                    КАК Ссылка,
	|	Товары.ВариантКомплектацииНоменклатуры           КАК ВариантКомплектацииНоменклатуры,
	|	Товары.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	Товары.ВариантРасчетаЦеныНабора                  КАК ВариантРасчетаЦеныНабора,
	|	Товары.НоменклатураНабора,
	|	Товары.ХарактеристикаНабора,
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	ВЫБОР КОГДА Товары.ВариантКомплектацииНоменклатуры.НоменклатураОсновногоКомпонента = Товары.Номенклатура
	|		И Товары.ВариантКомплектацииНоменклатуры.ХарактеристикаОсновногоКомпонента = Товары.Характеристика ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ОсновнаяКомплектующая,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	0 КАК КоличествоПоУмолчанию,
	|	Товары.Количество КАК Количество
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыДополнительноЧастьПервая
	|ИЗ
	|	Товары КАК Товары
	|
	|ГДЕ
	|	Товары.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Т.Ссылка                                                                                КАК Ссылка,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка                                           КАК ВариантКомплектацииНоменклатуры,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.ВариантРасчетаЦеныНабора                  КАК ВариантРасчетаЦеныНабора,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Владелец                                  КАК НоменклатураНабора,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Характеристика                            КАК ХарактеристикаНабора,
	|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура   КАК Номенклатура,
	|	ВариантыКомплектацииНоменклатурыТовары.Характеристика КАК Характеристика,
	|	ЛОЖЬ КАК ОсновнаяКомплектующая,
	|	NULL КАК СтавкаНДС,
	|	СУММА(ВариантыКомплектацииНоменклатурыТовары.Количество) КАК КоличествоПоУмолчанию,
	|	0 КАК Количество
	|ИЗ
	|	Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК ВариантыКомплектацииНоменклатурыТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ Т.Ссылка ИЗ Товары КАК Т) КАК Т
	|		ПО ИСТИНА
	|ГДЕ
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка В (ВЫБРАТЬ РАЗЛИЧНЫЕ Т.ВариантКомплектацииНоменклатуры ИЗ Товары КАК Т)
	|
	|СГРУППИРОВАТЬ ПО
	|	Т.Ссылка,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Владелец,
	|	ВариантыКомплектацииНоменклатурыТовары.Ссылка.Характеристика,
	|	ВариантыКомплектацииНоменклатурыТовары.Номенклатура,
	|	ВариантыКомплектацииНоменклатурыТовары.Характеристика,
	|	ВариантыКомплектацииНоменклатурыТовары.Упаковка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка,
	|	Таблица.ВариантКомплектацииНоменклатуры,
	|	Таблица.ВариантРасчетаЦеныНабора,
	|	Таблица.ВариантПредставленияНабораВПечатныхФормах,
	|	Таблица.НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	МАКСИМУМ(Таблица.СтавкаНДС) КАК СтавкаНДС,
	|	МАКСИМУМ(Таблица.ОсновнаяКомплектующая) КАК ОсновнаяКомплектующая,
	|	СУММА(Таблица.КоличествоПоУмолчанию) КАК КоличествоПоУмолчанию,
	|	СУММА(Таблица.Количество) КАК Количество
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыДополнительноЧастьВторая
	|ИЗ
	|	ВременнаяТаблицаНаборыДополнительноЧастьПервая КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Ссылка,
	|	Таблица.ВариантКомплектацииНоменклатуры,
	|	Таблица.ВариантРасчетаЦеныНабора,
	|	Таблица.ВариантПредставленияНабораВПечатныхФормах,
	|	Таблица.НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Результат.Ссылка,
	|	Результат.ВариантКомплектацииНоменклатуры,
	|	Результат.ВариантРасчетаЦеныНабора,
	|	Результат.ВариантПредставленияНабораВПечатныхФормах,
	|	Результат.НоменклатураНабора,
	|	Результат.ХарактеристикаНабора,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Результат.ОсновнаяКомплектующая
	|				ТОГДА Результат.СтавкаНДС
	|			ИНАЧЕ null
	|		КОНЕЦ) КАК СтавкаНДС,
	|	ВЫРАЗИТЬ(МИНИМУМ(ВЫБОР
	|			КОГДА Результат.КоличествоПоУмолчанию <> 0 И Результат.ОсновнаяКомплектующая
	|				ТОГДА Результат.Количество / Результат.КоличествоПоУмолчанию
	|			ИНАЧЕ null
	|		КОНЕЦ) + 0.5 КАК Число(10,0)) - 1 КАК Количество
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборыДополнительно
	|ИЗ
	|	ВременнаяТаблицаНаборыДополнительноЧастьВторая КАК Результат
	|СГРУППИРОВАТЬ ПО
	|	Результат.Ссылка,
	|	Результат.ВариантКомплектацииНоменклатуры,
	|	Результат.ВариантРасчетаЦеныНабора,
	|	Результат.ВариантПредставленияНабораВПечатныхФормах,
	|	Результат.НоменклатураНабора,
	|	Результат.ХарактеристикаНабора
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаНаборыДополнительно.ВариантКомплектацииНоменклатуры,
	|	ВЫБОР КОГДА Таблица.Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию) ТОГДА
	|		ВЫБОР КОГДА ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах = ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоНабор) ТОГДА
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие)
	|		ИНАЧЕ
	|			ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах
	|		КОНЕЦ
	|	ИНАЧЕ
	|		ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах
	|	КОНЕЦ КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ВЫБОР КОГДА Таблица.Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию) ТОГДА
	|		ВЫБОР КОГДА
	|			ВЫБОР КОГДА ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах = ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоНабор) ТОГДА
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие)
	|			ИНАЧЕ
	|				ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах
	|			КОНЕЦ = ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие)
	|			И ВременнаяТаблицаНаборыДополнительно.ВариантРасчетаЦеныНабора В (ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам),ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям)) ТОГДА
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих)
	|		ИНАЧЕ
	|			ВременнаяТаблицаНаборыДополнительно.ВариантРасчетаЦеныНабора
	|		КОНЕЦ
	|	ИНАЧЕ
	|		ВременнаяТаблицаНаборыДополнительно.ВариантРасчетаЦеныНабора
	|	КОНЕЦ КАК ВариантРасчетаЦеныНабора,
	|	Таблица.Ссылка                            КАК Ссылка,
	|	Таблица.НоменклатураНабора                КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора              КАК ХарактеристикаНабора,
	|	Таблица.НомерСтроки                       КАК НомерСтроки,
	|	ЕСТЬNULL(ВременнаяТаблицаНаборыДополнительно.Количество, 1) КАК КоличествоУпаковок,
	|	ЕСТЬNULL(ВременнаяТаблицаНаборыДополнительно.Количество, 1) КАК Количество,
	|	Таблица.Сумма                                 КАК Сумма,
	|	Таблица.СуммаНДС                              КАК СуммаНДС,
	|	Таблица.ДатаОтгрузки                          КАК ДатаОтгрузки,
	|	Таблица.СуммаСкидки                           КАК СуммаСкидки,
	|	Таблица.СуммаБезСкидки                        КАК СуммаБезСкидки,
	|	ВременнаяТаблицаНаборыДополнительно.СтавкаНДС КАК СтавкаНДС
	|ПОМЕСТИТЬ ВременнаяТаблицаНаборы
	|ИЗ
	|	ВременнаяТаблицаНаборыПодготовка КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаНаборыДополнительно КАК ВременнаяТаблицаНаборыДополнительно
	|		ПО Таблица.НоменклатураНабора = ВременнаяТаблицаНаборыДополнительно.НоменклатураНабора
	|		И Таблица.ХарактеристикаНабора = ВременнаяТаблицаНаборыДополнительно.ХарактеристикаНабора
	|		И Таблица.Ссылка = ВременнаяТаблицаНаборыДополнительно.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка											КАК Ссылка,
	|	Товары.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	Товары.ВариантРасчетаЦеныНабора                  КАК ВариантРасчетаЦеныНабора,
	|	Товары.НоменклатураНабора								КАК НоменклатураНабора,
	|	Товары.ХарактеристикаНабора								КАК ХарактеристикаНабора,
	|	Товары.ЭтоНабор КАК ЭтоНабор,
	|	Товары.ЭтоКомплектующие КАК ЭтоКомплектующие,
	|	Товары.НомерСтроки										КАК НомерСтроки,
	|	Товары.Номенклатура										КАК Номенклатура,
	|	Товары.Номенклатура.Код									КАК Код,
	|	Товары.Номенклатура.Артикул								КАК Артикул,
	|	Товары.Номенклатура.НаименованиеПолное					КАК НаименованиеПолное,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения				КАК ЕдиницаИзмерения,
	|	Товары.КоличествоУпаковок                                КАК Количество,
	|	Товары.Цена КАК Цена,
	|	Товары.Сумма                                             КАК Сумма,
	|	Товары.СтавкаНДС                                         КАК СтавкаНДС,
	|	Товары.СуммаНДС                                          КАК СуммаНДС,
	|	НЕОПРЕДЕЛЕНО                                             КАК ВидЦеныИсполнителя,
	|	Товары.ДатаОтгрузки                                      КАК ДатаОтгрузки,
	|	ЕСТЬNULL(Товары.Характеристика.НаименованиеПолное, """") КАК Характеристика,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) = 1 ТОГДА
	|		НЕОПРЕДЕЛЕНО
	|	ИНАЧЕ
	|		Товары.Упаковка.Наименование
	|	КОНЕЦ                                                    КАК Упаковка,
	|
	|	Товары.СуммаСкидки                                       КАК СуммаСкидки,
	|	Товары.СуммаБезСкидки                                    КАК СуммаБезСкидки,
	|	Товары.Содержание                                        КАК Содержание,
	|	Товары.ЭтоВозвратнаяТара                                 КАК ЭтоВозвратнаяТара	
	|
	|ИЗ (
	|
	|	ВЫБРАТЬ
	|		Таблица.Ссылка,
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ПустаяСсылка)
	|		КОНЕЦ КАК ВариантПредставленияНабораВПечатныхФормах,
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.ВариантРасчетаЦеныНабора
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.ПустаяСсылка)
	|		КОНЕЦ КАК ВариантРасчетаЦеныНабора,
	|		Таблица.НоменклатураНабора,
	|		Таблица.ХарактеристикаНабора,
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|		КОНЕЦ КАК ЭтоКомплектующие,
	|		ЛОЖЬ КАК ЭтоНабор,
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.НомерСтроки
	|		ИНАЧЕ
	|			Таблица.НомерСтроки
	|		КОНЕЦ КАК НомерСтроки,
	|		Таблица.Номенклатура,
	|		Таблица.Количество,
	|		Таблица.КоличествоУпаковок,
	|		Таблица.Цена,
	|		Таблица.Сумма,
	|		Таблица.СтавкаНДС,
	|		Таблица.СуммаНДС,
	|		Таблица.ДатаОтгрузки,
	|		Таблица.Характеристика,
	|		Таблица.Упаковка,
	|		Таблица.СуммаСкидки,
	|		Таблица.СуммаБезСкидки,
	|		Таблица.Содержание,
	|		Таблица.ЭтоВозвратнаяТара
	|	ИЗ
	|		Товары КАК Таблица
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаНаборы КАК ВременнаяТаблицаНаборы
	|			ПО ВременнаяТаблицаНаборы.НоменклатураНабора = Таблица.НоменклатураНабора
	|			 И ВременнаяТаблицаНаборы.ХарактеристикаНабора = Таблица.ХарактеристикаНабора
	|			 И ВременнаяТаблицаНаборы.Ссылка = Таблица.Ссылка
	|
	|	ГДЕ
	|		Таблица.НоменклатураНабора = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|		ИЛИ (Таблица.НоменклатураНабора <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	        И ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах В (ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоКомплектующие),
	|	                                                                              ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие)))
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ВременнаяТаблицаНаборы.Ссылка,
	|		ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах,
	|		ВременнаяТаблицаНаборы.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора,
	|		ВременнаяТаблицаНаборы.НоменклатураНабора,
	|		ВременнаяТаблицаНаборы.ХарактеристикаНабора,
	|		ЛОЖЬ КАК ЭтоКомплектующие,
	|		ИСТИНА КАК ЭтоНабор,
	|		ВременнаяТаблицаНаборы.НомерСтроки,
	|		ВременнаяТаблицаНаборы.НоменклатураНабора,
	|		ВременнаяТаблицаНаборы.Количество,
	|		ВременнаяТаблицаНаборы.КоличествоУпаковок,
	|		ВЫБОР
	|			КОГДА &ОтображатьСкидки ТОГДА
	|				ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.КоличествоУпаковок, 1) <> 0 ТОГДА
	|					(ВременнаяТаблицаНаборы.СуммаБезСкидки) / ЕСТЬNULL(ВременнаяТаблицаНаборы.КоличествоУпаковок, 1)
	|				ИНАЧЕ
	|					0
	|				КОНЕЦ
	|			ИНАЧЕ
	|				ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.КоличествоУпаковок, 1) <> 0 ТОГДА
	|					(ВременнаяТаблицаНаборы.Сумма) / ЕСТЬNULL(ВременнаяТаблицаНаборы.КоличествоУпаковок, 1)
	|				ИНАЧЕ
	|					0
	|				КОНЕЦ
	|		КОНЕЦ КАК Цена,
	|		ВременнаяТаблицаНаборы.Сумма КАК Сумма,
	|		ВременнаяТаблицаНаборы.СтавкаНДС,
	|		ВременнаяТаблицаНаборы.СуммаНДС,
	|		ВременнаяТаблицаНаборы.ДатаОтгрузки,
	|		ВременнаяТаблицаНаборы.ХарактеристикаНабора,
	|		ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка,
	|		ВременнаяТаблицаНаборы.СуммаСкидки,
	|		ВременнаяТаблицаНаборы.СуммаБезСкидки,
	|		"""",
	|		ЛОЖЬ
	|	ИЗ
	|		ВременнаяТаблицаНаборы КАК ВременнаяТаблицаНаборы
	|	ГДЕ
	|		ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах В (ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоНабор),
	|	                                                                        ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие))
	|) КАК Товары
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки,
	|	ЭтоНабор УБЫВ
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"Товары.Упаковка",
			"Товары.Номенклатура"));
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаНаименованиеЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование",
			"Товары.Упаковка",
			"Товары.Номенклатура"));
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ОтображатьСкидки", ОтображатьСкидки);
	
	ПакетРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	СтруктураДанныхДляПечати = Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке", ПакетРезультатовЗапроса[0]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоЭтапамОплаты", ПакетРезультатовЗапроса[1]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти", ПакетРезультатовЗапроса[ПакетРезультатовЗапроса.Количество() - 1]);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

#КонецЕсли
