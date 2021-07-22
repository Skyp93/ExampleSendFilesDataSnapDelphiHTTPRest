unit ServerConst1;

interface

resourcestring
  sPortInUse = '- Error: Port %s already in use';
  sPorts = 'Server working on port %s; Ecnrypt port %s';
  sPortSet = '- Port set to %s';
  sServerRunning = '- The Server is already running';
  sStartingServer = '- Starting HTTP Server on port %d (EncPort %s)';
  sStoppingServer = '- Stopping Server';
  sServerStopped = '- Server Stopped';
  sServerNotRunning = '- The Server is not running';
  sInvalidCommand = '- Error: Invalid Command';
  sIndyVersion = '- Indy Version: ';
  sActive = '- Active: ';
  sPort = '- Port: ';
  sEncPort = '- EncPort: ';
  sPath = '- path: ';
  sSessionID = '- Session ID CookieName: ';
  sCommands = 'Enter a Command: ' + slineBreak +
    '   - "start" to start the server' + slineBreak +
    '   - "stop" to stop the server' + slineBreak +
    '   - "set port" to change the default port' + slineBreak +
    '   - "status" for Server status' + slineBreak +
    '   - "help" to show commands' + slineBreak +
    '   - "exit" to close the application' + slineBreak +
    '   - "set EncPort" to change default Enc Port' + slineBreak +
    '   - "set Path" file catalog - set default file catalog Default "C:\ProgrammData\SrvDS\File"';
  sFileCatalog = '- Catalog:';

const
  cArrow = '->';
  cCommandStart = 'start';
  cCommandStop = 'stop';
  cCommandStatus = 'status';
  cCommandHelp = 'help';
  cCommandSetPort = 'set port';
  cCommandSetEncPort = 'set EncPort';
  cCommandExit = 'exit';
  cCommandSetCatalog = 'set path';

var
  ServerFileCatalog: string;

implementation

end.
