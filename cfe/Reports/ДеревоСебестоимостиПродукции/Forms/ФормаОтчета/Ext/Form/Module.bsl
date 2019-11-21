﻿
&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Команда = Команды.Добавить("ПодключаемаяКоманда_КомандаПечати");
	Команда.Действие  = "Подключаемый_Команда";
	Команда.Заголовок = НСтр("ru = 'Печать';
							|en = 'Print'");
	
	Кнопка = Элементы.Добавить(Команда.Имя, Тип("КнопкаФормы"), Элементы.ГруппаПрограммныйИнтерфейс);
	Кнопка.ИмяКоманды = Команда.Имя;
	
	ПостоянныеКоманды.Добавить(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
&После("Подключаемый_Команда")
Процедура ВИЛС_Подключаемый_Команда(Команда)
	Если НЕ ЭтотОбъект.ОтчетСформирован Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Отчет не сформирован';
																|en = 'Отчет не сформирован'"));
		Возврат;
	КонецЕсли;
	Если Команда.Имя = "ПодключаемаяКоманда_КомандаПечати" Тогда
		ТабДок = СформироватьПечать_ДеревоСебестоимостиПродукции();
		
		//Создаём новую коллекцию печатных форм
		КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("Печать_ДеревоСебестоимостиПродукции");
		
		//Добавляем в коллекцию сформированный табличный документ
		КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
		
		//Устанавливаем параметры печати (при необходимости)
		КоллекцияПечатныхФорм[0].Экземпляров = 1;
		КоллекцияПечатныхФорм[0].СинонимМакета = "Печать_ДеревоСебестоимостиПродукции";  //Так будет выглядеть имя файла при сохранении в файл из формы "Печать документов"
		
		//Вывод через стандартную процедуру БСП
	 	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, Неопределено, ЭтаФорма);
	

		//ПодключаемаяКоманда_КомандаПечатиНаСевере();	
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция СформироватьПечать_ДеревоСебестоимостиПродукции()
	ДеревоРезультат = РеквизитФормыВЗначение("ПолноеДеревоСебестоимости");
	Возврат(Отчеты.ДеревоСебестоимостиПродукции.СформироватьПечать_ДеревоСебестоимостиПродукции(ЭтотОбъект, ДеревоРезультат));	
КонецФункции	