﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

&Вместо("ДокументыОснованияИмеютНоменклатуруТипаТовар")
Процедура ВИЛС_ДокументыОснованияИмеютНоменклатуруТипаТовар(Отказ)
	
	МассивВсехРаспоряжений = ДокументыОснования.ВыгрузитьКолонку("ДокументОснование");
	МассивРаспоряженийСТоварами = Документы.ТранспортнаяНакладная.ВИЛС_ПолучитьТолькоДокументыОснованияСТоварами(МассивВсехРаспоряжений, Отказ, ЗаданиеНаПеревозку);  // fix Suetin 23.09.2019 18:07:12    ПолучитьТолькоДокументыОснованияСТоварами
		
КонецПроцедуры

#КонецЕсли


