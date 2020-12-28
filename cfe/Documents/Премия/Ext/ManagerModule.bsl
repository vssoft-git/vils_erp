﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

&После("ДобавитьКомандыПечати")
Процедура ВИЛС_ДобавитьКомандыПечати(КомандыПечати)
	
	// Приказ о поощрении сотрудников (Т-11а).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Отчет.ПечатнаяФормаТ11";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т11а";
	// begin fix Suetin 08.08.2019 15:56:14
	КомандаПечати.ДополнительныеПараметры.Вставить("ПереопределитьВычисляемоеПоле", Истина);
	КомандаПечати.ДополнительныеПараметры.Вставить("ПереопределяемоеВычисляемоеПоле", "ЛичныеДанные.ФИО.ФамилияИмяОтчествоВВинительномПадеже");
	КомандаПечати.ДополнительныеПараметры.Вставить("ПереопределяемоеВыражениеВычисляемогоПоля", "ЗарплатаКадрыОтчеты.ПросклоненныеФИО(ЛичныеДанные.ФИО.ФамилияИмяОтчество, 3, Работа.Сотрудник.ФизическоеЛицо.Пол) ");
	// end fix Suetin 08.08.2019 15:56:23
	КомандаПечати.Представление = НСтр("ru = 'Приказ о поощрении сотрудников (Т-11а) (ВИЛС)';
										|en = 'Employee recognition order (T-11a) (VILS)'");
	
	// Приказ о поощрении сотрудника (Т-11).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Отчет.ПечатнаяФормаТ11";
	КомандаПечати.Идентификатор = "ПФ_MXL_Т11";
	КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВсехПриказов", Истина);
	// begin fix Suetin 08.08.2019 15:56:14
	КомандаПечати.ДополнительныеПараметры.Вставить("ПереопределитьВычисляемоеПоле", Истина);
	КомандаПечати.ДополнительныеПараметры.Вставить("ПереопределяемоеВычисляемоеПоле", "ЛичныеДанные.ФИО.ФамилияИмяОтчествоВВинительномПадеже");
	КомандаПечати.ДополнительныеПараметры.Вставить("ПереопределяемоеВыражениеВычисляемогоПоля", "ЗарплатаКадрыОтчеты.ПросклоненныеФИО(ЛичныеДанные.ФИО.ФамилияИмяОтчество, 3, Работа.Сотрудник.ФизическоеЛицо.Пол) ");
	// end fix Suetin 08.08.2019 15:56:23
	КомандаПечати.Представление = НСтр("ru = 'Приказы на каждого сотрудника в отдельности (Т-11) (ВИЛС)';
										|en = 'Orders for each employee individually (T-11) (VILS)'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли