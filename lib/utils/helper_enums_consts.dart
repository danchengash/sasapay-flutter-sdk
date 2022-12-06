enum EnvironmentSasaPay { Live, Testing }

EnvironmentSasaPay? environmentMode;

const List<Map<String, String>> kbanksCodesSasapay = [
  {"label": "Kenya Commercial Bank (KCB)", "value": "01"},
  {"label": "Standard Chartered Bank KE", "value": "02"},
  {"label": "Absa Bank", "value": "03"},
  {"label": "NCBA", "value": "07"},
  {"label": "Prime Bank", "value": "10"},
  {"label": "Cooperative Bank", "value": "11"},
  {"label": "National Bank", "value": "12"},
  {"label": "Citibank", "value": "16"},
  {"label": "Habib Bank AG Zurich", "value": "17"},
  {"label": 'Middle East Bank', "value": "18"},
  {"label": 'Bank of Africa', "value": "19"},
  {"label": 'Consolidated Bank', "value": "23"},
  {"label": 'Stanbic Bank', "value": "31"},
  {"label": 'ABC Bank', "value": "35"},
  {"label": 'NIC Bank', "value": "41"},
  {"label": 'Spire Bank', "value": "49"},
  {"label": 'Paramount Universal Bank', "value": "50"},
  {"label": 'Kingdom Bank', "value": "51"},
  {"label": 'Guaranty Bank', "value": "53"},
  {"label": 'Victoria Commercial Bank', "value": "54"},
  {"label": 'Guardian Bank', "value": "55"},
  {"label": 'I&M Bank', "value": "57"},
  {"label": 'DTB', "value": "63"},
  {"label": 'Sidian Bank', "value": "66"},
  {"label": 'Equity Bank', "value": "68"},
  {"label": 'Family Bank', "value": "70"},
  {"label": 'Gulf African Bank', "value": "72"},
  {"label": 'First Community Bank', "value": "74"},
  {"label": ' KWFT Bank', "value": "78"},
  {"label": "MPesa", "value": "63902"},
  {"label": "AirtelMoney", "value": "63903"},
  {"label": "T-Kash", "value": "63907"},
  {"label": "SasaPay", "value": "0"}
];
