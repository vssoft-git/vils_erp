﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииПечатиФормы

&Вместо("ДанныеДляПечатныхФормСчетаНаОплатуИзвещения")
Функция ВИЛС_ДанныеДляПечатныхФормСчетаНаОплатуИзвещения(ПараметрыПечати, МассивОбъектов) Экспорт
	
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
	|	Документы.ДокументОснование КАК ДокументОснование
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	Документ.СчетНаОплатуКлиенту КАК Документы
	|ГДЕ
	|	Документы.Ссылка В(&МассивОбъектов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Документы.Ссылка КАК Ссылка,
	|	Документы.Номер КАК Номер,
	|	Документы.Дата КАК Дата,
	|	Документы.ДокументОснование КАК ДокументОснование,
	|	ЕСТЬNULL(Документы.БанковскийСчет.Владелец, Документы.Организация) КАК Организация,
	|	Документы.Организация КАК ОрганизацияПоставщик,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	Документы.Контрагент КАК Контрагент,
	|	Документы.Договор КАК Договор,    // fix Suetin 21.02.2019 16:21:05
	|	Документы.Контрагент.ЮрФизЛицо КАК КонтрагентЮрФизЛицо,
	|	Документы.БанковскийСчет КАК БанковскийСчет,
	|	
	|	ВЫБОР КОГДА Документы.БанковскийСчет.ИностранныйБанк
	|		ИЛИ Документы.БанковскийСчет.ВалютаДенежныхСредств <> Константы.ВалютаРегламентированногоУчета ТОГДА
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
	|	ВЫБОР
	|		КОГДА Документы.ДокументОснование ССЫЛКА Документ.ОтчетКомитенту
	|			ТОГДА ИСТИНА
	|		КОГДА Документы.ДокументОснование ССЫЛКА Документ.ОтчетКомиссионера
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЕСТЬNULL(Документы.ДокументОснование.ЦенаВключаетНДС, ЛОЖЬ)   // fix Suetin 21.02.2019 16:47:58 ЕСТЬNULL(..., ЛОЖЬ)
	|	КОНЕЦ КАК ЦенаВключаетНДС,
	|	Документы.ДокументОснование.СуммаДокумента КАК СуммаКВозврату,
	|	ВЫБОР
	|		КОГДА Документы.ДокументОснование.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК УчитыватьНДС,
	|	Документы.Валюта КАК Валюта,
	|	Документы.Менеджер.ФизическоеЛицо КАК Менеджер,
	|	Документы.ДополнительнаяИнформация КАК ДополнительнаяИнформация,
	|	Документы.ЧастичнаяОплата КАК ЧастичнаяОплата,
	|	Документы.НазначениеПлатежа КАК НазначениеПлатежа,
	|	ВЫБОР КОГДА Документы.ДокументОснование ССЫЛКА Документ.ОтчетКомитенту
	|				И Документы.ДокументОснование.СуммаВознаграждения = 0 ТОГДА
	|		0
	|	КОГДА Документы.ДокументОснование ССЫЛКА Документ.ОтчетКомитенту ТОГДА // СуммаВознаграждения <> 0
	|		Документы.СуммаДокумента * 100 / Документы.ДокументОснование.СуммаВознаграждения
	|	КОГДА Документы.ДокументОснование.СуммаДокумента = 0 ТОГДА
	|		0
	|	КОГДА (Документы.ДокументОснование ССЫЛКА Документ.ЗаказКлиента
	|				ИЛИ Документы.ДокументОснование ССЫЛКА Документ.ЗаявкаНаВозвратТоваровОтКлиента)
	|				И Документы.ДокументОснование.ТребуетсяЗалогЗаТару ТОГДА
	|		Документы.СуммаДокумента * 100 / (Документы.ДокументОснование.СуммаДокумента + Документы.ДокументОснование.СуммаВозвратнойТары)
	|	ИНАЧЕ
	|		Документы.СуммаДокумента * 100 / Документы.ДокументОснование.СуммаДокумента
	|	КОНЕЦ КАК ПроцентОплаты,
	|	Документы.СуммаДокумента КАК СуммаДокумента,
	|	Неопределено КАК Грузоотправитель,
	|	Выбор когда не Документы.ДокументОснование = Значение(Документ.ЗаказКлиента.ПустаяСсылка) тогда Документы.ДокументОснование.Грузополучатель иначе Неопределено Конец КАК Грузополучатель, // Неопределено КАК Грузополучатель
	|	Документы.ИдентификаторПлатежа КАК ИдентификаторПлатежа,
	|	ВЫБОР
	|		КОГДА ЗаявкаНаВозвратТоваровОтКлиента.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СчетКВозврату
	|ИЗ
	|	Документ.СчетНаОплатуКлиенту КАК Документы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаявкаНаВозвратТоваровОтКлиента
	|		ПО Документы.ДокументОснование = ЗаявкаНаВозвратТоваровОтКлиента.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО Документы.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ПО Документы.БанковскийСчет.Банк = КлассификаторБанков.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанковКорреспондентовРФ
	|		ПО Документы.БанковскийСчет.БанкДляРасчетов = КлассификаторБанковКорреспондентовРФ.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константы
	|		ПО ИСТИНА
	|ГДЕ
	|	Документы.Ссылка В
	|			(ВЫБРАТЬ
	|				ТаблицаДокументов.Ссылка
	|			ИЗ
	|				ТаблицаДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документы.МоментВремени
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	//begin fix Клещ А.Н. 02.07.2019  
		//|ВЫБРАТЬ
	//|	ЭтапыГрафикаОплаты.Ссылка КАК Ссылка,
	//|	ЭтапыГрафикаОплаты.НомерСтроки КАК НомерСтроки,
	//|	ЭтапыГрафикаОплаты.ДатаПлатежа КАК ДатаПлатежа,
	//|	ЭтапыГрафикаОплаты.ПроцентПлатежа КАК ПроцентПлатежа,
	//|	ЭтапыГрафикаОплаты.СуммаПлатежа КАК СуммаПлатежа,
	//|	ЭтапыГрафикаОплаты.ЭтоЗалогЗаТару КАК ЭтоЗалогЗаТару
	//|ИЗ
	//|	Документ.СчетНаОплатуКлиенту.ЭтапыГрафикаОплаты КАК ЭтапыГрафикаОплаты
	//|ГДЕ
	//|	ЭтапыГрафикаОплаты.Ссылка В
	//|			(ВЫБРАТЬ
	//|				ТаблицаДокументов.Ссылка
	//|			ИЗ
	//|				ТаблицаДокументов)
	//|
	//|УПОРЯДОЧИТЬ ПО
	//|	НомерСтроки
	//|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетНаОплатуКлиенту.Ссылка КАК Ссылка,
	|	1 КАК НомерСтроки,
	|	ДОБАВИТЬКДАТЕ(СчетНаОплатуКлиенту.Дата, ДЕНЬ, ВЫБОР
	|			КОГДА ТИПЗНАЧЕНИЯ(СчетНаОплатуКлиенту.ДокументОснование) = ТИП(Справочник.ДоговорыКонтрагентов)
	|				ТОГДА СчетНаОплатуКлиенту.ДокументОснование.СрокОплаты
	|			ИНАЧЕ СчетНаОплатуКлиенту.ДокументОснование.Договор.СрокОплаты
	|		КОНЕЦ) КАК ДатаПлатежа,
	|	100 КАК ПроцентПлатежа,
	|	СчетНаОплатуКлиенту.СуммаДокумента КАК СуммаПлатежа,
	|	ЛОЖЬ КАК ЭтоЗалогЗаТару
	|ИЗ
	|	Документ.СчетНаОплатуКлиенту КАК СчетНаОплатуКлиенту
	|ГДЕ
	|	СчетНаОплатуКлиенту.ЭтапыГрафикаОплаты.Ссылка В
	|			(ВЫБРАТЬ
	|				ТаблицаДокументов.Ссылка
	|			ИЗ
	|				ТаблицаДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	//end fix Клещ А.Н. 02.07.2019
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка КАК Ссылка,
	|	ТаблицаДокументов.ДокументОснование.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.НоменклатураНабора,
	|	Товары.ХарактеристикаНабора,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.Количество КАК Количество,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			Товары.Цена
	|		ИНАЧЕ Товары.Сумма/Товары.КоличествоУпаковок 
	|	КОНЕЦ КАК Цена,
	|	Товары.Сумма КАК Сумма,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	Товары.СуммаНДС КАК СуммаНДС,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			Товары.СуммаРучнойСкидки + Товары.СуммаАвтоматическойСкидки
	|		ИНАЧЕ 0 
	|	КОНЕЦ КАК СуммаСкидки,
	|	Товары.Сумма + Товары.СуммаРучнойСкидки + Товары.СуммаАвтоматическойСкидки КАК СуммаБезСкидки,
	|	ВЫБОР
	|		КОГДА
	|			Товары.Ссылка.ВернутьМногооборотнуюТару
	|			И Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЭтоВозвратнаяТара,
	|	Товары.Содержание КАК Содержание
	|ПОМЕСТИТЬ ТоварыПодготовка
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента.Товары КАК Товары
	|		ПО ТаблицаДокументов.ДокументОснование = Товары.Ссылка
	|			И (Товары.Отменено = ЛОЖЬ)
	|			И (Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|				ИЛИ Товары.Ссылка.ТребуетсяЗалогЗаТару
	|				ИЛИ НЕ Товары.Ссылка.ВернутьМногооборотнуюТару)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	//++ НЕ УТКА
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка КАК Ссылка,
	|	Неопределено КАК ХозяйственнаяОперация,
	|	1 КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|	Заказ.Номенклатура КАК Номенклатура,
	|	Заказ.Характеристика КАК Характеристика,
	|	NULL КАК Упаковка,
	|	1 КАК Количество,
	|	1 КАК КоличествоУпаковок,
	|	СУММА(Товары.Сумма) КАК Цена,
	|	СУММА(Товары.Сумма) КАК Сумма,
	|	Заказ.СтавкаНДС КАК СтавкаНДС,
	|	СУММА(Товары.СуммаНДС) КАК СуммаНДС,
	|	0 КАК СуммаСкидки,
	|	СУММА(Товары.Сумма) КАК СуммаБезСкидки,
	|	Ложь,
	|	МАКСИМУМ(Заказ.Содержание) КАК Содержание
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ЗаказДавальца КАК Заказ
	|	ПО
	|		ТаблицаДокументов.ДокументОснование = Заказ.Ссылка
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ЗаказДавальца.Продукция КАК Товары
	|	ПО
	|		ТаблицаДокументов.ДокументОснование = Товары.Ссылка
	|		И (Товары.Отменено = ЛОЖЬ)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокументов.Ссылка,
	|	Заказ.Номенклатура,
	|	Заказ.СтавкаНДС,
	|	Заказ.Характеристика
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка КАК Ссылка,
	|	Неопределено КАК ХозяйственнаяОперация,
	|	1 КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|	Отчет.Номенклатура КАК Номенклатура,
	|	Отчет.Характеристика КАК Характеристика,
	|	NULL КАК Упаковка,
	|	1 КАК Количество,
	|	1 КАК КоличествоУпаковок,
	|	СУММА(Товары.Сумма) КАК Цена,
	|	СУММА(Товары.Сумма) КАК Сумма,
	|	Отчет.СтавкаНДС КАК СтавкаНДС,
	|	СУММА(Товары.СуммаНДС) КАК СуммаНДС,
	|	0 КАК СуммаСкидки,
	|	СУММА(Товары.Сумма) КАК СуммаБезСкидки,
	|	Ложь,
	|	МАКСИМУМ(Отчет.Содержание) КАК Содержание
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетДавальцу КАК Отчет
	|	ПО
	|		ТаблицаДокументов.ДокументОснование = Отчет.Ссылка
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетДавальцу.Продукция КАК Товары
	|	ПО
	|		ТаблицаДокументов.ДокументОснование = Товары.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокументов.Ссылка,
	|	Отчет.Номенклатура,
	|	Отчет.СтавкаНДС,
	|	Отчет.Характеристика
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	//-- НЕ УТКА
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка,
	|	ТаблицаДокументов.ДокументОснование.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Товары.НомерСтроки,
	|	Товары.НоменклатураНабора,
	|	Товары.ХарактеристикаНабора,
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Упаковка,
	|	Товары.Количество,
	|	Товары.КоличествоУпаковок,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			Товары.Цена
	|		ИНАЧЕ Товары.Сумма/Товары.КоличествоУпаковок 
	|	КОНЕЦ,
	|	Товары.Сумма,
	|	Товары.СтавкаНДС,
	|	Товары.СуммаНДС,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			Товары.СуммаРучнойСкидки + Товары.СуммаАвтоматическойСкидки
	|		ИНАЧЕ 0 
	|	КОНЕЦ,
	|	Товары.Сумма + Товары.СуммаРучнойСкидки + Товары.СуммаАвтоматическойСкидки,
	|	ВЫБОР
	|		КОГДА
	|			Товары.Ссылка.ВернутьМногооборотнуюТару
	|			И Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЭтоВозвратнаяТара,
	|	Товары.Содержание
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЗаменяющиеТовары КАК Товары
	|		ПО ТаблицаДокументов.ДокументОснование = Товары.Ссылка
	|			И (Товары.Отменено = ЛОЖЬ)
	|			И (Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|				ИЛИ Товары.Ссылка.ТребуетсяЗалогЗаТару
	|				ИЛИ НЕ Товары.Ссылка.ВернутьМногооборотнуюТару)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка,
	|	ТаблицаДокументов.ДокументОснование.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Товары.НомерСтроки,
	|	Товары.НоменклатураНабора,
	|	Товары.ХарактеристикаНабора,
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Упаковка,
	|	Товары.Количество,
	|	Товары.КоличествоУпаковок,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			Товары.Цена
	|		ИНАЧЕ Товары.Сумма/Товары.КоличествоУпаковок 
	|	КОНЕЦ,
	|	Товары.Сумма,
	|	Товары.СтавкаНДС,
	|	Товары.СуммаНДС,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			Товары.СуммаРучнойСкидки + Товары.СуммаАвтоматическойСкидки
	|		ИНАЧЕ 0 
	|	КОНЕЦ,
	|	Товары.Сумма + Товары.СуммаРучнойСкидки + Товары.СуммаАвтоматическойСкидки,
	|	ВЫБОР
	|		КОГДА
	|			Товары.Ссылка.ВернутьМногооборотнуюТару
	|			И Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ТОГДА
	|			ИСТИНА
	|		ИНАЧЕ
	|			ЛОЖЬ
	|	КОНЕЦ КАК ЭтоВозвратнаяТара,
	|	NULL
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК Товары
	|		ПО ТаблицаДокументов.ДокументОснование = Товары.Ссылка
	|			И (Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|				ИЛИ Товары.Ссылка.ТребуетсяЗалогЗаТару
	|				ИЛИ НЕ Товары.Ссылка.ВернутьМногооборотнуюТару)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка,
	|	Неопределено КАК ХозяйственнаяОперация,
	|	Товары.НомерСтроки,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Упаковка,
	|	Товары.Количество,
	|	Товары.КоличествоУпаковок,
	|	Товары.Цена,
	|	Товары.Сумма,
	|	Товары.СтавкаНДС,
	|	Товары.СуммаНДС,
	|	0,
	|	0,
	|	Ложь,
	|	NULL
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыкупВозвратнойТарыКлиентом.Товары КАК Товары
	|		ПО ТаблицаДокументов.ДокументОснование = Товары.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка,
	|	ТаблицаДокументов.ДокументОснование.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Услуги.НомерСтроки,
	|	Услуги.НоменклатураНабора,
	|	Услуги.ХарактеристикаНабора,
	|	Услуги.Номенклатура,
	|	Услуги.Характеристика,
	|	NULL,
	|	Услуги.Количество,
	|	Услуги.Количество,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			Услуги.Цена
	|		ИНАЧЕ Услуги.Сумма/Услуги.Количество 
	|	КОНЕЦ,
	|	Услуги.Сумма,
	|	Услуги.СтавкаНДС,
	|	Услуги.СуммаНДС,
	|	ВЫБОР
	|		КОГДА &ОтображатьСкидки ТОГДА
	|			Услуги.СуммаРучнойСкидки + Услуги.СуммаАвтоматическойСкидки
	|		ИНАЧЕ 0 
	|	КОНЕЦ,
	|	Услуги.Сумма + Услуги.СуммаРучнойСкидки + Услуги.СуммаАвтоматическойСкидки,
	|	Ложь,
	|	Услуги.Содержание
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.АктВыполненныхРабот.Услуги КАК Услуги
	|		ПО ТаблицаДокументов.ДокументОснование = Услуги.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка,
	|	Неопределено КАК ХозяйственнаяОперация,
	|	1,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|	Основание.Услуга,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|	NULL,
	|	1,
	|	1,
	|	Основание.СуммаВознаграждения,
	|	Основание.СуммаВознаграждения,
	|	Основание.СтавкаНДСВознаграждения,
	|	Основание.СуммаНДСВознаграждения,
	|	0,
	|	Основание.СуммаВознаграждения,
	|	Ложь,
	|	NULL
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетКомитенту КАК Основание
	|		ПО ТаблицаДокументов.ДокументОснование = Основание.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка,
	|	Неопределено КАК ХозяйственнаяОперация,
	|	Товары.НомерСтроки,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Упаковка,
	|	Товары.Количество,
	|	Товары.КоличествоУпаковок,
	|	Товары.Цена,
	|	Товары.Сумма,
	|	Товары.СтавкаНДС,
	|	Товары.СуммаНДС,
	|	0,
	|	Товары.СуммаСНДС,
	|	Ложь,
	|	NULL
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетКомиссионера.Товары КАК Товары
	|		ПО ТаблицаДокументов.ДокументОснование = Товары.Ссылка
	|ГДЕ
	|	Товары.Количество <> 0
	|	И Товары.СуммаПродажи <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка,
	|	Неопределено КАК ХозяйственнаяОперация,
	|	Товары.НомерСтроки,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Упаковка,
	|	Товары.Количество,
	|	Товары.КоличествоУпаковок,
	|	Товары.Цена,
	|	Товары.Сумма,
	|	Товары.СтавкаНДС,
	|	Товары.СуммаНДС,
	|	0,
	|	Товары.Сумма,
	|	Ложь,
	|	NULL
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетКомиссионераОСписании.Товары КАК Товары
	|		ПО ТаблицаДокументов.Ссылка = Товары.Ссылка
	//begin fix Клещ А.Н. 06.02.2019  
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокументов.Ссылка,
	|	""Для счета на оплату"" КАК ХозяйственнаяОперация,
	|	Товары.НомерСтроки,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка),
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка),
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Упаковка,
	|	Товары.Количество,
	|	Товары.КоличествоУпаковок,
	|	Товары.Цена,
	|	Товары.Сумма,
	|	Товары.СтавкаНДС,
	|	Товары.СуммаНДС,
	|	0,
	|	Товары.Сумма,
	|	Ложь,
	|	Товары.Содержание
	|ИЗ
	|	ТаблицаДокументов КАК ТаблицаДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетНаОплатуКлиенту.ВИЛС_ТоварыЗаказа КАК Товары
	|		ПО ТаблицаДокументов.Ссылка = Товары.Ссылка
	//end fix Клещ А.Н. 06.02.2019 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка,
	|	Таблица.ХозяйственнаяОперация,
	|	
	|	ВариантыКомплектацииНоменклатуры.Ссылка КАК ВариантКомплектацииНоменклатуры,
	|	ВариантыКомплектацииНоменклатуры.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	ВариантыКомплектацииНоменклатуры.ВариантРасчетаЦеныНабора КАК ВариантРасчетаЦеныНабора,
	|	Таблица.НоменклатураНабора   КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Упаковка КАК Упаковка,
	|	Таблица.Количество КАК Количество,
	|	Таблица.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Таблица.Цена,
	|	Таблица.Сумма КАК Сумма,
	|	Таблица.СтавкаНДС,
	|	Таблица.СуммаНДС,
	|	Таблица.СуммаСкидки,
	|	Таблица.СуммаБезСкидки,
	|	Таблица.ЭтоВозвратнаяТара КАК ЭтоВозвратнаяТара,
	|	Таблица.Содержание КАК Содержание
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	ТоварыПодготовка КАК Таблица
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКомплектацииНоменклатуры КАК ВариантыКомплектацииНоменклатуры
	|		ПО ВариантыКомплектацииНоменклатуры.Владелец = Таблица.НоменклатураНабора
	|		И ВариантыКомплектацииНоменклатуры.Характеристика = Таблица.ХарактеристикаНабора
	|		И ВариантыКомплектацииНоменклатуры.Основной
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка                 КАК Ссылка,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.НоменклатураНабора     КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора   КАК ХарактеристикаНабора,
	|	МИНИМУМ(Таблица.НомерСтроки)   КАК НомерСтроки,
	|	СУММА(Таблица.Сумма)           КАК Сумма,
	|	СУММА(Таблица.СуммаНДС)        КАК СуммаНДС,
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
	|	Таблица.ХозяйственнаяОперация,
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
	|	
	|	ВЫБОР КОГДА Таблица.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию) ТОГДА
	|		ВЫБОР КОГДА ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах = ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ТолькоНабор) ТОГДА
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие)
	|		ИНАЧЕ
	|			ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах
	|		КОНЕЦ
	|	ИНАЧЕ
	|		ВременнаяТаблицаНаборыДополнительно.ВариантПредставленияНабораВПечатныхФормах
	|	КОНЕЦ КАК ВариантПредставленияНабораВПечатныхФормах,
	|	
	|	ВЫБОР КОГДА Таблица.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию) ТОГДА
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
	|	
	|	Таблица.Ссылка                            КАК Ссылка,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.НоменклатураНабора                КАК НоменклатураНабора,
	|	Таблица.ХарактеристикаНабора              КАК ХарактеристикаНабора,
	|	Таблица.НомерСтроки                       КАК НомерСтроки,
	|	ЕСТЬNULL(ВременнаяТаблицаНаборыДополнительно.Количество, 1) КАК КоличествоУпаковок,
	|	ЕСТЬNULL(ВременнаяТаблицаНаборыДополнительно.Количество, 1) КАК Количество,
	|	Таблица.Сумма                                 КАК Сумма,
	|	Таблица.СуммаНДС                              КАК СуммаНДС,
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
	|	Товары.Ссылка КАК Ссылка,
	|	
	|	Товары.ВариантПредставленияНабораВПечатныхФормах КАК ВариантПредставленияНабораВПечатныхФормах,
	|	Товары.ВариантРасчетаЦеныНабора                  КАК ВариантРасчетаЦеныНабора,
	|	
	|	Товары.НоменклатураНабора    КАК НоменклатураНабора,
	|	Товары.ХарактеристикаНабора  КАК ХарактеристикаНабора,
	|	Товары.ЭтоНабор         КАК ЭтоНабор,
	|	Товары.ЭтоКомплектующие КАК ЭтоКомплектующие,
	|	
	|	Товары.НомерСтроки                     КАК НомерСтроки,
	|	Товары.Номенклатура                    КАК Номенклатура,
	|	Товары.Номенклатура.Код                КАК Код,
	|	Товары.Номенклатура.Артикул            КАК Артикул,
	|	Товары.Номенклатура.НаименованиеПолное КАК НаименованиеПолное,
	|	Товары.Содержание                      КАК Содержание,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения 				 КАК ЕдиницаИзмерения,
	|	Товары.КоличествоУпаковок                                КАК Количество,
	|	Товары.Цена КАК Цена,
	|	Товары.Сумма                                             КАК Сумма,
	|	Товары.СтавкаНДС                                         КАК СтавкаНДС,
	|	Товары.СуммаНДС                                          КАК СуммаНДС,
	|	НЕОПРЕДЕЛЕНО                                             КАК ВидЦеныИсполнителя,
	|	ЕСТЬNULL(Товары.Характеристика.НаименованиеПолное, """") КАК Характеристика,
	|	
	|	ВЫБОР КОГДА ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) = 1 ТОГДА
	|		НЕОПРЕДЕЛЕНО
	|	ИНАЧЕ
	|		Товары.Упаковка.Наименование
	|	КОНЕЦ                                                    КАК Упаковка,
	|	
	|	Товары.СуммаСкидки                                       КАК СуммаСкидки,
	|	
	|	Товары.СуммаБезСкидки                                    КАК СуммаБезСкидки,
	|	
	|	Товары.ЭтоВозвратнаяТара                                 КАК ЭтоВозвратнаяТара
	//begin fix Клещ А.Н. 06.02.2019  
	|       , Товары.ХозяйственнаяОперация  Как  ХозяйственнаяОперация
	//end fix Клещ А.Н. 06.02.2019
	|	
	|ИЗ (
	|	
	|	ВЫБРАТЬ
	|		Таблица.Ссылка,
	|		
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.ВариантПредставленияНабораВПечатныхФормах
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.ПустаяСсылка)
	|		КОНЕЦ КАК ВариантПредставленияНабораВПечатныхФормах,
	|		
	|		ВЫБОР КОГДА ЕСТЬNULL(ВременнаяТаблицаНаборы.НомерСтроки, 0) <> 0 ТОГДА
	|			ВременнаяТаблицаНаборы.ВариантРасчетаЦеныНабора
	|		ИНАЧЕ
	|			ЗНАЧЕНИЕ(Перечисление.ВариантыРасчетаЦенНаборов.ПустаяСсылка)
	|		КОНЕЦ КАК ВариантРасчетаЦеныНабора,
	|		
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
	|		Таблица.Характеристика,
	|		Таблица.Упаковка,
	|		Таблица.СуммаСкидки,
	|		Таблица.СуммаБезСкидки,
	|		Таблица.ЭтоВозвратнаяТара,
	|		Таблица.Содержание
	//begin fix Клещ А.Н. 06.02.2019  
	|       , Таблица.ХозяйственнаяОперация 
	//end fix Клещ А.Н. 06.02.2019
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
	|		ВременнаяТаблицаНаборы.ХарактеристикаНабора,
	|		ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка,
	|		ВременнаяТаблицаНаборы.СуммаСкидки,
	|		ВременнаяТаблицаНаборы.СуммаБезСкидки,
	|		Ложь,
	|		""""
	//begin fix Клещ А.Н. 06.02.2019  
	|       , """" 
	//end fix Клещ А.Н. 06.02.2019
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
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"Товары.Упаковка",
			"Товары.Номенклатура"));
			
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование",
			"Товары.Упаковка",
			"Товары.Номенклатура"));
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ОтображатьСкидки", ОтображатьСкидки);
	
	ПакетРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	СтруктураДанныхДляПечати = Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке", ПакетРезультатовЗапроса[1]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоЭтапамОплаты", ПакетРезультатовЗапроса[2]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти", ПакетРезультатовЗапроса[ПакетРезультатовЗапроса.Количество() - 1]);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции
	
#КонецОбласти

#КонецОбласти

#КонецЕсли
