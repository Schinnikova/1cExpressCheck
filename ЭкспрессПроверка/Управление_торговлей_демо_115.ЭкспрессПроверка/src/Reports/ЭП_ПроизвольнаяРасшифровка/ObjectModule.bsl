#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

    Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;

КонецПроцедуры 

Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, Настройки, ПользовательскиеНастройки) Экспорт

	Если КлючСхемы <> "1" Тогда
		
		КлючСхемы = "1";
		
		Если ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения") Тогда
			Схема = ПолучитьИзВременногоХранилища(Контекст.НастройкиОтчета.АдресСхемы);
			ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, Схема, КлючСхемы);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

# КонецОбласти

#КонецЕсли