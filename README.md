# ExampleSendFilesDataSnapDelphiHTTPRest - Send Large Files

Пример AS-IS 
Передачи файлов с клиента на сервер и с сервера на клиент с использованием технологии DataSnap
под Delphi (Http Service) и WebBroker. 

AS-IS example
Transferring files from client to server and from server to client using DataSnap technology
под Delphi (Http Service) and WebBroker.
------

Процедура отправки на клиенте: 
 TfrmMain.BtnSendClick

Процедура получения файла на сервере: 
TServerMethods1.SendPartStream

Обработчик отправки файла (стрима) на сервере: 
TServerMethods1.LoadFile(aName: string): TStream;


Обработчик получения файла на клиенте: 
TfrmMain.BtnDownloadFilesClick

Учтена особенность передачи данных с сервера на клиент. DataSnap по умолчанию передает порции по 32kb - соответственно файлы свыше 32kb "прямым" путем переданны быть не могут,
существует 2 варианта реализации передачи больших файлов. Первый - использовать компоненты палитры Rest и передавать файл как TStringStream (JSON сериализация), а второй использовать разбиение на клиенте и слейвание Stream на сервере. 
В случае с JSON сериализациией и преобразованием TMemoryStream в TStringStream, вы можете с легкостью получить "Out of Memory" - по этому предпочтительно избегать подобных реализаций, что и выполнено в данном примере. 
Файлы передаются и загружаются параллельно, используя библиотеку PPL. Конструкцию TParallel.For.
В данном приере разбиваются файлы по 30kb:
 lsizes := (1024 * 30);


EN:
Sending procedure on the client:
TfrmMain. BtnSendClick

Procedure for getting a file on the server:
TServerMethods1.SendPartStream

Handler for sending a file (stream) on the server:
TServerMethods1.LoadFile(aName: string): TStream;


Handler for receiving a file on the client:
TfrmMain.BtnDownloadFilesClick

The feature of data transfer from the server to the client is taken into account. DataSnap transmits portions of 32kb by default - accordingly, files over 32kb cannot be transmitted in a "direct" way,
there are 2 options for implementing the transfer of large files. The first is to use the Rest palette components and pass the file as a TStringStream (JSON serialization), and the second is to use splitting on the client and merging the Stream on the server.
In the case of JSON serialization and conversion of TMemoryStream to TStringStream, you can easily get "Out of Memory" - therefore, it is preferable to avoid such implementations, which is done in this example.
Files are transferred and uploaded in parallel using the PPL library. The TParallel.For construction.
In this example, files are divided into 30 kb:
sizes := (1024 * 30);

--о готовности (about readiness)
Данная реализация совсем не сложная, я не стал размещать полноценный сервис обмена файлами, хотя в данном примере останется добавить лишь базу данных для учёта загрузок и пользователей.
This implementation is not complicated at all, I did not place a full-fledged file sharing service, although in this example it will only be necessary to add a database to account for downloads and users.

--- 
Возможно Вам будет полезно видео:
https://www.youtube.com/watch?v=NquqzZHGqi8 (Хороший пример, я с него начал, спасибо автору)
где передача файлов осуществялется с использованием rest и TStringStream(1)
В текущем примере реализована передача 2-ым способо

Perhaps the video will be useful to you:
https://www.youtube.com/watch?v=NquqzZHGqi8 (Thanks to the author)
where files are transferred using the REST and TStringStream(1)
In the current example, the transfer is implemented in the 2nd way

