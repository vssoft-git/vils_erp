﻿Функция СодержимоеВременнойТаблицы(МенеджерВТ,Имя) Экспорт
	
	Если Имя = "" Тогда
		Структура = Новый Структура;
		Для Каждого ТаблицаВТ из МенеджерВТ.Таблицы Цикл
			Имя = ТаблицаВТ.ПолноеИмя;
			Запрос = Новый Запрос;
			Запрос.Текст =
			"Выбрать * ИЗ "+Имя;
			Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
			
			Структура.Вставить(Имя,Запрос.Выполнить().Выгрузить());
			
		КонецЦикла;
		Возврат(Структура);
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"Выбрать * ИЗ "+Имя;
		Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
		Возврат(Запрос.Выполнить().Выгрузить());
	КонецЕсли;
	
КонецФункции

Функция ИспользуютсяОсобыеУсловияТруда(Организация) Экспорт
	
	НаборЗаписей = РегистрыСведений.НастройкиЗарплатаКадрыРасширенная.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Прочитать();
	
	ИспользоватьОсобыеУсловияТруда = Ложь;
	
	Если НаборЗаписей.Количество() ТОгда
		ИспользоватьОсобыеУсловияТруда = НаборЗаписей[0].ИспользоватьОсобыеУсловияТруда;
	КонецЕсли;
	
	Возврат ИспользоватьОсобыеУсловияТруда;
	
КонецФункции

Функция ВИЛС_ТекстЗапросаПоТаблицеЗначений(ТаблицаЗначений) Экспорт
	
	Если не ТипЗнч(ТаблицаЗначений) = Тип("ТаблицаЗначений") ТОгда
		Возврат "";
	КонецЕсли;
	
	ИмяТаблицы = "ТЗ";
	ИмяВТ = "ВТ";
	ТекстВЫБРАТЬ = "ВЫБРАТЬ";
	ТекстПолей = "";
	
	Для каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		ТекстПолей = ТекстПолей + ?(ТекстПолей = "", "", ",") + Символы.ПС + "	" + ИмяТаблицы + "." + Колонка.Имя; 
	КонецЦикла;
	
	ТекстХвоста = Символы.ПС + "ПОМЕСТИТЬ " + ИмяВТ + Символы.ПС + "ИЗ" + Символы.ПС + "	&" + ИмяТаблицы + " КАК " + ИмяТаблицы;
	
	ТекстЗапроса = ТекстВЫБРАТЬ + ТекстПолей + ТекстХвоста;
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ДоступныПоля(Пользователь,ИмяПрофиля) Экспорт 
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступаПользователи.Ссылка.Профиль КАК Профиль,
	|	ГруппыДоступаПользователи.Пользователь КАК Пользователь,
	|	ГруппыДоступаПользователи.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|ГДЕ
	|	ГруппыДоступаПользователи.Пользователь = &Пользователь
	|	И ГруппыДоступаПользователи.Ссылка.Профиль.Наименование = &ИмяПрофиля
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ГруппыДоступаПользователи.Ссылка.Профиль,
	|	ГруппыПользователейСостав.Пользователь,
	|	ГруппыПользователейСостав.Ссылка
	|ИЗ
	|	Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|		ПО (ГруппыДоступаПользователи.Пользователь = ГруппыПользователейСостав.Ссылка)
	|ГДЕ
	|	ГруппыПользователейСостав.Пользователь = &Пользователь
	|	И ГруппыДоступаПользователи.Ссылка.Профиль.Наименование = &ИмяПрофиля";
	
	
	Запрос.УстановитьПараметр("Пользователь",Пользователь);
	Запрос.УстановитьПараметр("ИмяПрофиля",ИмяПрофиля);
	
	Результат = Запрос.Выполнить().Выбрать();
	МожноРедактировать = Результат.Следующий();
	УстановитьПривилегированныйРежим(Истина);
	Возврат МожноРедактировать
КонецФункции

Процедура ДополнитьВредностьИзУсловийТруда(ДанныеУсловийТруда,Сотрудник) Экспорт
	
	Если не ЗначениеЗаполнено(Сотрудник) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВИЛС_ДанныеУсловийТрудаПоСотрудникамСрезПоследних.УсловияТруда КАК УсловияТруда
	|ИЗ
	|	РегистрСведений.ВИЛС_ДанныеУсловийТрудаПоСотрудникам.СрезПоследних(&ДатаСреза, Сотрудник = &Сотрудник) КАК ВИЛС_ДанныеУсловийТрудаПоСотрудникамСрезПоследних
	|";
	
	Запрос.УстановитьПараметр("Сотрудник",Сотрудник);
	Запрос.УстановитьПараметр("ДатаСреза",ДанныеУсловийТруда.Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДанныеУсловийТруда,Выборка.УсловияТруда);
	КонецЕсли;
	
	
КонецПроцедуры

Функция ДатаПоКоличествуРабочихДней (ДатаНачала,КоличествоДней) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь,
	|	ДанныеПроизводственногоКалендаря.ВидДня КАК ВидДня,
	|	ДанныеПроизводственногоКалендаря.ДатаПереноса КАК ДатаПереноса,
	|	ДанныеПроизводственногоКалендаря.Дата КАК Дата
	|ПОМЕСТИТЬ ВТ_ДанныеКалендаря
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &ДатаНачала И ДОБАВИТЬКДАТЕ(&ДатаНачала, ДЕНЬ, 15)
	|	И ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВТ_ДанныеКалендаря.Дата КАК Дата,
	|	ВТ_ДанныеКалендаря.ДатаПереноса КАК ДатаПереноса
	|ИЗ
	|	ВТ_ДанныеКалендаря КАК ВТ_ДанныеКалендаря
	|ГДЕ
	|	ВТ_ДанныеКалендаря.Дата >= ДобавитьКДате(&ДатаНачала,День,&КоличествоДней)
	|";
	
	Запрос.УстановитьПараметр("ДатаНачала",ДатаНачала);
	Запрос.УстановитьПараметр("КоличествоДней",КоличествоДней);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Дата = Выборка.Дата;
	Иначе
		Дата = Неопределено;
	КонецЕсли;
	
	Возврат Дата;
	
	
КонецФункции