﻿// begin fix Suetin 06.03.2019 12:15:13 Заполнение Порядка расчетов по умолчанию изменено на По договорам
&После("ОбработкаЗаполнения")
Процедура ВИЛС_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ПорядокРасчетов)
			Или ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным Тогда
		ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов;
	КонецЕсли;	
КонецПроцедуры
// end fix Suetin 06.03.2019 12:15:17