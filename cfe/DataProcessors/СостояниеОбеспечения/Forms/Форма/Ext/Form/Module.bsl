﻿
&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	НоваяКоманда = Команды.Добавить("ВИЛС_ВывестиНаПечать");
	НоваяКоманда.Действие = "ВывестиНаПечать";
	
	НоваяКнопка = Элементы.Добавить("ВИЛС_ВывестиНаПечать",Тип("КнопкаФормы"),Элементы.КоманднаяПанельСверху);
	НоваяКнопка.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
	НоваяКнопка.Заголовок = "Печать";
	НоваяКнопка.ИмяКоманды = "ВИЛС_ВывестиНаПечать";
	НоваяКнопка.Картинка =БиблиотекаКартинок.Печать;
	
КонецПроцедуры


&НаКлиенте
Процедура ВывестиНаПечать(Кнопка)
	
	ТабДок = ВывестиНаПечатьНаСервере();
	ТабДок.ОтображатьСетку = Ложь; 
	//ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать("Состояние обеспечения заказов");
	
КонецПроцедуры

&НаСервере
Функция ВывестиНаПечатьНаСервере()
	Строки = Товары.ПолучитьЭлементы();
	
	
	ТекДерево = ДанныеФормыВЗначение(Товары,Тип("ДеревоЗначений"));
	Колонки = ТекДерево.Колонки;
	Строки = ТекДерево.Строки;
	Макет = ПолучитьОбщийМакет("ВИЛС_СостояниеОбеспеченияЗаказов"); 
	ТабЗаголовокНачало = Макет.ПолучитьОбласть("Заголовок|Основное");
	ТабЗаголовокРезервКДате = Макет.ПолучитьОбласть("Заголовок|РезервКДате");
	ТабЗаголовокОкончание = Макет.ПолучитьОбласть("Заголовок|Окончание");
	ТабДок = Новый ТабличныйДокумент;
	
	ТабДок.Вывести(ТабЗаголовокНачало);
	
	КоличествоИтераций = (Колонки.Количество() - 55)/3;
	
	НомерКолонки = 0; 
	Шаг = 0;
	Если КоличествоИтераций Тогда
		Для СЧ = 0 по КоличествоИтераций Цикл
			
			НомерКолонки = 55+СЧ+Шаг;
			ЗначениеЗаголовка = Прав(Колонки[НомерКолонки].Имя,8);
			ТабЗаголовокРезервКДате.Параметры.Дата = Дата(Число(Прав(ЗначениеЗаголовка,4)),Число(Сред(ЗначениеЗаголовка,3,2)),Число(Лев(ЗначениеЗаголовка,2)));
			ТабДок.Присоединить(ТабЗаголовокРезервКДате);
			//Сообщить(Колонки[НомерКолонки].Имя);
			
			Шаг = СписокКолонок.Количество();//Шаг = 3;          // fix Suetin 28.12.2019 15:01:36
		КонецЦикла;
	КонецЕсли;	
	ТабДок.Присоединить(ТабЗаголовокОкончание);
	
	Область = ТабДок.Область("R5C7:R5C"+(КоличествоИтераций+7));
	Область.Объединить();
	
	Если Не Строки.Количество() Тогда
		Возврат ТабДок;
	КонецЕсли;
	
	Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
	НомерГруппы = 0;
	Для Каждого СтрокаЗаказа ИЗ Строки Цикл
		НомерГруппы = НомерГруппы+1; 
		СтрокиНоменклатуры = СтрокаЗаказа.Строки;
		ТабЗаказНачало = Макет.ПолучитьОбласть("Заказ|Основное");
		ТабЗаказРезервКДате = Макет.ПолучитьОбласть("Заказ|РезервКДате");
		ТабЗаказОкончание = Макет.ПолучитьОбласть("Заказ|Окончание");
		ТабЗаказНачало.Параметры.ЗаказКлиент =  СтрокаЗаказа.ЗаказПредставление+"/"+СтрокаЗаказа.Партнер;
		ЗаполнитьЗначенияСвойств(ТабЗаказНачало.Параметры,СтрокаЗаказа);
		ТабДок.Вывести(ТабЗаказНачало);	
		НомерКолонки = 0; 
		Шаг = 0;
		Для СЧ = 0 по КоличествоИтераций Цикл
			
			НомерКолонки = 55+СЧ+Шаг;
			ТабДок.Присоединить(ТабЗаказРезервКДате);
			
			Шаг = СписокКолонок.Количество();//Шаг = 3;          // fix Suetin 28.12.2019 15:03:33
		КонецЦикла;
		КоличествоИтог = 0;
		Для Каждого СтрокаНоменклатуры Из СтрокиНоменклатуры Цикл
			КоличествоИтог = КоличествоИтог+СтрокаНоменклатуры.КоличествоНеОбеспечено;
		КонецЦикла;		
		
		ЗаполнитьЗначенияСвойств(ТабЗаказОкончание.Параметры,СтрокаЗаказа);
		ТабЗаказОкончание.Параметры.КоличествоНеОбеспечено = КоличествоИтог;
		ТабДок.Присоединить(ТабЗаказОкончание);
		ТабДок.НачатьГруппуСтрок("Группа"+НомерГруппы);
		
		Для Каждого СтрокаНоменклатуры Из СтрокиНоменклатуры Цикл
			ТабНоменклатураНачало = Макет.ПолучитьОбласть("Номенклатура|Основное");
			ТабНоменклатураРезервКДате = Макет.ПолучитьОбласть("Номенклатура|РезервКДате");
			ТабНоменклатураОкончание = Макет.ПолучитьОбласть("Номенклатура|Окончание");
			НомерКолонки = 0; 
			Шаг = 0;
			ЗаполнитьЗначенияСвойств(ТабНоменклатураНачало.Параметры,СтрокаНоменклатуры);
			ТабДок.Вывести(ТабНоменклатураНачало);
			Для СЧ = 0 по КоличествоИтераций Цикл
				
				НомерКолонки = 55+СЧ+Шаг;
				ИмяКолонки = Колонки[НомерКолонки].Имя;
				ТабНоменклатураРезервКДате.Параметры.РезервКДате = СтрокаНоменклатуры[ИмяКолонки];
				ТабДок.Присоединить(ТабНоменклатураРезервКДате);
				//Сообщить(Колонки[НомерКолонки].Имя);
				
				Шаг = СписокКолонок.Количество();//Шаг = 3;   // fix Suetin 28.12.2019 15:03:28
			КонецЦикла;
			ЗаполнитьЗначенияСвойств(ТабНоменклатураОкончание.Параметры,СтрокаНоменклатуры);
			ТабДок.Присоединить(ТабНоменклатураОкончание);
		КонецЦикла;
		ТабДок.ЗакончитьГруппуСтрок();
	КонецЦикла;
	
	Возврат(ТабДок);
КонецФункции
