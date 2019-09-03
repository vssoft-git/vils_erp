﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

&Вместо("СформироватьПечатнуюФормуТ13")
Функция ВИЛС_СформироватьПечатнуюФормуТ13(МассивОбъектов, ОбъектыПечати)
	
	НастройкиПечатныхФорм = ЗарплатаКадры.НастройкиПечатныхФорм();
	
	ВидВремениВыходной = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.ВыходныеДни");
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УНИФИЦИРОВАННАЯ_ФОРМА_Т_13";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_УнифицированнаяФормаТ13");
	
	РезультатыЗапросаПоДокументам = СформироватьЗапросДляПечати(МассивОбъектов);
	
	КоличествоРезультатов = РезультатыЗапросаПоДокументам.Количество();
	
	ВыборкаПоДаннымДокументов = РезультатыЗапросаПоДокументам[КоличествоРезультатов - 2].Выбрать();
	
	ДанныеДокументов = Новый Соответствие;
	
	Пока ВыборкаПоДаннымДокументов.Следующий() Цикл
		
		ДанныеДокумента = Новый Структура("Дата, ДатаНачалаПериода, ДатаОкончанияПериода, Номер, ОрганизацияНаименование, Подразделение, ПодразделениеНаименование, ОрганизацияКодПоОКПО"
			+ ",ФИОРуководителя,ДолжностьРуководителя,ФИОКадровика,ДолжностьКадровика,ФИООтветственного,ДолжностьОтветственного");
		ЗаполнитьЗначенияСвойств(ДанныеДокумента, ВыборкаПоДаннымДокументов);
		ДанныеДокументов.Вставить(ВыборкаПоДаннымДокументов.Ссылка, ДанныеДокумента);
		
	КонецЦикла;	
	
	ВыборкаДанныхОВремени = РезультатыЗапросаПоДокументам[КоличествоРезультатов - 1].Выбрать();
	
	ВидВремениКомандировка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Командировка");
	
	ТекущийЛист = Новый ТабличныйДокумент;
	ТекущийЛист.АвтоМасштаб = Истина;
	ТекущийЛист.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;	
	Пока ВыборкаДанныхОВремени.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТекущийЛист = Новый ТабличныйДокумент;
			ТекущийЛист.АвтоМасштаб = Истина;
			ТекущийЛист.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли; 
		
		ДанныеДокумента = ДанныеДокументов[ВыборкаДанныхОВремени.Ссылка];
		
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
		ОбластьШапкаПараметры = Новый Структура("ДатаЗаполнения,НомерДокумента,ДатаНачала,ДатаОкончания,ОрганизацияНаименование,СообщениеОНеприменимостиПечатнойФормы,ПодразделениеНаименование,ОрганизацияКодПоОКПО");
		ОбластьШапкаПараметры.ДатаЗаполнения = ДанныеДокумента.Дата;
		ОбластьШапкаПараметры.НомерДокумента = ДанныеДокумента.Номер;
		ОбластьШапкаПараметры.ДатаНачала = ДанныеДокумента.ДатаНачалаПериода;
		ОбластьШапкаПараметры.ДатаОкончания = ДанныеДокумента.ДатаОкончанияПериода;
		ОбластьШапкаПараметры.ОрганизацияНаименование = ДанныеДокумента.ОрганизацияНаименование;
		ОбластьШапкаПараметры.ОрганизацияКодПоОКПО = ДанныеДокумента.ОрганизацияКодПоОКПО;
		
		ОбластьШапкаПараметры.СообщениеОНеприменимостиПечатнойФормы = 
			ЗарплатаКадры.СообщениеОНеприменимостиПечатнойФормы(
				ДанныеДокумента.Дата,
				'20150619',
				"Приказа Минфина РФ",
				'20150330',
				"52н");
		
		Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений И ЗначениеЗаполнено(ДанныеДокумента.Подразделение) Тогда
			ОбластьШапкаПараметры.ПодразделениеНаименование = ДанныеДокумента.Подразделение.ПолноеНаименование();
		Иначе
			ОбластьШапкаПараметры.ПодразделениеНаименование = ДанныеДокумента.ПодразделениеНаименование;
		КонецЕсли;
		
		ОбластьШапка.Параметры.Заполнить(ОбластьШапкаПараметры);
		
		ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
		
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		ТекущийЛист.Вывести(ОбластьШапка);
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
		ТекущийЛист.Вывести(ОбластьШапкаТаблицы);

		НомерСотрудника = 0;
		ОбластьДанныеОВремени = Макет.ПолучитьОбласть("Строка");
		
		ИменаПараметровДанныеОВремени = "Сотрудник,ТабельныйНомер,НомерПП,ДниПерваяПоловина,ЧасыПерваяПоловина,ДниВтораяПоловина,ЧасыВтораяПоловина,ДниЗаМесяц,ЧасыЗаМесяц";
		
		Пока ВыборкаДанныхОВремени.СледующийПоЗначениюПоля("Сотрудник") Цикл
			
			ОтработаноДнейЗаПервуюПоловинуМесяца = 0;
			ОтработаноЧасовЗаВторуюПоловинуМесяца = 0;
			ОтработаноДнейЗаВторуюПоловинуМесяца = 0;
			ОтработаноЧасовЗаПервуюПоловинуМесяца = 0;
			
			//begin fix Клещ А.Н. 09.07.2019  
			ОтработаноВечернихЧасовЗаПервуюПоловинуМесяца = 0;
			ОтработаноНочныхЧасовЗаПервуюПоловинуМесяца = 0;
			ОтработаноВечернихЧасовЗаВторуюПоловинуМесяца = 0;
			ОтработаноНочныхЧасовЗаВторуюПоловинуМесяца = 0;
			//end fix Клещ А.Н. 09.07.2019
			
			ОтработаноДнейЗаМесяц = 0;
			ОтработаноЧасовЗаМесяц = 0;
			НомерСотрудника = НомерСотрудника + 1;
			ОбластьДанныеОВремениПараметры = Новый Структура(ИменаПараметровДанныеОВремени);
			
			Если НомерСотрудника > 1 Тогда
				ВывестиДанныеСотрудникаВКоллекцию(ТабличныйДокумент, ТекущийЛист, ОбластьДанныеОВремени, ОбластьШапкаТаблицы);
				ОбластьДанныеОВремени = Макет.ПолучитьОбласть("Строка");
			КонецЕсли;
			
			Если НастройкиПечатныхФорм.ВыводитьПолныеФИОВСписочныхПечатныхФормах Тогда
				ФИО = ВыборкаДанныхОВремени.ФИОПолные;
			Иначе
				ФИО = ВыборкаДанныхОВремени.ФамилияИО;
			КонецЕсли;
			
			ОбластьДанныеОВремениПараметры.Сотрудник = ФИО + "
													|(" + ВыборкаДанныхОВремени.Должность + ")";
													
			ОбластьДанныеОВремениПараметры.ТабельныйНомер = ВыборкаДанныхОВремени.ТабельныйНомер;
			
			ОбластьДанныеОВремениПараметры.НомерПП = НомерСотрудника;
			
			ОтклоненияПоСотруднику = Новый ТаблицаЗначений;
			ОтклоненияПоСотруднику.Колонки.Добавить("ВидВремени");
			ОтклоненияПоСотруднику.Колонки.Добавить("БуквенныйКод");
			ОтклоненияПоСотруднику.Колонки.Добавить("Часов");
			ОтклоненияПоСотруднику.Колонки.Добавить("Дней");
			
			Пока ВыборкаДанныхОВремени.СледующийПоЗначениюПоля("Дата") Цикл 
				ПредставлениеВидовВремени = "";
				ЧасыПоВидамВремениСтрока = "";
				
				КоличествоЗаписейНаДату = 0;
				ЭтоКомандировка = Ложь;
	
				РабочийДень = Ложь;
				Пока ВыборкаДанныхОВремени.Следующий() Цикл
					Если Не ВыборкаДанныхОВремени.РабочееВремя 
						И ВыборкаДанныхОВремени.ВидВремени <> ВидВремениВыходной
						И ВыборкаДанныхОВремени.ОсновноеВремя <> Справочники.ВидыИспользованияРабочегоВремени.ПустаяСсылка() Тогда
						
						ОтклоненияПоВидуВремени = ОтклоненияПоСотруднику.Добавить();
						
						ОтклоненияПоВидуВремени.ВидВремени = ВыборкаДанныхОВремени.ВидВремени;
						ОтклоненияПоВидуВремени.БуквенныйКод = ВыборкаДанныхОВремени.БуквенныйКод;
						ОтклоненияПоВидуВремени.Дней = 1;
						Если Не ВыборкаДанныхОВремени.Целосменное
							И Не ВыборкаДанныхОВремени.ВидВремениСплошнойРегистрации Тогда
							ОтклоненияПоВидуВремени.Часов = ВыборкаДанныхОВремени.Часов;
						КонецЕсли;
					КонецЕсли;
					
					ПредставлениеВидовВремени = ПредставлениеВидовВремени + "/"+  ВыборкаДанныхОВремени.БуквенныйКод;
					
					Если Не ВыборкаДанныхОВремени.Целосменное
						И Не ВыборкаДанныхОВремени.ВидВремениСплошнойРегистрации Тогда
						ЧасыПоВидамВремениСтрока = ЧасыПоВидамВремениСтрока +  "/" + Формат(ВыборкаДанныхОВремени.Часов, "ЧГ=");
					КонецЕсли;
					
					Если ВыборкаДанныхОВремени.РабочееВремя 
						И ВыборкаДанныхОВремени.ОсновноеВремя <> Справочники.ВидыИспользованияРабочегоВремени.ПустаяСсылка() Тогда
						
						РабочийДень = Истина;
						ОтработаноЧасовЗаМесяц = ОтработаноЧасовЗаМесяц + ВыборкаДанныхОВремени.Часов;
						
						Если День(ВыборкаДанныхОВремени.Дата) > 15 Тогда
							ОтработаноЧасовЗаВторуюПоловинуМесяца = ОтработаноЧасовЗаВторуюПоловинуМесяца + ВыборкаДанныхОВремени.Часов; 
							//begin fix Клещ А.Н. 09.07.2019  
							Если ВыборкаДанныхОВремени.ОсновноеВремя.БуквенныйКод = "Н" Тогда
								ОтработаноНочныхЧасовЗаВторуюПоловинуМесяца = ОтработаноНочныхЧасовЗаВторуюПоловинуМесяца + ВыборкаДанныхОВремени.Часов;
							ИначеЕсли ВыборкаДанныхОВремени.ОсновноеВремя.БуквенныйКод = "ВЧ" Тогда
								ОтработаноВечернихЧасовЗаВторуюПоловинуМесяца = ОтработаноВечернихЧасовЗаВторуюПоловинуМесяца + ВыборкаДанныхОВремени.Часов;
							КонецЕсли;
							//end fix Клещ А.Н. 09.07.2019
						Иначе
							ОтработаноЧасовЗаПервуюПоловинуМесяца = ОтработаноЧасовЗаПервуюПоловинуМесяца + ВыборкаДанныхОВремени.Часов;
							//begin fix Клещ А.Н. 09.07.2019  
							Если ВыборкаДанныхОВремени.ОсновноеВремя.БуквенныйКод = "Н" Тогда
								ОтработаноНочныхЧасовЗаПервуюПоловинуМесяца = ОтработаноНочныхЧасовЗаПервуюПоловинуМесяца + ВыборкаДанныхОВремени.Часов;
							ИначеЕсли ВыборкаДанныхОВремени.ОсновноеВремя.БуквенныйКод = "ВЧ" Тогда
								ОтработаноВечернихЧасовЗаПервуюПоловинуМесяца = ОтработаноВечернихЧасовЗаПервуюПоловинуМесяца + ВыборкаДанныхОВремени.Часов;
							КонецЕсли;
							//end fix Клещ А.Н. 09.07.2019

						КонецЕсли;
						
					КонецЕсли;
					
					КоличествоЗаписейНаДату = КоличествоЗаписейНаДату + 1;
					Если ВыборкаДанныхОВремени.ОсновноеВремя = ВидВремениКомандировка Тогда
						ЭтоКомандировка = Истина;
					КонецЕсли;	
					
				КонецЦикла;
				
				Если КоличествоЗаписейНаДату = 1
					И ЭтоКомандировка Тогда  
					
					ЧасыПоВидамВремениСтрока = "";
				КонецЕсли;
				
				Если РабочийДень Тогда
					ОтработаноДнейЗаМесяц = ОтработаноДнейЗаМесяц + 1;
					Если День(ВыборкаДанныхОВремени.Дата) > 15 Тогда
						ОтработаноДнейЗаВторуюПоловинуМесяца = ОтработаноДнейЗаВторуюПоловинуМесяца + 1;
					Иначе
						ОтработаноДнейЗаПервуюПоловинуМесяца = ОтработаноДнейЗаПервуюПоловинуМесяца + 1;
					КонецЕсли;
				КонецЕсли;
				
				НомерДня = День(ВыборкаДанныхОВремени.Дата);
				
				ОбластьДанныеОВремениПараметры.Вставить("Символ" + НомерДня, Сред(ПредставлениеВидовВремени, 2));
				ОбластьДанныеОВремениПараметры.Вставить("ДополнительноеЗначение"+ НомерДня, Сред(ЧасыПоВидамВремениСтрока, 2));
				
			КонецЦикла;
			
			СуммаЯвокЗаПервуюПоловину = ОтработаноЧасовЗаПервуюПоловинуМесяца-ОтработаноВечернихЧасовЗаПервуюПоловинуМесяца-ОтработаноНочныхЧасовЗаПервуюПоловинуМесяца;
			СуммаЯвокЗаВторуюПоловину = ОтработаноЧасовЗаВторуюПоловинуМесяца-ОтработаноВечернихЧасовЗаВторуюПоловинуМесяца-ОтработаноНочныхЧасовЗаВторуюПоловинуМесяца;
			
			ЯвкиПерваяПоловина = ?(СуммаЯвокЗаПервуюПоловину,"Я"+СуммаЯвокЗаПервуюПоловину,"");
			ЯвкиВтораяПоловина = ?(СуммаЯвокЗаВторуюПоловину,"Я"+СуммаЯвокЗаВторуюПоловину,"");
			ЯвкиЗаМесяц        = ?(СуммаЯвокЗаПервуюПоловину+СуммаЯвокЗаВторуюПоловину,"Я"+(СуммаЯвокЗаПервуюПоловину+СуммаЯвокЗаВторуюПоловину),"");
			ВечерниеПерваяПоловина = ?(ОтработаноВечернихЧасовЗаПервуюПоловинуМесяца,"ВЧ"+ОтработаноВечернихЧасовЗаПервуюПоловинуМесяца,"");
			ВечерниеВтораяПоловина = ?(ОтработаноВечернихЧасовЗаВторуюПоловинуМесяца,"ВЧ"+ОтработаноВечернихЧасовЗаВторуюПоловинуМесяца,"");
			ВечерниеЗамесяц        = ?(ОтработаноВечернихЧасовЗаПервуюПоловинуМесяца+ОтработаноВечернихЧасовЗаВторуюПоловинуМесяца,"ВЧ"+(ОтработаноВечернихЧасовЗаПервуюПоловинуМесяца+ОтработаноВечернихЧасовЗаВторуюПоловинуМесяца),"");
			НочныеПерваяПоловина   = ?(ОтработаноНочныхЧасовЗаПервуюПоловинуМесяца,"Н"+ОтработаноНочныхЧасовЗаПервуюПоловинуМесяца,"");
			НочныеВтораяПоловина   = ?(ОтработаноНочныхЧасовЗаВторуюПоловинуМесяца,"Н"+ОтработаноНочныхЧасовЗаВторуюПоловинуМесяца,"");
			НочныеЗаМесяц          = ?(ОтработаноНочныхЧасовЗаПервуюПоловинуМесяца+ОтработаноНочныхЧасовЗаВторуюПоловинуМесяца,"Н"+(ОтработаноНочныхЧасовЗаПервуюПоловинуМесяца+ОтработаноНочныхЧасовЗаВторуюПоловинуМесяца),"");
			
			ОбластьДанныеОВремениПараметры.ДниПерваяПоловина = ОтработаноДнейЗаПервуюПоловинуМесяца;
			ОбластьДанныеОВремениПараметры.ЧасыПерваяПоловина = ""+ЯвкиПерваяПоловина+""+?(не ЯвкиПерваяПоловина="","/","")+""+ВечерниеПерваяПоловина+""+?(не ВечерниеПерваяПоловина="","/","")+""+НочныеПерваяПоловина+"/ "+ОтработаноЧасовЗаПервуюПоловинуМесяца;//Клещ А.Н. ОтработаноЧасовЗаПервуюПоловинуМесяца;
			ОбластьДанныеОВремениПараметры.ДниВтораяПоловина = ОтработаноДнейЗаВторуюПоловинуМесяца;
			ОбластьДанныеОВремениПараметры.ЧасыВтораяПоловина = ""+ЯвкиВтораяПоловина+""+?(не ЯвкиВтораяПоловина="","/","")+""+ВечерниеВтораяПоловина+""+?(не ВечерниеВтораяПоловина="","/","")+""+НочныеВтораяПоловина+"/ "+ОтработаноЧасовЗаВторуюПоловинуМесяца;//Клещ А.Н.ОтработаноЧасовЗаВторуюПоловинуМесяца;
			ОбластьДанныеОВремениПараметры.ДниЗаМесяц = ОтработаноДнейЗаМесяц;
			ОбластьДанныеОВремениПараметры.ЧасыЗаМесяц = ""+ЯвкиЗаМесяц+""+?(не ЯвкиЗаМесяц="","/","")+""+ВечерниеЗамесяц+""+?(не ВечерниеЗамесяц="","/","")+""+НочныеЗаМесяц+"/ "+ОтработаноЧасовЗаМесяц;//Клещ А.Н. ОтработаноЧасовЗаМесяц;
			
			ОтклоненияПоСотруднику.Свернуть("ВидВремени, БуквенныйКод", "Дней, Часов");
			
			СчОтклонений = 1;
			Для Каждого ОтклонениеПоВидуВремени Из ОтклоненияПоСотруднику Цикл
				Если СчОтклонений > 8 Тогда
					Прервать;
				КонецЕсли;
				
				ОбластьДанныеОВремениПараметры.Вставить("НеявкаКод" + СчОтклонений, ОтклонениеПоВидуВремени.БуквенныйКод);
				ОбластьДанныеОВремениПараметры.Вставить("НеявкаДниЧасы" + СчОтклонений, Формат(ОтклонениеПоВидуВремени.Дней, "ЧГ=")
					+ ?(ОтклонениеПоВидуВремени.Часов > 0, "(" + Формат(ОтклонениеПоВидуВремени.Часов, "ЧГ=") + ")", ""));
				
				СчОтклонений = СчОтклонений + 1;
			КонецЦикла;
			ОбластьДанныеОВремени.Параметры.Заполнить(ОбластьДанныеОВремениПараметры);
		КонецЦикла;
		
		
		ОбластьПодвал.Параметры.Заполнить(ДанныеДокумента);
 		Если НомерСотрудника > 0 Тогда
			ВывестиДанныеСотрудникаВКоллекцию(ТабличныйДокумент, ТекущийЛист, ОбластьДанныеОВремени, ОбластьШапкаТаблицы, ОбластьПодвал);
		Иначе
			ТабличныйДокумент.Вывести(ОбластьПодвал);
			ТекущийЛист.Вывести(ОбластьПодвал);
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДанныхОВремени.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции
	
#КонецЕсли