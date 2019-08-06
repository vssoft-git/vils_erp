﻿
&Вместо("МакетыВариантовОтчетовПечатныхФорм")
Функция ВИЛС_МакетыВариантовОтчетовПечатныхФорм()
	
	МакетыВариантовОтчетов = ЗарплатаКадрыОтчетыБазовый.МакетыВариантовОтчетовПечатныхФорм();
	
	// begin fix Suetin 06.08.2019 17:49:34
	МакетыВариантовОтчетов.Вставить("Отчет.ВИЛС_ПечатнаяФормаТ11.Т11", "Отчет.ВИЛС_ПечатнаяФормаТ11.ПФ_MXL_Т11");
	МакетыВариантовОтчетов.Вставить("Отчет.ВИЛС_ПечатнаяФормаТ11.Т11а", "Отчет.ВИЛС_ПечатнаяФормаТ11.ПФ_MXL_Т11а");	
	// end fix Suetin 06.08.2019 17:49:38
	
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ1.Т1", "ОбщийМакет.ПФ_MXL_Т1");
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ5.Т5", "ОбщийМакет.ПФ_MXL_Т5");
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ6.Т6", "ОбщийМакет.ПФ_MXL_Т6");
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ8.Т8", "ОбщийМакет.ПФ_MXL_Т8");
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ1а.Т1а", "Отчет.ПечатнаяФормаТ1а.ПФ_MXL_Т1а");
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ5а.Т5а", "Отчет.ПечатнаяФормаТ5а.ПФ_MXL_Т5а");
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ6а.Т6а", "Отчет.ПечатнаяФормаТ6а.ПФ_MXL_Т6а");
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ8а.Т8а", "Отчет.ПечатнаяФормаТ8а.ПФ_MXL_Т8а");
	
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ9.Т9", "Отчет.ПечатнаяФормаТ9.ПФ_MXL_Т9");
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ9.Т10", "Отчет.ПечатнаяФормаТ9.ПФ_MXL_Т10");
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ9.Т10а", "Отчет.ПечатнаяФормаТ9.ПФ_MXL_Т10а");
	
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ9а.Т9а", "Отчет.ПечатнаяФормаТ9а.ПФ_MXL_Т9а");
	
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ11.Т11", "Отчет.ПечатнаяФормаТ11.ПФ_MXL_Т11");
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТ11.Т11а", "Отчет.ПечатнаяФормаТ11.ПФ_MXL_Т11а");
	
	МакетыВариантовОтчетов.Вставить("Отчет.ПечатнаяФормаТрудовойДоговорМикропредприятий.ТрудовойДоговорМикропредприятий",
		"ОбщийМакет.ПФ_MXL_ТрудовойДоговорМикропредприятий");
	
	МакетыВариантовОтчетов.Вставить("Отчет.АнализНачисленийИУдержанийАвансом.РасчетныйЛистокПерваяПоловинаМесяца",
		"ОбщийМакет.ПФ_MXL_РасчетныйЛистокНастраиваемый");
	
	МакетыВариантовОтчетов.Вставить("Отчет.АнализНачисленийИУдержанийАвансом.Т51ПерваяПоловинаМесяца", "ОбщийМакет.ПФ_MXL_Т51");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") Тогда
		
		МакетыВариантовОтчетов.Вставить("Отчет.АнализНачисленийИУдержаний.РасчетныйЛистокСРазбивкойПоИсточникамФинансирования",
			"ОбщийМакет.ПФ_MXL_РасчетныйЛистокНастраиваемый");
		
		МакетыВариантовОтчетов.Вставить("Отчет.АнализНачисленийИУдержанийАвансом.РасчетныйЛистокСРазбивкойПоИсточникамФинансированияПерваяПоловинаМесяца",
			"ОбщийМакет.ПФ_MXL_РасчетныйЛистокНастраиваемый");
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВоинскийУчет") Тогда
		
		МакетыВариантовОтчетов.Вставить("Отчет.ВоинскийУчетОбщий.ИзвещениеОПриемеУвольнении", 
			"Отчет.ВоинскийУчетОбщий.ПФ_MXL_ИзвещениеОПриемеУвольнении2017");
		
		МакетыВариантовОтчетов.Вставить("Отчет.ВоинскийУчетОбщий.СписокГражданПодлежащихПостановкеНаВоинскийУчет", 
			"Отчет.ВоинскийУчетОбщий.ПФ_MXL_СписокГражданПодлежащихПостановкеНаВоинскийУчет2017");
		
		МакетыВариантовОтчетов.Вставить("Отчет.ВоинскийУчетОбщий.СписокЮношейДляОВК", 
			"Отчет.ВоинскийУчетОбщий.ПФ_MXL_СписокЮношейДляОВК2017");
		
		МакетыВариантовОтчетов.Вставить("Отчет.ВоинскийУчетОбщий.СписокДляСверкиСВоенкоматом", 
			"Отчет.ВоинскийУчетОбщий.ПФ_MXL_СписокДляСверкиСВоенкоматом2017");
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		МодульУправленческаяЗарплата = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
		МодульУправленческаяЗарплата.ДополнитьКоллекциюМакетовВариантовОтчетовПечатныхФорм(МакетыВариантовОтчетов);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.НастраиваемыеПечатныеФормы") Тогда
		МодульНастраиваемыеПечатныеФормы = ОбщегоНазначения.ОбщийМодуль("НастраиваемыеПечатныеФормы");
		МодульНастраиваемыеПечатныеФормы.ДополнитьКоллекциюМакетовВариантовОтчетовПечатныхФорм(МакетыВариантовОтчетов);
	КонецЕсли;
	
	Возврат МакетыВариантовОтчетов;
	
КонецФункции
