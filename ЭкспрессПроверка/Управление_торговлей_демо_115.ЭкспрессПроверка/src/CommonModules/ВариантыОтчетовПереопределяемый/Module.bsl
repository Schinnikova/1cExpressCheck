#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

&После("НастроитьВариантыОтчетов")
Процедура ЭП_НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ОписаниеОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ЭП_ПроизвольнаяРасшифровка);
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
