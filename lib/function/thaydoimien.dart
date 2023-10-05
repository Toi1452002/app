// ignore_for_file: non_constant_identifier_names

IntToString(int value){
  Map<int, String> mien = {
    1: "Nam",
    2:"Trung",
    3: "Bắc"
  };
  return mien[value];
}
MaMien_Thanh_Mien(String value){
  Map<String, String> mien = {
    "N": "Nam",
    "T":"Trung",
    "B": "Bắc"
  };
  return mien[value];
}



IntToMaMien(int value){
  Map<int, String> mien = {
    1: "mien-nam",
    2:"mien-trung",
    3: "mien-bac"
  };
  return mien[value];
}

N_NN(String value){
  Map<String, String> mien = {
    "N": "mien-nam",
    "T":"mien-trung",
    "B": "mien-bac"
  };
  return mien[value];
}