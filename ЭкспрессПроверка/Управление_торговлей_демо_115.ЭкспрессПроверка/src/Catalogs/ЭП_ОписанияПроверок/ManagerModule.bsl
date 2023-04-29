#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Помещает во временное хранилище схему компоновки данных,
// настройки компоновки данных и возвращает их адреса
//
// Параметры:
//	ОтчетСсылка - СправочникСсылка.ЭП_ОписанияПроверок - отчет, для которой требуется получить адреса
//
// Возвращаемое значение:
//	Структура - структура, содержащая адреса:
//		*СхемаКомпоновкиДанных - Строка, Неопределено - адрес схемы компоновки данных
//		*НастройкиКомпоновкиДанных - Строка, Неопределено - адрес настроек компоновки данных.
Функция АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище(ОтчетСсылка) Экспорт

	Адреса = Новый Структура("СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных", Неопределено, Неопределено);

	Если ТипЗнч(ОтчетСсылка) = Тип("ДанныеФормыСтруктура") Тогда
		ОписаниеПроверкиСсылка = ОтчетСсылка.Ссылка;
	Иначе
		ОписаниеПроверкиСсылка = ОтчетСсылка;
	КонецЕсли;

	СхемаОтчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОписаниеПроверкиСсылка, "СхемаКомпоновкиДанных, ХранилищеСхемыКомпоновкиДанных"); 
	// Получим схему компоновки данных
	Если ЗначениеЗаполнено(ОтчетСсылка.СхемаКомпоновкиДанных) ИЛИ СхемаОтчета.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		СхемаИНастройки = ОписаниеИСхемаКомпоновкиДанныхПоИмениМакета(ОписаниеПроверкиСсылка, СхемаОтчета.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
	Иначе
		СхемаКомпоновкиДанных = СхемаОтчета.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;

	Если СхемаКомпоновкиДанных = Неопределено Тогда
		Если ПустаяСтрока(ОтчетСсылка.СхемаКомпоновкиДанных) Тогда
			СхемаКомпоновкиДанных = ПолучитьМакет("ШаблоннаяСхемаКомпоновкиДанных");
		Иначе
			СхемаКомпоновкиДанных = ПолучитьМакет(ОтчетСсылка.СхемаКомпоновкиДанных);
		КонецЕсли;
	КонецЕсли;

	Адреса.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());

	Настройки = СхемаОтчета.ХранилищеНастроекКомпоновкиДанных.Получить();

	Если ЗначениеЗаполнено(Настройки) Тогда
		Адреса.НастройкиКомпоновкиДанных = ПоместитьВоВременноеХранилище(Настройки, Новый УникальныйИдентификатор());
	Иначе	
		КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		Настройки = КомпоновщикНастроекКомпоновкиДанных.ПолучитьНастройки();
		Адреса.НастройкиКомпоновкиДанных = ПоместитьВоВременноеХранилище(Настройки, Новый УникальныйИдентификатор());
	КонецЕсли;

	Возврат Адреса;

КонецФункции

// Функция возвращает структуру с синонимом и схемой компоновки данных по имени макета
//
// Параметры:
//	ОтчетСсылка -СправочникСсылка.ЭП_ОписанияПроверок - отчет, для которой требуется получить схему
//	ИмяМакета - Строка, Неопределено - имя получаемого макета схемы компоновки данных
//
// Возвращаемое значение:
//	Структура - Описание и схема компоновки данных:
//		* Описание - Строка - синоним получаемого макета
//		* СхемаКомпоновкиДанных - СхемаКомпоновкиДанных, Неопределено - найденная схема компоновки данных
//		* НастройкиКомпоновкиДанных - НастройкиКомпоновкиДанных, Неопределено - найденные настройки компоновки данных
//
Функция ОписаниеИСхемаКомпоновкиДанныхПоИмениМакета(ОтчетСсылка, ИмяМакета = Неопределено) Экспорт

	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Описание",					"");
	ВозвращаемоеЗначение.Вставить("СхемаКомпоновкиДанных",		Неопределено);
	ВозвращаемоеЗначение.Вставить("НастройкиКомпоновкиДанных",	Неопределено);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОписанияПроверок.ХранилищеСхемыКомпоновкиДанных КАК ХранилищеСхемыКомпоновкиДанных,
	|	ОписанияПроверок.ХранилищеНастроекКомпоновкиДанных КАК ХранилищеНастроекКомпоновкиДанных
	|ИЗ
	|	Справочник.ОписанияПроверок КАК ОписанияПроверок
	|ГДЕ
	|	ОписанияПроверок.Ссылка = &ОтчетСсылка");

	Запрос.УстановитьПараметр("ОтчетСсылка", ОтчетСсылка);

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();

	Если НЕ ЗначениеЗаполнено(ИмяМакета) Тогда

		ВозвращаемоеЗначение.Описание = ИмяМакета;
		Если Выборка.Следующий() Тогда
			ВозвращаемоеЗначение.СхемаКомпоновкиДанных = Выборка.ХранилищеСхемыКомпоновкиДанных.Получить();
			ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
		КонецЕсли;

	Иначе

		Макет = Метаданные.НайтиПоТипу(ТипЗнч(ОтчетСсылка)).Макеты.Найти(ИмяМакета);
		Если НЕ Макет = Неопределено Тогда
			ВозвращаемоеЗначение.Описание = Макет.Синоним;
			ВозвращаемоеЗначение.СхемаКомпоновкиДанных = ПолучитьМакет(ИмяМакета);
			Если Выборка.Следующий() Тогда
				ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;

	Возврат ВозвращаемоеЗначение;

КонецФункции

// Возвращает пользовательские настройки по умолчанию
//
// Параметры:
//	ОтчетСсылка - СправочникСсылка.ЭП_ОписанияПроверок - цель, для которой требуется получить настройки
//
// Возвращаемое значение:
//	ПользовательскиеНастройкиКомпоновкиДанных - пользовательские настройки по умолчанию
//
Функция ПользовательскиеНастройкиПоУмолчанию(ОтчетСсылка) Экспорт

	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;

	// Получим схему компоновки данных
	СхемаИНастройкиОтчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОтчетСсылка, "СхемаКомпоновкиДанных, ХранилищеСхемыКомпоновкиДанных");
	Если ЗначениеЗаполнено(СхемаИНастройкиОтчета.СхемаКомпоновкиДанных) ИЛИ СхемаИНастройкиОтчета.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		СхемаИНастройкиОтчета = ОписаниеИСхемаКомпоновкиДанныхПоИмениМакета(ОтчетСсылка, СхемаИНастройкиОтчета.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройкиОтчета.СхемаКомпоновкиДанных;
	Иначе
		СхемаКомпоновкиДанных = СхемаИНастройкиОтчета.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;

	Настройки = СхемаИНастройкиОтчета.ХранилищеНастроекКомпоновкиДанных.Получить();

	АдресСКД = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);

	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	Если НЕ Настройки = Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;

	Возврат КомпоновщикНастроек.ПользовательскиеНастройки;

КонецФункции

// Возвращает массив с именами схемам компоновок
//
// Возвращаемое значение:
//	Массив из Структура:
//	* Имя - Строка - имя макета
//	* Синоним - Строка - синоним макета
Функция ШаблоныСхемыКомпоновкиДанных() Экспорт

	Шаблоны = Новый Массив;

	Для Каждого Макет Из Метаданные.Справочники.ЭП_ОписанияПроверок.Макеты Цикл

		Если Макет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда

			Продолжить;

		КонецЕсли;

		Шаблоны.Добавить(Новый Структура("Имя, Синоним", Макет.Имя, Макет.Синоним));

	КонецЦикла;

	Возврат Шаблоны;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - Проверка уникальности справочника по наименованию
//
// Параметры:
// Объект				- СправочникОбъект.ЭП_ОписанияПроверок
// Возвращаемое значение:
// Булево - признак уникальности наименования данного элемента справочника
Функция НаименованиеУникально(Объект) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОписанияПроверок.Ссылка КАК Номенклатура
	|ИЗ
	|	Справочник.ОписанияПроверок КАК ОписанияПроверок
	|ГДЕ
	|	ОписанияПроверок.Ссылка <> &Ссылка
	|	И ОписанияПроверок.Наименование = &Наименование
	|	И НЕ ОписанияПроверок.ЭтоГруппа";

	Запрос.УстановитьПараметр("Ссылка",		Объект.Ссылка);
	Запрос.УстановитьПараметр("Наименование", Объект.Наименование);

	Возврат Запрос.Выполнить().Пустой();

КонецФункции

#КонецОбласти

#КонецЕсли
