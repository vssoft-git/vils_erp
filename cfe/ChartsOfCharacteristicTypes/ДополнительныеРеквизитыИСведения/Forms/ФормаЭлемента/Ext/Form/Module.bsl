﻿&НаСервере
&Вместо("ОбновитьСписокСвойствТекущегоНабора")
Процедура ВИЛС_ОбновитьСписокСвойствТекущегоНабора()
	
	Запрос = Новый Запрос;
	
	Если Не Элементы.ОбщиеРеквизитыНеВключенныеВНаборы.Пометка Тогда
		Запрос.УстановитьПараметр("Набор", ВыбранныйНаборСвойств);
		Запрос.Текст =
			"ВЫБРАТЬ
			|	СвойстваНаборов.НомерСтроки,
			|	СвойстваНаборов.Свойство,
			|	СвойстваНаборов.ПометкаУдаления,
			|	ВЫБОР
			|		КОГДА &ЭтоОсновнойЯзык
			|		ТОГДА Свойства.Заголовок
			|		ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(СвойстваПредставления.Заголовок, Свойства.Заголовок) КАК СТРОКА(150))
			|	КОНЕЦ КАК Заголовок,
			|	Свойства.ВладелецДополнительныхЗначений,
			|	Свойства.ТипЗначения КАК ТипЗначения,
			|	ВЫБОР
			|		КОГДА Свойства.Ссылка ЕСТЬ NULL 
			|			ТОГДА ИСТИНА
			|		КОГДА Свойства.НаборСвойств = ЗНАЧЕНИЕ(Справочник.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка)
			|			ТОГДА ИСТИНА
			|		ИНАЧЕ ЛОЖЬ
			|	КОНЕЦ КАК Общее,
			|	ВЫБОР
			|		КОГДА СвойстваНаборов.ПометкаУдаления = ИСТИНА
			|			ТОГДА 4
			|		ИНАЧЕ 3
			|	КОНЕЦ КАК НомерКартинки,
			|	ВЫБОР
			|		КОГДА &ЭтоОсновнойЯзык
			|		ТОГДА Свойства.Подсказка
			|		ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(СвойстваПредставления.Подсказка, Свойства.Подсказка) КАК СТРОКА(150))
			|	КОНЕЦ КАК Подсказка,
			|	ВЫБОР
			|		КОГДА &ЭтоОсновнойЯзык
			|		ТОГДА Свойства.ЗаголовокФормыЗначения
			|		ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(СвойстваПредставления.ЗаголовокФормыЗначения, Свойства.ЗаголовокФормыЗначения) КАК СТРОКА(150))
			|	КОНЕЦ КАК ЗаголовокФормыЗначения,
			|	ВЫБОР
			|		КОГДА &ЭтоОсновнойЯзык
			|		ТОГДА Свойства.ЗаголовокФормыВыбораЗначения
			|		ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(СвойстваПредставления.ЗаголовокФормыВыбораЗначения, Свойства.ЗаголовокФормыВыбораЗначения) КАК СТРОКА(150))
			|	КОНЕЦ КАК ЗаголовокФормыВыбораЗначения
			|ИЗ
			|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК СвойстваНаборов
			|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК Свойства
			|		ПО СвойстваНаборов.НаборСвойств = Свойства.Ссылка
			|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Представления КАК СвойстваПредставления
			|		ПО СвойстваНаборов.НаборСвойств = СвойстваПредставления.Ссылка
			|			И СвойстваПредставления.КодЯзыка = &КодЯзыка
			|
			|ГДЕ
			|	СвойстваНаборов.Ссылка = &Набор
			|
			|УПОРЯДОЧИТЬ ПО
			|	СвойстваНаборов.НомерСтроки
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Наборы.ВерсияДанных КАК ВерсияДанных
			|ИЗ
			|	Справочник.НаборыДополнительныхРеквизитовИСведений КАК Наборы
			|ГДЕ
			|	Наборы.Ссылка = &Набор";
		
		Если ЭтоДополнительноеСведение Тогда
			Запрос.Текст = СтрЗаменить(
				Запрос.Текст,
				"Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты",
				"Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения");
		КонецЕсли;
		
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Свойства.Ссылка КАК Свойство,
		|	Свойства.ПометкаУдаления КАК ПометкаУдаления,
		|	ВЫБОР
		|		КОГДА &ЭтоОсновнойЯзык
		|		ТОГДА Свойства.Заголовок
		|		ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(СвойстваПредставления.Заголовок, Свойства.Заголовок) КАК СТРОКА(150))
		|	КОНЕЦ КАК Заголовок,
		|	Свойства.ВладелецДополнительныхЗначений,
		|	Свойства.ТипЗначения КАК ТипЗначения,
		|	ИСТИНА КАК Общее,
		|	ВЫБОР
		|		КОГДА Свойства.ПометкаУдаления = ИСТИНА
		|			ТОГДА 4
		|		ИНАЧЕ 3
		|	КОНЕЦ КАК НомерКартинки,
		|	ВЫБОР
		|		КОГДА &ЭтоОсновнойЯзык
		|		ТОГДА Свойства.Подсказка
		|		ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(СвойстваПредставления.Подсказка, Свойства.Подсказка) КАК СТРОКА(150))
		|	КОНЕЦ КАК Подсказка,
		|	ВЫБОР
		|		КОГДА &ЭтоОсновнойЯзык
		|		ТОГДА Свойства.ЗаголовокФормыЗначения
		|		ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(СвойстваПредставления.ЗаголовокФормыЗначения, Свойства.ЗаголовокФормыЗначения) КАК СТРОКА(150))
		|	КОНЕЦ КАК ЗаголовокФормыЗначения,
		|	ВЫБОР
		|		КОГДА &ЭтоОсновнойЯзык
		|		ТОГДА Свойства.ЗаголовокФормыВыбораЗначения
		|		ИНАЧЕ ВЫРАЗИТЬ(ЕСТЬNULL(СвойстваПредставления.ЗаголовокФормыВыбораЗначения, Свойства.ЗаголовокФормыВыбораЗначения) КАК СТРОКА(150))
		|	КОНЕЦ КАК ЗаголовокФормыВыбораЗначения
		|ИЗ
		|	ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК Свойства
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Представления КАК СвойстваПредставления
		|		ПО Свойства.НаборСвойств = СвойстваПредставления.Ссылка
		|			И СвойстваПредставления.КодЯзыка = &КодЯзыка
		|		
		|ГДЕ
		|	Свойства.НаборСвойств = ЗНАЧЕНИЕ(Справочник.НаборыДополнительныхРеквизитовИСведений.ПустаяСсылка)
		|		И Свойства.ЭтоДополнительноеСведение = &ЭтоДополнительноеСведение
		|
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""ВерсияДанных"" КАК ВерсияДанных";
		
		Запрос.УстановитьПараметр("ЭтоДополнительноеСведение", (ЭтоДополнительноеСведение = 1));
	КонецЕсли;
	Запрос.УстановитьПараметр("ЭтоОсновнойЯзык", ТекущийЯзык() = Метаданные.ОсновнойЯзык);
	Запрос.УстановитьПараметр("КодЯзыка", ТекущийЯзык().КодЯзыка);
	
	НачатьТранзакцию();
	Попытка
		РезультатыЗапроса = Запрос.ВыполнитьПакет();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если Элементы.Свойства.ТекущаяСтрока = Неопределено Тогда
		Строка = Неопределено;
	Иначе
		Строка = Свойства.НайтиПоИдентификатору(Элементы.Свойства.ТекущаяСтрока);
	КонецЕсли;
	ТекущееСвойство = ?(Строка = Неопределено, Неопределено, Строка.Свойство);
	
	Свойства.Очистить();
	
	Выборка = РезультатыЗапроса[0].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Свойства.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		НоваяСтрока.ОбщиеЗначения = ЗначениеЗаполнено(Выборка.ВладелецДополнительныхЗначений);
		
		Если Выборка.ТипЗначения <> NULL
		   И УправлениеСвойствамиСлужебный.ТипЗначенияСодержитЗначенияСвойств(Выборка.ТипЗначения) Тогда
			
			НоваяСтрока.ТипЗначения = Строка(Новый ОписаниеТипов(
				Выборка.ТипЗначения,
				,
				"СправочникСсылка.ЗначенияСвойствОбъектовИерархия,
				|СправочникСсылка.ЗначенияСвойствОбъектов"));
			
			Запрос = Новый Запрос;
			Если ЗначениеЗаполнено(Выборка.ВладелецДополнительныхЗначений) Тогда
				Запрос.УстановитьПараметр("Владелец", Выборка.ВладелецДополнительныхЗначений);
			Иначе
				Запрос.УстановитьПараметр("Владелец", Выборка.Свойство);
			КонецЕсли;
			Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 4
			|	ПРЕДСТАВЛЕНИЕ(ЗначенияСвойствОбъектов.Ссылка) КАК Наименование
			|ИЗ
			|	Справочник.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
			|ГДЕ
			|	ЗначенияСвойствОбъектов.Владелец = &Владелец
			|	И НЕ ЗначенияСвойствОбъектов.ЭтоГруппа
			|	И НЕ ЗначенияСвойствОбъектов.ПометкаУдаления
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ ПЕРВЫЕ 4
			|	ПРЕДСТАВЛЕНИЕ(ЗначенияСвойствОбъектовИерархия.Ссылка) КАК Наименование
			|ИЗ
			|	Справочник.ЗначенияСвойствОбъектовИерархия КАК ЗначенияСвойствОбъектовИерархия
			|ГДЕ
			|	ЗначенияСвойствОбъектовИерархия.Владелец = &Владелец
			|	И НЕ ЗначенияСвойствОбъектовИерархия.ПометкаУдаления
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА КАК ЗначениеИстина
			|ИЗ
			|	Справочник.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
			|ГДЕ
			|	ЗначенияСвойствОбъектов.Владелец = &Владелец
			|	И НЕ ЗначенияСвойствОбъектов.ЭтоГруппа
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА
			|ИЗ
			|	Справочник.ЗначенияСвойствОбъектовИерархия КАК ЗначенияСвойствОбъектовИерархия
			|ГДЕ
			|	ЗначенияСвойствОбъектовИерархия.Владелец = &Владелец";
			РезультатыЗапроса = Запрос.ВыполнитьПакет();
			
			ПервыеЗначения = РезультатыЗапроса[0].Выгрузить().ВыгрузитьКолонку("Наименование");
			
			Если ПервыеЗначения.Количество() = 0 Тогда
				Если РезультатыЗапроса[1].Пустой() Тогда
					ПредставлениеЗначений = НСтр("ru = 'Значения еще не введены';
												|en = 'No values entered'");
				Иначе
					ПредставлениеЗначений = НСтр("ru = 'Значения помечены на удаление';
												|en = 'Values are marked for deletion'");
				КонецЕсли;
			Иначе
				ПредставлениеЗначений = "";
				Номер = 0;
				Для каждого Значение Из ПервыеЗначения Цикл
					Номер = Номер + 1;
					Если Номер = 4 Тогда
						ПредставлениеЗначений = ПредставлениеЗначений + ",...";
						Прервать;
					КонецЕсли;
					ПредставлениеЗначений = ПредставлениеЗначений + ?(Номер > 1, ", ", "") + Значение;
				КонецЦикла;
			КонецЕсли;
			ПредставлениеЗначений = "<" + ПредставлениеЗначений + ">";
			Если ЗначениеЗаполнено(НоваяСтрока.ТипЗначения) Тогда
				ПредставлениеЗначений = ПредставлениеЗначений + ", ";
			КонецЕсли;
			НоваяСтрока.ТипЗначения = ПредставлениеЗначений + НоваяСтрока.ТипЗначения;
		КонецЕсли;
		
		Если Выборка.Свойство = ТекущееСвойство Тогда
			Элементы.Свойства.ТекущаяСтрока =
				Свойства[Свойства.Количество()-1].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры