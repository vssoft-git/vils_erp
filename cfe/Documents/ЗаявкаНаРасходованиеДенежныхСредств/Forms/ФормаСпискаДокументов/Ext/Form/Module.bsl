﻿

&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	//Список.ТекстЗапроса =
	//"ВЫБРАТЬ
	//|	Заявка.Ссылка КАК Ссылка,
	//|	Заявка.ПометкаУдаления КАК ПометкаУдаления,
	//|	Заявка.Номер КАК Номер,
	//|	Заявка.Дата КАК Дата,
	//|	Заявка.Проведен КАК Проведен,
	//|	Заявка.Организация КАК Организация,
	//|	Заявка.Статус КАК Статус,
	//|	ВЫБОР
	//|		КОГДА Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплаты)
	//|			ТОГДА Заявка.ХозяйственнаяОперацияПоЗарплате
	//|		ИНАЧЕ Заявка.ХозяйственнаяОперация
	//|	КОНЕЦ КАК ХозяйственнаяОперация,
	//|	Заявка.СуммаДокумента КАК СуммаДокумента,
	//|	Заявка.Валюта КАК Валюта,
	//|	Заявка.БанковскийСчет КАК БанковскийСчет,
	//|	Заявка.Касса КАК Касса,
	//|	Заявка.ЖелательнаяДатаПлатежа КАК ДатаПлатежа,
	//|	ВЫБОР
	//|		КОГДА Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику)
	//|			ТОГДА Заявка.ПодотчетноеЛицо
	//|		КОГДА Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию)
	//|				ИЛИ Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию)
	//|				ИЛИ Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств)
	//|			ТОГДА Заявка.ОрганизацияПолучатель
	//|		ИНАЧЕ Заявка.Контрагент
	//|	КОНЕЦ КАК Получатель,
	//|	Заявка.Контрагент КАК Контрагент,
	//|	Заявка.Подразделение КАК Подразделение,
	//|	Заявка.КтоЗаявил КАК Заявитель,
	//|	Заявка.Представление КАК Представление,
	//|	Заявка.ПриоритетОплаты КАК ПриоритетОплаты,
	//|	Заявка.СверхЛимита КАК СверхЛимита,
	//|	ВЫБОР
	//|		КОГДА Заявка.ПриоритетОплаты В
	//|				(ВЫБРАТЬ ПЕРВЫЕ 1
	//|					Приоритеты.Ссылка КАК Приоритет
	//|				ИЗ
	//|					Справочник.ПриоритетыОплаты КАК Приоритеты
	//|				УПОРЯДОЧИТЬ ПО
	//|					Приоритеты.РеквизитДопУпорядочивания)
	//|			ТОГДА 0
	//|		КОГДА Заявка.ПриоритетОплаты В
	//|				(ВЫБРАТЬ ПЕРВЫЕ 1
	//|					Приоритеты.Ссылка КАК Приоритет
	//|				ИЗ
	//|					Справочник.ПриоритетыОплаты КАК Приоритеты
	//|				УПОРЯДОЧИТЬ ПО
	//|					Приоритеты.РеквизитДопУпорядочивания УБЫВ)
	//|			ТОГДА 2
	//|		ИНАЧЕ 1
	//|	КОНЕЦ КАК КартинкаПриоритета,
	//|	ВЫБОР
	//|		КОГДА ЕСТЬNULL(ДенежныеСредства.СуммаОстаток, 0) <= 0
	//|				И Заявка.Проведен
	//|				И Заявка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеДенежныхСредств.Отклонена)
	//|			ТОГДА ИСТИНА
	//|		ИНАЧЕ ЛОЖЬ
	//|	КОНЕЦ КАК ЗаявкаОплачена,
	//|	ВЫБОР
	//|		КОГДА НаличиеПрисоединенныхФайлов.ЕстьФайлы ЕСТЬ NULL
	//|			ТОГДА 1
	//|		КОГДА НаличиеПрисоединенныхФайлов.ЕстьФайлы
	//|			ТОГДА 0
	//|		ИНАЧЕ 1
	//|	КОНЕЦ КАК ЕстьФайлы,
	//|	Выбор когда ТипЗначения(Заявка.ВИЛС_Исполнитель) = Тип(Справочник.Пользователи) Тогда Выразить(Заявка.ВИЛС_Исполнитель как Справочник.Пользователи) иначе Выразить(Заявка.ВИЛС_Исполнитель как Строка(150)) конец  КАК ВИЛС_Исполнитель,
	//|   Выразить(Заявка.НазначениеПлатежа как Строка(300)) Как ВИЛС_НазначениеПлатежа
	//|ИЗ
	//|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК Заявка
	//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредстваКВыплате.Остатки КАК ДенежныеСредства
	//|		ПО (ДенежныеСредства.ЗаявкаНаРасходованиеДенежныхСредств = Заявка.Ссылка)
	//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеФайлов КАК НаличиеПрисоединенныхФайлов
	//|		ПО Заявка.Ссылка = НаличиеПрисоединенныхФайлов.ОбъектСФайлами";
	
	//НовыйРеквизит = Новый РеквизитФормы("ВИЛС_Исполнитель",Новый ОписаниеТипов("Строка"),"Объект.Список","Исполнитель");
	//МассивРеквизитов = Новый Массив;
	//МассивРеквизитов.Добавить(НовыйРеквизит);
	
	//ИзменитьРеквизиты(МассивРеквизитов);
	
	Элементы.ГруппаУстановитьСтатус.Видимость = Ложь;
КонецПроцедуры

&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если Элементы.Найти("ВИЛС_Исполнитель") = Неопределено Тогда
		//НовыйЭлемент = Элементы.Вставить("ВИЛС_Исполнитель",Тип("ПолеФормы"),Элементы.Список,Элементы.СверхЛимита);
		//НовыйЭлемент.ПутьКДанным = "Список.ВИЛС_Исполнитель";
		//НовыйЭлемент.Заголовок = "Исполнитель";
		//НовыйЭлемент.Вид = ВидПоляФормы.ПолеНадписи;
	КонецЕсли;
	
	Если Элементы.Найти("ВИЛС_НазначениеПлатежа") = Неопределено Тогда
		//НовыйЭлемент = Элементы.Вставить("ВИЛС_НазначениеПлатежа",Тип("ПолеФормы"),Элементы.Список,Элементы.СверхЛимита);
		//НовыйЭлемент.ПутьКДанным = "Список.ВИЛС_НазначениеПлатежа";
		//НовыйЭлемент.Заголовок = "Назначение платежа (доп.)";
		//НовыйЭлемент.Вид = ВидПоляФормы.ПолеНадписи;
		//НовыйЭлемент.АвтоВысотаЯчейки = Истина;
	КонецЕсли;

	
	Элементы.ГруппаУстановитьСтатус.Видимость = РольДоступна("ВИЛС_ДиректорПоФинансам") или РольДоступна("ПолныеПрава") ;
	Элементы.СписокУстановитьСтатусНеСогласована.Видимость = Ложь;
	Элементы.СписокУстановитьСтатусСогласована.Видимость = Ложь;
	Элементы.ГруппаФункцииКонтекстноеМеню.Доступность = Ложь;
КонецПроцедуры
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
