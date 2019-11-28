﻿
&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	НоваяКоманда = Команды.Добавить("ВИЛС_ПодключениеКПользователю");
	НоваяКоманда.Действие = "ВИЛС_ПодключитьсяКПользователю_Подключаемый";
	НоваяКнопка = Элементы.Вставить("ВИЛС_ПодключитьсяКПользователю",Тип("КнопкаФормы"),Элементы.ОсновнаяКоманднаяПанель,Элементы.ОткрытьПользователя);
	НоваяКнопка.Картинка = БиблиотекаКартинок.RFDIОперацииВыполнены;
	НоваяКнопка.ИмяКоманды = "ВИЛС_ПодключениеКПользователю";
	
	НоваяКоманда = Команды.Добавить("ВИЛС_ПодключениеКПроизвольномуПользователю");
	НоваяКоманда.Действие = "ВИЛС_ПодключитьсяКПроизвольномуПользователю_Подключаемый";
	НоваяКнопка = Элементы.Вставить("ВИЛС_ПодключитьсяКПроизвольномуПользователю",Тип("КнопкаФормы"),Элементы.ОсновнаяКоманднаяПанель,Элементы.ОткрытьПользователя);
	НоваяКнопка.Картинка = БиблиотекаКартинок.RFDIЧтение;
	НоваяКнопка.ИмяКоманды = "ВИЛС_ПодключениеКПроизвольномуПользователю";
КонецПроцедуры

&НаКлиенте
Процедура ВИЛС_ПодключитьсяКПользователю_Подключаемый(Кнопка)
	ТекДанные = Элементы.СписокПользователей.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран компьютер для подключения!';
																|en = 'You have not selected a computer to connect to!'"));
		Возврат;
	КонецЕсли;
	ИмяКомпьютера = СокрЛП(ТекДанные.Компьютер);
	ЗапуститьПриложение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("C:\Program Files\TightVNC\tvnviewer.exe -host=%1 -password=Admin#1", ИмяКомпьютера));
КонецПроцедуры

&НаКлиенте
Процедура ВИЛС_ПодключитьсяКПроизвольномуПользователю_Подключаемый(Кнопка)
	Оповещение = Новый ОписаниеОповещения("ВводСтрокиЗавершение",ЭтаФорма);
	ПоказатьВводСтроки(Оповещение, "ruwsd", НСтр("ru = 'Введите имя компьютера';
										|en = 'Enter computer name'"));
КонецПроцедуры

&НаКлиенте
Процедура ВводСтрокиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	ИмяКомпьютера = СокрЛП(Результат);
	Если Не ТипЗнч(ИмяКомпьютера) = Тип("Строка") 
		или ИмяКомпьютера = "" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран компьютер для подключения!';
																|en = 'You have not selected a computer to connect to!'"));
		Возврат;
	КонецЕсли;
	ЗапуститьПриложение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("C:\Program Files\TightVNC\tvnviewer.exe -host=%1 -password=Admin#1", ИмяКомпьютера));
КонецПроцедуры
