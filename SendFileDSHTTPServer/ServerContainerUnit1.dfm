object SContM: TSContM
  OldCreateOrder = False
  Height = 271
  Width = 415
  object DSServer: TDSServer
    OnConnect = DSServerConnect
    ChannelResponseTimeout = 66666
    Left = 96
    Top = 11
  end
  object DSServerClass: TDSServerClass
    OnGetClass = DSServerClassGetClass
    Server = DSServer
    Left = 200
    Top = 11
  end
  object DSHTTPService1: TDSHTTPService
    HttpPort = 8002
    Server = DSServer
    Filters = <
      item
        FilterId = 'ZLibCompression'
        Properties.Strings = (
          'CompressMoreThan=1024')
      end
      item
        FilterId = 'RSA'
        Properties.Strings = (
          'UseGlobalKey=true'
          'KeyLength=1024'
          'KeyExponent=3')
      end>
    Left = 192
    Top = 120
  end
end
