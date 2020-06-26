﻿
&После("ПриСозданииНаСервере")
Процедура ВИЛС_ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка)
	Если Форма.ИмяФормы = "Документ.ВедомостьНаВыплатуЗарплатыВБанк.Форма.ФормаДокумента" Тогда
		Если Не Форма.Элементы.Найти("СоставВзысканнаяСумма") = Неопределено 
				и Не ЗначениеЗаполнено(Форма.Элементы.СоставВзысканнаяСумма.ПутьКДаннымПодвала) Тогда
			ДобавляемыеРеквизиты = Новый Массив;	
			РеквизитСтаж = Новый РеквизитФормы("ВИЛС_СоставВзысканнаяСумма", Новый ОписаниеТипов("Число"),, "Взыскано", Истина);
			ДобавляемыеРеквизиты.Добавить(РеквизитСтаж);
			Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
			
			ПолеВводаСоставВзысканнаяСумма = Форма.Элементы.Вставить("ВИЛС_СоставВзысканнаяСумма", Тип("ПолеФормы"), Форма.Элементы.Состав, Форма.Элементы.Состав.ПодчиненныеЭлементы.СоставВзысканнаяСумма);
			ПолеВводаСоставВзысканнаяСумма.Вид = ВидПоляФормы.ПолеВвода;
			ПолеВводаСоставВзысканнаяСумма.Заголовок = "Взыскано";
			ПолеВводаСоставВзысканнаяСумма.ПутьКДанным = "Объект.Состав.ВзысканнаяСумма";
			ПолеВводаСоставВзысканнаяСумма.РастягиватьПоГоризонтали = Ложь;
			ПолеВводаСоставВзысканнаяСумма.ОтображатьВШапке = Истина;
			ПолеВводаСоставВзысканнаяСумма.ОтображатьВПодвале = Истина;
			ПолеВводаСоставВзысканнаяСумма.ПутьКДаннымПодвала = "Объект.Состав.ИтогВзысканнаяСумма";
			
			Форма.Элементы.СоставВзысканнаяСумма.Видимость = Ложь;
		КонецЕсли; 
	Иначе
	КонецЕсли; 
КонецПроцедуры
