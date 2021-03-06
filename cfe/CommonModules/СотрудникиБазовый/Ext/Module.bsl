
&ИзменениеИКонтроль("Печать")
Процедура ВИЛС_Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ТрудовойДоговорМикропредприятий") Тогда
		ПечатьТрудовойДоговорМикропредприятий(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т1") Тогда
		ПечатьТ1(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
#Удаление
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т2") Тогда
		ПечатьТ2(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
#КонецУдаления
#Вставка
// Здесь можно описать новое поведение.
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т2") Тогда
		ПечатьТ2(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т2_ВУР_ВИЛС") Тогда
		ВИЛС_ПечатьТ2_ВУР(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
#КонецВставки
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т5") Тогда
		ПечатьТ5(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_Т8") Тогда
		ПечатьТ8(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;	

КонецПроцедуры

// Печать такая-же, как ПечатьТ2,только макет ПФ_MXL_Т2_ВУР_ВИЛС и настройка компоновки Т3_ВУР_ВИЛС (Личные карточки (Т-2 ВУР ВИЛС))  // fix Suetin 26.04.2021 15:06:59
Процедура ВИЛС_ПечатьТ2_ВУР(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) 
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ОтчетТ2 = Отчеты.УнифицированнаяФормаТ2.Создать();
	ОтчетТ2.ИнициализироватьОтчет();
	ОтчетТ2.КомпоновщикНастроек.ЗагрузитьНастройки(ОтчетТ2.СхемаКомпоновкиДанных.ВариантыНастроек.Т2_ВУР_ВИЛС.Настройки);  // fix Suetin 26.04.2021 15:09:23 в типовом отчете настройка Т2
	
	Отбор = ОтчетТ2.КомпоновщикНастроек.Настройки.Отбор;
	
	Отбор.Элементы.Очистить();
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Сотрудник", ВидСравненияКомпоновкиДанных.ВСписке, МассивОбъектов);
	
	ОтчетТ2.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОбъектыПечати", ОбъектыПечати);
	
	ОтчетТ2.СкомпоноватьРезультат(ДокументРезультат);
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		КоллекцияПечатныхФорм,
		"ПФ_MXL_Т2_ВУР_ВИЛС", НСтр("ru = 'Личная карточка (Т-2 ВУР ВИЛС)';
							|en = 'Employee data card (T-2 VUR VILS)'"),
		ДокументРезультат, ,);
		
КонецПроцедуры

