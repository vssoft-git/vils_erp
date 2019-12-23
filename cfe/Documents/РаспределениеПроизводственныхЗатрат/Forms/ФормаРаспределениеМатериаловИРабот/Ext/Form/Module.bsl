﻿// begin fix Suetin 20.12.2019 13:47:44
&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	ИмяКоманды 		= "ВИЛС_АктИнвентаризации";
	Команда = Команды.Добавить(ИмяКоманды);
    Команда.Действие = "ВИЛС_ПечатьАктаИнвентаризации";
	
	ДобавляемыйЭлемент = Элементы.Вставить("ВИЛС_АктИнвентаризации", Тип("КнопкаФормы"), Элементы.Материалы.КоманднаяПанель, Элементы.Материалы.КоманднаяПанель.ПодчиненныеЭлементы.ЗатратыГруппаСортировка);
   	ДобавляемыйЭлемент.Вид 						= ВидКнопкиФормы.ОбычнаяКнопка; 
   	ДобавляемыйЭлемент.ИмяКоманды 				= "ВИЛС_АктИнвентаризации";
    ДобавляемыйЭлемент.Заголовок 				= "Акт инвентаризации (ВИЛС)";  
	ДобавляемыйЭлемент.ТолькоВоВсехДействиях   	= Ложь;
    ДобавляемыйЭлемент.Пометка                 	= Ложь;
	ДобавляемыйЭлемент.Картинка					= БиблиотекаКартинок.Печать;
	ДобавляемыйЭлемент.Отображение				= ОтображениеКнопки.КартинкаИТекст;
КонецПроцедуры

&НаКлиенте
Процедура ВИЛС_ПечатьАктаИнвентаризации(Команда)
	
	ПараметрОрганизация = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
	Если Элементы.Материалы.ТекущиеДанные <> Неопределено Тогда
		ПараметрОрганизация = Элементы.Материалы.ТекущиеДанные.Организация;
	ИначеЕсли ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ПараметрОрганизация = ОтборОрганизация;
	КонецЕсли;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("Организация",       ПараметрОрганизация);
	ПараметрыПечати.Вставить("Подразделение",     ОтборПодразделение);
	ПараметрыПечати.Вставить("Период",            Период);
	ПараметрыПечати.Вставить("Затраты",           Материалы);
	ПараметрыПечати.Вставить("НовоеПроизводство", Истина);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.РаспределениеПроизводственныхЗатрат", 
		"ВИЛС_АктИнвентаризацииМатериаловИПолуфабрикатов", 
		ПараметрОрганизация, 
		Неопределено, 
		ПараметрыПечати);
	
КонецПроцедуры	
// end fix Suetin 20.12.2019 13:47:49