#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ,СтандартнаяОбработка)

	Заголовок = "Экспресс-проверка";

	УстановитьНастройкиПоУмолчанию(ЭтотОбъект);

	ЗаполнитьДеревоПроверок();

	// Включаем все проверки
	ИзменитьФлажкиУВсехПроверок(ЭтотОбъект, 1);

	Если Параметры.Свойство("ПараметрыФормы") Тогда
		ЗаполнитьЗначенияСвойств(Отчет, Параметры.ПараметрыФормы, "Организация, НачалоПериода, КонецПериода");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ,СтандартнаяОбработка)

	ВариантМодифицирован = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()

	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)

	// Дополнительно добавим в настройки ДеревоПроверок
	ДеревоПроверокОбъект = РеквизитФормыВЗначение("ДеревоПроверок");
	Настройки.ДополнительныеСвойства.Вставить("ДеревоПроверок", Новый ХранилищеЗначения(ДеревоПроверокОбъект));

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)

	// Перепишем из сохраненного дерева значения флажков в дерево на форме.
	Если Настройки <> Неопределено Тогда
		Если Настройки.ДополнительныеСвойства.Свойство("ДеревоПроверок") Тогда
			СохраненноеДеревоПроверок = Настройки.ДополнительныеСвойства.ДеревоПроверок.Получить();

			ДеревоПроверокОбъект = РеквизитФормыВЗначение("ДеревоПроверок");

			СохраненныеСтрокиДерева = СохраненноеДеревоПроверок.Строки;
			Для Каждого СохраненныйРаздел Из СохраненныеСтрокиДерева Цикл
				// На уровне раздела
				СтрокаДерева = ДеревоПроверокОбъект.Строки.Найти(СохраненныйРаздел.Идентификатор, "Идентификатор", Истина);
				Если СтрокаДерева <> Неопределено Тогда
					СтрокаДерева.Включить = СохраненныйРаздел.Включить;
				КонецЕсли;

				// На уровне отдельных проверок
				Для Каждого СохраненнаяСтрокаПроверки Из СохраненныйРаздел.Строки Цикл
					СтрокаДерева = ДеревоПроверокОбъект.Строки.Найти(СохраненнаяСтрокаПроверки.Идентификатор, "Идентификатор", Истина);
					Если СтрокаДерева <> Неопределено Тогда
						СтрокаДерева.Включить = СохраненнаяСтрокаПроверки.Включить;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;

			ЗначениеВРеквизитФормы(ДеревоПроверокОбъект, "ДеревоПроверок");

		КонецЕсли;
	КонецЕсли;

	// Если переданы конкретная организация и период, то используем их.
	Если Параметры.Свойство("ПараметрыФормы") Тогда
		ЗаполнитьЗначенияСвойств(Отчет, Параметры.ПараметрыФормы, "Организация, НачалоПериода, КонецПериода");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)

	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)

	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)

	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)

	Если ТипЗнч(Расшифровка) = Тип("СправочникСсылка.ЭП_ОписанияПроверок") Тогда
		СтандартнаяОбработка = Ложь;
		ОбработкаРасшифровкиОписанияПроверки(Расшифровка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПроверок

&НаКлиенте
Процедура ДеревоПроверокВключитьПриИзменении(Элемент)

	СтрокаДерева = ДеревоПроверок.НайтиПоИдентификатору(Элементы.ДеревоПроверок.ТекущаяСтрока);
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;

	// Запретим интерактивно ставить третье состояние флажка.
	СтрокаДерева.Включить = ?(СтрокаДерева.Включить = 2, 0, СтрокаДерева.Включить);

	Если СтрокаДерева.ПолучитьРодителя() = Неопределено Тогда
		// Поменяли состояние на верхнем уровне, распространим его на подчиненные элементы.
		ПодчиненныеСтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
		Для Каждого ПодчиненнаяСтрокаДерева Из ПодчиненныеСтрокиДерева Цикл
			ПодчиненнаяСтрокаДерева.Включить = СтрокаДерева.Включить;
		КонецЦикла;
	Иначе
		// Поменяли состояние на нижнем уровне, надо отметить для родителя.
		КоличествоВключенныхПодчиненныхЭлементов = 0;

		РодительскаяСтрока = СтрокаДерева.ПолучитьРодителя();
		ПодчиненныеСтрокиДерева = РодительскаяСтрока.ПолучитьЭлементы();
		Для Каждого ПодчиненнаяСтрокаДерева Из ПодчиненныеСтрокиДерева Цикл
			Если ПодчиненнаяСтрокаДерева.Включить <> 0 Тогда
				КоличествоВключенныхПодчиненныхЭлементов = КоличествоВключенныхПодчиненныхЭлементов + 1;
			КонецЕсли;
		КонецЦикла;

		Если КоличествоВключенныхПодчиненныхЭлементов = 0 Тогда
			// Отключены все элементы, значит строка верхнего уровня отключена полностью.
			РодительскаяСтрока.Включить = 0;
		ИначеЕсли КоличествоВключенныхПодчиненныхЭлементов = ПодчиненныеСтрокиДерева.Количество() Тогда
			// Включены все элементы, значит строка верхнего уровня включена полностью.
			РодительскаяСтрока.Включить = 1;
		Иначе
			// Не все включены.
			РодительскаяСтрока.Включить = 2;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажкиУВсехПроверок(Команда)

	ИзменитьФлажкиУВсехПроверок(ЭтотОбъект, 1);

КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажкиУВсехПроверок(Команда)

	ИзменитьФлажкиУВсехПроверок(ЭтотОбъект, 0);

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверку(Команда)

	РезультатВыполнения = СформироватьОтчетНаСервере();

	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);
	Иначе
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)

	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)

	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДеревоПроверок()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
					|	ОписанияПроверок.Ссылка КАК Идентификатор,
					|	ОписанияПроверок.Наименование КАК Наименование,
					|	ОписанияПроверок.Включить КАК Включить,
					|	ОписанияПроверок.ПредметКонтроля КАК ПредметКонтроля,
					|	ИСТИНА КАК ДоступноПодробноОПроверке
					|ИЗ
					|	Справочник.ЭП_ОписанияПроверок КАК ОписанияПроверок
					|ГДЕ
					|	ОписанияПроверок.ЭтоГруппа = ЛОЖЬ
					|	И ОписанияПроверок.Включить
					|	И НЕ ОписанияПроверок.ПометкаУдаления
					|
					|УПОРЯДОЧИТЬ ПО
					|	ОписанияПроверок.ЭтоГруппа,
					|	ОписанияПроверок.Ссылка
					|ИТОГИ ПО
					|	Идентификатор ТОЛЬКО ИЕРАРХИЯ
					|АВТОУПОРЯДОЧИВАНИЕ";
	ДеревоПроверокЗнач = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	ЗначениеВРеквизитФормы(ДеревоПроверокЗнач, "ДеревоПроверок");

КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере()

	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;

	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);

	ИдентификаторЗадания = Неопределено;

	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();

	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	ОтчетОбъект.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
	РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);

	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;

	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;

	Возврат РезультатВыполнения;

КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчетаНаСервере()

	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация", Отчет.Организация);
	ПараметрыОтчета.Вставить("Партнер", Отчет.Партнер);
	ПараметрыОтчета.Вставить("Контрагент", Отчет.Контрагент);
	ПараметрыОтчета.Вставить("Склад", Отчет.Склад);
	ПараметрыОтчета.Вставить("Номенклатура", Отчет.Номенклатура);
	ПараметрыОтчета.Вставить("НачалоПериода", Отчет.ПериодОтчета.ДатаНачала);
	ПараметрыОтчета.Вставить("КонецПериода", Отчет.ПериодОтчета.ДатаОкончания);
	ПараметрыОтчета.Вставить("КонецПериодаГраница", Новый Граница(Отчет.ПериодОтчета.ДатаОкончания, ВидГраницы.Включая));
	ПараметрыОтчета.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);

	ВыполняемыеПроверки = Новый Массив;
	Для Каждого ГруппаПроверок Из ДеревоПроверок.ПолучитьЭлементы() Цикл
		Если ГруппаПроверок.Включить = 0 Тогда
			Продолжить;
		КонецЕсли;
		ВыполняемыеПроверки.Добавить(ГруппаПроверок.Идентификатор);
		ИндексГруппировки = ВыполняемыеПроверки.ВГраница();
		Для Каждого Проверка Из ГруппаПроверок.ПолучитьЭлементы() Цикл
			Если Проверка.Включить = 0 Тогда
				Продолжить;
			КонецЕсли;
			ВыполняемыеПроверки.Добавить(Проверка.Идентификатор);
		КонецЦикла;
		// Если элементов нет, то и группу не добавляем
		Если ИндексГруппировки = ВыполняемыеПроверки.ВГраница() Тогда
			ВыполняемыеПроверки.Удалить(ИндексГруппировки);
		КонецЕсли;
	КонецЦикла;
	ПараметрыОтчета.Вставить("ВыполняемыеПроверки", ВыполняемыеПроверки);

	Возврат ПараметрыОтчета;

КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);

	Если ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
		Результат = РезультатВыполнения.Результат;
	КонецЕсли;

	ИдентификаторЗадания = Неопределено;

	УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьФлажкиУВсехПроверок(Форма,ЗначениеФлага)

	Для Каждого ЭлементДерева Из Форма.ДеревоПроверок.ПолучитьЭлементы() Цикл
		ЭлементДерева.Включить = ЗначениеФлага;
		Для Каждого ЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
			ЭлементДерева.Включить = ЗначениеФлага;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОтменитьВыполнениеЗадания()

	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()

	//Показатель = "Сумма";
	//ОбщегоНазначенияСлужебныйКлиент.РассчитатьПоказатели(ЭтотОбъект, "Результат", "РассчитатьСумму");

	//ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьНастройки()

	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()

	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;

КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиПоУмолчанию(ФормаОтчета)

	Отчет.ПериодОтчета.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСостояниеПоляТабличногоДокумента(ПолеТабличногоДокумента,Состояние = "НеИспользовать")

	Если ТипЗнч(ПолеТабличногоДокумента) = Тип("ПолеФормы") И ПолеТабличногоДокумента.Вид = ВидПоляФормы.ПолеТабличногоДокумента Тогда
		ОтображениеСостояния = ПолеТабличногоДокумента.ОтображениеСостояния;
		Если ВРег(Состояние) = "НЕИСПОЛЬЗОВАТЬ" Тогда
			ОтображениеСостояния.Видимость = Ложь;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
			ОтображениеСостояния.Картинка = Новый Картинка;
			ОтображениеСостояния.Текст = "";
		ИначеЕсли ВРег(Состояние) = "НЕАКТУАЛЬНОСТЬ" Тогда
			ОтображениеСостояния.Видимость = Истина;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
			ОтображениеСостояния.Картинка = Новый Картинка;
			ОтображениеСостояния.Текст = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" для получения отчета.'");
		ИначеЕсли ВРег(Состояние) = "ФОРМИРОВАНИЕОТЧЕТА" Тогда
			ОтображениеСостояния.Видимость = Истина;
			ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
			ОтображениеСостояния.Картинка = БиблиотекаКартинок.ДлительнаяОперация48;
			ОтображениеСостояния.Текст = НСтр("ru = 'Отчет формируется...'");
		Иначе
			ВызватьИсключение (НСтр("ru = 'Недопустимое значение параметра (параметр номер ''2'')'"));
		КонецЕсли;
	Иначе
		ВызватьИсключение (НСтр("ru = 'Недопустимое значение параметра (параметр номер ''1'')'"));
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруАдресаНаСервере(ОписаниеСсылка)

	Возврат Справочники.ЭП_ОписанияПроверок.АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище(ОписаниеСсылка);

КонецФункции

&НаКлиенте
Асинх Процедура ОбработкаРасшифровкиОписанияПроверки(Расшифровка)

	// показать меню
	Список = Новый СписокЗначений;
	Список.Добавить("ОткрытьОписаниеПроверки", НСтр("ru = 'Открыть Описание проверки'"));
	Список.Добавить("ОткрытьОтчет", НСтр("ru = 'Открыть отчет в отдельном окне'"));
	Список.Добавить("ЗапуститьАвтоматическоеИсправление", НСтр("ru = 'Автоматическое исправление'"));

	Вид = Ждать ВыбратьИзМенюАсинх(Список);

	Если Вид = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Вид.Значение = "ОткрытьОтчет" Тогда
		// откроем отчет в отдельном окне с настройками из формы
		ОткрытьОтчетСНастройкамиИзФормы(Расшифровка);
	ИначеЕсли Вид.Значение = "ЗапуститьАвтоматическоеИсправление" Тогда
		// получим таблицу ошибок и выполним произвольный алгорим над ней
		ЗапуститьАвтоматическоеИсправлениеОшибок(Расшифровка);
	Иначе
		// Открыть Описание проверки
		ПоказатьЗначение(, Расшифровка);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетСНастройкамиИзФормы(ОписаниеПроверки)  
	
	СтруктураАдреса = ПолучитьСтруктуруАдресаНаСервере(ОписаниеПроверки);
	АдресНастройки = СтруктураАдреса.НастройкиКомпоновкиДанных;

	Если АдресНастройки = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось загрузить настройки отчета!'"));
		Возврат;
	КонецЕсли;

	Настройки = ПолучитьИзВременногоХранилища(АдресНастройки);
	Парам = ПолучитьПараметрыОткрытияОтчета(СтруктураАдреса.СхемаКомпоновкиДанных, Настройки, Строка(ОписаниеПроверки.УникальныйИдентификатор()));
	ОткрытьФорму("Отчет.ЭП_ПроизвольнаяРасшифровка.Форма", Парам, ЭтотОбъект, УникальныйИдентификатор);

КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыОткрытияОтчета(АдресСхемы, Настройки, КлючВарианта)
	
	Схема = ПолучитьИзВременногоХранилища(АдресСхемы);
	
	КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Схема));	
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	УстановитьПараметрыВНастройкахОтчета(КомпоновщикНастроекКомпоновкиДанных);
	УстановитьОтборыВНастройкахОтчета(КомпоновщикНастроекКомпоновкиДанных);
	
	ПараметрыОткрытия = Новый Структура; 	
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыОткрытия.Вставить("АдресСхемы", АдресСхемы);
	ПараметрыОткрытия.Вставить("Вариант", КомпоновщикНастроекКомпоновкиДанных.Настройки);
	ПараметрыОткрытия.Вставить("КлючВарианта", КлючВарианта);
	ПараметрыОткрытия.Вставить("ПользовательскиеНастройки", КомпоновщикНастроекКомпоновкиДанных.ПользовательскиеНастройки);
				
	Возврат ПараметрыОткрытия;

КонецФункции

&НаКлиенте
Асинх Процедура ЗапуститьАвтоматическоеИсправлениеОшибок(ОписаниеПроверки)

	ТекстВопроса = НСтр("ru = 'Будет выполнено автоматическое исправление ошибок. Продолжить?'");
	Ответ = Ждать ВопросАсинх(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗапуститьАвтоматическоеИсправлениеОшибокНаСервере(ОписаниеПроверки);
		ПоказатьПредупреждение(, НСтр("ru = 'Обработка выполнена!'"));
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗапуститьАвтоматическоеИсправлениеОшибокНаСервере(ОписаниеПроверки)

	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();

	// Таблица ошибок передается в алгоритм для обработки
	//@skip-check module-unused-local-variable
	ТаблицаОшибок = ОтчетОбъект.РезультатПроверки(ОписаниеПроверки, ПараметрыОтчета);

	УстановитьБезопасныйРежим(Истина);
	Выполнить(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОписаниеПроверки, "ТекстАлгоритма"));

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыВНастройкахОтчета(Настройки)
	
//	ДополнительныеПараметры = Новый Структура("ВПользовательскиеНастройки", Истина); 
	// установим отборы в настройках и в пользовательских настройках
	Если ЗначениеЗаполнено(Отчет.Организация) И КомпоновкаДанныхКлиентСервер.ПолеИспользуется(Настройки, Новый ПолеКомпоновкиДанных("Организация")) Тогда
		
		ЭлементОтбора = КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Настройки, "Организация", Отчет.Партнер);
		ЭлементОтбора.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;

		ПользовательскиеНастройки = Настройки.ПользовательскиеНастройки;   
		НастройкаОтбора = Новый Структура;
		НастройкаОтбора.Вставить("ВидСравнения",ВидСравненияКомпоновкиДанных.Равно);
		НастройкаОтбора.Вставить("ПравоеЗначение", Отчет.Организация);
		НастройкаОтбора.Вставить("Использование", Истина);   
		УстановитьПользовательскуюНастройку(Настройки, ПользовательскиеНастройки,
		"Организация",
		НастройкаОтбора); 
		
	КонецЕсли;

	Если ЗначениеЗаполнено(Отчет.Склад) И КомпоновкаДанныхКлиентСервер.ПолеИспользуется(Настройки, Новый ПолеКомпоновкиДанных("Склад")) Тогда
		
		ЭлементОтбора = КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Настройки, "Склад", Отчет.Партнер);
		ЭлементОтбора.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;

		ПользовательскиеНастройки = Настройки.ПользовательскиеНастройки;   
		НастройкаОтбора = Новый Структура;
		НастройкаОтбора.Вставить("ВидСравнения",ВидСравненияКомпоновкиДанных.Равно);
		НастройкаОтбора.Вставить("ПравоеЗначение", Отчет.Склад);
		НастройкаОтбора.Вставить("Использование", Истина);   
		УстановитьПользовательскуюНастройку(Настройки, ПользовательскиеНастройки,
		"Склад",
		НастройкаОтбора);
		
	КонецЕсли;

	Если ЗначениеЗаполнено(Отчет.Партнер) И КомпоновкаДанныхКлиентСервер.ПолеИспользуется(Настройки, Новый ПолеКомпоновкиДанных("Партнер")) Тогда

		ЭлементОтбора = КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Настройки, "Партнер", Отчет.Партнер);
		ЭлементОтбора.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;

		ПользовательскиеНастройки = Настройки.ПользовательскиеНастройки;   
		НастройкаОтбора = Новый Структура;
		НастройкаОтбора.Вставить("ВидСравнения",ВидСравненияКомпоновкиДанных.Равно);
		НастройкаОтбора.Вставить("ПравоеЗначение", Отчет.Партнер);
		НастройкаОтбора.Вставить("Использование", Истина);   
		УстановитьПользовательскуюНастройку(Настройки, ПользовательскиеНастройки,
		"Партнер",
		НастройкаОтбора);   
		
	КонецЕсли;

	Если ЗначениеЗаполнено(Отчет.Контрагент) И КомпоновкаДанныхКлиентСервер.ПолеИспользуется(Настройки, Новый ПолеКомпоновкиДанных("Контрагент")) Тогда
		
		ЭлементОтбора = КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Настройки, "Контрагент", Отчет.Партнер);
		ЭлементОтбора.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;

		ПользовательскиеНастройки = Настройки.ПользовательскиеНастройки;   
		НастройкаОтбора = Новый Структура;
		НастройкаОтбора.Вставить("ВидСравнения",ВидСравненияКомпоновкиДанных.Равно);
		НастройкаОтбора.Вставить("ПравоеЗначение", Отчет.Контрагент);
		НастройкаОтбора.Вставить("Использование", Истина);   
		УстановитьПользовательскуюНастройку(Настройки, ПользовательскиеНастройки,
		"Контрагент",
		НастройкаОтбора);
	КонецЕсли;

	Если ЗначениеЗаполнено(Отчет.Номенклатура) И КомпоновкаДанныхКлиентСервер.ПолеИспользуется(Настройки, Новый ПолеКомпоновкиДанных("Номенклатура")) Тогда
		
		ЭлементОтбора = КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Настройки, "Номенклатура", Отчет.Партнер);
		ЭлементОтбора.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;

		ПользовательскиеНастройки = Настройки.ПользовательскиеНастройки;   
		НастройкаОтбора = Новый Структура;
		НастройкаОтбора.Вставить("ВидСравнения",ВидСравненияКомпоновкиДанных.Равно);
		НастройкаОтбора.Вставить("ПравоеЗначение", Отчет.Номенклатура);
		НастройкаОтбора.Вставить("Использование", Истина);   
		УстановитьПользовательскуюНастройку(Настройки, ПользовательскиеНастройки,
		"Номенклатура",
		НастройкаОтбора);

	КонецЕсли;
КонецПроцедуры

// Устанавливает пользовательскую настройку по переданным значениям.
// 
// Параметры:
// 	КомпоновщикНастроекКомпоновкиДанных - КомпоновщикНастроекКомпоновкиДанных - 
// 	ПользовательскиеНастройки - ПользовательскиеНастройкиКомпоновкиДанных - 
// 	ИмяНастройки - Строка - Имя поля компоновки отбора.
// 	Настройка - Структура - значения для установки в пользовательскую настройку:
// * ПравоеЗначение - Произвольный - 
// * ВидСравнения - ВидСравненияКомпоновкиДанных - 
// * Использование - Булево -
&НаСервере
Процедура УстановитьПользовательскуюНастройку(КомпоновщикНастроекКомпоновкиДанных, ПользовательскиеНастройки, ИмяНастройки, Настройка)
	
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(ИмяНастройки);
	ЭлементОтбора = Неопределено;   
	Для Каждого Элемент Из КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор.Элементы Цикл
	    Если Элемент.ЛевоеЗначение = ПолеКомпоновки Тогда
	        ЭлементОтбора = Элемент;
	        Прервать;
	    КонецЕсли;
	КонецЦикла;   
	Если ЭлементОтбора = Неопределено Тогда       
		Для каждого Элемент Из ПользовательскиеНастройки.Элементы Цикл       
		    Если ТипЗнч(Элемент) = Тип("ОтборКомпоновкиДанных") Тогда           
		        ЭлементОтбора = Элемент.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		        ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки;
		        ЭлементОтбора.ВидСравнения = Настройка.ВидСравнения;
		        ЭлементОтбора.Использование = Настройка.Использование;
		        ЭлементОтбора.ПравоеЗначение = Настройка.ПравоеЗначение;          
		    КонецЕсли;     
		КонецЦикла;            
	Иначе       
	    Элемент = ПользовательскиеНастройки.Элементы.Найти(ЭлементОтбора.ИдентификаторПользовательскойНастройки);      
	    Элемент.ВидСравнения     = Настройка.ВидСравнения;
	    Элемент.ПравоеЗначение   = Настройка.ПравоеЗначение;
	    Элемент.Использование    = Настройка.Использование;       
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВНастройкахОтчета(Настройки)
	// установим параметры
	ПараметрОтчета = КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Настройки, "НачалоПериода", Отчет.ПериодОтчета.ДатаНачала,,Ложь);
	Если ПараметрОтчета <> Неопределено Тогда
		ПараметрОтчета.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	ПараметрОтчета = КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Настройки, "КонецПериода", Отчет.ПериодОтчета.ДатаОкончания,,Ложь);
	Если ПараметрОтчета <> Неопределено Тогда
		ПараметрОтчета.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	ПараметрОтчета = КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Настройки, "Организация", Отчет.Организация);
	Если ПараметрОтчета <> Неопределено Тогда
		ПараметрОтчета.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;
	КонецЕсли;		
	
	ПараметрОтчета = КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Настройки, "Склад", Отчет.Склад);
	Если ПараметрОтчета <> Неопределено Тогда
		ПараметрОтчета.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;
	КонецЕсли;	
	
	ПараметрОтчета = КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Настройки, "Партнер", Отчет.Партнер);
	Если ПараметрОтчета <> Неопределено Тогда
		ПараметрОтчета.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;
	КонецЕсли;	
	
	ПараметрОтчета = КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Настройки, "Контрагент", Отчет.Контрагент);
	Если ПараметрОтчета <> Неопределено Тогда
		ПараметрОтчета.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;
	КонецЕсли;	
	
	ПараметрОтчета = КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Настройки, "Номенклатура", Отчет.Номенклатура);
	Если ПараметрОтчета <> Неопределено Тогда
		ПараметрОтчета.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти
