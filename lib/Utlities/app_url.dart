class AppUrl{
  // this is base url
  static const String baseUrl = 'https://disease.sh/v3/covid-19/';

  // fetch world covid stats
  static const String worldStatesApi = baseUrl + 'all' ;
  static const String countriesList = baseUrl + 'countries' ;
}