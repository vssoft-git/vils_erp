﻿
&НаСервереБезКонтекста
&ИзменениеИКонтроль("ИнициализироватьХозяйственныеОперацииИДокументы")
Функция ВИЛС_ИнициализироватьХозяйственныеОперацииИДокументы(ХозяйственныеОперацииИДокументы, ОтборХозяйственныеОперации, ОтборТипыДокументов, КлючНазначенияИспользования, ДокументыКОформлению)
#Вставка
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ИнвентаризацияНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ИнвентаризацияНМА.ПолноеИмя();
	Строка.КлючНазначенияИспользования  = "ИнвентаризацияНМА";
	Строка.ЗаголовокРабочегоМеста       = НСтр("ru = 'Инвентаризация НМА';
												|en = 'IA stocktaking'");
	Строка.ДобавитьКнопкуСоздать        = Истина;
#КонецВставки

	// ВнутреннееПотреблениеТоваров
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию;
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ВнутреннееПотреблениеТоваров.ПолноеИмя();
	Строка.КлючНазначенияИспользования 	= "РегламентированныйУчет";
	Строка.ДобавитьКнопкуСоздать        = Истина;

	// ВыработкаНМА
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ВыработкаНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ВыработкаНМА.ПолноеИмя();
	Строка.КлючНазначенияИспользования  = "РегламентированныйУчет";
	Строка.ДобавитьКнопкуСоздать        = Истина;

	// ИзменениеПараметровНМА
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ИзменениеПараметровНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ИзменениеПараметровНМА.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Изменение параметров НМА';
	|en = 'Change of IA parameters'");
	Строка.КлючНазначенияИспользования  = "РегламентированныйУчет";
	Строка.ДобавитьКнопкуСоздать        = Истина;

	// ПереоценкаНМА
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ПереоценкаНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ПереоценкаНМА.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Переоценка НМА';
	|en = 'IA revaluation'");
	Строка.КлючНазначенияИспользования  = "РегламентированныйУчет";
	Строка.ДобавитьКнопкуСоздать        = Истина;

	// ПодготовкаКПередачеНМА
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ПодготовкаКПередачеНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ПодготовкаКПередачеНМА.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Подготовка к передаче НМА';
	|en = 'Preparation for IA handover'");
	Строка.КлючНазначенияИспользования  = "РегламентированныйУчет";
	Строка.ДобавитьКнопкуСоздать        = Истина;

	// ПринятиеКУчетуНМА
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ПринятиеКУчетуНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ПринятиеКУчетуНМА.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Принятие к учету НМА';
	|en = 'IA recognition'");
	Строка.КлючНазначенияИспользования  = "РегламентированныйУчет";
	Строка.ДобавитьКнопкуСоздать        = Истина;

	// ПриобретениеУслугПрочихАктивов
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.ПриобретениеУслугПрочихАктивов.ПолноеИмя();
	Строка.КлючНазначенияИспользования  = "РегламентированныйУчет";
	Строка.ДобавитьКнопкуСоздать        = Истина;

	// РеализацияУслугПрочихАктивов
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.РеализацияКлиенту;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.РеализацияУслугПрочихАктивов.ПолноеИмя();
	Строка.КлючНазначенияИспользования  = "РегламентированныйУчет";
	Строка.ДобавитьКнопкуСоздать        = Истина;

	// СписаниеНМА
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация        = Перечисления.ХозяйственныеОперации.СписаниеНМА;
	Строка.ПолноеИмяДокумента           = Метаданные.Документы.СписаниеНМА.ПолноеИмя();
	Строка.ДокументПредставление        = НСтр("ru = 'Списание НМА';
	|en = 'IA retirement'");
	Строка.КлючНазначенияИспользования  = "РегламентированныйУчет";
	Строка.ДобавитьКнопкуСоздать        = Истина;

	ТаблицаЗначенийДоступно = ОбщегоНазначенияУТ.ДоступныеХозяйственныеОперацииИДокументы(
	ХозяйственныеОперацииИДокументы, 
	ОтборХозяйственныеОперации, 
	ОтборТипыДокументов, 
	КлючНазначенияИспользования);

	Возврат ТаблицаЗначенийДоступно;

КонецФункции
