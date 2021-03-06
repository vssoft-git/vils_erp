// begin fix Suetin 19.02.2020 17:17:38
// Если у пользователя нет доступной роли 
// ВИЛС_ДоступностьДействияРезервироватьВЗаказеНаПеремещение 
// или 
// ПолныеПрава 
// действия по резервированию будут недоступны
&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	Перем ВИЛС_Регистратор;
	Если Параметры.Свойство("Регистратор", ВИЛС_Регистратор)
		и Не РольДоступна("ПолныеПрава") 
		и Не РольДоступна("ВИЛС_ДоступностьДействияРезервироватьВЗаказеНаПеремещение")
		и ТипЗнч(ВИЛС_Регистратор) = Тип("ДокументСсылка.ЗаказНаПеремещение") Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("ВариантОбеспечения", Перечисления.ВариантыОбеспечения.СоСклада);
		НайденныеСтроки = ТаблицаДоступныхДействийТекущая.НайтиСтроки(Отбор);
		Для каждого ТекСтрока Из НайденныеСтроки Цикл
			ТаблицаДоступныхДействийТекущая.Удалить(ТекСтрока);
		КонецЦикла; 
		НайденныеСтроки = ТаблицаДоступныхДействий.НайтиСтроки(Отбор);
		Для каждого ТекСтрока Из НайденныеСтроки Цикл
			ТаблицаДоступныхДействий.Удалить(ТекСтрока);
		КонецЦикла;
		Отбор.Вставить("ВариантОбеспечения", Перечисления.ВариантыОбеспечения.ИзЗаказов);
		НайденныеСтроки = ТаблицаДоступныхДействийТекущая.НайтиСтроки(Отбор);
		Для каждого ТекСтрока Из НайденныеСтроки Цикл
			ТаблицаДоступныхДействийТекущая.Удалить(ТекСтрока);
		КонецЦикла; 
		НайденныеСтроки = ТаблицаДоступныхДействий.НайтиСтроки(Отбор);
		Для каждого ТекСтрока Из НайденныеСтроки Цикл
			ТаблицаДоступныхДействий.Удалить(ТекСтрока);
		КонецЦикла;
		//ОбновитьСписокВыбораДоступныхДействий();
	КонецЕсли; 
КонецПроцедуры
// end fix Suetin 19.02.2020 17:17:42